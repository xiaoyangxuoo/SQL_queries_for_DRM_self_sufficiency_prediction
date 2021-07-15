SELECT DISTINCT C.ENTITYID, c.birthdate, C.FirstName, C.LastName, E.BeginDate,  E.ProgramName, A.OutcomeDate AS LastSSMatrixDate
, DATEDIFF(DD, E.BEGINDATE, GETDATE()) DaysinProgram, cma.Casemanager AS CaseManagername--, DATEDIFF(DD, A.OUTCOMEDATE, GETDATE()) DaysSinceLastSSmatrix
FROM CLIENT C
INNER JOIN
(
SELECT EM.CLIENTID, E.BeginDate, E.EndDate, ProgramName, E.EnrollmentID
FROM EnrollmentMember EM
INNER JOIN ENROLLMENT E
ON E.EnrollmentID = EM.EnrollmentID AND PROGRAMID IN (140,141,155,161)  AND STATUS = 100
INNER JOIN PROGRAM P
ON P.ProgramID = E.ProgramID
WHERE E.DeletedDate > GETDATE()
and getdate() between e.BeginDate and e.EndDate
--and em.RelationToHoH = 1
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
ON E.enrollmentid = A.enrollmentid
left join
(
select u.FirstName + ' ' + u.LastName as Casemanager, cma.EnrollmentID
from CaseManagerAssignment cma
INNER JOIN Users U
ON CMA.UserID = U.EntityID
AND CMA.DeletedDate > GETDATE() 
AND GETDATE() BETWEEN CMA.BeginDate AND CMA.EndDate
and X_AssignmentType = 2
) cma
on e.EnrollmentID = cma.EnrollmentID      --DATEDIFF(DD, E.BeginDate,
where   A.OUTCOMEDATE	is null
and  DATEDIFF(DD, E.BEGINDATE, GETDATE()) > 14
and c.lastname <> 'test'

