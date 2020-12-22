-- Question 7-25 (Part a): Display the course ID and course name for all courses
-- with an ISM prefix.
-- SOLUTION: Select CourseID and CourseName from the Course table and filter 
-- rows to only those where CourseID begins with 'ISM'. Order the returned rows
-- by CourseID in Ascending order.
SELECT CourseID as "Course ID", CourseName as "Course Name"
FROM uricba.Course
WHERE CourseID LIKE 'ISM%'
ORDER BY CourseID;

-- Question 7-25 (Part b): Display all courses for which Professor Berndt has
-- been qualified.
-- SOLUTION: Select CourseID and CourseName from the Course table. Use an inner
-- join to join the Course table on the Faculty table on the PK-FK pair 
-- (FacultyID). Use the Where clause to only return rows where FacultyName
-- equals 'Berndt'. Order the returned rows by CourseName in Ascending order.
SELECT cou.CourseID as "Course ID", cou.CourseName as "Course Name"
FROM uricba.Course cou INNER JOIN uricba.Qualified qual ON
cou.CourseID = qual.CourseID
INNER JOIN uricba.Faculty fac ON fac.FacultyID = qual.FacultyID
WHERE fac.FacultyName = 'Berndt'
ORDER BY cou.CourseName;

-- Question 7-25 (Part c): Display the class roster, including student name, for
-- all students enrolled in section 2714 of ISM 4212.
-- SOLUTION: Select StudentID and StudentName from the Student table, CourseID
-- from the Course table, and SectionNo from the Section table. Use an inner
-- join operation to join the Student table on the Registration table on the 
-- PK-FK pair (StudentID). Use a second inner join operation to join the Section
-- table on the Registration table on the PK-FK pair (SectionNo). Use the Where 
-- clause to only return rows where SectionNo in the Registration table equals 
-- 2714. Order the returned rows by StudentID from the Student table in 
-- Ascending order.
SELECT stu.StudentID as "Student ID", stu.StudentName as "Student Name",
sec.CourseID as "Course ID", sec.SectionNo as "Section Number"
FROM uricba.Student stu INNER JOIN uricba.Registration reg ON
stu.StudentID = reg.StudentID
INNER JOIN uricba.Section sec ON sec.SectionNo = reg.SectionNo
WHERE reg.SectionNo = 2714
ORDER BY stu.StudentID;

-- Question 7-26: Which instructors are qualified to teach ISM 3113?
-- SOLUTION: Select FacultyID and FacultyName from the Faculty table. Use an 
-- inner join operation to join the Faculty table on the Qualfied table on the 
-- PK-FK pair (FacultyID). Use the Where clause to only return rows where 
-- CourseID in the Qualfied table equals 'ISM 3113'. Order the returned rows by 
-- FacultyName from the Faculty table in Ascending order.
SELECT fac.FacultyID as "Faculty ID", fac.FacultyName as "Instructor Name"
FROM uricba.Faculty fac INNER JOIN uricba.Qualified qual ON
fac.FacultyID = qual.FacultyID
WHERE qual.CourseID = 'ISM 3113'
ORDER BY fac.FacultyName;

-- Question 7-27: Is any instructor qualified to teach ISM 3113 and not
-- qualified to teach ISM 4930?
-- SOLUTION: Select both FacultyID and FacultyName from the Faculty table. Use 
-- an inner join operation to join the Faculty table with the Qualified table on
-- PK-FK pair (FacultyID). Use the Where clause to only return rows where 
-- CourseID in the Qualified table equals 'ISM 3113'. Also use a non-correlated
-- subquery in the Where clause to only return rows where FacultyName from the 
-- Faculty Table is not in the list of Faculty members qualified to teach 
-- ISM 4930. Order the returned rows by FacultyName from the Course table in 
-- Ascending order.
SELECT fac.FacultyID as "Faculty ID", fac.FacultyName as "Instructor Name"
FROM uricba.Faculty fac INNER JOIN uricba.Qualified qual ON
fac.FacultyID = qual.FacultyID
WHERE qual.CourseID = 'ISM 3113' AND fac.FacultyName NOT IN 
(SELECT fac.FacultyName as "Instructor Name"
FROM uricba.Faculty fac INNER JOIN uricba.Qualified qual ON
fac.FacultyID = qual.FacultyID
WHERE qual.CourseID = 'ISM 4930')
ORDER BY fac.FacultyName;

-- Question 7-28 (Part a): What are the names of the course(s) that student
-- Altvater took during the semester I-2015?
-- SOLUTION: Select CourseName from the Course table. Use three 
-- inner join operations to join four tables (Course, Section, Registration,
-- Student) on the corresponding PK-FK pairs. Use the Where clause to 
-- only return rows where StudentName in the Student table equals 'Altvater' and
-- where Semester in the Section table equals 'I-2015'. Order the returned rows 
-- by CourseName from the Course table in Ascending order.
SELECT cou.CourseName as "Course Name"
FROM uricba.Course cou INNER JOIN uricba.Section sec ON
cou.CourseID = sec.CourseID
INNER JOIN uricba.Registration reg ON sec.SectionNo = reg.SectionNo
INNER JOIN uricba.Student stu ON reg.StudentID = stu.StudentID
WHERE stu.StudentName = 'Altvater' AND sec.Semester = 'I-2015'
ORDER BY cou.CourseName;

-- Question 7-28 (Part b): List names of the students who have taken at least 
-- one course that Professor Collins is qualified to teach.
-- SOLUTION: Select distinct StudentID and StudentName values from the Student 
-- table. Use four inner join operations to join five tables (Student, 
-- Registration, Section, Qualfied, Faculty) on the corresponding PK-FK pairs. 
-- Use the Where clause to only return rows where FacultyID equals the Faculty 
-- ID for Professor Collins (i.e., 4756). Order the returned rows by StudentName
-- from the Student table in Ascending order.
SELECT DISTINCT stu.StudentID as "Student ID", stu.StudentName as "Student Name"
FROM uricba.Student stu INNER JOIN uricba.Registration reg ON
stu.StudentID = reg.StudentID
INNER JOIN uricba.Section sec ON sec.SectionNo = reg.SectionNo
INNER JOIN uricba.Qualified qual ON qual.CourseID = sec.CourseID
INNER JOIN uricba.Faculty fac ON fac.FacultyID = qual.FacultyID
WHERE qual.FacultyID = 4756
ORDER BY stu.StudentID;

-- Question 7-28 (Part c): How many students did Professor Collins teach during
-- the semester I-2015?
-- SOLUTION: Obtain a scalar aggregate of the number of Student IDs from the
-- Registration table using count(). Use three inner join operations to join 
-- four tables (Registration, Section, Qualfied, Faculty) on the corresponding 
-- PK-FK pairs. Use a Where clause to only returns rows in which the FacultyName
-- is equal to 'Collins' and the Semester is equal to 'I-2015'.
SELECT count(reg.StudentID) as "Number of Students"
FROM uricba.Registration reg INNER JOIN uricba.Section sec ON
sec.SectionNo = reg.SectionNo
INNER JOIN uricba.Qualified qual ON qual.CourseID = sec.CourseID
INNER JOIN uricba.Faculty fac ON fac.FacultyID = qual.FacultyID
WHERE fac.FacultyName = 'Collins' AND sec.Semester = 'I-2015'
ORDER BY count(reg.StudentID);