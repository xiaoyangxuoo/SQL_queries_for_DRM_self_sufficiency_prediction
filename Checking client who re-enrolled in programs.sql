select DISTINCT L.FirstName, L.LastName, L.BeginDate, R. BeginDate, L.ProgramName, R.ProgramName from 
(
select FirstName, LastName, E.BeginDate, P.ProgramName from Client C
inner join EnrollmentMember EM
on EM.ClientID = C.EntityID
inner join Enrollment E
on E.EnrollmentID = EM.EnrollmentID
inner join Program P
on P.ProgramID = E.ProgramID
where P.ProgramID = 140 and E.DeletedDate > getdate()
) L
inner join 
(
select FirstName, LastName, E.BeginDate, P.ProgramName from Client C
inner join EnrollmentMember EM
on EM.ClientID = C.EntityID
inner join Enrollment E
on E.EnrollmentID = EM.EnrollmentID
inner join Program P
on P.ProgramID = E.ProgramID
where P.ProgramID = 140 and E.DeletedDate > getdate()
) R
on L.BeginDate <> R.BeginDate and L.FirstName = R.FirstName and L.LastName = R.LastName
--where R.BeginDate is not NULL