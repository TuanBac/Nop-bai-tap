USE test_1;
-- Question 1: Tạo view có chứa danh sách nhân viên thuộc phòng ban sale
CREATE OR REPLACE VIEW v_nhanvienphongsale AS
SELECT Fullname FROM `Account` a 
JOIN `Position` p
ON a.Position_ID = p.Position_ID 
WHERE p.position_name = 'Sale';
SELECT * FROM v_nhanvienphongsale;

WITH nhanvienphongsale AS(
SELECT Fullname FROM `Account` a 
JOIN `Position` p
ON a.Position_ID = p.Position_ID 
WHERE p.position_name = 'Sale'
)
SELECT Fullname FROM nhanvienphongsale;
-- Question 2: Tạo view có chứa thông tin các account tham gia vào nhiều group nhất
CREATE OR REPLACE VIEW v_account AS
SELECT a.Account_ID, a.Fullname, COUNT(ga.Group_ID) AS So_luong_group
FROM `Account` a JOIN Groupaccount ga
ON a.Account_ID = ga.Account_ID
GROUP BY a.Account_ID, a.Fullname
HAVING COUNT(ga.Group_ID) = (SELECT MAX(COUNT(ga.Group_ID))
				   FROM 
					(SELECT COUNT(ga.Group_ID)
	                                 FROM Groupaccount ga
	                                 GROUP BY ga.Account_ID) AS Sub
	                     );                      
SELECT * FROM v_account;

WITH thamgianhieugroupnhat AS(
SELECT a.Account_ID, a.Fullname, COUNT(ga.Group_ID) AS So_luong_group
FROM `Account` a JOIN Groupaccount ga
ON a.Account_ID = ga.Account_ID
GROUP BY a.Account_ID, a.Fullname
HAVING COUNT(ga.Group_ID) = (SELECT MAX(COUNT(ga.Group_ID))
			     FROM 
				(SELECT COUNT(ga.Group_ID)
                                  FROM Groupaccount ga
                                  GROUP BY ga.Account_ID) AS Sub
                             )
)
SELECT * FROM thamgianhieugroupnhat;
-- Question 3: Tạo view có chứa câu hỏi có những content quá dài (content quá 300 từ được coi là quá dài) và xóa nó đi
CREATE OR REPLACE VIEW v_quadai AS
SELECT q.Content, LENGTH(q.Content)
FROM Question q 
WHERE LENGTH(q.Content) > 60;
SELECT * FROM v_quadai;
DELETE FROM v_quadai;
-- Question 4: Tạo view có chứa danh sách các phòng ban có nhiều nhân viên nhất
CREATE OR REPLACE VIEW v_department AS
SELECT d.Department_name, COUNT(a.Account_ID) AS So_nhan_vien
FROM Department d JOIN `Account` a
ON d.Department_ID = a.Department_ID
GROUP BY d.Department_ID, d.Department_name
HAVING COUNT(a.Account_ID) = (SELECT MAX(COUNT(a.Account_ID)) 
				FROM 
				(SELECT COUNT(a.Account_ID)
				FROM `Account` a 
				GROUP BY a.Department_ID) AS Sub
			      );
SELECT * FROM v_department;
-- Question 5: Tạo view có chứa tất các các câu hỏi do user họ Nguyễn tạo
CREATE OR REPLACE VIEW v_nguyen AS
SELECT q.Content, a.Username, a.Fullname 
FROM Question q JOIN `Account` a
ON q.Creator_ID = a.Account_ID
WHERE Fullname LIKE 'Nguyen%';
SELECT * FROM v_nguyen;

WITH ho_nguyen AS (
SELECT q.Content, a.Username, a.Fullname 
FROM Question q JOIN `Account` a
ON q.Creator_ID = a.Account_ID
WHERE Fullname LIKE 'Nguyen%'
)
SELECT Content, Username, Fullname FROM ho_nguyen;
