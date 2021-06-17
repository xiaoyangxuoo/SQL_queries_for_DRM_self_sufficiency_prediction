SELECT DISTINCT C.ENTITYID, C.FirstName, C.LastName, E.BeginDate, E.EndDate, E.ProgramName, A.OutcomeDate AS LastSSMatrix, 
DATEDIFF(DD, E.BEGINDATE, GETDATE()) DaysinProgram, DATEDIFF(DD, A.OUTCOMEDATE, GETDATE()) DaysSinceLastSSmatrix
FROM CLIENT C
INNER JOIN
(
SELECT EM.CLIENTID, E.BeginDate, E.EndDate, ProgramName, E.EnrollmentID
FROM EnrollmentMember EM
INNER JOIN ENROLLMENT E
ON E.EnrollmentID = EM.EnrollmentID AND PROGRAMID IN (140,141,155,161) AND STATUS = 100
INNER JOIN PROGRAM P
ON P.ProgramID = E.ProgramID
WHERE E.DeletedDate > GETDATE()
and getdate() between E.BeginDate and E.EndDate
) E
ON E.ClientID = C.EntityID
LEFT JOIN 
(
SELECT max(AO.OUTCOMEDATE) OUTCOMEDATE, A.enrollmentid 
FROM ASSESSMENT A
INNER JOIN AssessOutcomes AO
ON A.AssessmentID = AO.AssessmentID
INNER JOIN OutcomeDomain OD
ON AO.DomainID = OD.DomainID AND (OD.DomainName LIKE N'%self-sufficient%' OR OD.domainName LIKE N'%ss matrix%' or od.DomainName like N'%Self Sufficiency Matrix%')
GROUP BY A.enrollmentid
) A
ON E.EnrollmentID = A.enrollmentid
--left join
--(
--select u.FirstName + ' ' + u.LastName as Casemanager, em.ClientID
--from EnrollmentMember em
--inner join enrollment e
--on em.EnrollmentID = e.EnrollmentID and e.DeletedDate > getdate() and getdate() between e.BeginDate and e.EndDate and e.ProgramID in (140,141,161,155) 
--inner join CaseManagerAssignment cma
--on e.EnrollmentID = cma.EnrollmentID
--INNER JOIN Users U
--ON CMA.UserID = U.EntityID
--AND CMA.DeletedDate > GETDATE() 
--AND GETDATE() BETWEEN CMA.BeginDate AND CMA.EndDate
--where e.Status = 100
--and cma.X_AssignmentType = 2) cma
--on cma.clientid = c.EntityID
where  A.OUTCOMEDATE is not null  --- after the left join, filter out the null values
and DATEDIFF(DD, A.OUTCOMEDATE, GETDATE()) > 30 ---- Get all the clients with no ssmatrix within the past 30 days
and c.LastName <> 'Test'
--order by cma.casemanager asc