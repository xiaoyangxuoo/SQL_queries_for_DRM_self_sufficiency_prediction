
-------------- Discovery of all the tables for the outcomes---------------------------------------------
-- Client -- EnrollmentMember -- Enrollment -- Assessment and then, maybe enrolled in the graduate?: 
select * from Assessment where AssessmentID = 177973; --- This is the test client I created.
select * from AssessOutcomes where AssessmentID = 177973; --- This is the test client I created.
select * from OutcomeDomain where DomainName like '%Graduate%'; --- （output the domain name for the assessment performed on the client）
select * from OutcomeScore -- (we are using the Outcome Value to match the score and short description)

------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------Candidate tables LIST-----------------------------------------------------------------------------
select * from CaseNotes, Client, Enrollment, EnrollmentMember, Program, Enrollment
select * from Client
select * from Program
select * from OutcomeDomainScores
select * from DomainType --(including dependencies) …..(to be discovered)
select * from EnrollmentServicePlan
select * from GoalStep
select * from GoalOutcomes
select * from GoalType
---Follow up (Graduate assessments after 3, 6 , 9 month or…)
--- Treatmentplan is consistent across all programs


--- find the graduates, 108 for 
select * from Enrollment where ProgramID = 108 and BeginDate

--- find the Domainname of the graduates
select * from Assessment;
select * from AssessOutcomes;
select * from OutcomeDomain
select * from DomainTypeCategory
select * from DomainTypeCategoryType
select * from OutcomeScore
-- select * from OutcomeMatrixScore DON'T know what this is
--select * from OutcomeScoreGroup
--select * from OutcomeScoreRepo

--select * from ProgramOutcomes, might be useful for relating each domain into each program???
--select * from UVW_OutcomesSelfSufficiency
select DomainID, DomainName, DomainTypeCategory.CategoryID from OutcomeDomain
inner join DomainTypeCategory
on OutcomeDomain.DomainID = DomainTypeCategory.DomainTypeID
inner join DomainTypeCategoryType
on DomainTypeCategory.CategoryID = DomainTypeCategoryType.CategoryID
WHERE DomainName like '%Graduate%';

--select OutcomeID, count(*) from AssessOutcomes, don't worry about this???
--group by OutcomeID
--order by count(*) desc;

select * from ListItem
where ListLabel like '%permanent%';
----------------- Response vector generated-----------------------------------------------
-------- useful Prescreen, Youth, Graduate, Planned Departure, and Treatment Plan
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
group by ClientID
order by Scoretot desc



---filtering the program name based on this
--order by FirstName, LastName

--where EntityID = 180419 --and Assessment.AssessmentID = 168792  and OutcomeDomain.DomainName LIKE '%SS Matrix%'-- For this person, this is 
--assessment ID 168792 is corresponding to the Crossing NLP treatment plan, may broadcast to other programs
--select * from Program where ProgramName = 'Next Step'
--select DISTINCT ProgramID, ProgramName from Program where ProgramName LIKE '%STAR%'
-----------------------------------------------------------------------------------------------------------------------
----------------- Response vector generated----------------------------------------------------------------------------

 

------------------------ Generating the absence information of each client--------------------------------------------
------------------------------------------------------------------------------------------------------------=---------
select * from ResourceAbsence
select * from Resource
Select * from ResourceUsage
--select * from AbsenceExtension, as this might not be useful?

select FirstName, LastName, ResourceAbsence.AbsenceID, ResourceAbsence. BeginDate, ResourceName from Client C
inner join ResourceAbsence
on ResourceAbsence.EntityID = C.EntityID
inner join ResourceUsage
on ResourceAbsence.UsageID = ResourceUsage.UsageID
inner join Resource
on Resource.ResourceID = ResourceUsage.ResourceID
order by BeginDate DESC
--- where C.EntityID = 342185, filtering out the person based on the Entity ID
------------------------------------------------------------------------------------------------------------------------
------------------------ Generating the absence information of each client--------------------------------------------

select * from WorkHistoryJournal
select * from WorkHistory
--select * from service --(work clock-in or Clock-out
--------- Finding the casenotes, casenote.casenotetypeid = (counsling case note

---------------- Generated the full work history of each client---------------------------------------------------
------------------------------------------------------------------------------------------------------------------
select C.EntityID as "ClientID", count(WorkHistory.BeginDate) As "Work_hist_count" from Client C
inner join WorkHistory
on WorkHistory.ClientID = C.EntityID
group by C.EntityID
--order by "Work_hist_count"
------------------------------------------------------------------------------------------------------------------
---------------- Generated the full work history of each client---------------------------------------------------



------------------------ generating the counseling session records for each client--------------------------------
------------------------------------------------------------------------------------------------------------------
------- 
--select CaseNotes.CaseNoteSummary, CaseNotes.CaseNoteTypeID from CaseNotes where CaseNoteSummary LIKE '%Counseling%'


--select CaseNoteID, CaseNoteSummary, CaseNoteTypeID from CaseNotes where CaseNoteTypeID in
--(select distinct ListValue from ListItem where ListLabel like '%Counsel%' )

--------- The following query returns 28617 distinct rows         
select TEMP.ClientID, count(*) AS "Number_of_counselings_attended" from 
(select  distinct Client.EntityId AS "ClientID", CaseNoteSummary, CaseNotes.Body, Client.FirstName, Client.MiddleName, Client.LastName, CaseNotes.CreatedDate from Client
inner join CaseNotes 
on CaseNotes.EntityID = Client.EntityID
where CaseNoteSummary Like '%cousneling%' or CaseNoteSummary LIKE '%Counseling%' ) TEMP --- excluded the body LIKE "%%" because I think sometimes it's due to the template but contains no text
group by TEMP.ClientID
order by "Number_of_counselings_attended" desc

--and Client.EntityID = 132142--- Also, I need to parse the casenotes that some of the participants have attended an outside session or not.
--group by Client.EntityId

--select * from CaseNotes --where Body LIKE '%counsel%'， this query returns 160000+ results, which basically contains all casenotes


------------------------------------------------------------------------------------------------------------------
------------------------ generating the counseling session records for each client--------------------------------

select distinct ProgramName from Program 