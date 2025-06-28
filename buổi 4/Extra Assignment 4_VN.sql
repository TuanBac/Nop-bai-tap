USE adventureworks;
-- Exercise 1: Subquery
-- Question 1: Viết 1 query lấy thông tin "Name" từ bảng Production. Product có name của ProductSubcategory là 'Saddles'.
-- Sử dụng Sub Query để lấy ra tất cả các ID của ProductSubcategory có name = 'Saddles'.
-- Sau đó trong outer query, sử dụng kết quả từ Sub Query để lấy ra yêu cầu của đề bài.
SELECT p.`name` 
FROM product p 
WHERE p.ProductSubcategoryID IN (SELECT ps.ProductSubcategoryID
								FROM ProductSubcategory ps 
								WHERE ps.`name` = 'Saddles'); 
-- Question 2: Thay đổi câu Query 1 để lấy được kết quả sau.
SELECT p.`name` 
FROM product p 
WHERE p.ProductSubcategoryID IN (SELECT ps.ProductSubcategoryID
								FROM ProductSubcategory ps 
								WHERE ps.`name` LIKE "Bo%"); 
-- Question 3: Viết câu query trả về tất cả các sản phẩm có giá rẻ nhất (lowest ListPrice) và Touring Bike (nghĩa là ProductSubcategoryID = 3)
SELECT p.`name` FROM product p
WHERE p.ListPrice = (SELECT MIN(p.ListPrice) FROM product) AND p.ProductSubcategoryID = 3;
-- Exercise 2: JOIN nhiều bảng
-- Question 1: Viết query lấy danh sách tên country và province được lưu trong AdventureWorks2008sample database.
SELECT c.`name` AS Country, sp.`name` AS Province
FROM countryregion c
JOIN stateprovince sp
ON c.CountryRegionCode = sp.CountryRegionCode;
-- Question 2: Tiếp tục với câu query trước và thêm điều kiện là chỉ lấy country Germany và Canada
-- Chú ý: sử dụng sort order và column heading
SELECT c.`name` AS Country, sp.`name` AS Province
FROM countryregion c
JOIN stateprovince sp
ON c.CountryRegionCode = sp.CountryRegionCode
WHERE c.`name` IN ('Germany', 'Canada');
-- Question 3:
-- Từ bảng SalesPerson, chúng ta lấy cột BusinessEntityID (là định danh của người sales), Bonus and the SalesYTD 
-- Từ bảng SalesOrderHeader, chúng ta lấy cột SalesOrderID OrderDate
SELECT so.SalesOrderID, so.OrderDate, so.SalesPersonID, s.SalesPersonID AS BusinessEntityID, s.Bonus, s.SalesYTD
FROM salesperson s
JOIN salesorderheader so
ON s.SalesPersonID = so.SalesPersonID;
-- Question 4: Sử dụng câu query ở question 3, thêm cột JobTitle and xóa cột SalesPersonID và BusinessEntityID.
SELECT so.SalesOrderID, so.OrderDate, s.Bonus, s.SalesYTD
FROM salesperson s
JOIN salesorderheader so
ON s.SalesPersonID = so.SalesPersonID;

