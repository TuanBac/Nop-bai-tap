-- Tạo table với các ràng buộc và kiểu dữ liệu và thêm ít nhất 3 bản ghi vào mỗi table trên
CREATE DATABASE IF NOT EXISTS Extra_Assignment_5;
USE Extra_Assignment_5;
CREATE TABLE Employee (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeLastName VARCHAR(50) NOT NULL,
    EmployeeFirstName VARCHAR(50) NOT NULL,
    EmployeeStatus VARCHAR(20),
    SupervisorID INT,
    SocialSecurityNumber VARCHAR(20),
    FOREIGN KEY (SupervisorID) REFERENCES Employee(EmployeeID)
);
CREATE TABLE Projects (
    ProjectID INT AUTO_INCREMENT PRIMARY KEY,
    managerID INT NOT NULL,
    ProjectName VARCHAR(100) NOT NULL,
    ProjectStartDate DATE,
    ProjectDescription TEXT,
    ProjectDetail TEXT,
    ProjectCompletedOn DATETIME,
    FOREIGN KEY (managerID) REFERENCES Employee(EmployeeID)
);
CREATE TABLE Project_Modules (
    ModuleID INT AUTO_INCREMENT PRIMARY KEY,
    ProjectID INT NOT NULL,
    EmployeeID INT NOT NULL,
    ProjectModuleDate DATE,
    ProjectModuleCompletedOn DATE,
    ProjectModuleDescription TEXT,
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);
CREATE TABLE Work_Done (
    WorkDoneID INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID INT NOT NULL,
    ModuleID INT NOT NULL,
    WorkDoneDate DATE,
    WorkDoneDescription TEXT,
    WorkDoneStatus VARCHAR(20),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (ModuleID) REFERENCES Project_Modules(ModuleID)
);
INSERT INTO Employee (EmployeeLastName, EmployeeFirstName, EmployeeStatus, SupervisorID, SocialSecurityNumber) VALUES
('Nguyen', 'Van A', 'Active', NULL, '123-45-6789'),
('Tran', 'Thi B', 'Active', 1, '234-56-7890'),
('Le', 'Van C', 'Active', 1, '345-67-8901'),
('Pham', 'Minh D', 'Active', 2, '456-78-9012'),
('Hoang', 'Thu E', 'Inactive', 3, '567-89-0123');

INSERT INTO Projects (managerID, ProjectName, ProjectStartDate, ProjectDescription, ProjectDetail, ProjectCompletedOn) VALUES
(1, 'Dự án Alpha', '2025-01-01', 'Hệ thống quản lý kho', 'Chi tiết Alpha', '2025-04-15'),
(2, 'Dự án Beta', '2025-02-15', 'Ứng dụng di động', 'Chi tiết Beta', NULL),
(3, 'Dự án Gamma', '2025-03-01', 'Website thương mại điện tử', 'Chi tiết Gamma', NULL),
(1, 'Dự án Delta', '2025-04-01', 'Phần mềm kế toán', 'Chi tiết Delta', NULL),
(2, 'Dự án Epsilon', '2025-05-01', 'Hệ thống CRM', 'Chi tiết Epsilon', NULL);

INSERT INTO Project_Modules (ProjectID, EmployeeID, ProjectModuleDate, ProjectModuleCompletedOn, ProjectModuleDescription) VALUES
(1, 2, '2025-02-01', '2025-04-01', 'Module quản lý sản phẩm'),
(1, 3, '2025-02-10', '2025-04-10', 'Module quản lý đơn hàng'),
(2, 4, '2025-03-01', NULL, 'Module giao diện người dùng'),
(3, 5, '2025-03-15', NULL, 'Module thanh toán'),
(4, 3, '2025-04-15', NULL, 'Module báo cáo tài chính');

INSERT INTO Work_Done (EmployeeID, ModuleID, WorkDoneDate, WorkDoneDescription, WorkDoneStatus) VALUES
(2, 1, '2025-03-01', 'Thiết kế database', 'Completed'),
(3, 2, '2025-03-15', 'Xây dựng API', 'Completed'),
(4, 3, NULL, 'Thiết kế giao diện', 'In Progress'),
(5, 4, NULL, 'Tích hợp cổng thanh toán', 'Pending'),
(3, 5, NULL, 'Viết báo cáo tài chính', 'In Progress');

-- a)Viết stored procedure (không có parameter) để Remove tất cả thông tin project đã hoàn thành sau 3 tháng kể từ ngày hiện.
-- In số lượng record đã remove từ các table liên quan trong khi removing (dùng lệnh print)
DROP PROCEDURE IF EXISTS remove_completedprojects_after3month
DELIMITER //
CREATE PROCEDURE remove_completedprojects_after3month()
BEGIN
	DECLARE v_deleted_projects INT DEFAULT 0;
    DECLARE v_deleted_modules INT DEFAULT 0;
    DECLARE v_deleted_workdone INT DEFAULT 0;

    -- Xóa work_done
    DELETE wd
    FROM Work_Done wd
    JOIN Project_Modules pm ON wd.ModuleID = pm.ModuleID
    JOIN Projects p ON pm.ProjectID = p.ProjectID
    WHERE p.ProjectCompletedOn <= DATE_SUB(CURDATE(), INTERVAL 3 MONTH);
    SET v_deleted_workdone = ROW_COUNT();

    -- Xóa project_modules
    DELETE pm
    FROM Project_Modules pm
    JOIN Projects p ON pm.ProjectID = p.ProjectID
    WHERE p.ProjectCompletedOn <= DATE_SUB(CURDATE(), INTERVAL 3 MONTH);
    SET v_deleted_modules = ROW_COUNT();

    -- Xóa projects
    DELETE FROM Projects
    WHERE ProjectCompletedOn <= DATE_SUB(CURDATE(), INTERVAL 3 MONTH);
    SET v_deleted_projects = ROW_COUNT();

    SELECT CONCAT(
        'Đã xóa ', v_deleted_projects, ' Project, ',
        v_deleted_modules, ' ProjectModule, ',
        v_deleted_workdone, ' WorkDone.'
    ) AS `Kết quả xóa`;
END;
//
DELIMITER ;
CALL remove_completedprojects_after3month();

-- b) Viết stored procedure (có parameter) để in ra các module đang được thực hiện
DROP PROCEDURE IF EXISTS processing_module;
DELIMITER //
CREATE PROCEDURE processing_module(IN in_projectID INT)
BEGIN
	SELECT pm.ModuleID, pm.ProjectModuleDescription,
    p.ProjectID, p.ProjectName, p.ProjectDescription, p.ProjectDetail,
    e.EmployeeID, e.EmployeeLastName
    FROM Project_modules pm
    JOIN Projects p ON p.ProjectID = pm.ProjectID
    JOIN Employee e  ON e.EmployeeID = pm.EmployeeID 
    WHERE pm.ProjectID = in_projectID
    AND pm.ProjectModuleCompletedOn IS NULL;
END
// DELIMITER ;
CALL processing_module(3);
-- Viết hàm (có parameter) trả về thông tin 1 nhân viên đã tham gia làm mặc dù không ai giao việc cho nhân viên đó (trong bảng Works)
 DROP PROCEDURE IF EXISTS workdone_but_nothavejob
 DELIMITER //
 CREATE PROCEDURE workdone_but_nothavejob( IN in_employeeid INT)
 BEGIN 
	SELECT e.EmployeeFirstName, e.EmployeeLastName FROM employee e
    JOIN work_done w ON e.EmployeeID = w.EmployeeID
    WHERE e.EmployeeID = in_employeeid
    AND e.EmployeeID NOT IN (SELECT pm.employeeid FROM project_modules pm);
END
// DELIMITER ;
CALL workdone_but_nothavejob(2);
