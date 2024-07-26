# Institute Informtion System (IIS)
<br>

## PROJECT DESCRIPTION
The Institute Information System (IIS) is a comprehensive web application designed to streamline administrative tasks and enhance the academic experience for both the students and teachers. The system offers a range of features tailed to meet the specific needs of each user group.
<br>
<br>

## Concepts Used 
HTML, Javascript, JSP, Servlets, Cookies, Session Tracking, Php, JDBC Database Connectivity, Ajax

<br>
<br>

## MODULES
### Authentication: This module consists of the login and signup pages which allows the user to register an account on this website and login to them to post content.

-	Login: Secure login mechanism for students and teachers.

-	Registration: Allows new pre defined nominal roll member to register for the iis portal.

> Attributes: username, email, password
> <br>
> Functions: validate(), register(), login()
<br>
### Student Module: It is the home page for the students.

-	Course Registration: Students can browse courses for the upcoming semester.

-	Semester Result: Enables students to view their results for the previous sem.

-	Attendance: Provides students with a real time view of their attendance.

> Attributes: course, id, username, semester, result, attendance
> <br>
>Functions: Submit(), getResult(), logout(), getAttendance
<br>
###	Teacher Module: It is the home page for teacher.

-	Internal Marks Entry: Teachers can enter or update internal marks of students. 

-	Attendance Management: Facilitates daily attendance recording. 

-	Schedule Management: Teacher can  view their teaching subjects and allocated batch details.

> Attributes: name, id, username, marks, date, semester, course
> <br>
> Functions: submit(), Edit(), getEvent() 
<br>
### Profile: This module will display the information of logged in user like the username, profile image, total content, their posts etc. 

> Attributes: id, username, date, content, batch, course, department
> <br>
> Functions: retrieveContent(), getUser 

<br>
<br>

starting point:- login.jsp
<br>
change database configuration in JSP,Servelets
<br>
php folder contains php files
