[33mcommit 59720ed7b04cab8402fc64e19052b8e765022270[m[33m ([m[1;36mHEAD -> [m[1;32mmaster[m[33m)[m
Author: Martin Yang <MYang@denrescue.org>
Date:   Thu Jun 17 16:12:05 2021 -0600

    SQL snippets from work v2

[1mdiff --git a/Checking client with SSmatrix but needs a new one.sql b/Checking client with SSmatrix but needs a new one.sql[m
[1mnew file mode 100644[m
[1mindex 0000000..1551b9f[m
[1m--- /dev/null[m
[1m+++ b/Checking client with SSmatrix but needs a new one.sql[m	
[36m@@ -0,0 +1,45 @@[m
[32m+[m[32mSELECT DISTINCT C.ENTITYID, C.FirstName, C.LastName, E.BeginDate, E.EndDate, E.ProgramName, A.OutcomeDate AS LastSSMatrix,[m[41m [m
[32m+[m[32mDATEDIFF(DD, E.BEGINDATE, GETDATE()) DaysinProgram, DATEDIFF(DD, A.OUTCOMEDATE, GETDATE()) DaysSinceLastSSmatrix[m
[32m+[m[32mFROM CLIENT C[m
[32m+[m[32mINNER JOIN[m
[32m+[m[32m([m
[32m+[m[32mSELECT EM.CLIENTID, E.BeginDate, E.EndDate, ProgramName, E.EnrollmentID[m
[32m+[m[32mFROM EnrollmentMember EM[m
[32m+[m[32mINNER JOIN ENROLLMENT E[m
[32m+[m[32mON E.EnrollmentID = EM.EnrollmentID AND PROGRAMID IN (140,141,155,161) AND STATUS = 100[m
[32m+[m[32mINNER JOIN PROGRAM P[m
[32m+[m[32mON P.ProgramID = E.ProgramID[m
[32m+[m[32mWHERE E.DeletedDate > GETDATE()[m
[32m+[m[32mand getdate() between E.BeginDate and E.EndDate[m
[32m+[m[32m) E[m
[32m+[m[32mON E.ClientID = C.EntityID[m
[32m+[m[32mLEFT JOIN[m[41m [m
[32m+[m[32m([m
[32m+[m[32mSELECT max(AO.OUTCOMEDATE) OUTCOMEDATE, A.enrollmentid[m[41m [m
[32m+[m[32mFROM ASSESSMENT A[m
[32m+[m[32mINNER JOIN AssessOutcomes AO[m
[32m+[m[32mON A.AssessmentID = AO.AssessmentID[m
[32m+[m[32mINNER JOIN OutcomeDomain OD[m
[32m+[m[32mON AO.DomainID = OD.DomainID AND (OD.DomainName LIKE N'%self-sufficient%' OR OD.domainName LIKE N'%ss matrix%' or od.DomainName like N'%Self Sufficiency Matrix%')[m
[32m+[m[32mGROUP BY A.enrollmentid[m
[32m+[m[32m) A[m
[32m+[m[32mON E.EnrollmentID = A.enrollmentid[m
[32m+[m[32m--left join[m
[32m+[m[32m--([m
[32m+[m[32m--select u.FirstName + ' ' + u.LastName as Casemanager, em.ClientID[m
[32m+[m[32m--from EnrollmentMember em[m
[32m+[m[32m--inner join enrollment e[m
[32m+[m[32m--on em.EnrollmentID = e.EnrollmentID and e.DeletedDate > getdate() and getdate() between e.BeginDate and e.EndDate and e.ProgramID in (140,141,161,155)[m[41m [m
[32m+[m[32m--inner join CaseManagerAssignment cma[m
[32m+[m[32m--on e.EnrollmentID = cma.EnrollmentID[m
[32m+[m[32m--INNER JOIN Users U[m
[32m+[m[32m--ON CMA.UserID = U.EntityID[m
[32m+[m[32m--AND CMA.DeletedDate > GETDATE()[m[41m [m
[32m+[m[32m--AND GETDATE() BETWEEN CMA.BeginDate AND CMA.EndDate[m
[32m+[m[32m--where e.Status = 100[m
[32m+[m[32m--and cma.X_AssignmentType = 2) cma[m
[32m+[m[32m--on cma.clientid = c.EntityID[m
[32m+[m[32mwhere  A.OUTCOMEDATE is not null  --- after the left join, filter out the null values[m
[32m+[m[32mand DATEDIFF(DD, A.OUTCOMEDATE, GETDATE()) > 30 ---- Get all the clients with no ssmatrix within the past 30 days[m
[32m+[m[32mand c.LastName <> 'Test'[m
[32m+[m[32m--order by cma.casemanager asc[m
\ No newline at end of file[m
[1mdiff --git a/Checking client without a SSmatrix.sql b/Checking client without a SSmatrix.sql[m
[1mnew file mode 100644[m
[1mindex 0000000..2250949[m
[1m--- /dev/null[m
[1m+++ b/Checking client without a SSmatrix.sql[m	
[36m@@ -0,0 +1,42 @@[m
[32m+[m[32mSELECT DISTINCT C.ENTITYID, c.birthdate, C.FirstName, C.LastName, E.BeginDate,  E.ProgramName, A.OutcomeDate AS LastSSMatrixDate[m
[32m+[m[32m, DATEDIFF(DD, E.BEGINDATE, GETDATE()) DaysinProgram--, DATEDIFF(DD, A.OUTCOMEDATE, GETDATE()) DaysSinceLastSSmatrix[m
[32m+[m[32mFROM CLIENT C[m
[32m+[m[32mINNER JOIN[m
[32m+[m[32m([m
[32m+[m[32mSELECT EM.CLIENTID, E.BeginDate, E.EndDate, ProgramName, E.EnrollmentID[m
[32m+[m[32mFROM EnrollmentMember EM[m
[32m+[m[32mINNER JOIN ENROLLMENT E[m
[32m+[m[32mON E.EnrollmentID = EM.EnrollmentID AND PROGRAMID IN (140,141,155,161)  AND STATUS = 100[m
[32m+[m[32mINNER JOIN PROGRAM P[m
[32m+[m[32mON P.ProgramID = E.ProgramID[m
[32m+[m[32mWHERE E.DeletedDate > GETDATE()[m
[32m+[m[32mand getdate() between e.BeginDate and e.EndDate[m
[32m+[m[32m--and em.RelationToHoH = 1[m
[32m+[m[32m) E[m
[32m+[m[32mON E.ClientID = C.EntityID[m
[32m+[m[32mLEFT JOIN[m[41m [m
[32m+[m[32m([m
[32m+[m[32mSELECT max(AO.OUTCOMEDATE) OUTCOMEDATE, A.enrollmentid[m[41m [m
[32m+[m[32mFROM ASSESSMENT A[m
[32m+[m[32mINNER JOIN AssessOutcomes AO[m
[32m+[m[32mON A.AssessmentID = AO.AssessmentID[m
[32m+[m[32mINNER JOIN OutcomeDomain OD[m
[32m+[m[32mON AO.DomainID = OD.DomainID AND (OD.DomainName LIKE N'%self-sufficient%' OR OD.domainName LIKE N'%ss matrix%' or od.DomainName like N'%Self Sufficiency Matrix%')[m
[32m+[m[32mGROUP BY A.enrollmentid[m
[32m+[m[32m) A[m
[32m+[m[32mON E.enrollmentid = A.enrollmentid[m
[32m+[m[32m--left join[m
[32m+[m[32m--([m
[32m+[m[32m--select u.FirstName + ' ' + u.LastName as Casemanager, cma.EnrollmentID[m
[32m+[m[32m--from CaseManagerAssignment cma[m
[32m+[m[32m--INNER JOIN Users U[m
[32m+[m[32m--ON CMA.UserID = U.EntityID[m
[32m+[m[32m--AND CMA.DeletedDate > GETDATE()[m[41m [m
[32m+[m[32m--AND GETDATE() BETWEEN CMA.BeginDate AND CMA.EndDate[m
[32m+[m[32m--and X_AssignmentType = 2[m
[32m+[m[32m--) cma[m
[32m+[m[32m--on e.EnrollmentID = cma.EnrollmentID      DATEDIFF(DD, E.BeginDate,[m
[32m+[m[32mwhere   A.OUTCOMEDATE	is null[m
[32m+[m[32mand  DATEDIFF(DD, E.BEGINDATE, GETDATE()) > 14[m
[32m+[m[32mand c.lastname <> 'test'[m
[32m+[m

[33mcommit 4540509a5054a250372cb86850a6ff57f003c58e[m
Author: Martin Yang <MYang@denrescue.org>
Date:   Thu Jun 17 11:50:40 2021 -0600

    updated version of Data Engineering task v1

[1mdiff --git a/Code for searching all tables containing a columnXXX.sql b/Code for searching all tables containing a columnXXX.sql[m
[1mindex e84d70c..caae2e0 100644[m
[1m--- a/Code for searching all tables containing a columnXXX.sql[m	
[1m+++ b/Code for searching all tables containing a columnXXX.sql[m	
[36m@@ -3,7 +3,12 @@[m [mSELECT      c.name  AS 'ColumnName'[m
             ,t.name AS 'TableName'[m
 FROM        sys.columns c[m
 JOIN        sys.tables  t   ON c.object_id = t.object_id[m
[31m-WHERE       c.name LIKE '%checkin%'[m
[32m+[m[32mWHERE       c.name LIKE '%counsel%'[m
 ORDER BY    TableName, ColumnName;[m
 [m
[31m-select * from FormHistory[m
\ No newline at end of file[m
[32m+[m[32m--select * from IssueMentalHealth --"isIncounseling"[m
[32m+[m
[32m+[m[32m--select * from ListItem[m
[32m+[m[32m--where ListLabel like '%Counsel%'[m
[32m+[m
[32m+[m[32m--select distinct ListValue from ListItem where ListLabel like '%Counsel%'[m[41m [m
\ No newline at end of file[m
[1mdiff --git a/Constructing graduate table.sql b/Constructing graduate table.sql[m
[1mindex 8c80d47..50e52f5 100644[m
[1m--- a/Constructing graduate table.sql[m	
[1m+++ b/Constructing graduate table.sql[m	
[36m@@ -116,5 +116,22 @@[m [morder by ClientName[m
 [m
 ------------------------ generating the counseling session records for each client--------------------------------[m
 ------------------------------------------------------------------------------------------------------------------[m
[32m+[m[32m-------[m[41m [m
[32m+[m[32m--select CaseNotes.CaseNoteSummary, CaseNotes.CaseNoteTypeID from CaseNotes where CaseNoteSummary LIKE '%Counseling%'[m
[32m+[m
[32m+[m
[32m+[m[32m--select CaseNoteID, CaseNoteSummary, CaseNoteTypeID from CaseNotes where CaseNoteTypeID in[m
[32m+[m[32m--(select distinct ListValue from ListItem where ListLabel like '%Counsel%' )[m
[32m+[m
[32m+[m[32m--------- The following query returns 45007 rows[m
[32m+[m[32mselect Client.FirstName + ' ' + Client.LastName AS "Client_Name", Client.EntityId AS "ClientID",CaseNoteSummary, Body from Client[m
[32m+[m[32minner join CaseNotes[m[41m [m
[32m+[m[32mon CaseNotes.EntityID = Client.EntityID[m
[32m+[m[32mwhere CaseNoteSummary Like '%cousneling%' or CaseNoteSummary LIKE '%Counseling%' or Body LIKE '%counsel%'[m
[32m+[m
[32m+[m[32m--select * from CaseNotes --where Body LIKE '%counsel%'， this query returns 160000+ results, which basically contains all casenotes[m
[32m+[m
[32m+[m
[32m+[m[32m------------------------------------------------------------------------------------------------------------------[m
[32m+[m[32m------------------------ generating the counseling session records for each client--------------------------------[m
 [m
[31m-select * from CaseNotes where CaseNoteTypeID LIKE 'counselling case'???--- counselling case[m
\ No newline at end of file[m
