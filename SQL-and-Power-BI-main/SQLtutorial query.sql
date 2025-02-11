-- Create the Students table to store student information
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DateOfBirth DATE,
    Gender VARCHAR(10),
    Email VARCHAR(100),
    PhoneNumber VARCHAR(20)
);

-- Create the Courses table to store information about available courses
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    CourseDescription TEXT,
    CreditHours INT
);

-- Create the StudentCourses table to track which students are registered for which courses
CREATE TABLE StudentCourses (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    RegisteredYear INT,
    CONSTRAINT FK_StudentID FOREIGN KEY (StudentID) REFERENCES Students (StudentID),
    CONSTRAINT FK_CourseID FOREIGN KEY (CourseID) REFERENCES Courses (CourseID)
);

-- Update the CourseID from 1 to 1011 for a specific record in the Courses table
UPDATE Courses
SET CourseID = 1011
WHERE CourseID = 1;

-- Insert a new student into the Students table
INSERT INTO Students (StudentID, FirstName, LastName, DateOfBirth, Gender, Email, PhoneNumber)
VALUES (1, 'John', 'Doe', '1995-01-15', 'Male', 'johndoe@example.com', '123-456-7890');

-- Insert another student
INSERT INTO Students (StudentID, FirstName, LastName, DateOfBirth, Gender, Email, PhoneNumber)
VALUES (2, 'Jane', 'Smith', '1998-03-22', 'Female', 'janesmith@example.com', '987-654-3210');

-- Insert a new course into the Courses table
INSERT INTO Courses (CourseID, CourseName, CourseDescription, CreditHours)
VALUES (1, 'Introduction to Programming', 'An introductory programming course', 3);

-- Insert another course
INSERT INTO StudentCourses (EnrollmentID, StudentID, CourseID, RegisteredYear)
VALUES (2, 2, 2, 2022);

-- Insert a record indicating that student 1 registered for course 1 in 2023
INSERT INTO StudentCourses (EnrollmentID, StudentID, CourseID, RegisteredYear)
VALUES (1, 1, 1, 2023);

-- Insert another record for student 2 and course 2 in 2022
INSERT INTO StudentCourses (EnrollmentID, StudentID, CourseID, RegisteredYear)
VALUES (2, 2, 2, 2022);

select *
from StudentCourses
where CourseID = 1

update StudentCourses
set CourseID = 1011
where CourseID = 1

exec sp_helpconstraint 'StudentCourses';

exec sp_helpconstraint 'Students';

exec sp_helpconstraint 'Courses';

alter table Students
drop constraint FK_StudentID

Alter table StudentCourses
drop constraint FK_CourseID

Alter table StudentCourses
drop constraint FK_StudentID

Alter table Courses
drop constraint FK_CourseID

update StudentCourses
set CourseID = 1012
where CourseID = 2

select * from Courses

update Courses
set CourseID = 1011
where CourseID = 1


update Courses
set CourseID = 1012
where CourseID = 2

select * from Students

update Students
set StudentID = 101
where StudentID = 1

update Students
set StudentID = 102
where StudentID = 2

select * from Students

select * from StudentCourses

update StudentCourses
set StudentID = 
	case 
		when StudentID = 1 then 101
		when StudentID = 2 then 102
		else StudentID
	end;
	01
where StudentID = 1

INSERT INTO StudentCourses (EnrollmentID, StudentID, CourseID, RegisteredYear)
VALUES 
	(3, 103, 1008, 2022),
	(4, 105, 2503, 2021),
	(5, 106, 4106, 2022);

select * from Students s
join StudentCourses sc
on s.StudentID = sc.StudentID
join Courses c
on sc.CourseID = c.CourseID

INSERT INTO Courses (CourseID, CourseName, CourseDescription, CreditHours)
VALUES 
	(5803, 'Introduction to Machine Learning', 'An introductory ML course', 3),
	(5000, 'Introduction to Data Science', 'An principal data science course', 3),
	(5035, 'Object Oriented programming', 'An Object Oriented programming course', 3);

select * from Courses

select * from StudentCourses

update StudentCourses
set CourseID = 5035
where CourseID = 2503

select * from Students

insert into Students (StudentID, FirstName, LastName, DateOfBirth, Gender, Email, PhoneNumber)
values
	(103, 'Olga', 'Livenston', '1997-08-09', 'Female', 'olgalivenston@example.com', '613-123-4567'),
	(104, 'Zoe', 'Hinton', '1996-07-10', 'Female', 'Zoehinton@example.com', '613-502-3856'),
	(105, 'Nora', 'Hampton', '1999-11-27', 'Male', 'norahampton@example.com', '613-416-8500');

	select * from StudentCourses