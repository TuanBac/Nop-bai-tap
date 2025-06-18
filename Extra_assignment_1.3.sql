DROP DATABASE IF EXISTS Assignment3;
CREATE DATABASE Assignment3;
USE Assignment3;

CREATE TABLE Thongtin
(
	ID MEDIUMINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `Name` VARCHAR(30) NOT NULL,
    BirthDate DATE,
    Gender BIT NULL,
    -- 0 là Male, 1 là Female, NULL là Unknown.
    IsDeletedFlag BIT NOT NULL
    -- 0 là đang hoạt động, 1 là đã xóa.
);
