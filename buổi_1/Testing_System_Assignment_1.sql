DROP DATABASE IF EXISTS `Test_1`;
CREATE DATABASE `Test_1`;
USE `Test_1`;

-- Table 1: Department
CREATE TABLE `Department`
(
	DepartmentID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    DepartmentName VARCHAR(20) NOT NULL UNIQUE
);
-- Table 2: Position
CREATE TABLE `Position`
(
	PositionID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    PositionName ENUM('Dev', 'Test', 'Scrum Master', 'PM')
);
-- Table 3: Account
CREATE TABLE `Account`
(
	AccountID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Email VARCHAR(50) NOT NULL UNIQUE,
    Username VARCHAR(30) NOT NULL UNIQUE,
    Fullname VARCHAR(50) NOT NULL,
    DepartmentID INT UNSIGNED NOT NULL,
    PositionID INT UNSIGNED NOT NULL,
    Createdate DATE,
	FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    FOREIGN KEY (PositionID) REFERENCES `Position`(PositionID)
);
-- Table 4: Group
CREATE TABLE `Group`
(
	GroupID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Groupname VARCHAR(30) NOT NULL UNIQUE,
    CreatorID INT UNSIGNED NOT NULL,
    Createdate DATE,
    FOREIGN KEY (CreatorID) REFERENCES `Account`(AccountID)
);
-- Table 5: Group Account
CREATE TABLE `GroupAccount`
(
	GroupID INT UNSIGNED NOT NULL,
    AccountID INT UNSIGNED NOT NULL,
    Joindate DATE,
    FOREIGN KEY(GroupID) REFERENCES `Group`(GroupID),
    FOREIGN KEY(AccountID) REFERENCES `Account`(AccountID)
);
-- Table 6: TypeQuestion
CREATE TABLE `TypeQuestion`
(
	TypeID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Typename ENUM('Essay', 'Multiple Choice')
);
-- Table 7: CategoryQuestion
CREATE TABLE `CategoryQuestion`
(
	CategoryID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Categoryname VARCHAR(50) NOT NULL
);
-- Table 8: Question
CREATE TABLE `Question`
(
	QuestionID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
	Content VARCHAR(500) NOT NULL,
	CategoryID INT UNSIGNED NOT NULL,
	TypeID INT UNSIGNED NOT NULL,
	CreatorID INT UNSIGNED NOT NULL,
	CreateDate DATE,
    FOREIGN KEY (CategoryID) REFERENCES CategoryQuestion(CategoryID),
    FOREIGN KEY (TypeID) REFERENCES TypeQuestion(TypeID),
    FOREIGN KEY (CreatorID) REFERENCES `Account`(AccountID)
);
-- Table 9: Answer
CREATE TABLE `Answer`
(
	AnswerID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Content VARCHAR(500) NOT NULL,
    QuestionID INT UNSIGNED NOT NULL,
    isCorrect BIT(1),
    FOREIGN KEY (QuestionID) REFERENCES Question(QuestionID)
);
-- Table 10: Exam
CREATE TABLE `Exam`
(
	ExamID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `Code` CHAR(8) NOT NULL,
    Title VARCHAR(30) NOT NULL,
    CategoryID INT UNSIGNED NOT NULL,
    Duration INT UNSIGNED NOT NULL,
    CreatorID INT UNSIGNED NOT NULL,
    Createdate DATE,
    FOREIGN KEY (CategoryID) REFERENCES CategoryQuestion(CategoryID),
    FOREIGN KEY (CreatorID) REFERENCES `Account`(AccountID)
);
-- Table 11: Exam Question
CREATE TABLE `ExamQuestion`
(
	ExamID INT UNSIGNED NOT NULL,
    QuestionID INT UNSIGNED NOT NULL,
    FOREIGN KEY (ExamID) REFERENCES Exam(ExamID),
	FOREIGN KEY (QuestionID) REFERENCES Question(QuestionID)
);

    

