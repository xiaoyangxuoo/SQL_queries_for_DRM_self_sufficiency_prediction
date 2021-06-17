select * from CaseManagerAssignment
where ClientID = 330137;



select client.Firstname, client.LastName, CaseManagerAssignment.UserID,  X_AssignmentType from
Client 
join CaseManagerAssignment
on client.EntityID = CasemanagerAssignment.clientID
left join Entity
on CaseManagerAssignment.userID = Entity.EntityID
where ClientID = 343687

select * from ProviderTypeCategoryType
WHERE ProviderTypeCategoryTypeID IN (1000000009, 1000000011, 1000000012, 1000000013, 1000000014, 1000000015, 1000000016, 1000000023)


select FirstName, Lastname, EntityID from Users
where EntityID = 155910


SELECT DISTINCT
       --description,
       ProviderName,
       provider.CreatedDate,
	   provider.EntityID
FROM Provider
    INNER JOIN ProviderTypeCategory
        ON provider.EntityID = ProviderTypeCategory.EntityID

select * from Provider 
select * from ProviderTypeCategory
select * from ProviderTypeCategoryType


SELECT * 
        FROM dbo.CaseManagerAssignment
        --WHERE GETDATE() BETWEEN BeginDate AND EndDate
        --AND DeletedDate > GETDATE()
        --AND dbo.Provider.EntityID = dbo.CaseManagerAssignment.UserID


select ProgramName, Enrollment.ProgramID from Enrollment
INNER JOIN Program
        ON Enrollment.ProgramID = Program.ProgramID
where Enrollment.ProgramID in (140, 141,155)
OR (Enrollment.ProgramID IN (108,106) and DATEDIFF(DAY, Enrollment.BeginDate, GETDATE())<365)
order by ProgramID


select * from CaseManagerAssignment where CaseManagerAssignment.X_AssignmentType = 7

select ProgramName, ProgramID from Program
where ProgramID = 106

---- Query to see the listlabel with listValue (which is X_assignmentType = 7, "mentors")
select * from Lists
select * from ListItem where ListID = 1000000019


select cast(getdate() As Date)
select getdate()

select Gender from Client

select ListValue, ListLabel from ListItem where ListID = 1
select * from Provider

--select  description, username from Provider where description like "%Farm%" 

select * from Users 
where FirstName = 'Tom' and isActive = 1


--select * from Assessment;
select AssessmentID, FirstName, LastName from Assessment
inner join Users 
on Users.EntityID = Assessment.CreatedBy


select * from AssessOutcomes

select * from Client;
select * from EnrollmentMember;

-------------- Discovery of all the tables for the outcomes---------------------------------------------
-- Client -- EnrollmentMember -- Enrollment -- Assessment and then, maybe enrolled in the graduate?: 


select * from Assessment where AssessmentID = 177973; --- This is the test client I created.

select * from AssessOutcomes where AssessmentID = 177973; --- This is the test client I created.

select * from OutcomeDomain where DomainName like '%Graduate%'; --- （output the domain name for the assessment performed on the client）
select * from OutcomeScore -- (we are using the Outcome Value to match the score and short description)

------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------Candidate tables ----------------------------------------------------------------------------------------------------------------
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
----------------- Response vector generated-----------
-------- useful Prescreen, Youth, Graduate, Planned Departure, and Treatment Plan
select FirstName, LastName, Program.ProgramName, OutcomeDomain.DomainName, OutcomeDomain.DomainID, OutcomeScore.OutcomeValue AS "Score_of_ThisDomain", Assessment.CreatedDate as "Assess-Date" from Client
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
where Program.ProgramName like '%Treatment%'
order by FirstName, LastName
--where EntityID = 180419 --and Assessment.AssessmentID = 168792  and OutcomeDomain.DomainName LIKE '%SS Matrix%'-- For this person, this is 
--assessment ID 168792 is corresponding to the Crossing NLP treatment plan, may broadcast to other programs


select * from Program where ProgramName = 'Next Step'
select DISTINCT ProgramID, ProgramName from Program where ProgramName LIKE '%STAR%' 

select * from ResourceAbsence
select * from AbsenceExtension

select * from CaseNotes where CaseNoteTypeID LIKE 'counselling case'???

select * from WorkHistoryJournal
select * from WorkHistory
select * from service --(work clock-in or Clock-out
--------- Finding the casenotes, casenote.casenotetypeid = (counsling case note

---------Query for searching all tables containing a column EntityID
SELECT      c.name  AS 'ColumnName'
            ,t.name AS 'TableName'
FROM        sys.columns c
JOIN        sys.tables  t   ON c.object_id = t.object_id
WHERE       c.name LIKE '%checkin%'
ORDER BY    TableName, ColumnName;

select * from FormHistory