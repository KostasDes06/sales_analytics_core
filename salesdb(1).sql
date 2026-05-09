BEGIN TRANSACTION;

DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS order_table;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS seller;
DROP TABLE IF EXISTS team;

CREATE TABLE team (
    Team_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Team_name TEXT NOT NULL,
    Players INTEGER,
    Discount_Rate REAL
);

CREATE TABLE seller (
    Seller_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Fullname TEXT NOT NULL, Address TEXT,
    Phone_Number TEXT,
    Email TEXT,
    Commission_rate REAL,
    Total_commission REAL DEFAULT 0.00
);

CREATE TABLE product (
    Product_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Product_name TEXT NOT NULL,
    Description TEXT,
    Color TEXT,
    Size TEXT,
    Price REAL NOT NULL,
    Wholesale_cost REAL,
    Stock_Quantity INTEGER DEFAULT 0
);

CREATE TABLE customer (
    Customer_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Fullname TEXT NOT NULL,
    Address TEXT,
    Phone_Number TEXT,
    Balance REAL DEFAULT 0.00,
    Email TEXT,
    Team_ID INTEGER,
    FOREIGN KEY(Team_ID) REFERENCES team(Team_ID)
);

CREATE TABLE order_table (
    Order_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Order_Date TEXT NOT NULL,
    Price REAL,
    Customer_ID INTEGER NOT NULL,
    Seller_ID INTEGER NOT NULL,
    FOREIGN KEY(Customer_ID) REFERENCES customer(Customer_ID),
    FOREIGN KEY(Seller_ID) REFERENCES seller(Seller_ID)
);

CREATE TABLE order_details (
    Order_ID INTEGER,
    Product_ID INTEGER,
    Attribute TEXT,
    PRIMARY KEY (Order_ID, Product_ID),
    FOREIGN KEY(Order_ID) REFERENCES order_table(Order_ID),
    FOREIGN KEY(Product_ID) REFERENCES product(Product_ID)
);

INSERT INTO team VALUES(1,'Red Dragons',15,0.1);
INSERT INTO team VALUES(2,'Blue Sharks',22,0.15);
INSERT INTO team VALUES(3,'Golden Eagles',12,0.05);
INSERT INTO team VALUES(4,'Silver Foxes',10,0.08);
INSERT INTO team VALUES(5,'Bronze Bears',20,0.12);
INSERT INTO team VALUES(6,'Emerald Pythons',14,0.2);

INSERT INTO seller VALUES(1,'Nikos Papadopoulos','Athens Str 5','6971234567','nikos@sales.com',0.05,500.0);
INSERT INTO seller VALUES(2,'Maria Georgiou','Thessaloniki Str 12','6989876543','maria@sales.com',0.07,1200.0);
INSERT INTO seller VALUES(3,'John Smith','London Ave 10','4412345678','john@sales.com',0.05,200.0);
INSERT INTO seller VALUES(4,'Andreas Kanavos','Corfu 1','2661012345','kanavos@ionio.gr',0.1,0.0);
INSERT INTO seller VALUES(5,'Anna Sotiroupoulou','Corfu 2','2661054321','sotirop@ionio.gr',0.1,0.0);
INSERT INTO seller VALUES(6,'Kostas Desyllas','Athens 10','6911111111','desyllas@mail.com',0.08,0.0);

INSERT INTO product VALUES(1,'T-Shirt Basic','Cotton T-Shirt','White','L',12.0,5.0,100);
INSERT INTO product VALUES(2,'Socks Pair','Wool Socks','Black','M',4.5,1.0,200);
INSERT INTO product VALUES(3,'Luxury Jacket','Leather Jacket','Black','XL',150.0,80.0,10);
INSERT INTO product VALUES(4,'Cap','Baseball Cap','Red','OneSize',8.0,3.0,50);
INSERT INTO product VALUES(5,'Basketball Spalding','Professional Ball','Orange','Size 7',85.0,40.0,50);
INSERT INTO product VALUES(6,'Nike Air Jordan','High-top Shoes','Red/Black','44',180.0,90.0,20);
INSERT INTO product VALUES(7,'Shorts NBA','Lakers Edition','Yellow','L',45.0,15.0,60);
INSERT INTO product VALUES(8,'Training Cone','Plastic Cone','Orange','Small',5.5,1.2,300);
INSERT INTO product VALUES(9,'Whistle Fox 40','Referee Whistle','Silver','Standard',12.0,3.0,100);
INSERT INTO product VALUES(10,'Wristband','Cotton Wristband','White','OneSize',4.0,0.5,500);

INSERT INTO customer VALUES(1,'Kostas Dimitriou','12 High St, Starford','6900000001',0.0,'kostas@mail.com',1);
INSERT INTO customer VALUES(2,'Eleni Ioannou','45 Port Rd, Liverpool','6900000002',0.0,'eleni@mail.com',1);
INSERT INTO customer VALUES(3,'Christos Arapis','Ermou 54, Athens','6924024915',0.0,'christos.arapis@example.com',3);
INSERT INTO customer VALUES(4,'Sofia Papadopoulos','Main St 69, Starford','6913508391',0.0,'sofia.papadopoulos@example.com',2);
INSERT INTO customer VALUES(5,'Eleni Katsaros','Ermou 65, Athens','6953598731',0.0,'eleni.katsaros@example.com',1);
INSERT INTO customer VALUES(6,'Eleni Arapis','High St 32, Athens','6913106639',0.0,'eleni.arapis@example.com',2);
INSERT INTO customer VALUES(7,'Christos Savva','Main St 80, Liverpool','6917941927',0.0,'christos.savva@example.com',2);
INSERT INTO customer VALUES(8,'Giannis Georgiou','Ermou 76, Athens','6928903580',0.0,'giannis.georgiou@example.com',4);
INSERT INTO customer VALUES(9,'Christos Metallinos','Ermou 93, Corfu','6935053121',0.0,'christos.metallinos@example.com',4);
INSERT INTO customer VALUES(10,'Nikos Metallinos','Ermou 80, Starford','6955429920',0.0,'nikos.metallinos@example.com',5);
INSERT INTO customer VALUES(11,'Anna Arapis','Main St 88, Thessaloniki','6949787404',0.0,'anna.arapis@example.com',3);
INSERT INTO customer VALUES(12,'Nikos Georgiou','Ermou 52, Corfu','6954893239',0.0,'nikos.georgiou@example.com',5);
INSERT INTO customer VALUES(13,'Sofia Georgiou','Main St 40, Athens','6913155497',0.0,'sofia.georgiou@example.com',1);
INSERT INTO customer VALUES(14,'Anna Georgiou','Main St 37, Thessaloniki','6965541926',0.0,'anna.georgiou@example.com',2);
INSERT INTO customer VALUES(15,'Maria Papadopoulos','High St 73, Thessaloniki','6988714235',0.0,'maria.papadopoulos@example.com',3);
INSERT INTO customer VALUES(16,'Anna Metallinos','Ermou 16, Corfu','6970716332',0.0,'anna.metallinos@example.com',3);
INSERT INTO customer VALUES(17,'Nikos Georgiou','High St 20, Starford','6973391785',0.0,'nikos.georgiou@example.com',4);
INSERT INTO customer VALUES(18,'Anna Katsaros','High St 87, Liverpool','6995675942',0.0,'anna.katsaros@example.com',3);
INSERT INTO customer VALUES(19,'Christos Arapis','Main St 84, Starford','6950498954',0.0,'christos.arapis@example.com',2);
INSERT INTO customer VALUES(20,'Dimitris Savva','Main St 32, Athens','6934054715',0.0,'dimitris.savva@example.com',6);
INSERT INTO customer VALUES(21,'Anna Savva','Ermou 56, Athens','6919494357',0.0,'anna.savva@example.com',6);
INSERT INTO customer VALUES(22,'Sofia Arapis','High St 21, Corfu','6942945169',0.0,'sofia.arapis@example.com',4);
INSERT INTO customer VALUES(23,'Dimitris Katsaros','Main St 91, Corfu','6925485106',0.0,'dimitris.katsaros@example.com',1);
INSERT INTO customer VALUES(24,'Christos Papadopoulos','High St 12, Athens','6941142652',0.0,'christos.papadopoulos@example.com',3);
INSERT INTO customer VALUES(25,'Giannis Katsaros','Ermou 40, Corfu','6940652844',0.0,'giannis.katsaros@example.com',4);
INSERT INTO customer VALUES(26,'Christos Katsaros','Ermou 46, Starford','6911525726',0.0,'christos.katsaros@example.com',6);
INSERT INTO customer VALUES(27,'Eleni Savva','Main St 21, Athens','6919229083',0.0,'eleni.savva@example.com',6);
INSERT INTO customer VALUES(28,'Nikos Arapis','Ermou 13, Starford','6971376262',0.0,'nikos.arapis@example.com',5);
INSERT INTO customer VALUES(29,'Anna Savva','High St 73, Athens','6934097393',0.0,'anna.savva@example.com',2);
INSERT INTO customer VALUES(30,'Sofia Savva','High St 88, Liverpool','6963340610',0.0,'sofia.savva@example.com',5);
INSERT INTO customer VALUES(31,'Nikos Georgiou','Ermou 99, Athens','6917294848',0.0,'nikos.georgiou@example.com',2);
INSERT INTO customer VALUES(32,'Giannis Papadopoulos','Main St 18, Starford','6963851115',0.0,'giannis.papadopoulos@example.com',2);
INSERT INTO customer VALUES(33,'Dimitris Georgiou','Main St 96, Starford','6957157602',0.0,'dimitris.georgiou@example.com',4);
INSERT INTO customer VALUES(34,'Nikos Savva','High St 23, Thessaloniki','6960897611',0.0,'nikos.savva@example.com',4);
INSERT INTO customer VALUES(35,'Christos Arapis','Main St 53, Starford','6952559055',0.0,'christos.arapis@example.com',6);
INSERT INTO customer VALUES(36,'Eleni Papadopoulos','High St 28, Starford','6978621136',0.0,'eleni.papadopoulos@example.com',4);
INSERT INTO customer VALUES(37,'Eleni Georgiou','Ermou 65, Starford','6924850599',0.0,'eleni.georgiou@example.com',4);
INSERT INTO customer VALUES(38,'Nikos Katsaros','Main St 61, Starford','6957269579',0.0,'nikos.katsaros@example.com',1);
INSERT INTO customer VALUES(39,'Eleni Papadopoulos','High St 41, Athens','6985321883',0.0,'eleni.papadopoulos@example.com',4);
INSERT INTO customer VALUES(40,'Christos Katsaros','Ermou 52, Athens','6925885139',0.0,'christos.katsaros@example.com',1);
INSERT INTO customer VALUES(41,'Anna Katsaros','Main St 79, Athens','6911183755',0.0,'anna.katsaros@example.com',6);
INSERT INTO customer VALUES(42,'Anna Papadopoulos','Ermou 63, Athens','6914882312',0.0,'anna.papadopoulos@example.com',5);
INSERT INTO customer VALUES(43,'Giannis Metallinos','Ermou 26, Starford','6916296405',0.0,'giannis.metallinos@example.com',5);
INSERT INTO customer VALUES(44,'Maria Arapis','Main St 60, Corfu','6938627970',0.0,'maria.arapis@example.com',6);
INSERT INTO customer VALUES(45,'Dimitris Katsaros','Main St 57, Athens','6960239691',0.0,'dimitris.katsaros@example.com',2);
INSERT INTO customer VALUES(46,'Maria Katsaros','Ermou 27, Athens','6962777161',0.0,'maria.katsaros@example.com',2);
INSERT INTO customer VALUES(47,'Sofia Metallinos','High St 23, Thessaloniki','6932195727',0.0,'sofia.metallinos@example.com',2);
INSERT INTO customer VALUES(48,'Anna Savva','High St 61, Athens','6914590599',0.0,'anna.savva@example.com',2);
INSERT INTO customer VALUES(49,'Eleni Metallinos','Main St 84, Liverpool','6915928605',0.0,'eleni.metallinos@example.com',5);
INSERT INTO customer VALUES(50,'Dimitris Katsaros','Main St 98, Liverpool','6966232567',0.0,'dimitris.katsaros@example.com',2);
INSERT INTO customer VALUES(51,'Giannis Papadopoulos','Ermou 14, Liverpool','6952305424',0.0,'giannis.papadopoulos@example.com',3);
INSERT INTO customer VALUES(52,'Maria Georgiou','High St 47, Athens','6988965235',0.0,'maria.georgiou@example.com',6);
INSERT INTO customer VALUES(53,'Dimitris Georgiou','Main St 5, Thessaloniki','6973780585',0.0,'dimitris.georgiou@example.com',4);
INSERT INTO customer VALUES(54,'Anna Georgiou','Main St 23, Thessaloniki','6947951067',0.0,'anna.georgiou@example.com',3);
INSERT INTO customer VALUES(55,'Christos Savva','Ermou 35, Corfu','6940772282',0.0,'christos.savva@example.com',6);
INSERT INTO customer VALUES(56,'Maria Georgiou','Main St 32, Athens','6966500563',0.0,'maria.georgiou@example.com',4);
INSERT INTO customer VALUES(57,'Maria Savva','High St 61, Starford','6923226332',0.0,'maria.savva@example.com',3);
INSERT INTO customer VALUES(58,'Maria Metallinos','Ermou 3, Athens','6982297816',0.0,'maria.metallinos@example.com',4);
INSERT INTO customer VALUES(59,'Christos Georgiou','Main St 99, Liverpool','6988303784',0.0,'christos.georgiou@example.com',6);
INSERT INTO customer VALUES(60,'Eleni Savva','Ermou 35, Corfu','6923571627',0.0,'eleni.savva@example.com',1);
INSERT INTO customer VALUES(61,'Christos Metallinos','Main St 95, Corfu','6981712165',0.0,'christos.metallinos@example.com',6);
INSERT INTO customer VALUES(62,'Anna Metallinos','High St 60, Corfu','6987322756',0.0,'anna.metallinos@example.com',6);
INSERT INTO customer VALUES(63,'Dimitris Papadopoulos','Ermou 11, Thessaloniki','6934054633',0.0,'dimitris.papadopoulos@example.com',6);
INSERT INTO customer VALUES(64,'Christos Georgiou','Main St 90, Starford','6929546757',0.0,'christos.georgiou@example.com',5);
INSERT INTO customer VALUES(65,'Anna Metallinos','Main St 26, Thessaloniki','6928309806',0.0,'anna.metallinos@example.com',2);
INSERT INTO customer VALUES(66,'Maria Papadopoulos','Main St 100, Athens','6962403772',0.0,'maria.papadopoulos@example.com',2);
INSERT INTO customer VALUES(67,'Nikos Katsaros','Ermou 18, Liverpool','6968913592',0.0,'nikos.katsaros@example.com',2);
INSERT INTO customer VALUES(68,'Dimitris Katsaros','Main St 97, Corfu','6914230998',0.0,'dimitris.katsaros@example.com',3);
INSERT INTO customer VALUES(69,'Giannis Georgiou','Ermou 18, Starford','6952160915',0.0,'giannis.georgiou@example.com',5);
INSERT INTO customer VALUES(70,'Maria Georgiou','Main St 77, Liverpool','6991921153',0.0,'maria.georgiou@example.com',2);
INSERT INTO customer VALUES(71,'Dimitris Papadopoulos','Main St 99, Starford','6959277796',0.0,'dimitris.papadopoulos@example.com',5);
INSERT INTO customer VALUES(72,'Christos Arapis','Main St 88, Athens','6970409508',0.0,'christos.arapis@example.com',5);
INSERT INTO customer VALUES(73,'Christos Arapis','High St 69, Starford','6949172597',0.0,'christos.arapis@example.com',1);
INSERT INTO customer VALUES(74,'Sofia Georgiou','Ermou 82, Athens','6962138826',0.0,'sofia.georgiou@example.com',6);
INSERT INTO customer VALUES(75,'Maria Arapis','Ermou 46, Corfu','6979665729',0.0,'maria.arapis@example.com',2);
INSERT INTO customer VALUES(76,'Eleni Georgiou','Ermou 33, Starford','6985914429',0.0,'eleni.georgiou@example.com',2);
INSERT INTO customer VALUES(77,'Giannis Arapis','Ermou 91, Liverpool','6987882532',0.0,'giannis.arapis@example.com',1);
INSERT INTO customer VALUES(78,'Eleni Georgiou','High St 21, Liverpool','6985305928',0.0,'eleni.georgiou@example.com',6);
INSERT INTO customer VALUES(79,'Dimitris Arapis','Main St 71, Thessaloniki','6965926642',0.0,'dimitris.arapis@example.com',3);
INSERT INTO customer VALUES(80,'Anna Papadopoulos','Main St 11, Liverpool','6976163299',0.0,'anna.papadopoulos@example.com',5);
INSERT INTO customer VALUES(81,'Nikos Papadopoulos','High St 56, Starford','6937855743',0.0,'nikos.papadopoulos@example.com',6);
INSERT INTO customer VALUES(82,'Sofia Georgiou','Ermou 31, Athens','6923970037',0.0,'sofia.georgiou@example.com',1);
INSERT INTO customer VALUES(83,'Eleni Metallinos','Ermou 83, Starford','6957539920',0.0,'eleni.metallinos@example.com',2);
INSERT INTO customer VALUES(84,'Christos Arapis','Main St 31, Athens','6940201650',0.0,'christos.arapis@example.com',6);
INSERT INTO customer VALUES(85,'Eleni Arapis','Ermou 89, Thessaloniki','6976031249',0.0,'eleni.arapis@example.com',3);
INSERT INTO customer VALUES(86,'Giannis Papadopoulos','Main St 66, Athens','6994321487',0.0,'giannis.papadopoulos@example.com',6);
INSERT INTO customer VALUES(87,'Christos Savva','Ermou 70, Liverpool','6968338558',0.0,'christos.savva@example.com',4);
INSERT INTO customer VALUES(88,'Anna Arapis','High St 17, Starford','6966295411',0.0,'anna.arapis@example.com',1);
INSERT INTO customer VALUES(89,'Eleni Papadopoulos','Main St 55, Liverpool','6931927151',0.0,'eleni.papadopoulos@example.com',6);
INSERT INTO customer VALUES(90,'Christos Savva','Main St 55, Thessaloniki','6982027645',0.0,'christos.savva@example.com',5);
INSERT INTO customer VALUES(91,'Giannis Savva','High St 46, Liverpool','6941735263',0.0,'giannis.savva@example.com',2);
INSERT INTO customer VALUES(92,'Eleni Georgiou','Main St 99, Thessaloniki','6967829081',0.0,'eleni.georgiou@example.com',3);
INSERT INTO customer VALUES(93,'Christos Metallinos','High St 51, Corfu','6933403300',0.0,'christos.metallinos@example.com',5);
INSERT INTO customer VALUES(94,'Dimitris Georgiou','Main St 78, Corfu','6986300071',0.0,'dimitris.georgiou@example.com',6);
INSERT INTO customer VALUES(95,'Nikos Savva','Ermou 71, Starford','6953994178',0.0,'nikos.savva@example.com',3);
INSERT INTO customer VALUES(96,'Maria Metallinos','High St 77, Starford','6935271167',0.0,'maria.metallinos@example.com',3);
INSERT INTO customer VALUES(97,'Christos Savva','High St 12, Starford','6967171159',0.0,'christos.savva@example.com',2);
INSERT INTO customer VALUES(98,'Anna Katsaros','High St 40, Corfu','6987914386',0.0,'anna.katsaros@example.com',2);
INSERT INTO customer VALUES(99,'Dimitris Papadopoulos','Ermou 40, Starford','6932352175',0.0,'dimitris.papadopoulos@example.com',5);
INSERT INTO customer VALUES(100,'Giannis Savva','Ermou 34, Corfu','6993308256',0.0,'giannis.savva@example.com',2);
INSERT INTO customer VALUES(101,'Giannis Metallinos','Main St 99, Athens','6934528457',0.0,'giannis.metallinos@example.com',6);
INSERT INTO customer VALUES(102,'Maria Metallinos','Ermou 13, Thessaloniki','6987017319',0.0,'maria.metallinos@example.com',6);
INSERT INTO customer VALUES(103,'Giannis Katsaros','High St 8, Liverpool','6999113334',0.0,'giannis.katsaros@example.com',4);
INSERT INTO customer VALUES(104,'Eleni Georgiou','High St 88, Liverpool','6997525703',0.0,'eleni.georgiou@example.com',3);
INSERT INTO customer VALUES(105,'Maria Arapis','Main St 22, Starford','6966671497',0.0,'maria.arapis@example.com',5);
INSERT INTO customer VALUES(106,'Sofia Papadopoulos','High St 100, Corfu','6923987373',0.0,'sofia.papadopoulos@example.com',3);
INSERT INTO customer VALUES(107,'Eleni Georgiou','Main St 26, Thessaloniki','6923883717',0.0,'eleni.georgiou@example.com',4);
INSERT INTO customer VALUES(108,'Christos Arapis','Ermou 83, Liverpool','6964171263',0.0,'christos.arapis@example.com',5);
INSERT INTO customer VALUES(109,'Maria Savva','Ermou 51, Corfu','6980855760',0.0,'maria.savva@example.com',6);
INSERT INTO customer VALUES(110,'Maria Arapis','Ermou 39, Corfu','6979848783',0.0,'maria.arapis@example.com',6);
INSERT INTO customer VALUES(111,'Maria Katsaros','High St 77, Liverpool','6972036416',0.0,'maria.katsaros@example.com',4);
INSERT INTO customer VALUES(112,'Christos Metallinos','High St 15, Liverpool','6962553732',0.0,'christos.metallinos@example.com',1);
INSERT INTO customer VALUES(113,'Dimitris Katsaros','Ermou 53, Liverpool','6929115270',0.0,'dimitris.katsaros@example.com',2);
INSERT INTO customer VALUES(114,'Giannis Georgiou','Ermou 11, Starford','6923149881',0.0,'giannis.georgiou@example.com',6);
INSERT INTO customer VALUES(115,'Nikos Papadopoulos','High St 6, Athens','6938191834',0.0,'nikos.papadopoulos@example.com',1);
INSERT INTO customer VALUES(116,'Christos Metallinos','Ermou 71, Athens','6998319874',0.0,'christos.metallinos@example.com',1);
INSERT INTO customer VALUES(117,'Sofia Papadopoulos','High St 61, Liverpool','6922028868',0.0,'sofia.papadopoulos@example.com',2);
INSERT INTO customer VALUES(118,'Eleni Papadopoulos','High St 46, Starford','6959815928',0.0,'eleni.papadopoulos@example.com',6);
INSERT INTO customer VALUES(119,'Nikos Savva','High St 71, Thessaloniki','6969076413',0.0,'nikos.savva@example.com',4);
INSERT INTO customer VALUES(120,'Christos Savva','High St 100, Starford','6981845207',0.0,'christos.savva@example.com',4);
INSERT INTO customer VALUES(121,'Dimitris Katsaros','Ermou 67, Corfu','6935580547',0.0,'dimitris.katsaros@example.com',5);
INSERT INTO customer VALUES(122,'Nikos Georgiou','Main St 86, Athens','6980689183',0.0,'nikos.georgiou@example.com',3);
INSERT INTO customer VALUES(123,'Maria Savva','Ermou 96, Corfu','6915041776',0.0,'maria.savva@example.com',5);
INSERT INTO customer VALUES(124,'Christos Arapis','Ermou 35, Corfu','6918669541',0.0,'christos.arapis@example.com',1);
INSERT INTO customer VALUES(125,'Dimitris Katsaros','High St 16, Athens','6929579268',0.0,'dimitris.katsaros@example.com',2);
INSERT INTO customer VALUES(126,'Christos Savva','Main St 96, Liverpool','6980773122',0.0,'christos.savva@example.com',2);
INSERT INTO customer VALUES(127,'Maria Arapis','High St 13, Thessaloniki','6981544946',0.0,'maria.arapis@example.com',1);
INSERT INTO customer VALUES(128,'Maria Metallinos','Ermou 27, Starford','6983215538',0.0,'maria.metallinos@example.com',1);
INSERT INTO customer VALUES(129,'Giannis Katsaros','Main St 44, Corfu','6994414518',0.0,'giannis.katsaros@example.com',5);
INSERT INTO customer VALUES(130,'Eleni Katsaros','Main St 69, Thessaloniki','6937821742',0.0,'eleni.katsaros@example.com',5);
INSERT INTO customer VALUES(131,'Christos Papadopoulos','Main St 28, Corfu','6916148917',0.0,'christos.papadopoulos@example.com',2);
INSERT INTO customer VALUES(132,'Anna Metallinos','Main St 81, Starford','6953213573',0.0,'anna.metallinos@example.com',4);
INSERT INTO customer VALUES(133,'Eleni Georgiou','High St 66, Thessaloniki','6975294839',0.0,'eleni.georgiou@example.com',5);
INSERT INTO customer VALUES(134,'Nikos Georgiou','Ermou 53, Starford','6927647547',0.0,'nikos.georgiou@example.com',2);
INSERT INTO customer VALUES(135,'Sofia Arapis','Ermou 65, Thessaloniki','6934341569',0.0,'sofia.arapis@example.com',1);
INSERT INTO customer VALUES(136,'Sofia Katsaros','Ermou 19, Thessaloniki','6990092258',0.0,'sofia.katsaros@example.com',5);
INSERT INTO customer VALUES(137,'Christos Arapis','High St 49, Athens','6931063201',0.0,'christos.arapis@example.com',1);
INSERT INTO customer VALUES(138,'Maria Savva','High St 97, Liverpool','6933103485',0.0,'maria.savva@example.com',5);
INSERT INTO customer VALUES(139,'Eleni Arapis','High St 24, Starford','6970261180',0.0,'eleni.arapis@example.com',2);
INSERT INTO customer VALUES(140,'Sofia Savva','Main St 15, Corfu','6955183519',0.0,'sofia.savva@example.com',2);
INSERT INTO customer VALUES(141,'Christos Savva','Main St 17, Starford','6952791351',0.0,'christos.savva@example.com',1);
INSERT INTO customer VALUES(142,'Nikos Georgiou','Ermou 48, Corfu','6943790694',0.0,'nikos.georgiou@example.com',4);
INSERT INTO customer VALUES(143,'Sofia Papadopoulos','Ermou 96, Starford','6987282495',0.0,'sofia.papadopoulos@example.com',4);
INSERT INTO customer VALUES(144,'Sofia Georgiou','Main St 81, Corfu','6983105190',0.0,'sofia.georgiou@example.com',3);
INSERT INTO customer VALUES(145,'Christos Georgiou','Main St 82, Starford','6950889666',0.0,'christos.georgiou@example.com',6);
INSERT INTO customer VALUES(146,'Christos Metallinos','High St 18, Corfu','6967354303',0.0,'christos.metallinos@example.com',6);
INSERT INTO customer VALUES(147,'Giannis Papadopoulos','Main St 74, Corfu','6980720144',0.0,'giannis.papadopoulos@example.com',5);
INSERT INTO customer VALUES(148,'Sofia Papadopoulos','Ermou 78, Corfu','6976755184',0.0,'sofia.papadopoulos@example.com',1);
INSERT INTO customer VALUES(149,'Dimitris Georgiou','High St 98, Thessaloniki','6910914207',0.0,'dimitris.georgiou@example.com',4);
INSERT INTO customer VALUES(150,'Nikos Katsaros','Main St 47, Liverpool','6994381662',0.0,'nikos.katsaros@example.com',5);
INSERT INTO customer VALUES(151,'Giannis Papadopoulos','Ermou 93, Thessaloniki','6979513808',0.0,'giannis.papadopoulos@example.com',6);
INSERT INTO customer VALUES(152,'Christos Arapis','High St 17, Liverpool','6911707796',0.0,'christos.arapis@example.com',6);

INSERT INTO order_table VALUES(1,'2023-10-05',500.0,1,2);
INSERT INTO order_table VALUES(2,'2025-04-02',22.5,35,6);
INSERT INTO order_table VALUES(3,'2025-05-17',11.0,16,1);
INSERT INTO order_table VALUES(4,'2025-08-12',16.0,39,6);
INSERT INTO order_table VALUES(5,'2025-06-12',360.0,56,5);
INSERT INTO order_table VALUES(6,'2025-09-17',4.5,49,1);
INSERT INTO order_table VALUES(7,'2025-09-20',450.0,60,3);
INSERT INTO order_table VALUES(8,'2025-08-08',13.5,145,4);
INSERT INTO order_table VALUES(9,'2025-03-24',135.0,24,4);
INSERT INTO order_table VALUES(10,'2025-10-23',16.0,75,6);
INSERT INTO order_table VALUES(11,'2025-08-05',16.0,120,4);
INSERT INTO order_table VALUES(12,'2025-03-25',600.0,66,4);
INSERT INTO order_table VALUES(13,'2025-04-23',600.0,147,4);
INSERT INTO order_table VALUES(14,'2025-06-21',18.0,118,3);
INSERT INTO order_table VALUES(15,'2025-05-16',11.0,135,5);
INSERT INTO order_table VALUES(16,'2025-09-22',48.0,79,3);
INSERT INTO order_table VALUES(17,'2025-07-23',8.0,65,3);
INSERT INTO order_table VALUES(18,'2025-06-11',255.0,47,3);
INSERT INTO order_table VALUES(19,'2025-06-13',600.0,17,5);
INSERT INTO order_table VALUES(20,'2026-01-20',24.0,103,3);
INSERT INTO order_table VALUES(21,'2026-01-05',85.0,49,4);
INSERT INTO order_table VALUES(22,'2025-08-19',22.5,95,2);
INSERT INTO order_table VALUES(23,'2025-07-06',300.0,124,2);
INSERT INTO order_table VALUES(24,'2025-08-17',150.0,59,2);
INSERT INTO order_table VALUES(25,'2025-12-10',48.0,96,6);
INSERT INTO order_table VALUES(26,'2025-08-06',11.0,104,1);
INSERT INTO order_table VALUES(27,'2025-08-07',360.0,112,2);
INSERT INTO order_table VALUES(28,'2025-07-16',180.0,78,3);
INSERT INTO order_table VALUES(29,'2025-08-05',170.0,7,1);
INSERT INTO order_table VALUES(30,'2025-03-03',425.0,133,4);
INSERT INTO order_table VALUES(31,'2025-06-29',13.5,16,1);
INSERT INTO order_table VALUES(32,'2025-12-14',225.0,46,5);
INSERT INTO order_table VALUES(33,'2025-09-21',22.0,15,3);
INSERT INTO order_table VALUES(34,'2025-04-01',13.5,60,5);
INSERT INTO order_table VALUES(35,'2025-12-27',8.0,100,4);
INSERT INTO order_table VALUES(36,'2025-11-11',24.0,127,5);
INSERT INTO order_table VALUES(37,'2025-05-18',12.0,83,5);
INSERT INTO order_table VALUES(38,'2025-06-02',90.0,16,2);
INSERT INTO order_table VALUES(39,'2025-12-10',225.0,3,1);
INSERT INTO order_table VALUES(40,'2025-12-26',13.5,31,1);
INSERT INTO order_table VALUES(41,'2025-07-28',40.0,73,2);
INSERT INTO order_table VALUES(42,'2025-02-18',24.0,72,6);
INSERT INTO order_table VALUES(43,'2025-02-19',22.5,34,6);
INSERT INTO order_table VALUES(44,'2025-06-05',255.0,75,5);
INSERT INTO order_table VALUES(45,'2025-11-04',13.5,16,6);
INSERT INTO order_table VALUES(46,'2025-08-17',360.0,95,5);
INSERT INTO order_table VALUES(47,'2025-09-04',135.0,85,3);
INSERT INTO order_table VALUES(48,'2025-08-14',540.0,30,1);
INSERT INTO order_table VALUES(49,'2025-07-03',5.5,16,5);
INSERT INTO order_table VALUES(50,'2025-08-12',45.0,36,2);
INSERT INTO order_table VALUES(51,'2026-01-06',360.0,118,1);
INSERT INTO order_table VALUES(52,'2025-06-27',27.5,31,6);
INSERT INTO order_table VALUES(53,'2025-10-31',18.0,90,5);
INSERT INTO order_table VALUES(54,'2025-11-20',16.0,115,3);
INSERT INTO order_table VALUES(55,'2026-01-13',600.0,94,3);
INSERT INTO order_table VALUES(56,'2025-05-16',9.0,53,4);
INSERT INTO order_table VALUES(57,'2025-06-20',900.0,144,5);
INSERT INTO order_table VALUES(58,'2026-01-06',60.0,93,3);
INSERT INTO order_table VALUES(59,'2025-11-11',36.0,77,1);
INSERT INTO order_table VALUES(60,'2025-12-25',720.0,45,2);
INSERT INTO order_table VALUES(61,'2025-11-03',24.0,102,5);
INSERT INTO order_table VALUES(62,'2025-12-26',135.0,82,5);
INSERT INTO order_table VALUES(63,'2025-09-13',4.0,3,2);
INSERT INTO order_table VALUES(64,'2025-09-30',300.0,95,3);
INSERT INTO order_table VALUES(65,'2025-10-04',45.0,74,1);
INSERT INTO order_table VALUES(66,'2025-06-14',18.0,67,6);
INSERT INTO order_table VALUES(67,'2025-10-09',22.0,76,4);
INSERT INTO order_table VALUES(68,'2025-06-11',300.0,56,4);
INSERT INTO order_table VALUES(69,'2025-08-30',24.0,78,5);
INSERT INTO order_table VALUES(70,'2025-09-27',300.0,41,5);
INSERT INTO order_table VALUES(71,'2025-07-08',450.0,94,1);
INSERT INTO order_table VALUES(72,'2025-07-13',135.0,75,2);
INSERT INTO order_table VALUES(73,'2025-06-03',11.0,9,6);
INSERT INTO order_table VALUES(74,'2025-05-26',12.0,5,5);
INSERT INTO order_table VALUES(75,'2025-02-23',255.0,4,1);
INSERT INTO order_table VALUES(76,'2025-02-14',12.0,111,2);
INSERT INTO order_table VALUES(77,'2025-05-02',255.0,4,6);
INSERT INTO order_table VALUES(78,'2025-03-11',18.0,7,5);
INSERT INTO order_table VALUES(79,'2025-10-28',85.0,36,2);
INSERT INTO order_table VALUES(80,'2025-08-06',13.5,39,2);
INSERT INTO order_table VALUES(81,'2025-07-27',60.0,15,4);
INSERT INTO order_table VALUES(82,'2026-01-08',340.0,141,4);
INSERT INTO order_table VALUES(83,'2026-02-04',36.0,134,4);
INSERT INTO order_table VALUES(84,'2025-11-27',48.0,141,4);
INSERT INTO order_table VALUES(85,'2025-10-17',90.0,145,3);
INSERT INTO order_table VALUES(86,'2025-10-25',425.0,20,2);
INSERT INTO order_table VALUES(87,'2025-06-18',135.0,27,1);
INSERT INTO order_table VALUES(88,'2025-11-24',24.0,84,3);
INSERT INTO order_table VALUES(89,'2025-08-24',180.0,14,2);
INSERT INTO order_table VALUES(90,'2025-04-08',750.0,14,6);
INSERT INTO order_table VALUES(91,'2026-01-26',720.0,129,6);
INSERT INTO order_table VALUES(92,'2025-10-14',450.0,1,6);
INSERT INTO order_table VALUES(93,'2025-05-09',360.0,33,3);
INSERT INTO order_table VALUES(94,'2025-11-03',60.0,81,4);
INSERT INTO order_table VALUES(95,'2025-07-25',12.0,94,3);
INSERT INTO order_table VALUES(96,'2025-08-03',720.0,16,2);
INSERT INTO order_table VALUES(97,'2025-08-05',11.0,126,2);
INSERT INTO order_table VALUES(98,'2025-11-19',16.0,118,1);
INSERT INTO order_table VALUES(99,'2026-02-13',300.0,102,5);
INSERT INTO order_table VALUES(100,'2025-07-05',18.0,26,4);
INSERT INTO order_table VALUES(101,'2025-05-04',180.0,54,3);

INSERT INTO order_details VALUES(1, 1, '2 items');
INSERT INTO order_details VALUES(1, 2, '1 pair');
INSERT INTO order_details VALUES(2, 3, '3 items');
INSERT INTO order_details VALUES(3, 1, '1 item');
INSERT INTO order_details VALUES(4, 4, '5 items');

COMMIT;