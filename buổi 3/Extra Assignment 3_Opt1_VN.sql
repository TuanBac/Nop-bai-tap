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
Training_Class CHAR(5),
Evaluation_Notes TEXT
);
-- Question 2: Thêm trường VTI_Account với điều kiện not null & unique
ALTER TABLE Trainee ADD COLUMN VTI_Account VARCHAR(30) NOT NULL UNIQUE;

-- Question 1: Thêm ít nhất 10 bản ghi vào table
INSERT INTO Trainee (Full_Name, Birth_Date, Gender, ET_IQ, ET_Gmath, ET_English, Training_Class, Evaluation_Notes, VTI_Account)
VALUES 
('Nguyễn Văn A', '2000-05-20', 'Male', 3, 13, 8, 'A001', 'Học viên có tư duy tốt, cần cải thiện tiếng Anh.', 'nguyenvana'),
('Trần Thị B', '1999-11-15', 'Female', 19, 9, 26, 'A001', 'Tiến bộ nhanh, chăm chỉ.', 'tranthib'),
('Lê Văn C', '2001-02-10', 'Male', 12, 20, 29, 'A002', 'Có khả năng làm việc nhóm tốt.', 'levanc'),
('Phạm Thị D', '1998-08-08', 'Unknown', 15, 19, 9, 'A002', 'Giao tiếp tốt, cần cải thiện toán logic.', 'phamthid'),
('Hoàng Văn E', '2000-12-01', 'Male', 19, 14, 19, 'A003', 'Điểm đầu vào cao, tư duy rõ ràng.', 'hoangvane'),
('Đỗ Thị F', '2001-07-07', 'Female', 9, 1, 27, 'A003', 'Chăm chỉ, chưa nổi bật.', 'dothif'),
('Vũ Văn G', '1999-09-09', 'Unknown', 19, 0, 2, 'A001', 'Có tiềm năng phát triển.', 'vuvang'),
('Ngô Thị H', '2002-03-03', 'Unknown', 20, 1, 39, 'A002', 'Học viên trung bình khá.', 'ngothih'),
('Bùi Văn I', '1997-04-04', 'Male', 11, 2, 42, 'A003', 'Cần cải thiện tất cả các kỹ năng.', 'buivani'),
('Đặng Thị K', '2000-06-06', 'Female', 13, 5, 33, 'A001', 'Học viên xuất sắc.', 'dangthik');
/* Question 2: Viết lệnh để lấy ra tất cả các thực tập sinh đã vượt qua bài test đầu vào, 
	giả sử với điều kiện thỏa mãn số điểm ET_IQ>=5, ET_Gmath>=5 ET_English>=15,
	nhóm chúng thành các tháng sinh khác nhau  */
SELECT Full_name, MONTH(Birth_date) AS Tháng_Sinh,
	   ET_IQ, ET_Gmath, ET_English
FROM Trainee 
WHERE ET_IQ>=5 AND 
	  ET_Gmath>=5 AND
      ET_English>=15
ORDER BY Tháng_sinh;
/* Question 3: Viết lệnh để lấy ra thực tập sinh có tên dài nhất,
lấy ra các thông tin sau: tên, tuổi, các thông tin cơ bản (như đã được định nghĩa trong table) */
SELECT *
FROM trainee 
WHERE CHAR_LENGTH(Full_name) = (SELECT MAX(CHAR_LENGTH(Full_name)) FROM trainee);

/* Question 4: Viết lệnh để lấy ra tất cả các thực tập sinh là ET,
1 ET thực tập sinh là những người đã vượt qua bài test đầu vào và thỏa mãn số điểm như sau:
ET_IQ + ET_Gmath>=20 ET_IQ>=8
ET_Gmath>=8 ET_English>=18 */
SELECT Full_name AS ET, ET_IQ, ET_Gmath, ET_English
FROM trainee
WHERE (ET_IQ + ET_Gmath)>=20 AND ET_IQ>=8 AND ET_Gmath>=8 AND ET_English>=18;

-- Question 5: xóa thực tập sinh có TraineeID = 3
DELETE 
FROM trainee
WHERE TraineeID = 3;

-- Question 6: Thực tập sinh có TraineeID = 5 được chuyển sang lớp "2". Hãy cập nhật thông tin vào database
UPDATE Trainee
SET Training_Class = '2'
WHERE TraineeID = 5;
