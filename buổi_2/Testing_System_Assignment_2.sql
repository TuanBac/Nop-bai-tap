DROP DATABASE IF EXISTS `Test_1`;
CREATE DATABASE `Test_1`;
USE `Test_1`;

-- Table 1: Department
CREATE TABLE `Department`
(
	Department_ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Department_Name VARCHAR(20) NOT NULL UNIQUE
);
-- Table 2: Position
CREATE TABLE `Position`
(
	Position_ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Position_Name VARCHAR(50) NOT NULL UNIQUE
);
-- Table 3: Account
CREATE TABLE `Account`
(
	Account_ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Email VARCHAR(50) NOT NULL UNIQUE,
    Username VARCHAR(30) NOT NULL UNIQUE,
    Fullname VARCHAR(50) NOT NULL,
    Department_ID INT UNSIGNED NOT NULL,
    Position_ID INT UNSIGNED NOT NULL,
    Createdate DATE,
	FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID),
    FOREIGN KEY (Position_ID) REFERENCES `Position`(Position_ID)
);
-- Table 4: Group
CREATE TABLE `Group`
(
	Group_ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Group_name VARCHAR(30) NOT NULL UNIQUE,
    Creator_ID INT UNSIGNED NOT NULL,
    Createdate DATE,
    FOREIGN KEY (Creator_ID) REFERENCES `Account`(Account_ID)
);
-- Table 5: Group Account
CREATE TABLE `GroupAccount`
(
	Group_ID INT UNSIGNED NOT NULL,
    Account_ID INT UNSIGNED NOT NULL,
    Joindate DATE,
    FOREIGN KEY(Group_ID) REFERENCES `Group`(Group_ID),
    FOREIGN KEY(Account_ID) REFERENCES `Account`(Account_ID)
);
-- Table 6: TypeQuestion
CREATE TABLE `TypeQuestion`
(
	Type_ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Type_name ENUM('Essay', 'Multiple Choice')
);
-- Table 7: CategoryQuestion
CREATE TABLE `CategoryQuestion`
(
	Category_ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Category_name VARCHAR(50) NOT NULL
);
-- Table 8: Question
CREATE TABLE `Question`
(
	Question_ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
	Content VARCHAR(500) NOT NULL,
	Category_ID INT UNSIGNED NOT NULL,
	Type_ID INT UNSIGNED NOT NULL,
	Creator_ID INT UNSIGNED NOT NULL,
	CreateDate DATE,
    FOREIGN KEY (Category_ID) REFERENCES CategoryQuestion(Category_ID),
    FOREIGN KEY (Type_ID) REFERENCES TypeQuestion(Type_ID),
    FOREIGN KEY (Creator_ID) REFERENCES `Account`(Account_ID)
);
-- Table 9: Answer
CREATE TABLE `Answer`
(
	Answer_ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Content VARCHAR(500) NOT NULL,
    Question_ID INT UNSIGNED NOT NULL,
    isCorrect BIT(1),
    FOREIGN KEY (Question_ID) REFERENCES Question(Question_ID)
);
-- Table 10: Exam
CREATE TABLE `Exam`
(
	Exam_ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `Code` CHAR(8) NOT NULL,
    Title VARCHAR(30) NOT NULL,
    Category_ID INT UNSIGNED NOT NULL,
    Duration INT UNSIGNED NOT NULL,
    Creator_ID INT UNSIGNED NOT NULL,
    CreateDate DATE,
    FOREIGN KEY (Category_ID) REFERENCES CategoryQuestion(Category_ID),
    FOREIGN KEY (Creator_ID) REFERENCES `Account`(Account_ID)
);
-- Table 11: Exam Question
CREATE TABLE `ExamQuestion`
(
	Exam_ID INT UNSIGNED NOT NULL,
    Question_ID INT UNSIGNED NOT NULL,
    FOREIGN KEY (Exam_ID) REFERENCES Exam(Exam_ID),
	FOREIGN KEY (Question_ID) REFERENCES Question(Question_ID)
);
	-- Excersise 2 
    -- Question 1: Thêm ít nhất 10 record vào mỗi table 
    
INSERT INTO `Department` (Department_Name)
VALUES ('Marketing'), ('Sale'), ('Bảo vệ'), ('Nhân Sự'), ('Kỹ thuật'), ('Tài chính'), ('Phó giám đốc'), ('Giám đốc'), ('Thư kí'), ('Bán hàng');
INSERT INTO `Position` (Position_Name)
VALUES ('Dev'), ('Test'), ('Scrum Master'), ('PM'), ('Phân tích nghiệp vụ'),('Chủ sản phẩm'),('Nhà thiết kế'),('Kỹ sư DevOps'),('Phân tích dữ liệu'),('Trưởng nhóm kỹ thuật');
INSERT INTO `Account` (Email, Username, Fullname, Department_ID, Position_ID, CreateDate)
VALUES 
('tuan.nguyenduc@gmail.com', 'tuanbac999', 'Nguyen Duc Tuan', 1, 1, '2025-01-01'),
('phungthanhdo8@gmail.com', 'dotay123', 'Phung Thanh Do', 2, 2, '2025-01-05'),
('bitishunter666@gmail.com', 'bitisadadis', 'Le Dinh Thong', 1, 1, '2025-01-10'),
('voicoibietbay@gmail.com', 'voicon2chan', 'Tran Dinh Hung', 4, 4, '2025-02-01'),
('kevincalvin@gmail.com', 'quantamgiac4canh', 'Lo Van Vin', 5, 2, '2025-02-10'),
('trananh99@gmail.com', 'anhtran1', 'Tran Van Anh', 2, 3, '2025-03-05'),
('phananhtu4@gmail.com', 'tututu2', 'Phan Thanh Tu', 3, 1, '2025-04-09'),
('emlaconga1@gmail.com', 'gaconxxx', 'Le Ba Hoang', 2, 4, '2025-11-1'),
('heoconchandai3@gmai.com', 'conheo3chan', 'Pham Vu Vuong', 3, 5, '2024-05-13'),
('sutocdai8686@gmail.com', 'xetangtuotxich02', 'Luong Thanh Trung', 3, 4, '2025-07-01');
INSERT INTO `Group` (Group_name, Creator_ID, CreateDate)
VALUES
('Nhóm Dev', 1, '2024-03-01'),
('Nhóm Tester', 2, '2024-03-02'),
('Nhóm Backend', 1, '2024-04-01'),
('Nhóm Frontend', 2, '2018-04-02'),
('Nhóm QA', 3, '2024-04-03'),
('Nhóm Marketing Online', 4, '2024-04-04'),
('Nhóm Dự án A', 5, '2024-04-05'),
('Nhóm Hành chính', 7, '2024-04-07'),
('Nhóm Training', 9, '2024-04-09'),
('Nhóm Luật pháp', 10, '2024-04-10');
INSERT INTO `GroupAccount` (Group_ID, Account_ID, Joindate)
VALUES
(1, 1, '2025-03-10'),
(2, 2, '2025-03-11'),
(3, 3, '2025-03-12'),
(4, 4, '2025-03-13'),
(5, 5, '2025-03-14'),
(6, 6, '2025-04-17'),
(7, 7, '2025-04-18'),
(8, 8, '2025-04-19'),
(9, 9, '2025-04-20'),
(10, 10, '2025-03-02');
INSERT INTO `TypeQuestion` (Type_name)
VALUES ('Essay'), ('Multiple Choice'), ('Multiple Choice'), ('Multiple Choice'), ('Essay'), ('Multiple Choice'), ('Essay'), ('Essay'), ('Essay'), ('Multiple Choice');
INSERT INTO `CategoryQuestion` (Category_name)
VALUES ('Java'), ('SQL'), ('Python'), ('Thiết kế'), ('Marketing'),('Pháp luật'), ('Dự án'), ('Tài chính'), ('Xã hội'), ('Hành chính');
INSERT INTO `Question` (Content, Category_ID, Type_ID, Creator_ID, CreateDate)
VALUES
('Java là gì?', 1, 1, 1, '2024-04-01'),
('JOIN trong SQL là gì?.', 2, 1, 2, '2024-04-02'),
('Phiên bản mới nhất của Python là bao nhiêu?', 3, 2, 3, '2024-04-03'),
('Thiết kế UI khác UX thế nào?', 4, 1, 4, '2024-04-04'),
('Hình thức Marketing phổ biến nhất hiện nay là gì?', 5, 1, 5, '2024-04-05'),
('Đánh người gây thương tích trên 11% thì đi tù bao lâu?', 6, 1, 10, '2025-06-11'),
('Quản lý rủi ro trong dự án có tác dụng gì?', 7, 1, 5, '2024-05-07'),
('Có 500 triệu thì nên đầu tư vào đâu?', 6, 1, 2, '2025-11-04'),
('Tại sao tỉ lệ sinh ở Việt Nam giảm?', 10, 1, 5, '2025-01-01'),
('Làm CCCD sau bao lâu thì được nhận?', 9, 2, 1, '2025-08-09');
INSERT INTO `Answer` (Content, Question_ID, isCorrect)
VALUES
('Java là ngôn ngữ lập trình dễ tiếp cận.', 1, b'1'),
('JOIN giúp kết hợp nhiều bảng.', 2, b'1');
INSERT INTO `Answer` (Content, Question_ID, isCorrect)
VALUES -- Multi-choice
('Python 3.10.6', 3, b'0'),
('Python 3.11.5', 3, b'0'),
('Python 3.12.3', 3, b'0'),
('Python 3.13.2', 3, b'1');
INSERT INTO `Answer` (Content, Question_ID, isCorrect)
VALUES
('UI là giao diện, UX là trải nghiệm người dùng.', 4, b'1'),
('Digital Marketing - Tiếp thị Kỹ thuật số.', 5, b'1'),
('Từ 5 năm đến 10 năm tù', 6, b'1'),
('Quản lý rủi ro giúp giảm thiểu tác động tiêu cực.', 7, b'1'),
('Mua vàng hoặc BĐS', 8, b'1'),
('Do giới trẻ bị áp lực kinh tế, ưu tiên phát triển sự nghiệp', 9, b'1');
INSERT INTO `Answer` (Content, Question_ID, isCorrect)
VALUES -- Multi-choice
('7 ngày.', 10, b'1'),
('14 ngày.', 10, b'0'),
('30 ngày.', 10, b'0'),
('60 ngày.', 10, b'0');
INSERT INTO `Exam` (`Code`, Title, Category_ID, Duration, Creator_ID, CreateDate)
VALUES
('JV001ABC', 'Kiểm tra Java cơ bản', 1, 90, 1, '2019-06-01'),
('SQL002XY', 'Luyện tập SQL nâng cao', 2, 45, 2, '2025-06-02'),
('PYT003DD', 'Hiểu biết về Python', 3, 40, 3, '2025-06-03'),
('UX004UIX', 'Thi thiết kế UI/UX', 4, 35, 4, '2025-06-04'),
('MKT005PR', 'Marketing thực chiến', 5, 50, 5, '2025-06-05'),
('LUAT06PL', 'Kiến thức pháp luật', 6, 30, 10, '2025-06-06'),
('PM0007DC', 'Quản lý dự án', 7, 60, 5, '2025-06-07'),
('TC0003CT', 'Đầu tư có lãi', 8, 30, 3, '2025-06-08'),
('XHVN25CI', 'Hiểu biết xã hội cơ bản', 9, 45, 6, '2025-06-09'),
('HANH10HC', 'Nội quy công ty', 10, 25, 7, '2025-06-10');
INSERT INTO `ExamQuestion` (Exam_ID, Question_ID)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);
	-- Question 2: Lấy ra tất cả các phòng ban 
SELECT * FROM `Department`;
	-- Question 3: Lấy ra id của phòng ban "Sale" 
SELECT * FROM `Department` WHERE Department_name = 'Sale';
	-- Question 4: Lấy ra thông tin account có full name dài nhất
SELECT * FROM `Account` WHERE LENGTH(Fullname) = (SELECT MAX(LENGTH(Fullname)) FROM `Account`);
	-- Question 5: Lấy ra thông tin account có full name dài nhất và thuộc phòng ban có id  = 3 
SELECT * FROM `Account` WHERE LENGTH(Fullname) = (SELECT MAX(LENGTH(Fullname)) FROM `Account` WHERE Department_ID = 3);
	-- Question 6: Lấy ra tên group đã tham gia trước ngày 20/12/2019 
SELECT Group_name FROM `Group` WHERE Createdate < '2019-12-20';
	-- Question 7: Lấy ra ID của question có >= 4 câu trả lời 
SELECT Question_ID FROM `Answer` GROUP BY Question_ID HAVING COUNT(*) >= 4;
	-- Question 8: Lấy ra các mã đề thi có thời gian thi >= 60 phút và được tạo trước ngày 20/12/2019 
SELECT `Code` FROM Exam WHERE Duration >= 60 AND CreateDate < '2019-12-20';
	-- Question 9: Lấy ra 5 group được tạo gần đây nhất 
SELECT * FROM `Group` ORDER BY Createdate DESC LIMIT 5;
	-- Question 10: Đếm số nhân viên thuộc department có id = 2 
SELECT COUNT(*) FROM `Account` WHERE Department_ID = 2;
	-- Question 11: Lấy ra nhân viên có tên bắt đầu bằng chữ "D" và kết thúc bằng chữ "o"
SELECT Fullname FROM `Account` WHERE Fullname LIKE 'D%' AND '%o';
	-- Question 12: Xóa tất cả các exam được tạo trước ngày 20/12/2019  
DELETE FROM `Exam` WHERE CreateDate < '2019-12-20'; -- Lỗi do có ràng buộc khóa phụ với bảng khác  
	-- Question 13: Xóa tất cả các question có nội dung bắt đầu bằng từ "câu hỏi" 
DELETE FROM `Question` WHERE Content LIKE 'câu hỏi%';
	-- Question 14: Update thông tin của account có id = 5 thành tên "Nguyễn Bá Lộc" và email thành loc.nguyenba@vti.com.vn 
UPDATE `Account` SET Fullname = 'Nguyễn Bá Lộc', Email = 'loc.nguyenba@vti.com.vn' WHERE Account_ID = 5;
	-- Question 15: update account có id = 5 sẽ thuộc group có id = 4 
UPDATE `Group` SET Group_ID = 4 WHERE Creator_ID = 5; -- (Creator_ID chính là Account_ID) Lỗi do có ràng buộc với bảng khác 
UPDATE `GroupAccount` SET Group_ID = 4 WHERE Account_ID = 5; -- Chạy ngon 



 
