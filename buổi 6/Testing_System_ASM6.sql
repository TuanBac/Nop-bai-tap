USE test_1;
-- Question 1: Tạo trigger không cho phép người dùng nhập vào Group có ngày tạo trước 1 năm trước 
DROP TRIGGER IF EXISTS trigger_notallow_entergroup_withcreatedate_before1yearago;
DELIMITER //
CREATE TRIGGER trigger_notallow_entergroup_withcreatedate_before1yearago
BEFORE INSERT ON `Group` 
FOR EACH ROW
BEGIN
	DECLARE v_CreateDate DATETIME;
    SET v_CreateDate = DATE_SUB(NOW(), interval 1 year);
	IF (NEW.CreateDate <= v_CreateDate) THEN
 	 	 	 	SIGNAL SQLSTATE '12345'
 	 	 	 	SET MESSAGE_TEXT = 'Không được bạn ơi ';
 	 	 	END IF;

END// 
DELIMITER ;
INSERT INTO `group` (`Group_Name`, `Creator_ID`, `CreateDate`)
VALUES ('2', '1', '2018-04-10');
-- Question 2: Tạo trigger Không cho phép người dùng thêm bất kỳ user nào vào department "Sale" nữa, 
-- khi thêm thì hiện ra thông báo "Department "Sale" cannot add more user" 
DROP TRIGGER IF EXISTS trigger_NotAddUserInSale;
DELIMITER //
CREATE TRIGGER trigger_NotAddUserInSale
BEFORE INSERT ON `Account`
FOR EACH ROW
BEGIN
	DECLARE v_deptid INT;
    SELECT d.Department_ID INTO v_deptid
    FROM Department d
    WHERE d.Department_name = 'Sale';
    IF (NEW.department_ID = v_deptid) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Department "Sale" cannot add more user';
	END IF;
END // 
DELIMITER ;

INSERT INTO `account` (`Email`, `Username`, `FullName`, `Department_ID`, `Position_ID`, `CreateDate`) 
VALUES ('4', '4', '4', '2', '4', '2020-11-13');
 
-- Question 3: Cấu hình 1 group có nhiều nhất là 5 user ==> 
DROP TRIGGER IF EXISTS trigger_limit5user;
DELIMITER //
CREATE TRIGGER trigger_limit5user
BEFORE INSERT ON `GroupAccount`
FOR EACH ROW 
BEGIN
	DECLARE v_countuser INT;
    
    SELECT COUNT(ga.Group_ID) INTO v_countuser
    FROM GroupAccount ga
    WHERE ga.Group_ID = NEW.Group_ID;
    IF (v_countuser >= 5) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'This group is limit 5 user';
	END IF;
END //
DELIMITER ;
-- Question 4: Cấu hình 1 bài thi có nhiều nhất là 10 Question 
DROP TRIGGER IF EXISTS trigger_limit10question;
DELIMITER //
CREATE TRIGGER trigger_limit10question
BEFORE INSERT ON `Examquestion`
FOR EACH ROW 
BEGIN
	DECLARE v_countquestion INT;
    
    SELECT COUNT(eq.question_ID) INTO v_countquestion
    FROM examquestion eq
    WHERE eq.Question_ID = NEW.Question_ID;
    IF (v_countquestion >= 10) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'This group is limit 10 question';
	END IF;
END //
DELIMITER ;

-- Question 5: Tạo trigger không cho phép người dùng xóa tài khoản có email là "admin@gmail.com" (đây là tài khoản admin, không cho phép user xóa),
-- còn lại các tài khoản khác thì sẽ cho phép xóa và sẽ xóa tất cả các thông tin liên quan tới user đó

-- chỉnh DELETE CASCADE trên các bảng liên quan
ALTER TABLE Examquestion 
DROP FOREIGN KEY examquestion_ibfk_1;
ALTER TABLE Examquestion
ADD CONSTRAINT examquestion_ibfk_1
FOREIGN KEY (Exam_ID) REFERENCES Exam(Exam_ID)
ON DELETE CASCADE;

ALTER TABLE `Group`
DROP FOREIGN KEY group_ibfk_1;
ALTER TABLE `Group`
ADD CONSTRAINT group_ibfk_1
FOREIGN KEY (Creator_ID) REFERENCES `Account`(Account_ID)
ON DELETE CASCADE;

ALTER TABLE `Groupaccount`
DROP FOREIGN KEY groupaccount_ibfk_1;
ALTER TABLE `Groupaccount`
ADD CONSTRAINT groupaccount_ibfk_1
FOREIGN KEY (Group_ID) REFERENCES `Group`(Group_ID)
ON DELETE CASCADE;

ALTER TABLE `Question`
DROP FOREIGN KEY question_ibfk_3;
ALTER TABLE `Question`
ADD CONSTRAINT question_ibfk_3
FOREIGN KEY (Creator_ID) REFERENCES `Account`(Account_ID)
ON DELETE CASCADE;

ALTER TABLE `Answer`
DROP FOREIGN KEY answer_ibfk_1;
ALTER TABLE `Answer`
ADD CONSTRAINT answer_ibfk_1
FOREIGN KEY (Question_ID) REFERENCES `Question`(Question_ID)
ON DELETE CASCADE;

ALTER TABLE Examquestion 
DROP FOREIGN KEY examquestion_ibfk_2;
ALTER TABLE Examquestion
ADD CONSTRAINT examquestion_ibfk_2
FOREIGN KEY (Question_ID) REFERENCES Question(Question_ID)
ON DELETE CASCADE;
-- tạo trigger 
DROP TRIGGER IF EXISTS trigger_del_account
DELIMITER //
CREATE TRIGGER trigger_del_account
BEFORE DELETE ON `Account`
FOR EACH ROW
BEGIN	
    IF (OLD.Email = 'admin@gmail.com') THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'đây là tài khoản admin, không cho phép user xóa';
	ELSE		
		DELETE FROM `Exam` e
        WHERE e.Creator_ID = OLD.Account_ID; 
    END IF;
END
// DELIMITER ;
DELETE FROM `Account` WHERE Email = 'admin@gmail.com';
DELETE FROM `Account` WHERE Account_ID = 1;
-- Question 6: Không sử dụng cấu hình default cho field DepartmentID của table Account,
-- hãy tạo trigger cho phép người dùng khi tạo account không điền vào departmentID thì sẽ được phân vào phòng ban "waiting Department" 
DROP TRIGGER IF EXISTS trigger_NotEnterDepartmentID
DELIMITER //
CREATE TRIGGER trigger_NotEnterDepartmentID
BEFORE INSERT ON `Account`
FOR EACH ROW
BEGIN
	IF (NEW.Department_ID IS NULL) THEN
		SET NEW.Department_ID = 11;
    END IF;
END
// DELIMITER ;
-- nếu phòng ban 'waiting room' không cố định
DROP TRIGGER IF EXISTS trigger_NotEnterDepartmentID
DELIMITER //
CREATE TRIGGER trigger_NotEnterDepartmentID
BEFORE INSERT ON `Account`
FOR EACH ROW
BEGIN
	DECLARE v_waitingdept_id INT;
    
	IF (NEW.Department_ID IS NULL) THEN
		SELECT Department_ID INTO v_waitingdept_id
		FROM Department
		WHERE Department_Name = 'Phòng chờ'
		LIMIT 1;
		SET NEW.Department_ID = v_waitingdept_id;
	END IF;
END
// DELIMITER ;
INSERT INTO `Account` (`Email`, `Username`, `FullName`, `Position_ID`, `CreateDate`) 
VALUES ('6', '7', '9', '2', '2020-11-13')
-- Question 7: Cấu hình 1 bài thi chỉ cho phép user tạo tối đa 4 answers cho mỗi question, trong đó có tối đa 2 đáp án đúng. 
DROP TRIGGER IF EXISTS trigger_limit4answer
DELIMITER //
CREATE TRIGGER trigger_limit4answer
BEFORE INSERT ON Answer
FOR EACH ROW
BEGIN
	DECLARE v_NumOfAnswer INT;
    DECLARE v_NumOfCorrectAnswer INT;
    -- đếm số đáp án
	SELECT COUNT(a.Answer_ID) INTO v_NumOfAnswer
    FROM Answer a
    WHERE a.Question_ID = NEW.Question_ID;
    -- nếu nhiều hơn 4 đáp án thì sẽ chặn 
    IF (v_NumOfAnswer >= 4) THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Số câu trả lời tối đa là 4';
	END IF;
    -- nếu đáp án mới là đúng thì kiểm tra số đáp án đúng hiện tại
    IF (NEW.isCorrect = b'1') THEN
		SELECT COUNT(a.Answer_ID) INTO v_NumOfCorrectAnswer
        FROM Answer a
        WHERE a.Question_ID = NEW.Question_ID
        AND isCorrect = b'1';
        -- nếu nhiều hơn 2 đáp án đúng thì chặn 
        IF (v_NumOfCorrectAnswer >= 2) THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Số câu trả lời đúng tối đa là 2';
            END IF;
		END IF;
END
// DELIMITER ;
INSERT INTO `test_1`.`answer` (`Content`, `Question_ID`, `isCorrect`) 
VALUES ('1', '2', b'1'),
		('2', '2', b'1'),
        ('3', '2', b'1'),
        ('4', '2', b'1'),
        ('5', '2', b'1');
-- Question 8: Viết trigger sửa lại dữ liệu cho đúng:
-- Nếu người dùng nhập vào gender của account là nam, nữ, chưa xác định thì sẽ đổi lại thành M, F, U cho giống với cấu hình ở database 
DROP TRIGGER IF EXISTS Input_Gender;
DELIMITER //
CREATE TRIGGER Input_Gender
BEFORE INSERT ON `Account`
FOR EACH ROW
BEGIN
	DECLARE v_gender VARCHAR(30);
    SET v_gender = NEW.Gender;
    SET NEW.Gender = CASE (v_gender)
						WHEN 'nam' THEN 'M'
						WHEN 'nữ' THEN 'F'
						ELSE 'U'
						END;
END
// DELIMITER ;

-- Question 9: Viết trigger không cho phép người dùng xóa bài thi mới tạo được 2 ngày
DROP TRIGGER IF EXISTS del_exam
DELIMITER //
CREATE TRIGGER del_exam
BEFORE DELETE ON Exam
FOR EACH ROW
BEGIN
	DECLARE v_CreateDate DATETIME;
    SET v_CreateDate = DATE_SUB(NOW(), INTERVAL 2 DAY);
	IF (OLD.CreateDate > v_CreateDate) THEN
 	 	 	 	SIGNAL SQLSTATE '45000'
 	 	 	 	SET MESSAGE_TEXT = 'Không được xóa bạn ơi ';
	END IF;
END
// DELIMITER ;

-- Question 10: Viết trigger chỉ cho phép người dùng chỉ được update, delete các question khi question đó chưa nằm trong exam nào
-- trigger xóa question  
DROP TRIGGER IF EXISTS before_del_question
DELIMITER //
CREATE TRIGGER before_del_question
BEFORE DELETE ON Question
FOR EACH ROW
BEGIN
	DECLARE v_countquestion INT;
    SELECT COUNT(*) INTO v_countquestion
    FROM Examquestion eq
    WHERE eq.Question_ID = OLD.Question_ID;
    IF (v_countquestion > 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Không được xóa question này vì đang nằm trong exam';
	END IF;
END
// DELIMITER ;

-- trigger update question
DROP TRIGGER IF EXISTS before_del_question
DELIMITER //
CREATE TRIGGER before_del_question
BEFORE UPDATE ON Question
FOR EACH ROW
BEGIN
	DECLARE v_countquestion INT;
    SELECT COUNT(*) INTO v_countquestion
    FROM Examquestion eq
    WHERE eq.Question_ID = OLD.Question_ID;
    IF (v_countquestion > 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Không thể update question này vì đang nằm trong exam';
	END IF;
END
// DELIMITER ;
-- Question 12: Lấy ra thông tin exam trong đó: 
-- Duration <= 30 thì sẽ đổi thành giá trị "Short time" 
-- 30 < Duration <= 60 thì sẽ đổi thành giá trị "Medium time" Duration > 60 thì sẽ đổi thành giá trị "Long time" 
SELECT e.Exam_ID, e.Title, e.Duration,
	CASE
		WHEN Duration <= 30 THEN 'Short time'
        WHEN Duration <= 60 THEN 'Medium time'
        ELSE 'Long time'
	END AS DurationCategory
FROM Exam e;

-- Question 13: Thống kê số account trong mỗi group và in ra thêm 1 column nữa có tên là the_number_user_amount và mang giá trị được quy định như sau:
-- Nếu số lượng user trong group =< 5 thì sẽ có giá trị là few 
-- Nếu số lượng user trong group <= 20 và > 5  thì sẽ có giá trị là normal 
-- Nếu số lượng user trong group > 20 thì sẽ có giá trị là higher 
SELECT ga.Group_ID, COUNT(ga.Account_ID) AS 'Số Account',
	CASE
		WHEN 'Số Account' <= 5 THEN 'Few'
        WHEN 'Số Account' <= 20 THEN 'Normal'
        ELSE 'Higher'
	END AS the_number_user_amount
FROM GroupAccount ga
GROUP BY ga.Group_ID;

-- Question 14: Thống kê số mỗi phòng ban có bao nhiêu user, nếu phòng ban nào không có user thì sẽ thay đổi giá trị 0 thành "Không có User" 
SELECT d.Department_ID, d.Department_name, COUNT(a.Account_ID) AS So_account,
	CASE
		WHEN COUNT(a.Account_ID) >= 1 THEN COUNT(a.Account_ID)
        ELSE 'Không có User'
	END AS 'Số Account'
FROM Department d
LEFT JOIN `Account` a
ON a.Department_ID = d.Department_ID
GROUP BY d.Department_ID;