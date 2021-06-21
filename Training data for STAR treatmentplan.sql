select C.FirstName + ' ' + C.LastName As "ClientName"
		,C.EntityID as ClientID
       ,CASE 
	    WHEN Absence_T.Absence_count is not null then Absence_T.Absence_count
		WHEN Absence_T.Absence_count is null then 0
		END AS "AbsenceCount"
	   ,CASE
	   WHEN WH.Work_hist_count is not null then WH.Work_hist_count
	   WHEN WH.Work_hist_count is null then 0
	   END AS "WorkHistCount"
	   ,
	   CASE
	   WHEN Counsel.Number_of_counselings_attended is not null then Counsel.Number_of_counselings_attended
	   WHEN Counsel.Number_of_counselings_attended is null then 0
	   END AS "Counsel.Count_of_Counseling_attended"
	   ,
	   CASE 
	   WHEN AO.Scoretot is not null then AO.Scoretot
	   WHEN AO.Scoretot is null then NULL
	   END AS "AVG_AssessScore"

from Client C
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
on Client.EntityID = EnrollmentMember.ClientID
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
where Program.ProgramName like '%STAR Treatment%' 
) AO
group by ClientID) 
AO    --------------TABLE OF Assessment Outcome scores, temporarily using average score over all domains
on AO.ClientID = C.EntityID
--inner join 
where Program.ProgramName like '%STAR Treatment%'  -- status does not have to be 100 meaning active. even not active can be past data for analytics purpose. deletion date does not necessarily :E.DeletedDate > GETDATE()























