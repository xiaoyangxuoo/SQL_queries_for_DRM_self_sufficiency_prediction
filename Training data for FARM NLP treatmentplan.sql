select DISTINCT
       C.FirstName + ' ' + C.LastName As "ClientName"
		,C.EntityID as ClientID
       ,
	   ISNULL(Absence_T.Absence_count, 0) AS "AbsenceCount"
	   ,
	    CASE
	   WHEN EnrollmentMember.BeginDate > '01-01-2019' THEN 1
	   WHEN EnrollmentMember.BeginDate <= '12-31-2018' THEN 0
	   END AS "Absence_valid"
	   ,
	   ISNULL(WH.Work_hist_count, 0) AS "WorkHistCount"
	   ,
	   ISNULL(Counsel.Number_of_counselings_attended, 0)  AS "Counseling_attended"
	   ,
	   ISNULL(G.Count_of_goals_setup, 0) AS "Number_of_goals" 
	   ,
	   DATEDIFF(HOUR,C.BirthDate, getdate()) / 8760 AS "Age"	  
	   ,
	   CASE 
	   WHEN Enrollment.EndDate > getdate() then DATEDIFF(MONTH, Enrollment.BeginDate, getdate())
	   WHEN Enrollment.EndDate <= getdate() then DATEDIFF(MONTH, Enrollment.BeginDate, Enrollment.EndDate) END AS "Months_in_Program"
	   ,
	   ISNULL (AO.Scoretot, NULL) AS "AVG_Score" 

FROM Client C
left join 
(select C.EntityID as ClientID
--, FirstName+ ' '+ LastName AS "ClientName"
, count(ResourceAbsence.AbsenceID) AS "Absence_count"
--ResourceAbsence. BeginDate
--ResourceName 
from Client C
inner join ResourceAbsence
on ResourceAbsence.EntityID = C.EntityID
inner join ResourceUsage
on ResourceAbsence.UsageID = ResourceUsage.UsageID
inner join Resource
on Resource.ResourceID = ResourceUsage.ResourceID
group by C.EntityID
) Absence_T --------------TABLE OF ABSENCE COUNT
on Absence_T.ClientID = C.EntityID
left join
(
select C.EntityID as "ClientID", count(WorkHistory.BeginDate) As "Work_hist_count" from Client C
inner join WorkHistory
on WorkHistory.ClientID = C.EntityID
group by C.EntityID
) WH --------------TABLE OF WORKHISTORY COUNT
on WH.ClientID = C.EntityID
left join
(
select TEMP.ClientID, count(*) AS "Number_of_counselings_attended" from 
(select  distinct Client.EntityId AS "ClientID", CaseNoteSummary, CaseNotes.Body, Client.FirstName, Client.MiddleName, Client.LastName, CaseNotes.CreatedDate from Client
inner join CaseNotes 
on CaseNotes.EntityID = Client.EntityID
where CaseNoteSummary Like '%cousneling%' or CaseNoteSummary LIKE '%Counseling%' ) TEMP --- excluded the body LIKE "%%" because I think sometimes it's due to the template but contains no text
group by TEMP.ClientID
--order by "Number_of_counselings_attended" desc
) Counsel  --------------TABLE OF COUNSELING SESSION COUNT
on Counsel.ClientID = C.EntityID

left join
(
select Client.EntityID ClientID, count(GoalID) AS "Count_of_goals_setup" from Client
inner join Goal
on Client.EntityID = Goal.ClientID
group by Client.EntityID

) G ------------------- Table that represents how many goals each client has set up
on G.ClientID = C.EntityID

--------- selecting only star treatment clients 
inner join EnrollmentMember
on C.EntityID = EnrollmentMember.ClientID
inner join Enrollment
on Enrollment.EnrollmentID = EnrollmentMember.EnrollmentID
inner join Program
on Program.ProgramID = Enrollment.ProgramID
left join
(
select ClientID, AVG(1.0 * Score_of_ThisDomain) Scoretot from 
(select Client.EntityId ClientID, OutcomeDomain.DomainName, OutcomeDomain.DomainID, OutcomeScore.OutcomeValue AS "Score_of_ThisDomain" from Client
inner join EnrollmentMember
on Client.EntityID = EnrollmentMember.ClientID --AND EnrollmentMember.EndDate > GETDATE() AND EnrollmentMember.DeletedDate > GETDATE()
inner join Enrollment
on Enrollment.EnrollmentID = EnrollmentMember.EnrollmentID
inner join Program
on Program.ProgramID = Enrollment.ProgramID
inner join Assessment
on Assessment.EnrollmentID = Enrollment.EnrollmentID
inner join AssessOutcomes
on Assessment.AssessmentID = AssessOutcomes.AssessmentID
inner join OutcomeDomain
on OutcomeDomain.DomainID = AssessOutcomes.DomainID
inner join OutcomeScore
on OutcomeScore.DomainID = AssessOutcomes.DomainID and OutcomeScore.ScoreID = AssessOutcomes.ScoreID
--inner join 
where Program.ProgramName like '%FARM NLP Treatment%' 
) AO
group by ClientID) 
AO    --------------TABLE OF Assessment Outcome scores, temporarily using average score over all domains
on AO.ClientID = C.EntityID
--inner join 
where 
Program.ProgramName like '%FARM NLP Treatment%' 
AND C.LastName <> 'Test' --- excluding the test client
      AND C.EntityID <> 161737 --- excluding the outside third party client
and C.BirthDate is not null 
and C.BirthDate < GETDATE() 
--Enrollment.DeletedDate > GETDATE() -------- filtering out those deleted records?
and DATEDIFF(HOUR,C.BirthDate, getdate()) / 8760 < 120   ---- less than 120 years old
--and Status = 100 --and  E.CreatedDate > ' 01-01-2019' and C.CreatedDate < getdate()