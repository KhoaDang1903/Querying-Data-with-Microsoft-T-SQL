SELECT 23*24

SELECT CUSTOMERKEY as 'MÃ KH'
, FirstName
, LastName
, TotalChildren as 'Số con'
, NumberChildrenAtHome
FROM dbo.DimCustomer


SELECT CUSTOMERKEY as 'MÃ KH'
, FirstName
, LastName
, TotalChildren as 'Số con'
, NumberChildrenAtHome
, FirstName + '' + LastName as 'fullname'
, TotalChildren - 1 as TotalChildMinus
FROM dbo.DimCustomer

-- Alias dùng để gán tên cột cho bảng kết quả và không tồn tại thực tế trong database
/* comment single line: dùng --
comment mutiple line /*mở comment
*/ */

SELECT TOP 10 PERCENT CustomerKey
, FirstName
, Lastname
FROM dbo.DimCustomer

-- SELECT TOP n* là lấy ra tất cả cột nhưng chỉ 10 dòng đầu tiên của bảng
-- SELECT TOP n PERCENT

--Muốn tìm xem trong 18494KH thì có bao nhiêu Title
--Lấy ra tập giá trị không trùng lặp của Title

SELECT DISTINCT Title
FROM dbo.DimCustomer

SELECT DISTINCT Title
, Gender
FROM dbo.DimCustomer
-- SELECT DISTINCT là lấy ra tập giá trị không trùng lặp
-- SELECT DISTINCT 2 cột trở lên là lấy ra tập giá trị tổ hợp không trùng lặp

SELECT TOP 10 PERCENT customerKey
, TotalChildren
FROM dbo.DimCustomer
ORDER BY TotalChildren DESC
, CustomerKey

-- Default của ORDER BY  là từ bé đến lớn (A-Z) nếu muốn sắp xếp ngược lại từ lớn đến bé (Z-A) thì thêm Keyword DESC
-- ORDER BY có thể sắp xếp theo nhiều layers
-- ORDER BY mà kết hợp với TOP thì sẽ lấy ra TOP giá trị theo sắp xếp

------------------------------------------------------------------------------------------------------------------------------------------
/* Ex1: Từ bộ AdventureworksDW2019, bảng DimEmployee,  
Lấy ra EmployeeKey, FirstName, LastName, BaseRate, VacationHours, SickLeaveHours 
Sau đó lấy ra thêm các cột như sau:  
a. Cột FullName  được lấy ra từ: FirstName + ' ' + LastName 
b. Cột VacationLeavePay được lấy ra từ: BaseRate * VacationHours 
c. Cột SickLeavePay được lấy ra từ: BaseRate * SickLeaveHours  
d.  Cột TotalLeavePay được lấy ra từ VacationLeavePay + SickLeavePay  
*/    

-- Your code here  

USE AdventureWorksDW2019 
SELECT 
    EmployeeKey
    , FirstName 
    , LastName 
    , BaseRate 
    , VacationHours 
    , SickLeaveHours
    , FirstName + ' ' + LastName AS FullName 
    , BaseRate * VacationHours AS VacationLeavePay
    , BaseRate * SickLeaveHours AS SickLeavePay 
    , BaseRate * VacationHours + BaseRate * SickLeaveHours AS TotalLeavePay 
FROM dbo.DimEmployee;

-- way 2:
SELECT EmployeeKey
    , FirstName 
    , LastName 
    , BaseRate 
    , VacationHours 
    , SickLeaveHours
    , FullName 
    , VacationLeavePay
    , SickLeavePay
    , VacationLeavePay + SickLeavePay as TotalLeavePay
FROM (
SELECT 
    EmployeeKey
    , FirstName 
    , LastName 
    , BaseRate 
    , VacationHours 
    , SickLeaveHours
    , FirstName + ' ' + LastName AS FullName 
    , BaseRate * VacationHours AS VacationLeavePay
    , BaseRate * SickLeaveHours AS SickLeavePay 
    -- , BaseRate * VacationHours + BaseRate * SickLeaveHours AS TotalLeavePay 
FROM dbo.DimEmployee) as Emp;

/* Ex2: Từ bộ AdventureworksDW2019, bảng FactInternetSales,  
Lấy ra SalesOrderNumber, ProductKey, OrderDate 
Sau đó lấy ra thêm các cột như sau:  
a. Cột TotalRevenue được lấy ra từ: OrderQuantity * UnitPrice  
B. Cột TotalCost được lấy ra từ: ProductStandardCost + DiscountAmount 
c. Cột Profit được lấy ra từ: TotalRevenue - TotalCost  
d. Cột Profit Margin được lấy ra từ: (TotalRevenue - TotalCost)/TotalRevenue * 100 
*/  

-- Your code here  

SELECT 
    SalesOrderNumber 
    , ProductKey
    , OrderDate
    , OrderQuantity * UnitPrice AS TotalRevenue
    , ProductStandardCost + DiscountAmount AS TotalCost
    , OrderQuantity * UnitPrice - (ProductStandardCost + DiscountAmount) AS Profit
    , (OrderQuantity * UnitPrice - (ProductStandardCost + DiscountAmount))/(OrderQuantity * UnitPrice)*100 AS ProfitMargin 
FROM dbo.FactInternetSales;

/* Ex3: Từ bộ AdventureworksDW2019, bảng FactProductInventory,  
Lấy ra các cột như sau:  
A. Cột NoProductEOD lấy ra từ UnitsBalance + UnitsIn - UnitsOut  
b. Cột TotalCost lấy ra từ: NoProductEOD * UnitCost  
*/  

-- Your code here  

SELECT  
    (UnitsBalance + UnitsIn - UnitsOut) AS 'NoProductEOD'
    , (UnitsBalance + UnitsIn - UnitsOut) * UnitCost AS 'Total Cost' 
FROM dbo.FactProductInventory;

/* Ex4: Từ bộ AdventureworksDW2019, bảng DimGeography, lấy ra EnglishCountryRegionName, 
City, StateProvinceName. Loại bỏ các dòng trùng lặp và sắp xếp bảng kết quả theo thứ tự tăng dần của Country 
và những dòng có cùng giá trị Country thì sắp xếp thêm theo thứ tự giảm dần của City */ 

-- Your code here  

SELECT DISTINCT 
    EnglishCountryRegionName
    , City
    , StateProvinceName 
FROM dbo.DimGeography 
ORDER BY EnglishCountryRegionName ASC, City DESC;

/* Ex5: Từ bộ AdventureworksDW2019, bảng DimProduct, lấy ra EnglishProductName của top 10% các sản phẩm có mức ListPrice cao nhất */

-- Your code here  

SELECT 
	TOP 10 PERCENT EnglishProductName ,
    ListPrice
FROM dbo.DimProduct 
ORDER BY ListPrice DESC; 

--------------------------------------------------------------------------------------------------------------------------------------------

SELECT DepartmentName
, [Status]
, StartDate
, VacationHours
FROM dbo.DimEmployee
WHERE (DepartmentName = 'Tool Design'
OR Status IS NOT NULL
OR StartDate BETWEEN '2009-01-01' AND '2009-12-31')
AND VacationHours > 10

--SQL ưu tiên lấy điều kiện AND trước rồi đến OR -> muốn define đúng thì ngoặc vào cụm đấy


SELECT FirstName
FROM dbo.DimEmployee
WHERE FirstName LIKE 'D%d'

--Tên bắt đầu bằng chữ D
-- Kí tự thay thế % --> có thể có, không có hoặc có nhiều kí tự
-- Tên bắt đầu bằng chữ D và kết thúc bằng chữ d

SELECT FirstName
FROM dbo.DimEmployee
WHERE FirstName LIKE 'D__%d' -- partern/regex -> regular expression
-- Tên có ít nhất 4 kí tự và bắt đầu bằng chữ D, kết thúc bằng chữ d

SELECT FirstName
FROM dbo.DimEmployee
WHERE FirstName LIKE '[B,D]__%d' 
-- Tên có ít nhất 4 kí tự và bắt đầu bằng chữ B hoặc D, kết thúc bằng chữ d

SELECT FirstName
FROM dbo.DimEmployee
WHERE FirstName LIKE '[B-D]__%d' 
-- Tên có ít nhất 4 kí tự và bắt đầu bằng chữ B hoặc chữ C hoặc chữ D, kết thúc bằng chữ d

SELECT FirstName
FROM dbo.DimEmployee
WHERE FirstName LIKE '[^B-D]__%d' 
-- Tên có ít nhất 4 kí tự và bắt đầu khác chữ B hoặc chữ C hoặc chữ D, kết thúc bằng chữ d
-- SQL là non case-sensitive (không phân biệt hoa thường)


SELECT Status
, Status + ' Until today ' as Status_New
, ISNULL([Status], 'Off') + ' Until today' as Status_notnull
From dbo.DimEmployee

-- Hàm INSULL (Trường muốn kiểm tra Null, Giá trị thay thế nếu bị Null)

SELECT CAST ('2022' as int) as New_databyte

SELECT CONVERT(int, '2022') as New_datatype

SELECT CONVERT(VARCHAR, GETDATE(),22)

----------------------------------------------------------------------------------------------------------------------------------------

/* Ex1: Từ bộ AdventureWorksDW2019, bảng FactInternetSales,  

Lấy tất cả các bản ghi có OrderDate từ ngày '2011-01-01' về sau và ShipDate trong năm 2011  

*/  
-- Your code here 
SELECT *
FROM FactInternetSales
WHERE Orderdate >= '2011-01-01'
AND YEAR(ShipDate)= 2011 -- ShipDate BETWEEN '2011-01-01' AND '2011-12-31'

/*Ex2: Từ bộ AdventureWorksDW2019, bảng DimProduct, 

Lấy ra thông tin ProductKey, ProductAlternateKey và EnglishProductName của các sản phẩm.  

Lọc các sản phẩn có ProductAlternasteKey bắt đầu bằng chữ 'BK-' theo sau đó là 1 ký tự bất kỳ khác chữ T và kết thúc bằng 2 con số bất kỳ 

Đồng thời, thoả mãn điều kiện Color là Black hoặc Red hoặc White  

*/  

-- Your code here 

SELECT 
	ProductKey
    , ProductAlternateKey
    , EnglishProductName
    , Color
FROM dbo.DimProduct
WHERE ProductAlternateKey LIKE 'BK-[^T]%-[0-9][0-9]' 
AND Color IN ('Black', 'White', 'Red');

-- kết thúc bằng 20 con số bất kỳ:
SELECT 
	ProductKey
    , ProductAlternateKey
    , EnglishProductName
    , Color
FROM dbo.DimProduct
WHERE ProductAlternateKey LIKE 'BK-[^T]%-' + REPLICATE('[0-9]', 2)
	AND Color IN ('Black', 'Red', 'White');

/* Ex3: Từ bộ AdventureWorksDW2019, bảng DimProduct, lấy ra tất cả các sản phẩm có cột Color là Red */  

-- Your code here 

SELECT *
FROM DimProduct
WHERE Color IN ('Red')

/* Ex4: Từ bộ AdventureWorksDW2019, bảng FactInternetSales chứa thông tin bán hàng,  

lấy ra tất cả các bản ghi bán các sản phẩm có màu là Red */  

(Gợi ý: Sử dụng toán tử IN kết hợp Subquery,  

Có thể tham khảo thêm từ link sau: sqlservertutorial.net/sql-server-basics/sql-server-in/  

*/  

-- Your code here 

SELECT *
FROM FactInternetSales
WHERE ProductKey IN 
(
	SELECT ProductKey
	FROM dbo.DimProduct
	WHERE Color = 'Red'
);

/* Ex5: Từ bộ AdventureWorksDW2019, bảng DimEmployee, lấy ra EmployeeKey, FirstName, LastName, MiddleName 
của những nhân viên có MiddleName không bị Null và cột Phone có độ dài 12 ký tự */  
-- Your code here 

SELECT EmployeeKey
, FirstName
, LastName
, MiddleName
FROM DimEmployee
WHERE  MiddleName IS NOT NULL
AND LEN (Phone) = 12

/* Ex6: Từ bộ AdventureWorksDW2019, bảng DimEmployee, lấy ra danh sách các EmployeeKey 

Sau đó lấy ra thêm các cột sau:  

a. Cột FullName được lấy ra từ kết hợp 3 trường FirstName, MiddleName và LastName, 
với dấu cách ngăn cách giữa các trường (sử dụng 2 cách: toán tử '+' và hàm, sau đó so sánh sự khác biệt)  

b. Cột AgeHired tính tuổi nhân viên tại thời điểm được tuyển, sử dụng cột HireDate và BirthDate 

c. Cột AgeNow tính tuổi nhân viên đến thời điểm hiện tại, sử dụng cột BirthDate 

d. Cột UserName được lấy ra từ phần đằng sau dấu "\" của cột LoginID  

(Ví dụ: LoginID = adventure-works\jun0, vậy Username tương ứng cần được lấy ra là jun0)  */

-- Your code here 

-- CÂU a
--Cách 1
SELECT EmployeeKey
, REPLACE( FirstName, ISNULL(MiddleName, ' ') + LastName,' ') + ' ' + LastName AS FullName
FROM DimEmployee

--Cách 2
SELECT EmployeeKey
,CONCAT (FirstName,' ', MiddleName, ' ', LastName) AS FullName
FROM DimEmployee

--Sử dụng toán tử thì phải sử lí Null bằng ISNULL, còn nếu dùng hàm CONCAT thì nó tự bỏ quá giá trị NULL

--Câu b,c,d

SELECT BirthDate
, HireDate
, LoginID
, DATEDIFF(YEAR, BirthDate, HireDate) AS AgeHired
, DATEDIFF(YEAR, BirthDate, CURRENT_TIMESTAMP) AS AgeNow
, RIGHT(LoginID, Len(LoginID)- CHARINDEX('\', LoginID)) AS UserName
FROM DimEmployee

SELECT EmployeeKey 
,BirthDate
, HireDate
, LoginID
, FirstName + ' ' + ISNULL(MiddleName, '') +'' + LastName AS FullName
, DATEDIFF(YEAR, BirthDate, HireDate) AS AgeHired
, DATEDIFF(YEAR, BirthDate, CURRENT_TIMESTAMP) AS AgeNow
, RIGHT(LoginID, Len(LoginID)- CHARINDEX('\', LoginID)) AS UserName
FROM DimEmployee

-- cách của GPT
SELECT 
    EmployeeKey, 
    LoginID, 
    REPLACE(LoginID, LEFT(LoginID, CHARINDEX('\', LoginID)), '') AS UserName
FROM DimEmployee



SELECT 
	EmployeeKey
    , FirstName
    , LastName
    , MiddleName
    -- Ý a
    , FirstName + ' ' + MiddleName + ' ' + LastName as FullName_way1-- không dùng được, NULL khi MiddleName NULL
    , CONCAT(FirstName , ' ' , MiddleName , ' ' , LastName) as FullName_way2 -- bị dup giá trị ' '
    , ISNULL(FirstName + ' ' + MiddleName + ' ' + LastName, FirstName + ' ' + LastName ) AS FullName_way3
    , REPLACE(CONCAT(FirstName , ' ' , MiddleName , ' ' , LastName), '  ', ' ') as FullName_way4_1
    ,CONCAT (FirstName,' ', MiddleName, ' ', LastName) AS FullName_way4_2 -- Dư dấu cách rồi
    , FirstName + ISNULL(' ' + MiddleName + ' ', ' ') + LastName AS FullName_way5
    , CONCAT_WS(' ', FirstName, MiddleName, LastName) AS FullName_way6
    , HireDate
    , BirthDate
    -- Ý b
    , DATEDIFF(YEAR, BirthDate, HireDate) AS AgeHired
    -- Ý c 
    , DATEDIFF(YEAR, BirthDate, GETDATE()) AS AgeNow --DATEDIFF(YEAR, BirthDate, CURRENT_TIMESTAMP)
    -- Ý d 
    , LoginID
    -- , REPLACE(LoginID, 'adventure-works\', '') AS UserName_replace 
    -- , SUBSTRING(LoginID, 17, 100) AS UserName_substring_fixed
    , SUBSTRING(LoginID, CHARINDEX('\', LoginID) + 1, LEN(LoginID)) AS UserName_substring_dynamic
    , RIGHT(LoginID, LEN(LoginID) - CHARINDEX('\', LoginID)) AS UserName_right_dynamic
FROM dbo.DimEmployee
 

 
---------------------------------------------------------------------------------------------------------------------------------------
 

/*Ex 1: Từ bảng dbo.FactInternetSales và dbo.DimSalesTerritory, lấy ra thông tin SalesOrderNumber, 
SalesOrderLineNumber, ProductKey, SalesTerritoryCountry  của các bản ghi có SalesAmount trên 1000
*/ 

SELECT F.SalesOrderNumber
    , F.SalesOrderLineNumber
    , F.ProductKey
    , F.SalesAmount
    , D.SalesTerritorycountry
FROM dbo.FactInternetSales F
INNER JOIN dbo.DimSalesTerritory D
        ON F.SalesTerritoryKey = D.SalesTerritoryKey
WHERE F.SalesAmount > 1000


/*Ex 2: Từ bảng dbo.DimProduct và dbo.DimProductSubcategory. Lấy ra ProductKey, 
EnglishProductName và Color của các sản phẩm thoả mãn EnglishProductSubCategoryName chứa chữ 'Bikes' và ListPrice có phần nguyên là 3399 
*/ 

SELECT P.ProductKey
    , P.EnglishProductName
    , P.Color
    , S.EnglishProductSubCategoryName 
    , P.ListPrice
FROM dbo.DimProduct P
INNER JOIN dbo.DimProductSubcategory S
    ON P.ProductSubCategoryKey = S.ProductSubcategoryKey
WHERE EnglishProductSubCategoryName LIKE '%Bikes%'
    AND ListPrice LIKE ('3399.') + REPLICATE ('[0-9]',2)

--//  Bài làm đúng, tuy nhiên ListPrice là dữ liệu dạng số, bạn không nên xử lý theo kiểu dạng string nhé. Thay vào đó bạn có thể sử dụng hàm FLOOR(ListPrice) = 3399 là hàm làm tròn xuống 

/* Ex 3: Từ bảng dbo.DimPromotion, dbo.FactInternetSales, 
lấy ra ProductKey, SalesOrderNumber, SalesAmount từ các bản ghi thoả mãn DiscountPct >= 20% */ 

SELECT  D.DiscountPct
    , F.ProductKey
    , F.SalesOrderNumber
    , F.SalesAmount
FROM dbo.DimPromotion D
INNER JOIN dbo.FactInternetSales F
    ON D.PromotionKey = F.PromotionKey
WHERE DiscountPct >= 20/100


/* Ex 4: Từ bảng dbo.DimCustomer, dbo.DimGeography, lấy ra cột Phone, FullName (kết hợp FirstName,
MiddleName, LastName kèm khoảng cách ở giữa) của các khách hàng có YearlyInCome > 150000 và CommuteDistance nhỏ hơn 5 Miles*/ 

SELECT C.Phone
, ISNULL( C.FirstName + ' ' + C.MiddleName + ' ' + C.LastName, C.FirstName + ' ' + C.LastName) AS FullName
, C.YearlyIncome
, C.CommuteDistance
FROM dbo.DimCustomer C
INNER JOIN dbo.DimGeography G
    ON C.GeographyKey = G.GeographyKey
WHERE C.YearlyInCome > 150000
AND C.CommuteDistance LIKE '[0-4]-[0-4] Miles'

-- bạn nên để điều kiện là CommuteDistance LIKE '[0-4]-[0-5] Miles' vì trong dữ liệu còn có giá trị '2-5 Miles' thì '[0-4]-[0-4] Miles' không lấy được 


/* Ex 5: Từ bảng dbo.DimCustomer, lấy ra CustomerKey và thực hiện các yêu cầu sau:  
a. Tạo cột mới đặt tên là YearlyInComeRange từ các điều kiện sau:  
- Nếu YearlyIncome từ 0 đến 50000 thì gán giá trị "Low Income"  
- Nếu YearlyIncome từ 50001 đến 90000 thì gán giá trị "Middle Income"  
- Nếu YearlyIncome từ  90001 trở lên thì gán giá trị "High Income"  
b. Tạo cột mới đặt tên là AgeRange từ các điều kiện sau:  
- Nếu tuổi của Khách hàng tính đến 31/12/2019 đến 39 tuổi thì gán giá trị "Young Adults"  
- Nếu tuổi của Khách hàng tính đến 31/12/2019 từ 40 đến 59 tuổi thì gán giá trị "Middle-Aged Adults"  
- Nếu tuổi của Khách hàng tính đến 31/12/2019 lớn hơn 60 tuổi thì gán giá trị "Old Adults"  
 */   

SELECT CustomerKey
, CASE
    WHEN YearlyIncome BETWEEN 0 AND 50000  THEN 'Low Income'
    WHEN YearlyIncome BETWEEN 50001 AND 90000 THEN 'Middle Income'
    WHEN YearlyIncome >= 90001 THEN 'High Income'
        ELSE 'Other'
END AS YearlyInComeRange
, CASE
    WHEN DATEDIFF (Year, birthdate, 31/12/2019) <= 39  THEN 'Young Adults'
    WHEN DATEDIFF (Year, birthdate, 31/12/2019) BETWEEN 40 AND 59 THEN 'Middle-Aged Adults'
    WHEN DATEDIFF (Year, birthdate, 31/12/2019) >60 THEN 'Old Adults'
        ELSE 'Other'
END AS AgeRange
FROM dbo.DimCustomer  

SELECT Birthdate
, year (birthdate) as year_birth
, CAST (Birthdate AS date) as datenew1
, CAST (Birthdate AS varchar) as datenew2
FROM dbo.DimCustomer

-- bạn xem lại buổi học số 2 về kiểu dữ liệu thời gian nhé, với kiểu dữ liệu thời gian, bạn cần khai báo theo format 'YYYY-MM-DD' hoặc 'YYYY/MM/DD' và cần có cặp dấu ngoặc đơn nhé. 
-- Việc bạn đặt 31/12/2019, sql đang hiểu giá trị này =0, dẫn đến khi sử dụng DATEDIFF giá trị ra âm và toàn bộ giá trị cột AgeRange đều là 'Young Adults'  



 /* Ex 6: Từ bảng FactInternetSales, FactResellerSale và DimProduct. 
 Tìm tất cả SalesOrderNumber có EnglishProductName chứa từ 'Road' và có màu vàng (Yellow) */ 

SELECT Combined.SalesOrderNumber
FROM
    (SELECT  I.SalesOrderNumber
        , I.ProductKey
        FROM FactInternetSales I
    UNION ALL
    SELECT R.SalesOrderNumber
        , R.ProductKey
        FROM FactResellerSales R) 
            AS combined
    INNER JOIN DimProduct P
        ON combined.ProductKey = P.ProductKey
    WHERE P.EnglishProductName LIKE '%Road%'
    AND P.Color = 'Yellow'


-------------------------------------------------------------------------------------------------
/*Ex 1: Từ bảng dbo.FactInternetSales và dbo.DimSalesTerritory.
Lấy ra thông tin SalesOrderNumber, SalesOrderLineNumber, ProductKey, SalesTerritoryCountry 
của các bản ghi có SalesAmount trên 1000.
*/
-- Your code here

USE AdventureWorksDW2019

SELECT 
    FIS.SalesOrderNumber
	, FIS.SalesOrderLineNumber
	, FIS.ProductKey
	, DST.SalesTerritoryCountry
FROM dbo.FactInternetSales AS FIS 
    LEFT JOIN dbo.DimSalesTerritory AS DST 
	    ON FIS.SalesTerritoryKey = DST.SalesTerritoryKey
WHERE FIS.SalesAmount > 1000;


/*Ex 2: Từ bảng dbo.DimProduct và dbo.DimProductSubcategory. 
Lấy ra ProductKey, EnglishProductName và Color của các sản phẩm thoả mãn EnglishProductSubCategoryName chứa chữ 'Bikes' 
và ListPrice có phần nguyên là 3399.
*/
-- Your code here

-- WAY 1
SELECT 
    DP.ProductKey
    , DP.EnglishProductName
    , DP.Color
FROM dbo.DimProduct AS DP
    LEFT JOIN dbo.DimProductSubcategory AS DPS 
        ON DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
WHERE DPS.EnglishProductSubcategoryName LIKE '%Bikes%'
    AND (DP.ListPrice >= 3399 AND DP.ListPrice < 3400);

-- WAY 2
SELECT 
    DP.ProductKey
    , DP.EnglishProductName
    , DP.Color
FROM dbo.DimProduct AS DP
    LEFT JOIN dbo.DimProductSubcategory AS DPS 
        ON DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
WHERE DPS.EnglishProductSubcategoryName LIKE '%Bikes%'
    AND FLOOR(DP.ListPrice) = 3399


/* Ex 3: Từ bảng dbo.DimPromotion, dbo.FactInternetSales. 
Lấy ra ProductKey, SalesOrderNumber, SalesAmount, DiscountPct 
từ các bản ghi thoả mãn DiscountPct >= 20%. */
-- Your code here

SELECT 
    FIS.ProductKey
    , FIS.SalesOrderNumber
    , FIS.SalesAmount
    , FORMAT(DP.DiscountPct,'P') AS PerDiscount
FROM dbo.FactInternetSales AS FIS
    LEFT JOIN  dbo.DimPromotion AS DP
        ON FIS.PromotionKey = DP.PromotionKey
WHERE DP.DiscountPct >= 0.2;


/* Ex 4: Từ bảng dbo.DimCustomer, dbo.DimGeography, lấy ra cột Phone, City, FullName (kết hợp FirstName, MiddleName, LastName kèm khoảng cách ở giữa) 
của các khách hàng có YearlyInCome > 150000 và CommuteDistance nhỏ hơn 5 Miles*/
-- Your code here

-- WAY 1
SELECT 
    DC.Phone
    , DG.City
    , ISNULL(DC.FirstName + ' ' + DC.MiddleName + ' ' + DC.LastName, DC.FirstName + ' ' + DC.LastName ) AS FullName_1
    , CONCAT_WS(' ', DC.FirstName, DC.MiddleName, DC.LastName) AS FullName_2
    , CommuteDistance
FROM dbo.DimCustomer AS DC 
    LEFT JOIN dbo.DimGeography AS DG 
        ON DC.GeographyKey = DG.GeographyKey
WHERE DC.YearlyIncome > 150000 
	AND DC.CommuteDistance IN ('0-1 Miles', '1-2 Miles', '2-5 Miles');

-- WAY 2
SELECT 
    DC.Phone
    , DG.City
    , ISNULL(DC.FirstName + ' ' + DC.MiddleName + ' ' + DC.LastName, DC.FirstName + ' ' + DC.LastName ) AS FullName_1
    , CONCAT_WS(' ', DC.FirstName, DC.MiddleName, DC.LastName) AS FullName_2
    , CommuteDistance
FROM dbo.DimCustomer AS DC 
    LEFT JOIN dbo.DimGeography AS DG 
        ON DC.GeographyKey = DG.GeographyKey
WHERE DC.YearlyIncome > 150000 
	AND DC.CommuteDistance LIKE '[0-4]-[0-5] Miles';
 

/* Ex 5: Từ bảng dbo.DimCustomer, lấy ra CustomerKey và thực hiện các yêu cầu sau: 
a. Tạo cột mới đặt tên là YearlyInComeRange từ các điều kiện sau: 
- Nếu YearlyIncome từ 10000 đến 50000 thì gán giá trị "Low Income" 
- Nếu YearlyIncome từ 50001 đến 90000 thì gán giá trị "Middle Income" 
- Nếu YearlyIncome từ  90001 trở lên thì gán giá trị "High Income" 
b. Tạo cột mới đặt tên là AgeRange từ các điều kiện sau: 
- Nếu tuổi của Khách hàng tính đến 31/12/2019 đến 39 tuổi thì gán giá trị "Young Adults" 
- Nếu tuổi của Khách hàng tính đến 31/12/2019 từ 40 đến 59 tuổi thì gán giá trị "Middle-Aged Adults" 
- Nếu tuổi của Khách hàng tính đến 31/12/2019 lớn hơn hoặc bằng 60 tuổi thì gán giá trị "Old Adults" 
 */
-- Your code here

SELECT 
        CustomerKey 
        , CASE WHEN YearlyIncome <= 50000 THEN 'Low Income'
             WHEN YearlyIncome <= 90000 THEN 'Middle Income'
             WHEN YearlyIncome >= 90001 THEN 'High Income'
            END AS YearlyInComeRange
        , CASE WHEN DATEDIFF(year, BirthDate, '2019-12-31') <= 39 THEN 'Young Adults'
             WHEN DATEDIFF(year, BirthDate, '2019-12-31') <= 59 THEN 'Middle-Aged Adults'
             WHEN DATEDIFF(year, BirthDate, '2019-12-31') > 60 THEN 'Old Adults'
            END AS Age
    FROM dbo.DimCustomer


/* Ex 6: Từ bảng FactInternetSales, FactResellerSale và DimProduct. 
Tìm tất cả SalesOrderNumber có EnglishProductName chứa từ 'Road' và có màu vàng (Yellow) */ 
-- Your code here  

SELECT 
	FIS.SalesOrderNumber
FROM dbo.FactInternetSales AS FIS 
	LEFT JOIN dbo.DimProduct AS DP
	    ON FIS.ProductKey = DP.ProductKey
WHERE DP.EnglishProductName LIKE '%Road%' 
	AND DP.Color = 'Yellow'

UNION

SELECT FRS.SalesOrderNumber
FROM dbo.FactResellerSales AS FRS
	LEFT JOIN dbo.DimProduct AS DP
	    ON FRS.ProductKey = DP.ProductKey
WHERE DP.EnglishProductName LIKE '%Road%' 
	AND DP.Color = 'Yellow';
------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------
/*Ex 1: Từ các bảng dbo.DimProduct, dbo.DimPromotion, dbo.FactInternetSales, 
lấy ra ProductKey, EnglishProductName của các dòng thoả mãn Discount Pct >= 20% */ 
-- Your code here  

USE AdventureWorksDW2019

SELECT 
    FIS.ProductKey
    , DP.EnglishProductName
FROM dbo.FactInternetSales AS FIS
    LEFT JOIN dbo.DimProduct AS DP 
        ON FIS.ProductKey = DP.ProductKey
    LEFT JOIN dbo.DimPromotion AS DPM 
        ON FIS.PromotionKey = DPM.PromotionKey
WHERE DPM.DiscountPct >= 0.2;


/*Ex 2: Từ các bảng DimProduct, DimProductSubcategory, DimProductCategory, 
lấy ra các cột Product key, EnglishProductName, EnglishProductSubCategoryName, EnglishProductCategoryName 
của sản phẩm thoả mãn điều kiện EnglishProductCategoryName là 'Clothing' */ 
-- Your code here  

SELECT 
    DP.ProductKey
    , DP.EnglishProductName
    , DPSC.EnglishProductSubcategoryName
    , DPC.EnglishProductCategoryName
FROM dbo.DimProduct AS DP 
    LEFT JOIN dbo.DimProductSubcategory AS DPSC 
        ON DP.ProductSubcategoryKey = DPSC.ProductSubcategoryKey 
    LEFT JOIN dbo.DimProductCategory AS DPC 
        ON DPSC.ProductCategoryKey = DPC.ProductCategoryKey
WHERE DPC.EnglishProductCategoryName = 'Clothing';


/*Ex 3: Từ bảng FactInternetSales và DimProduct, lấy ra ProductKey, EnglishProductName, ListPrice 
của những sản phẩm chưa từng được bán. Sử dụng 2 cách: toán tử IN và phép JOIN */ 
-- Your code here  

-- WAY 1: IN
SELECT 
    ProductKey
    , EnglishProductName
    , ListPrice
FROM dbo.DimProduct
WHERE ProductKey NOT IN (SELECT ProductKey FROM dbo.FactInternetSales); 


-- WAY 2: JOIN 
SELECT 
    DP.ProductKey
    , DP.EnglishProductName
    , DP.ListPrice
FROM dbo.DimProduct AS DP 
    LEFT JOIN dbo.FactInternetSales AS FIS 
        ON DP.ProductKey = FIS.ProductKey
WHERE FIS.SalesAmount IS NULL;



/*Ex 4: Từ bảng DimDepartmentGroup, lấy ra thông tin DepartmentGroupKey, DepartmentGroupName, ParentDepartmentGroupKey 
và thực hiện self-join lấy ra ParentDepartmentGroupName */ 
-- Your code here 

SELECT 
    ChildTable.DepartmentGroupName
    , ParentTable.DepartmentGroupName AS ParentDepartmentGroupName
FROM dbo.DimDepartmentGroup AS ChildTable
    LEFT JOIN dbo.DimDepartmentGroup AS ParentTable 
        ON ChildTable.ParentDepartmentGroupKey = ParentTable.DepartmentGroupKey;


/*Ex 5: Từ bảng FactFinance, DimOrganization, DimScenario, 
lấy ra OrganizationKey, OrganizationName, Parent OrganizationKey, 
và thực hiện self-join lấy ra Parent OrganizationName, 
Amount thoả mãn điều kiện ScenarioName là 'Actual'. */   
-- Your code here  


--WAY 1
SELECT 
    DO.OrganizationKey
    , DO.OrganizationName
    , PDO.OrganizationKey AS ParentOrganizationKey
    , PDO.OrganizationName AS ParentOrganizationName
    , FF.Amount
FROM dbo.FactFinance AS FF 
    LEFT JOIN dbo.DimScenario AS DS 
        ON DS.ScenarioKey = FF.ScenarioKey
    LEFT JOIN dbo.DimOrganization AS DO 
        ON FF.OrganizationKey = DO.OrganizationKey
    LEFT JOIN dbo.DimOrganization AS PDO 
        ON DO.ParentOrganizationKey = PDO.OrganizationKey
WHERE DS.ScenarioName = 'Actual';


--WAY 2
-- Sử dụng subquery, Organization + ParentOrganization -> self join 

SELECT 
    FF.OrganizationKey
    , DO.OrganizationName
    , DO.ParentOrganizationKey
    , DO.ParentOrganizationName
    , FF.Amount
FROM dbo.FactFinance AS FF 
    LEFT JOIN dbo.DimScenario AS DS 
        ON FF.ScenarioKey = DS.ScenarioKey
    LEFT JOIN (
    SELECT 
        childDO.OrganizationKey
        , childDO.OrganizationName
        , childDO.ParentOrganizationKey
        , parentDO.OrganizationName AS ParentOrganizationName
    FROM dbo.DimOrganization AS childDO
        LEFT JOIN dbo.DimOrganization AS parentDO 
            ON childDO.ParentOrganizationKey = parentDO.OrganizationKey
) AS DO 
        ON FF.OrganizationKey = DO.OrganizationKey
WHERE DS.ScenarioName = 'Actual';

--WAY 3
-- Sử dụng CTE để tạo ra bảng tạm, Organization + ParentOrganization -> self join 
-- CTE
WITH New_DO AS 
(
    SELECT 
        childDO.OrganizationKey
        , childDO.OrganizationName
        , childDO.ParentOrganizationKey
        , parentDO.OrganizationName AS ParentOrganizationName
    FROM dbo.DimOrganization AS childDO
        LEFT JOIN dbo.DimOrganization AS parentDO 
            ON childDO.ParentOrganizationKey = parentDO.OrganizationKey
)
-- main query
SELECT 
    FF.OrganizationKey
    , DO.OrganizationName
    , DO.ParentOrganizationKey
    , DO.ParentOrganizationName
    , FF.Amount
FROM dbo.FactFinance AS FF 
    LEFT JOIN dbo.DimScenario AS DS 
        ON FF.ScenarioKey = DS.ScenarioKey
    LEFT JOIN New_DO AS DO 
        ON FF.OrganizationKey = DO.OrganizationKey 
WHERE DS.ScenarioName = 'Actual';

-- lưu ý khi chạy thì chạy CTE cùng main query

-----------------------------------------------------------------------------------------------
/* Ex1: Từ bảng DimEmployee, tính BaseRate trung bình của từng Title có trong công ty */  
SELECT 
    Title, 
    AVG(BaseRate) AS AvgBaseRate
FROM 
    DimEmployee
GROUP BY 
    Title;

 

 

 

 

 

 

 

/* Ex 2: Từ bảng FactInternetSales, lấy ra cột TotalOrderQuantity, sử dụng cột OrderQuantity tính tổng số lượng bán ra với từng ProductKey và từng ngày OrderDate*/ 

 

 SELECT 
    ProductKey,
    OrderDate,
    SUM(OrderQuantity) AS TotalOrderQuantity
FROM 
    FactInternetSales
GROUP BY 
    ProductKey, 
    OrderDate;


 

 

 

 

 

 

/* Ex3: Từ bảng DimProduct, FactInternetSales, DimProductCategory và các bảng liên quan nếu cần thiết 

Lấy ra thông tin ngành hàng gồm: CategoryKey, EnglishCategoryName của các dòng thoả mãn điều kiện OrderDate trong năm 2012 và tính toán các cột sau đối với từng ngành hàng:  

- TotalRevenue sử dụng cột SalesAmount 

- TotalCost sử dụng côt TotalProductCost 

- TotalProfit được tính từ (TotalRevenue - TotalCost) 

Chỉ hiển thị ra những bản ghi có TotalRevenue > 5000 */  

 

SELECT 
    c.ProductCategoryKey,
    c.EnglishProductName,
    SUM(f.SalesAmount) AS TotalRevenue,
    SUM(f.TotalProductCost) AS TotalCost,
    SUM(f.SalesAmount) - SUM(f.TotalProductCost) AS TotalProfit
FROM 
    FactInternetSales f
JOIN 
    DimProduct p ON f.ProductKey = p.ProductKey
JOIN 
    DimProductCategory c ON p.CategoryKey = c.ProductCategoryKey
WHERE 
    YEAR(f.OrderDate) = 2012
GROUP BY 
    c.ProductCategoryKey, c.EnglishProductName
HAVING 
    SUM(f.SalesAmount) > 5000


    SELECT *
FROM DimProduct

SELECT *
FROM FactInternetSales

SELECT *
FROM DimProductCategory
 

 

/* Ex 4: Từ bảng FactInternetSale, DimProduct, 

- Tạo ra cột Color_group từ cột Color, nếu Color là 'Black' hoặc 'Silver' gán giá trị 'Basic' cho cột Color_group, nếu không lấy nguyên giá trị cột Color sang 

- Sau đó tính toán cột TotalRevenue từ cột SalesAmount đối với từng Color_group mới này */  

 
 SELECT 
    CASE 
        WHEN p.Color IN ('Black', 'Silver') THEN 'Basic'
        ELSE p.Color
    END AS Color_group,
    SUM(fs.SalesAmount) AS TotalRevenue
FROM 
    FactInternetSales fs
JOIN 
    DimProduct p ON fs.ProductKey = p.ProductKey
GROUP BY 
    CASE 
        WHEN p.Color IN ('Black', 'Silver') THEN 'Basic'
        ELSE p.Color
    END;
 

 

 

 

 

/* Ex 5 (nâng cao) Từ bảng FactInternetSales, FactResellerSales và các bảng liên quan nếu cần, sử dụng cột SalesAmount tính toán doanh thu ứng với từng tháng của 2 kênh bán Internet và Reseller 

Kết quả trả ra sẽ gồm các cột sau: Year, Month, InternSales, Reseller_Sales 

Gợi ý: Tính doanh thu theo từng tháng ở mỗi bảng độc lập FactInternetSales và FactResllerSales bằng sử dụng CTE  

Lưu ý khi có nhiều hơn 1 CTE trong mệnh đề thì viết syntax như sau:  

 

WITH Name_CTE_1 AS ( 

SELECT statement 

) 

, Name_CTE_2 AS ( 

SELECT statement 

)  

 

SELECT statement 

*/  

WITH InternetSales_CTE AS (
    SELECT 
        YEAR(OrderDate) AS Year,
        MONTH(OrderDate) AS Month,
        SUM(SalesAmount) AS SalesAmount,
        'Internet' AS Channel
    FROM 
        FactInternetSales
    GROUP BY 
        YEAR(OrderDate),
        MONTH(OrderDate)
),

ResellerSales_CTE AS (
    SELECT 
        YEAR(OrderDate) AS Year,
        MONTH(OrderDate) AS Month,
        SUM(SalesAmount) AS SalesAmount,
        'Reseller' AS Channel
    FROM 
        FactResellerSales
    GROUP BY 
        YEAR(OrderDate),
        MONTH(OrderDate)
),

CombinedSales_CTE AS (
    SELECT * FROM InternetSales_CTE
    UNION ALL
    SELECT * FROM ResellerSales_CTE
)

SELECT 
    Year,
    Month,
    SUM(CASE WHEN Channel = 'Internet' THEN SalesAmount ELSE 0 END) AS InternetSales,
    SUM(CASE WHEN Channel = 'Reseller' THEN SalesAmount ELSE 0 END) AS ResellerSales
FROM 
    CombinedSales_CTE
GROUP BY 
    Year, Month





-- Câu 1: Dựa và bảng FactInternetSales 

-- Tính tổng số lượng sản phẩm (OrderQuantity) đã được bán cho mỗi khách hàng (CustomerKey). Hiển thị kết quả theo thứ tự giảm dần của tổng số lượng. 

 

SELECT CustomerKey
, SUM (OrderQuantity) AS TotalOrderQuantity 
FROM  FactInternetSales
GROUP BY CustomerKey
ORDER BY TotalOrderQuantity  DESC



 

-- Câu 2: Dựa vào bảng FactInternetSales và DimProduct 

-- Thống kê tổng số lượng sản phẩm được bán (TotalOrderQuantity) cho mỗi sản phẩm (EnglishProductName).
-- Hiển thị kết quả theo thứ tự giảm dần của TotalOrderQuantity. 

SELECT Sum (OrderQuantity) AS TotalOrderQuantity
, D.EnglishProductName
FROM FactInternetSales FIS
LEFT JOIN DimProduct D
ON FIS.ProductKey = D.ProductKey
GROUP BY EnglishProductName
ORDER BY TotalOrderQuantity DESC



 

 

-- Câu 3: Dựa vào bảng FactInternetSales, DimCustomer, tạo ra trường FullName từ (FirstName, MiddleName, LastName và sử dụng dấu cách ' ' để ghép nối)   

-- và thống kê số lượng đơn đặt hàng (OrderCount) mà họ đã thực hiện trong năm 2014. Và chỉ lấy những khách hàng có ít nhất 2 đơn đặt hàng.  

 
SELECT  COUNT (FIS.SalesOrderNumber) AS OrderCount
, ISNULL (DC.FirstName + ' ' + DC.MiddleName + ' ' + DC.LastName, DC.FirstName + ' ' + DC.LastName) AS FullName
FROM FactInternetSales FIS
LEFT JOIN DimCustomer DC
ON FIS.CustomerKey = DC.CustomerKey
WHERE Year(FIS.OrderDate) = 2014
GROUP BY ISNULL (DC.FirstName + ' ' + DC.MiddleName + ' ' + DC.LastName, DC.FirstName + ' ' + DC.LastName)
HAVING COUNT (FIS.SalesOrderNumber) >= 2






-- Câu 4:  

-- Từ bảng DimProduct, DimProductSubCategory, DimProductCategory và FactInternetSales 

-- Viết truy vấn lấy ra EnglishProductCategoryName, TotalAmount (tính theo SaleAmount) của 2 danh mục có doanh thu cao nhất trong năm 2014 


SELECT TOP 2 DPC.EnglishProductCategoryName
, SUM (FIS.SalesAmount) AS TotalAmount
FROM DimProduct DP
LEFT JOIN FactInternetSales FIS
ON DP.ProductKey = FIS.ProductKey
LEFT JOIN DimProductSubcategory DPS
ON DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
LEFT JOIN DimProductCategory DPC
ON DPS.ProductCategoryKey = DPC.ProductCategoryKey
WHERE year(FIS.OrderDate) = 2014
GROUP BY DPC.EnglishProductCategoryName
ORDER BY SUM (FIS.SalesAmount) DESC


 

-- Câu 5: Từ bảng FactInternetSale và bảng FactResellerSale, 

-- thực hiện từ 2 nguồn bán là Internet và Reseller đưa ra tất cả tất cả các SaleOrderNumber và doanh thu của mỗi SaleOrderNumber 


SELECT 
    FIS.SalesOrderNumber, 
    SUM(FIS.SalesAmount) AS TotalAmount
FROM 
    FactInternetSales FIS
GROUP BY 
    FIS.SalesOrderNumber
UNION ALL
SELECT 
    FRS.SalesOrderNumber, 
    SUM(FRS.SalesAmount) AS TotalAmount
FROM 
    FactResellerSales FRS
GROUP BY 
    FRS.SalesOrderNumber;


 

-- Câu 6: Dựa vào 2 bảng p và bảng FactFinace, thực hiện lấy ra TotalAmount (dựa vào Amount) của DepartmentGroupName và ParentDepartmentGroupName 

SELECT SUM (Amount) AS TotalAmount
, DPG.DepartmentGroupName
, FF.ParentDepartmentGroupName
FROM DimDepartmentGroup DPG
LEFT JOIN FactFinance FF
ON DPG.DepartmentGroupKey = FF.DepartmentGroupKey
GROUP BY DPG.DepartmentGroupName
AND 

SELECT *
FROM FactFinance
