
CREATE DATABASE TPCH
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

CREATE TABLE Region (
    regionkey INT,
    name VARCHAR(30),
    comment VARCHAR(130),
    CONSTRAINT PK_Region PRIMARY KEY (regionkey)
);

CREATE TABLE Nation (
    nationkey INT,
    name VARCHAR(30),
    regionkey INT,
    comment VARCHAR(130),
    CONSTRAINT PK_Nation PRIMARY KEY (nationkey),
    CONSTRAINT FK_Region
     FOREIGN KEY (regionkey)
        REFERENCES Region(regionkey)
);


CREATE TABLE Part (
    partkey INT,
    name VARCHAR(50),
    mfgr VARCHAR(30),
    brand VARCHAR(20),
    type VARCHAR(30),
    size INT,
    container VARCHAR(20),
    retailprice DECIMAL(10,2),
    comment VARCHAR(130),
    CONSTRAINT PK_Part PRIMARY KEY (partkey),
    CONSTRAINT CK_Part_Price CHECK (retailprice > 0)
);

CREATE TABLE Supplier (
    suppkey INT,
    name VARCHAR(30),
    address VARCHAR(50),
    nationkey INT,
    phone VARCHAR(18),
    acctbal DECIMAL(12,2),
    comment VARCHAR(130),
    CONSTRAINT PK_Supplier PRIMARY KEY (suppkey),
    CONSTRAINT FK_Sup_Nation FOREIGN KEY (nationkey)
        REFERENCES Nation(nationkey)
);

CREATE TABLE PartSupp (
    partkey INT,
    suppkey INT,
    availqty INT,
    supplycost DECIMAL(10,2),
    comment VARCHAR(130),
    CONSTRAINT PK_Part_Supp PRIMARY KEY (partkey, suppkey),
    CONSTRAINT CK_Part_Supp_Availqty CHECK (availqty > 0),
    CONSTRAINT FK_PartSupp_Part FOREIGN KEY (partkey)
        REFERENCES Part(partkey),
    CONSTRAINT FK_PartSupp_Supplier FOREIGN KEY (suppkey)
        REFERENCES Supplier(suppkey)
);

CREATE TABLE Customer (
    custkey INT,
    name VARCHAR(30),
    address VARCHAR(40),
    nationkey INT,
    phone VARCHAR(20),
    acctbal DECIMAL(12,2),
    mktsegment VARCHAR(15),
    comment VARCHAR(130),
    CONSTRAINT PK_Custkey PRIMARY KEY (custkey),
    CONSTRAINT FK_Nation FOREIGN KEY (nationkey)
        REFERENCES Nation(nationkey)
);

CREATE TABLE Orders (
    orderkey INT NOT NULL,
    custkey INT NOT NULL,
    orderstatus CHAR(1) NOT NULL,
    totalprice DECIMAL(12,2) NOT NULL,
    orderdate DATE NOT NULL,
    orderpriority VARCHAR(15) NOT NULL,
    clerk VARCHAR(15) NOT NULL,
    shippriority INT NOT NULL,
    comment VARCHAR(152),
    CONSTRAINT PK_Orders PRIMARY KEY (orderkey),
    CONSTRAINT FK_Orders_Customer FOREIGN KEY (custkey)
        REFERENCES Customer(custkey)
);

CREATE TABLE Lineitem (
    orderkey       INT           NOT NULL,
    partkey        INT           NOT NULL,
    suppkey        INT           NOT NULL,
    linenumber     INT           NOT NULL,
    quantity       DECIMAL(10,2) NOT NULL,
    extendedprice  DECIMAL(12,2) NOT NULL,
    discount       DECIMAL(4,2)  NOT NULL,
    tax            DECIMAL(4,2)  NOT NULL,
    returnflag     CHAR(1)       NOT NULL,
    linestatus     CHAR(1)       NOT NULL,
    shipdate       DATE          NOT NULL,
    commitdate     DATE          NOT NULL,
    receiptdate    DATE          NOT NULL,
    shipinstruct   VARCHAR(25)   NOT NULL,
    shipmode       VARCHAR(10)   NOT NULL,
    comment        VARCHAR(152),
    CONSTRAINT PK_Lineitem PRIMARY KEY (orderkey, linenumber),
    CONSTRAINT FK_Lineitem_Orders    FOREIGN KEY (orderkey) REFERENCES Orders(orderkey),
    CONSTRAINT FK_Lineitem_PartSupp  FOREIGN KEY (partkey, suppkey)
        REFERENCES PartSupp(partkey, suppkey)
);

INSERT INTO Region(regionkey,name ,comment ) VALUES 
(1,'Asia','Asia Region'),
(2, 'EUROPE', 'European region'),
(3, 'AFRICA', 'African region'),
(4, 'AMERICA', 'American region');


INSERT INTO Nation (nationkey, name, regionkey, comment) VALUES
(1, 'CHINA', 1, 'China nation'),
(2, 'JAPAN', 1, 'Japan nation'),
(3, 'GERMANY', 2, 'Germany nation'),
(4, 'USA', 4, 'United States');

INSERT INTO Part(partkey,name,mfgr,brand,type,size,container,retailprice,comment) VALUES
(1,'laptop','manufA','APPLE','Electronic',10, 'BOX', 500.00, 'Laptop product'),
(2, 'Keyboard', 'manufB', 'HUAWEI', 'Electronic', 5, 'PACK', 50.00, 'Keyboard product'),
(3, 'Mouse', 'manufB', 'HUAWEI', 'Electronic', 3, 'BOX', 25.00, 'Mouse product'),
(4, 'Monitor', 'manufC', 'XIAOMI', 'Electronic', 20, 'BOX', 300.00, 'Monitor product');

INSERT INTO Supplier(suppkey,name,address,nationkey, phone, acctbal, comment)
VALUES
(1,'Zhang','Shanghai',1,'177-8299-2345',1600.00,'Mr.Zhang'),
(2, 'Li', 'Tokyo', 2, '03-12345678', 1500.00, 'Miss Li'),
(3, 'John', 'Berlin', 3, '030-12345678', 3000.00, 'Mr.John');

INSERT INTO PartSupp
(partkey, suppkey, availqty, supplycost, comment)
VALUES
  (1,1,5,300.00,'low inventory'),
  (1,2,100,320,'sufficient inventort'),
  (2,3,40,20,'normal inventory'),
  (4,2,8,200,'low inventory');
  

INSERT INTO Customer
 (custkey,name,address,nationkey,phone,acctbal,mktsegment,comment)
 VALUES 
  (1,'Alice' ,'Shenzhen',1,'409-9876-4589',4000.00, 'LOGISTICS','customer Alice'),
  (2,'Nina' ,'NewYork',4,'889-7667-3800',9900.00,'FINANCE','customer Nina'),
  (3, 'Charlie', 'Tokyo', 2, '13800000003', 1500.00, 'MACHINERY', 'Customer Charlie'),
  (4, 'David', 'Berlin', 3, '13800000004', 3000.00, 'HOUSEHOLD', 'Customer David');
  
  INSERT INTO Orders
(orderkey, custkey, orderstatus, totalprice, orderdate,
 orderpriority, clerk, shippriority, comment)
VALUES
(1001, 1, 'O', 500.00, '2026-10-01', '1-URGENT', 'Clerk#001', 0, 'First order'),
(1002, 1, 'F', 1000.00, '2026-10-05', '2-HIGH', 'Clerk#002', 0, 'Second order'),
(1003, 2, 'O', 300.00, '2026-10-10', '3-MEDIUM', 'Clerk#003', 0, 'Third order'),
(1004, 3, 'F', 50.00, '2026-10-15', '4-NOT SPECIFIED', 'Clerk#004', 0, 'Fourth order');


INSERT INTO Lineitem
(orderkey, partkey, suppkey, linenumber, quantity,
 extendedprice, discount, tax, returnflag, linestatus,
 shipdate, commitdate, receiptdate, shipinstruct, shipmode, comment)
VALUES
(1001, 1, 1, 1, 1.00, 500.00, 0.05, 0.08, 'N', 'O',
 '2026-10-02', '2026-10-03', '2026-10-04', 'DELIVER IN PERSON', 'AIR', 'First item'),

(1002, 1, 2, 1, 2.00, 1000.00, 0.10, 0.08, 'N', 'F',
 '2026-10-06', '2026-10-07', '2026-10-08', 'TAKE BACK RETURN', 'SHIP', 'Second item'),

(1003, 2, 3, 1, 1.00,25.00, 0.00, 0.05, 'R', 'O',
 '2026-10-11', '2026-10-12', '2026-10-13', 'COLLECT COD', 'TRUCK', 'Third item'),

(1004, 4, 2, 1, 1.00, 300.00, 0.05, 0.08, 'N', 'F',
 '2026-10-16', '2026-10-17', '2026-10-18', 'DELIVER IN PERSON', 'AIR', 'Fourth item');


SELECT name,retailprice,supplycost 
FROM Part,PartSupp
WHERE Part.partkey=PartSupp.partkey;

INSERT INTO Region(regionkey,name ,comment ) VALUES 
(1,'Africa','Africa Region');


INSERT INTO Nation (nationkey, name, regionkey, comment) VALUES
(5, 'Brazil', 5, 'Bra nation');


INSERT INTO Region (regionkey, name, comment)
VALUES (6, 'Oceania', 'test fkey');
INSERT INTO Nation (nationkey, name, regionkey, comment)
VALUES (6, 'Australia', 6, 'test fk');
DELETE FROM Region 
WHERE regionkey=6;


INSERT INTO Part(partkey,name,mfgr,brand,type,size,container,retailprice,comment) VALUES
(6,'milk','manufB','Anchor','drinks',5,'pack',-5.00,'eatble');


INSERT INTO PartSupp
(partkey, suppkey, availqty, supplycost, comment)
VALUES
  (3,3,-1,400.00,'low inventory');
  
  UPDATE PartSupp
  SET availqty=650
  WHERE partkey=2 AND suppkey=3;
   UPDATE PartSupp
  SET availqty=850
  WHERE partkey=4 AND suppkey=2;
  
    SELECT 
    Nation.name AS nation,
    COUNT(DISTINCT Supplier.suppkey) AS totalsupply,
    COUNT(DISTINCT PartSupp.partkey) AS totalpart,
    SUM(PartSupp.availqty) AS totalavailqty,
    AVG(PartSupp.supplycost) AS cost
    FROM Nation 
    JOIN Supplier  ON  Nation.nationkey=Supplier.nationkey
    JOIN PartSupp ON Supplier.suppkey=PartSupp.suppkey
    GROUP BY Nation.name,Nation.nationkey
    HAVING SUM(PartSupp.availqty)>500;
    
    
  INSERT INTO Customer
 (custkey,name,address,nationkey,phone,acctbal,mktsegment,comment)
 VALUES 
  (5,'Catherine' ,'Xian',1,'409-9876-9889',7000.00, 'LOGISTICS','customer Catherine'),
  (6,'Tiger' ,'NewYork',4,'666-7667-3800',11800.00,'FINANCE','customer Tiger');

SELECT 
C.name,
N.name,
C.acctbal
FROM Customer C JOIN Nation N On N.nationkey=C.nationkey
 WHERE 
    C.acctbal>(
    SELECT  AVG(Ci.acctbal)
    FROM Customer Ci
    WHERE Ci.nationkey=C.nationkey 
 );
  
  
 SELECT *
 FROM Customer C
 WHERE NOT EXISTS (
 SELECT 1
 FROM Orders O
 WHERE O.custkey=C.custkey
 );
 创建 StockAlert_Log 表，包含以下字段：
• alert_id：自增主键
• partkey：零件编号（INT）
• suppkey：供应商编号（INT）
• alert_time：报警时间（TIMESTAMP，默认当前时间）
 
 CREATE TABLE StockAlert_Log(
   alert_id INT AUTO_INCREMENT,
   partkey INT,
   suppkey INT,
   alert_time TIMESTAMP,
  CONSTRAINT PK_ID PRIMARY KEY (alert_id),
  CONSTRAINT FK_partkey FOREIGN KEY(partkey)
  REFERENCES Part(partkey),
  CONSTRAINT FK_suppkey FOREIGN KEY(suppkey)
  REFERENCES Supplier(suppkey)
  );
  
DELIMITER $$
CREATE TRIGGER trg_partsupp_lowstock
AFTER UPDATE ON PartSupp
FOR EACH ROW 
BEGIN 
  IF NEW.availqty < 10 AND OLD.availqty >= 10  THEN
        INSERT INTO StockAlert_Log (partkey, suppkey)
        VALUES (NEW.partkey,NEW.suppkey);
        END IF ;
END $$
 
  
  INSERT INTO PartSupp
(partkey, suppkey, availqty, supplycost, comment)
VALUES
  (3,2,15,20.00,'low inventory');
  UPDATE PartSupp
  SET availqty=50
  WHERE partkey=1 AND suppkey=2;
  SELECT *
  FROM PartSupp;
  
  
  ALTER TABLE StockAlert_Log
  MODIFY alert_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
 
  UPDATE PartSupp
  SET availqty=5
  WHERE partkey=1 AND suppkey=2;
  
  UPDATE PartSupp
  SET availqty=12
  WHERE partkey=3 AND suppkey=2; 
  
  
 SELECT * FROM StockAlert_Log;
