

select * from Program
select * from Enrollments

select ProgramName, count(EnrollmentID) as "open_enrollments" from Enrollment
inner join Program
on Program.ProgramID = Enrollment.ProgramID
where status = 100 and getdate() between Enrollment.BeginDate and Enrollment.EndDate
and Enrollment.DeletedDate > getdate()
group by Program.ProgramName
order by open_enrollments desc;


------ combine the two queries together， average age and open_enrollments
select ProgramName, AVG(datediff(YY, BirthDate, getdate())) as "Average_Age", count(Enrollment.EnrollmentID) as "open_enrollments" from Enrollment
inner join EnrollmentMember
on Enrollment.EnrollmentID = EnrollmentMember.EnrollmentID
inner join Client
on EnrollmentMember.ClientID = Client.EntityID
inner join Program on Enrollment.ProgramID = Program.ProgramID
where Enrollment.DeletedDate > getdate() and status = 100 and getdate() between Enrollment.BeginDate and Enrollment.EndDate
group by ProgramName
order by open_enrollments desc;

select * from Client 
where BirthDate <> ''
order by BirthDate desc;
