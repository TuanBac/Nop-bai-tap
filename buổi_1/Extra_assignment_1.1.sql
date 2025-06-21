DROP DATABASE IF EXISTS FresherManagement;
CREATE DATABASE FresherManagement;
USE FresherManagement;

-- Quesion1: Tạo table Trainee
CREATE TABLE Trainee
(
TraineeID INT AUTO_INCREMENT PRIMARY KEY,
Full_Name VARCHAR(50),
Birth_Date DATE,
Gender ENUM('Male','Female','Unknown'),
ET_IQ TINYINT UNSIGNED,
	CHECK (ET_IQ <= 20),
ET_Gmath TINYINT UNSIGNED,
	CHECK (ET_Gmath <= 20),
ET_English TINYINT UNSIGNED,
	CHECK (ET_English <= 50),
Training_Class CHAR(10),
Evaluation_Notes TEXT
);
-- Question 2: Thêm trường VTI_Account với điều kiện not null & unique
ALTER TABLE Trainee ADD COLUMN VTI_Account VARCHAR(30) NOT NULL UNIQUE;
