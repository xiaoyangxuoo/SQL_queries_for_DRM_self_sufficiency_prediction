SELECT distinct FirstName, LastName, client.EntityID, 
CASE
WHEN ProgramName like '%nlp%' THEN 'NLP - Men'
WHEN ProgramName like '%Refugee%' THEN 'Refugee'
WHEN ProgramName like '%STAR%' and client.gender =  1 and Enrollment.ProgramID <> 86 THEN 'STAR - Men'
WHEN ProgramName like '%STAR%' and client.Gender = 2 and Enrollment.ProgramID <> 86 THEN 'STAR - Women'
WHEN ProgramName like '%Champa%' THEN 'Champa - Women'
WHEN ProgramName like '%Champa Children%' THEN 'Champa - Children'
WHEN Program.ProgramID = 86  and DATEDIFF(HOUR, client.BirthDate, GETDATE())/8766 <= 18 THEN 'STAR Youth'
End as ProgType, ProgramName,DATEDIFF(HOUR, client.BirthDate, GETDATE())/8766 as Age
 FROM Client
INNER JOIN EnrollmentMember on client.EntityID = Enrollmentmember.ClientID and Enrollmentmember.EndDate > GETDATE()and Enrollmentmember.DeletedDate > GETDATE()
INNER JOIN Enrollment on Enrollmentmember.EnrollmentID = Enrollment.EnrollmentID and (enrollment.ProgramID IN  (77, 93, 94, 95, 96, 78, 79, 80,  65, 66, 68, 69, 70,  71, 72, 73, 86,154) OR (ProgramID = 108 and DATEDIFF(day,enrollment.BeginDate,GETDATE()) <365)) and Status = 100 
and enrollment.DeletedDate > GETDATE()
INNER JOIN Program on Enrollment.ProgramID = Program.ProgramID
Left JOIN CaseManagerAssignment on client.EntityID = CaseManagerAssignment.ClientID and CaseManagerAssignment.X_AssignmentType = 109 and CaseManagerAssignment.DeletedDate > GETDATE()
INNER JOIN FamilyMember on Client.EntityID = familymember.ClientID and familymember.DateRemoved > GETDATE()
LEFT JOIN Provider on CaseManagerAssignment.UserID = Provider.EntityID
Where 
provider.EntityID is null and
 client.LastName <> 'Test' and client.EntityID <> 161737 
 and DATEDIFF(HOUR, client.BirthDate, GETDATE())/8766 >= 11 and enrollment.ProgramID not in (77,65,109,106,108,110,71)
 --and Enrollment.ProgramID = 86