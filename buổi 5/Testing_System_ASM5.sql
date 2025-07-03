USE Test_1;
-- Question 1: Tạo store để người dùng nhập vào tên phòng ban và in ra tất cả các account thuộc phòng ban đó 
DROP PROCEDURE IF EXISTS sp_timaccount;
DELIMITER //
CREATE PROCEDURE sp_timaccount( IN in_dept_name VARCHAR(50))
BEGIN
     SELECT a.Fullname 
     FROM `Account` a
     JOIN Department d
     ON a.Department_ID = d.Department_ID
     WHERE d.Department_name = in_dept_name;     
END
// DELIMITER ;
CALL sp_timaccount('nhân sự');
-- Question 2: Tạo store để in ra số lượng account trong mỗi group
DROP PROCEDURE IF EXISTS sp_slaccount;
DELIMITER //
CREATE PROCEDURE sp_slaccount()
	BEGIN
		SELECT g.Group_ID, g.Group_name, COUNT(a.Account_ID) AS 'Số Account'
        FROM `GroupAccount` ga 
        LEFT JOIN `Account` a ON a.Account_ID = ga.Account_ID
        LEFT JOIN `Group` g ON g.Group_ID = ga.Group_ID
        GROUP BY g.Group_ID, g.Group_name;
	END
// DELIMITER ;
CALL sp_slaccount();
-- Question 3: Tạo store để thống kê mỗi type question có bao nhiêu question được tạo trong tháng hiện tại 
DROP PROCEDURE IF EXISTS sp_soquestion;
DELIMITER // 
CREATE PROCEDURE sp_soquestion( IN in_type VARCHAR(50))
	BEGIN 
		SELECT t.type_id, t.type_name, COUNT(q.question_id) AS 'Số câu hỏi'
        FROM question q 
        JOIN typequestion t ON q.type_id = t.type_id
        WHERE t.type_name = in_type
        AND MONTH(q.CreateDate) = MONTH(CURDATE())
        AND YEAR(q.CreateDate) = YEAR(CURDATE())
        GROUP BY t.type_id, t.type_name;
	END
// DELIMITER ;
CALL sp_soquestion('multiple choice');

-- Question 4: Tạo store để trả ra id của type question có nhiều câu hỏi nhất 
DROP PROCEDURE IF EXISTS sp_type_nhieu_cauhoi_nhat;
DELIMITER //
CREATE PROCEDURE sp_type_nhieu_cauhoi_nhat(OUT out_typeid INT)
BEGIN 
	SELECT t.Type_ID INTO out_typeid
    FROM typequestion t
    JOIN question q ON t.type_ID = q.type_ID
    GROUP BY t.type_ID
    HAVING COUNT(q.Question_ID) = (SELECT MAX(So_cauhoi)
									FROM ( SELECT COUNT(q.Question_ID) AS So_cauhoi
											FROM Question q 
											GROUP BY q.type_ID) AS MaxQuestion
									);
END
 // DELIMITER ;
SET @max_typeid = 0;
CALL sp_type_nhieu_cauhoi_nhat(@max_typeid);
SELECT @max_typeid;
-- Question 5: Sử dụng store ở question 4 để tìm ra tên của type question
DROP PROCEDURE IF EXISTS sp_NameOfTypeQuestionHaveMaxQuestion;
DELIMITER //
CREATE PROCEDURE sp_NameOfTypeQuestionHaveMaxQuestion()
BEGIN
	DECLARE v_max_typeid INT;
    CALL sp_type_nhieu_cauhoi_nhat(v_max_typeid);
    SELECT t.type_name FROM typequestion t
	WHERE t.type_ID = v_max_typeid;
END
// DELIMITER ;
CALL sp_NameOfTypeQuestionHaveMaxQuestion();
-- Question 6: Viết 1 store cho phép người dùng nhập vào 1 chuỗi và 
-- trả về group có tên chứa chuỗi của người dùng nhập vào 
-- hoặc trả về user có username chứa chuỗi của người dùng nhập vào 
DROP PROCEDURE IF EXISTS sp_GetGroupnameOrUsernameFromInputValue;
DELIMITER //
CREATE PROCEDURE sp_GetGroupnameOrUsernameFromInputValue( IN str VARCHAR(50))
BEGIN 
	SELECT Group_Name as Result, 'group' as 'Loại' 
    FROM `group` 
    WHERE Group_Name LIKE CONCAT('%', str, '%')
    UNION
	SELECT UserName as Result, 'user' as 'Loại' 
    FROM `Account` 
    WHERE Username LIKE CONCAT('%', str, '%');
END
// DELIMITER ;
CALL sp_GetGroupnameOrUsernameFromInputValue('t');

-- Question 7: Viết 1 store cho phép người dùng nhập vào thông tin fullName, email và trong store sẽ tự động gán:  
-- 	username sẽ giống email nhưng bỏ phần @..mail đi  	
--  positionID: sẽ có default là developer 
--  departmentID: sẽ được cho vào 1 phòng chờ 
--   Sau đó in ra kết quả tạo thành công 
        
DROP PROCEDURE IF EXISTS sp_themthongtin;
DELIMITER //
CREATE PROCEDURE sp_themthongtin(IN in_fullname VARCHAR(50), IN in_email VARCHAR(50))
BEGIN
	DECLARE v_username VARCHAR(50); 
    DECLARE v_positionid INT; 
    DECLARE v_departmentid INT;
    
    -- 	username sẽ giống email nhưng bỏ phần @..mail đi 
    SET v_username = substring_index(in_email, '@', 1);
    
    --  positionID: sẽ có default là developer 
    SELECT Position_ID INTO v_positionid
    FROM `Position`
    WHERE Position_name = 'Dev';
    
    -- departmentID: sẽ được cho vào 1 phòng chờ ==> Tài khoản mới tạo sẽ được xếp vào một phòng ban có tên là "Phòng chờ"
    SELECT Department_ID INTO v_departmentid
    FROM Department
    WHERE Department_name = 'Phòng chờ';
INSERT INTO test_1.`Account` (FullName, Email, Username, Position_ID, Department_ID)
VALUES (in_fullname, in_email, v_username, v_positionid, v_departmentid);
SELECT 'Đã tạo thành công' AS msg;
END //
DELIMITER ;
CALL sp_themthongtin('em la ai', 'lalala@gmail.com');

-- Question 8: Viết 1 store cho phép người dùng nhập vào Essay hoặc Multiple-Choice để thống kê câu hỏi essay hoặc multiple-choice nào có content dài nhất 
DROP PROCEDURE IF EXISTS sp_f_longestcontent;
DELIMITER //
CREATE PROCEDURE sp_f_longestcontent(IN in_typename ENUM('Essay', 'Multiple Choice'))
BEGIN
	SELECT q.Content, CHAR_LENGTH(q.Content) AS 'Số ký tự'
    FROM Question q
    JOIN Typequestion t ON q.type_ID = t.type_ID
    WHERE t.type_name = in_typename
    AND CHAR_LENGTH(q.Content) = (SELECT MAX(CHAR_LENGTH(q2.Content)) -- từng loại không phải cả bảng 
									FROM Question q2
									JOIN Typequestion t2 ON q2.type_ID = t2.type_ID
                                    WHERE t2.type_name = in_typename);
END //
DELIMITER ;
CALL sp_f_longestcontent('Essay');
CALL sp_f_longestcontent('Multiple Choice');

-- Question 9: Viết 1 store cho phép người dùng xóa exam dựa vào ID 
DROP PROCEDURE IF EXISTS sp_DeleteExamBasedOnID;
DELIMITER //
CREATE PROCEDURE sp_DeleteExamBasedOnID(IN in_examid INT)
BEGIN
	DELETE FROM Examquestion eq WHERE eq.Exam_ID = in_examid;-- xóa khóa ngoại tránh lỗi 
    
	DELETE FROM Exam e
    WHERE e.Exam_ID = in_examid;
END
// DELIMITER ;
CALL sp_DeleteExamBasedOnID();

-- Question 10: Tìm ra các exam được tạo từ 3 năm trước và xóa các exam đó đi (sử dụng store ở câu 9 để xóa) 
            -- Sau đó in số lượng record đã remove từ các table liên quan trong khi removing
            
DROP PROCEDURE IF EXISTS sp_DeleteExamBefore3Year;
DELIMITER //
CREATE PROCEDURE sp_DeleteExamBefore3Year()
BEGIN
    DECLARE v_ExamID INT;
    DECLARE v_CountExam INT DEFAULT 0;
    DECLARE v_CountExamquestion INT DEFAULT 0;
    DECLARE i INT DEFAULT 1;
    DECLARE v_print_Del_info_Exam VARCHAR(100);

    -- Bảng tạm chứa các ExamID cần xóa
    DROP TABLE IF EXISTS ExamIDBefore3Year_Temp;
    CREATE TABLE ExamIDBefore3Year_Temp (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        ExamID INT
    );

    -- Lấy danh sách Exam tạo hơn 3 năm
    INSERT INTO ExamIDBefore3Year_Temp(ExamID)
    SELECT e.Exam_ID
    FROM exam e
    WHERE e.CreateDate <= DATE_SUB(CURDATE(), INTERVAL 3 YEAR);

    -- Đếm số bản ghi cần xóa
    SELECT COUNT(*) INTO v_CountExam FROM ExamIDBefore3Year_Temp;

    SELECT COUNT(*) INTO v_CountExamquestion
    FROM examquestion ex
    JOIN ExamIDBefore3Year_Temp et ON ex.Exam_ID = et.ExamID;

    -- Vòng lặp xóa
    WHILE i <= v_CountExam DO
        SELECT ExamID INTO v_ExamID
        FROM ExamIDBefore3Year_Temp
        WHERE ID = i;

        CALL sp_DeleteExamBasedOnID(v_ExamID);

        SET i = i + 1;
    END WHILE;

    SET v_print_Del_info_Exam = CONCAT("Đã xóa ", v_CountExam, " Exam và ", v_CountExamquestion, " ExamQuestion.");
    SELECT v_print_Del_info_Exam AS `Kết quả xóa`;

END //

DELIMITER ;
CALL SP_DeleteExamBefore3Year();

-- Question 11: Viết store cho phép người dùng xóa phòng ban bằng cách người dùng nhập vào tên phòng ban 
-- và các account thuộc phòng ban đó sẽ được chuyển về phòng ban default là phòng ban chờ việc 
DROP PROCEDURE IF EXISTS sp_del_department;
DELIMITER //
CREATE PROCEDURE sp_del_department(IN in_departmentname VARCHAR(50))
BEGIN
	DECLARE v_departmentID VARCHAR(50);
    
    SELECT d.Department_ID INTO v_departmentID
    FROM Department d 
    WHERE d.Department_Name = in_departmentname;
    
    UPDATE `Account` a SET a.Department_ID = '11'
    WHERE a.Department_ID = v_departmentID;
    
    DELETE FROM Department d WHERE d.Department_Name = in_departmentname;
END //
DELIMITER ;
CALL sp_del_department('Marketing');

-- Question 12: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong năm nay
DROP PROCEDURE IF EXISTS sp_QuestionCreatedEachMonth;
DELIMITER //

CREATE PROCEDURE sp_QuestionCreatedEachMonth()
BEGIN
    SELECT 
        MONTH(q.CreateDate) AS 'Tháng',
        COUNT(*) AS 'Số lượng câu hỏi'
    FROM Question q
    WHERE YEAR(q.CreateDate) = YEAR(CURDATE())
    GROUP BY MONTH(q.CreateDate)
    ORDER BY 'Tháng';
END //
DELIMITER ;

-- Question 13: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong 6 tháng gần đây nhất  
-- (Nếu tháng nào không có thì sẽ in ra là "không có câu hỏi nào trong  tháng") 
DROP PROCEDURE IF EXISTS sp_CountQuesBefore6Month;
DELIMITER //
CREATE PROCEDURE sp_CountQuesBefore6Month()
BEGIN
    WITH CTE_Last6Months AS (
        SELECT MONTH(DATE_SUB(NOW(), INTERVAL 5 MONTH)) AS MONTH,
               YEAR(DATE_SUB(NOW(), INTERVAL 5 MONTH)) AS YEAR
        UNION
        SELECT MONTH(DATE_SUB(NOW(), INTERVAL 4 MONTH)), YEAR(DATE_SUB(NOW(), INTERVAL 4 MONTH))
        UNION
        SELECT MONTH(DATE_SUB(NOW(), INTERVAL 3 MONTH)), YEAR(DATE_SUB(NOW(), INTERVAL 3 MONTH))
        UNION
        SELECT MONTH(DATE_SUB(NOW(), INTERVAL 2 MONTH)), YEAR(DATE_SUB(NOW(), INTERVAL 2 MONTH))
        UNION
        SELECT MONTH(DATE_SUB(NOW(), INTERVAL 1 MONTH)), YEAR(DATE_SUB(NOW(), INTERVAL 1 MONTH))
        UNION
        SELECT MONTH(NOW()), YEAR(NOW())
    )
    SELECT 
        M.MONTH,
        M.YEAR,
        CASE
            WHEN COUNT(q.Question_ID) = 0 THEN 'không có câu hỏi nào trong tháng'
            ELSE CAST(COUNT(q.Question_ID) AS CHAR)
        END AS SL
    FROM CTE_Last6Months M
    LEFT JOIN Question q
        ON M.MONTH = MONTH(q.CreateDate) AND M.YEAR = YEAR(q.CreateDate)
    GROUP BY M.YEAR, M.MONTH
    ORDER BY M.YEAR ASC, M.MONTH ASC;
END //
DELIMITER ;
CALL sp_CountQuesBefore6Month();
