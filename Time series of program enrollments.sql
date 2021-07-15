-------- Time series originally
select E.BeginDate, count(P.ProgramName) "Daily_Enrollments" from Client C
inner join EnrollmentMember EM
on EM.ClientID = C.EntityID
inner join Enrollment E
on E.EnrollmentID = EM.EnrollmentID
inner join Program P
on P.ProgramID = E.ProgramID
where P.ProgramID = 155 and E.DeletedDate > getdate()------ Does not care whether the record has been deleted or not.
group by E.BeginDate
;

with TS as (
select E.BeginDate, count(P.ProgramName) "Daily_Enrollments" from Client C
inner join EnrollmentMember EM
on EM.ClientID = C.EntityID
inner join Enrollment E
on E.EnrollmentID = EM.EnrollmentID
inner join Program P
on P.ProgramID = E.ProgramID
where P.ProgramID = 155 and E.DeletedDate > getdate()------ Does not care whether the record has been deleted or not.
group by E.BeginDate
)
, monthly_costs as (
    SELECT
        BeginDate
      , "Daily_Enrollments"
      , sum("Daily_Enrollments") OVER (ORDER BY BeginDate) as
        PreviousEnrollments
    FROM
        TS
)
SELECT
    BeginDate
  , PreviousEnrollments AS
    Blabla
FROM monthly_costs