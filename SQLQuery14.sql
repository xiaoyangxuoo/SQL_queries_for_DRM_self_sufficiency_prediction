WITH CTE (ListValue, ListLabel)  
AS  
-- Define the CTE query.  
(  
select ListValue, ListLabel from ListItem where ListID = 1
)
SELECT DISTINCT
       FirstName,
	   LastName,
       Client.EntityID as "Client_ID",
       ProgramName as "Program_Enrolled",
       CTE.ListLabel as "Gender",
       DATEDIFF(HOUR, Client.BirthDate, GETDATE()) / 8766 AS Age,
       DATEDIFF(MONTH, Enrollment.CreatedDate, GETDATE()) as "Months_waited",
       -- ROW_NUMBER() OVER (ORDER BY EntityID) AS RowNumber
       --COUNT(dbo.EnrollmentMember.enrollmentid) OVER (PARTITION BY EntityID) as "Row_Count"  
	   CASE 
			WHEN CaseManagerAssignment.UserID IS NULL THEN 'Not yet matched'
			WHEN CaseManagerAssignment.UserID IS NOT NULL THEN 'Matched'
	   END AS "Indicator"
FROM Client
    INNER JOIN EnrollmentMember
        ON Client.EntityID = EnrollmentMember.ClientID
           AND EnrollmentMember.EndDate > GETDATE()
           AND EnrollmentMember.DeletedDate > GETDATE()
    INNER JOIN Enrollment
        ON EnrollmentMember.EnrollmentID = Enrollment.EnrollmentID
           AND
           (
               Enrollment.ProgramID IN (140, 155) --- STAR programID is 155, CROSSING NLP ID is 140 and FARM programID is 141，might need to exclude the individual ones for the crossing and the farm
               OR
               (
                   ProgramID IN (108, 106) --- 106 for STAR graduate, 108 for Crossing NLP graduate
                   AND DATEDIFF(DAY, Enrollment.BeginDate, GETDATE()) < 365 --- program graduate within one year
               )
           )
           AND Status = 100 --- the client is active
           AND Enrollment.DeletedDate > GETDATE()
    INNER JOIN Program
        ON Enrollment.ProgramID = Program.ProgramID   --- for outputting the program name for the program the client is enrolled in
    INNER JOIN CTE
        on Client.Gender = CTE.ListValue ----- For outputting the client's gender in sense
    LEFT JOIN CaseManagerAssignment
        ON Client.EntityID = CaseManagerAssignment.ClientID
           AND (CaseManagerAssignment.X_AssignmentType = 7 ) ---  mentors
           AND CaseManagerAssignment.DeletedDate > GETDATE()
WHERE --CaseManagerAssignment.UserID IS NULL
       Client.LastName <> 'Test' --- excluding the test client
      AND Client.EntityID <> 161737 --- excluding the outside third party client
      AND DATEDIFF(HOUR, Client.BirthDate, GETDATE()) / 8766 >= 11   --- Minimum 11 years old is required to participate  
	  --And FirstName = 'Nicole' and LastName = 'Richardson'
      order by Months_waited DESC;