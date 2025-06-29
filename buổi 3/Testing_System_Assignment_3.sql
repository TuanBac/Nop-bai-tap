USE `test_1`;

-- Question 1: Viết lệnh để lấy ra danh sách nhân viên và thông tin phòng ban của họ
SELECT Fullname, Department_Name 
FROM `Account` a
LEFT JOIN Department d
ON a.Department_ID = d.Department_ID;
-- Question 2: Viết lệnh để lấy ra thông tin các account được tạo sau ngày 20/12/2010  
SELECT * FROM `Account` WHERE Createdate > '2010-12-20';
-- Question 3: Viết lệnh để lấy ra tất cả các developer 
SELECT * 
FROM `Account` a JOIN `Position` p
ON a.Position_ID = p.Position_ID
WHERE Position_Name = 'Dev';
-- Question 4: Viết lệnh để lấy ra danh sách các phòng ban có >3 nhân viên
   SELECT d.Department_ID, d.Department_Name, COUNT(a.Account_ID) AS 'Số nhân viên'
   FROM Department d JOIN `Account` a
   ON d.Department_ID = a.Department_ID
   GROUP BY d.Department_Name,d.Department_ID
   HAVING COUNT(a.Account_ID) > 3;
-- Question 5: Viết lệnh để lấy ra danh sách câu hỏi được sử dụng trong đề thi nhiều nhất 
SELECT q.Content, COUNT(eq.Exam_ID) AS 'Số lần xuất hiện' 
FROM Question q JOIN Examquestion eq
ON q.Question_ID = eq.Question_ID 
GROUP BY q.Question_ID, q.Content
HAVING COUNT(eq.Exam_ID) 
ORDER BY COUNT(eq.Exam_ID) DESC LIMIT 1; -- trường hợp chỉ có 1 câu hỏi được sử dụng nhiều nhất 
-- Question 6: Thông kê mỗi category Question được sử dụng trong bao nhiêu Question
SELECT cq.Category_Name, COUNT(q.Question_ID) AS 'Số câu hỏi'
FROM Categoryquestion cq LEFT JOIN Question q
ON cq.Category_ID = q.Category_ID
GROUP BY cq.Category_ID, cq.Category_Name;
-- Question 7: Thông kê mỗi Question được sử dụng trong bao nhiêu Exam 
SELECT q.Content, COUNT(eq.exam_id) AS 'Số đề thi'
FROM question q LEFT JOIN examquestion eq
ON q.Question_ID = eq.Question_ID 
GROUP BY q.Question_ID, q.Content;
-- Question 8: Lấy ra Question có nhiều câu trả lời nhất 
SELECT q.Content, COUNT(a.Answer_ID) AS 'Số câu trả lời'
FROM Question q JOIN Answer a
ON q.Question_ID = a.Question_ID
GROUP BY q.Content, q.Question_ID
HAVING COUNT(a.Answer_ID) 
ORDER BY COUNT(a.Answer_ID) DESC LIMIT 1; -- trường hợp chỉ có 1 câu hỏi có nhiều câu trả lời nhất 
-- Question 9: Thống kê số lượng account trong mỗi group  
SELECT ga.Group_ID,g.Group_name, COUNT(a.Account_ID) AS 'Số lượng account'
FROM `Account` a 
JOIN Groupaccount ga ON a.Account_ID = ga.Account_ID
JOIN `Group` g ON g.Group_ID = ga.Group_ID
GROUP BY ga.Group_ID, g.Group_name;
-- Question 10: Tìm chức vụ có ít người nhất 
SELECT p.position_name, COUNT(a.Account_ID) AS 'Số người' 
FROM `Account` a
JOIN `Position` p
ON a.Position_ID = p.Position_ID
GROUP BY p.position_name
ORDER BY COUNT(a.Account_ID) ASC LIMIT 1; -- trường hợp chỉ có 1 position ít người nhất 
-- Question 11: Thống kê mỗi phòng ban có bao nhiêu dev, test, scrum master, PM  
SELECT d.Department_ID, d.Department_Name, p.Position_Name, COUNT(p.Position_ID) AS 'Số chức vụ'
FROM `Account` a 
JOIN `Position` p ON p.Position_ID = a.Position_ID
JOIN Department d ON a.Department_ID = d.Department_ID
WHERE p.Position_name IN ('dev', 'test', 'scrum master', 'PM')
GROUP BY d.Department_ID, p.Position_ID;

SELECT
 d.Department_ID, d.Department_Name,
 (SELECT COUNT(*) FROM `Account` a JOIN `Position` p ON a.Position_ID = p.Position_ID WHERE department_id = d.department_id AND p.Position_name = 'dev') AS 'Dev',
 (SELECT COUNT(*) FROM `Account` a JOIN `Position` p ON a.Position_ID = p.Position_ID WHERE department_id = d.department_id AND p.Position_name = 'PM') AS 'PM',
 (SELECT COUNT(*) FROM `Account` a JOIN `Position` p ON a.Position_ID = p.Position_ID WHERE department_id = d.department_id AND p.Position_name = 'Scrum Master') AS 'scrum master',
 (SELECT COUNT(*) FROM `Account` a JOIN `Position` p ON a.Position_ID = p.Position_ID WHERE department_id = d.department_id AND p.Position_name = 'test') AS 'Test'
FROM Department d
GROUP BY d.Department_ID, d.Department_Name; 
-- Question 12: Lấy thông tin chi tiết của câu hỏi bao gồm: thông tin cơ bản của question, loại câu hỏi, ai là người tạo ra câu hỏi, câu trả lời là gì
SELECT q.Content, q.Question_ID, t.Type_name, a.fullname AS 'Người tạo', cq.Category_Name, an.Content AS 'Câu trả lời'
FROM Question q
JOIN `Account` a ON q.Creator_ID = a.Account_ID
JOIN CategoryQuestion cq ON q.Category_ID = cq.Category_ID
JOIN TypeQuestion t ON q.Type_ID = t.Type_ID
JOIN Answer an ON q.Question_ID = an.Question_ID
WHERE an.isCorrect = 1;
-- Question 13: Lấy ra số lượng câu hỏi của mỗi loại tự luận hay trắc nghiệm 
SELECT t.Type_name, COUNT(q.Question_ID) AS 'Số câu hỏi'
FROM Question q JOIN TypeQuestion t
ON q.Type_ID = t.Type_ID
GROUP BY t.Type_ID;
-- Question 14:Lấy ra group không có account nào 
SELECT g.Group_ID, g.Group_name
FROM `Group` g LEFT JOIN GroupAccount ga
ON g.Group_ID = ga.Group_ID
WHERE ga.Account_ID IS NULL; -- dùng LEFT JOIN do ta muốn đếm cả Account_ID bị NULL ở bảng GroupAccount
-- Question 15: Lấy ra group không có account nào 
SELECT g.Group_ID, g.Group_name
FROM `Group` g LEFT JOIN GroupAccount ga
ON g.Group_ID = ga.Group_ID
WHERE ga.Account_ID IS NULL;
-- Question 16: Lấy ra question không có answer nào 
SELECT q.Content, q.Question_ID 
FROM Question q LEFT JOIN Answer a
ON 	q.Question_ID = a.Question_ID
WHERE a.Answer_ID IS NULL;

-- Exercise 2: Union
-- Question 17:
-- a) Lấy các account thuộc nhóm thứ 1 
SELECT * FROM `Account` a JOIN GroupAccount ga
ON a.Account_ID = ga.Account_ID 
WHERE ga.Group_ID = 1;
-- b) Lấy các account thuộc nhóm thứ 2 
SELECT * FROM `Account` a JOIN GroupAccount ga
ON a.Account_ID = ga.Account_ID 
WHERE ga.Group_ID = 2;
-- c) Ghép 2 kết quả từ câu a) và câu b) sao cho không có record nào trùng nhau
SELECT * 
FROM `Account` a 
JOIN GroupAccount ga ON a.Account_ID = ga.Account_ID 
WHERE ga.Group_ID = 1
UNION 
SELECT * 
FROM `Account` a 
JOIN GroupAccount ga ON a.Account_ID = ga.Account_ID 
WHERE ga.Group_ID = 2;
-- Question 18:  
-- a) Lấy các group có lớn hơn 5 thành viên 
SELECT g.Group_ID, g.Group_Name, COUNT(ga.Account_ID) AS 'Số thành viên'
FROM `Group` g
JOIN GroupAccount ga ON g.Group_ID = ga.Group_ID
GROUP BY g.Group_ID
HAVING COUNT(ga.Account_ID) > 5;
-- b) Lấy các group có nhỏ hơn 7 thành viên 
SELECT g.Group_ID, g.Group_Name, COUNT(ga.Account_ID) AS 'Số thành viên'
FROM `Group` g
JOIN GroupAccount ga ON g.Group_ID = ga.Group_ID
GROUP BY g.Group_ID
HAVING COUNT(ga.Account_ID) < 7;
-- c) Ghép 2 kết quả từ câu a) và câu b) 
SELECT g.Group_ID, g.Group_Name, COUNT(ga.Account_ID) AS 'Số thành viên'
FROM `Group` g
JOIN GroupAccount ga ON g.Group_ID = ga.Group_ID
GROUP BY g.Group_ID
HAVING COUNT(ga.Account_ID) > 0
UNION ALL
SELECT g.Group_ID, g.Group_Name, COUNT(ga.Account_ID) AS 'Số thành viên'
FROM `Group` g
JOIN GroupAccount ga ON g.Group_ID = ga.Group_ID
GROUP BY g.Group_ID
HAVING COUNT(ga.Account_ID) < 7;


