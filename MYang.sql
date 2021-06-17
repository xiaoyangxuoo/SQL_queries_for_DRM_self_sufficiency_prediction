-- select * from Enrollment
-- open enrollments per program, -- status =100, getdate() between begindate and enddate, avg age of person in each program

-- select getdate() as "current_date"
select * from EnrollmentMember;

----- with count aggregation
select ProgramID, count(EnrollmentID) as "open_enrollments" from Enrollment
where status = 100 and getdate() between BeginDate and EndDate
group by ProgramID
order by ProgramID

----- with no aggregation
select ProgramID, EnrollmentID from Enrollment
where status = 100 and getdate() between BeginDate and EndDate;

----- average age of each person in each program
select * from client

select * from EnrollmentMember

select * from Enrollment


---------average age of each person in each program

select ProgramName, AVG(datediff(YY, BirthDate, getdate())) as "Average_Age" from Enrollment
inner join EnrollmentMember
on Enrollment.EnrollmentID = EnrollmentMember.EnrollmentID
inner join Client
on EnrollmentMember.ClientID = Client.EntityID
inner join Program on Enrollment.ProgramID = Program.ProgramID
group by ProgramName;



select * from users
---- report how many users are there in each organization
select OrgName, count(UserName) as "Count_of_Users" from users
inner join Organization
on Users.OrganizationID = Organization.EntityID
where isActive = 1
group by OrgName
order by "Count_of_Users"


select EntityID from Users where UserName = 'Myang'


--- Take a look at all tables that are located inside the database
select * from INFORMATION_SCHEMA.TABLES
--
--where TABLE_NAME ='Enrollment'
where TABLE_SCHEMA = 'dbo'
and TABLE_NAME like '%Gender%'
order by TABLE_NAME;
GO



--- randomly sampling 10% of the all available rows,, random sampling!
select TOP 10 percent FirstName from users
where FirstName <> ''
order by NEWID()

----- Check to see if any client comes to our organization more than twice
select cl.FirstName, cl.LastName, cl.CreatedDate as "First_Date", cr.CreatedDate as "Second_Date" from Client cl
inner join Client cr
on cl.FirstName = cr.FirstName and cl.LastName = cr.LastName
and cl.Birthdate = cr.Birthdate
and (DATEPART(YEAR, cl.CreatedDate) <> DATEPART(YEAR,cr.CreatedDate) OR (DATEPART(YEAR, cl.CreatedDate) = DATEPART(YEAR, cl.CreatedDate) and DATEPART(MONTH, cl.CreatedDate) <> DATEPART(MONTH, cl.CreatedDate))) ---- different year of same year but different month





select * from WriteOffs