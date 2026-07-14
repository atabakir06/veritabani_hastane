USE AcilServisDB;

DROP TABLE IF EXISTS Tedavi_Malzeme;
DROP TABLE IF EXISTS Tedaviler;
DROP TABLE IF EXISTS Basvurular;
DROP TABLE IF EXISTS Malzemeler;
DROP TABLE IF EXISTS Hastalar;
DROP TABLE IF EXISTS Doktorlar;
DROP TABLE IF EXISTS Bolumler;



CREATE TABLE Bolumler (
    BolumID INT PRIMARY KEY IDENTITY(1,1),
    BolumAdi NVARCHAR(50)
);

CREATE TABLE Doktorlar (
    DoktorID INT PRIMARY KEY IDENTITY(1,1),
    AdSoyad NVARCHAR(100),
    BolumID INT,

    FOREIGN KEY (BolumID)
    REFERENCES Bolumler(BolumID)
);

CREATE TABLE Hastalar (
    HastaID INT PRIMARY KEY IDENTITY(1,1),
    AdSoyad NVARCHAR(100),
    Yas INT,
    Cinsiyet NVARCHAR(10)
);

CREATE TABLE Basvurular (
    BasvuruID INT PRIMARY KEY IDENTITY(1,1),
    HastaID INT,
    DoktorID INT,
    BasvuruTarihi DATETIME,
    BeklemeSuresi INT,
    KuyrukDurumu NVARCHAR(20),

    FOREIGN KEY (HastaID)
    REFERENCES Hastalar(HastaID),

    FOREIGN KEY (DoktorID)
    REFERENCES Doktorlar(DoktorID)
);

CREATE TABLE Tedaviler (
    TedaviID INT PRIMARY KEY IDENTITY(1,1),
    BasvuruID INT,
    TedaviAdi NVARCHAR(100),
    Ucret DECIMAL(10,2),

    FOREIGN KEY (BasvuruID)
    REFERENCES Basvurular(BasvuruID)
);

CREATE TABLE Malzemeler (
    MalzemeID INT PRIMARY KEY IDENTITY(1,1),
    MalzemeAdi NVARCHAR(100),
    Fiyat DECIMAL(10,2)
);


CREATE TABLE Tedavi_Malzeme (
    TedaviID INT,
    MalzemeID INT,
    Adet INT,

    PRIMARY KEY (TedaviID, MalzemeID),

    FOREIGN KEY (TedaviID)
    REFERENCES Tedaviler(TedaviID),

    FOREIGN KEY (MalzemeID)
    REFERENCES Malzemeler(MalzemeID)
);


INSERT INTO Bolumler VALUES
('Kardiyoloji'),
('Ortopedi'),
('Nöroloji');

INSERT INTO Doktorlar VALUES
('Ahmet Yılmaz',1),
('Ayşe Demir',2),
('Mehmet Kaya',3);

INSERT INTO Hastalar VALUES
('Ali Veli',25,'Erkek'),
('Zeynep Kara',30,'Kadın'),
('Fatma Ak',40,'Kadın'),
('Can Demir',50,'Erkek'),
('Merve Çelik',20,'Kadın'),
('Burak Yıldız',60,'Erkek');

INSERT INTO Basvurular VALUES
(1,1,'2026-05-12 10:00',15,'Kuyruk Var'),
(2,2,'2026-05-12 10:30',5,'Kuyruk Yok'),
(3,3,'2026-05-12 11:00',25,'Kuyruk Var'),
(4,1,'2026-05-12 11:30',10,'Kuyruk Yok'),
(5,2,'2026-05-12 12:00',35,'Kuyruk Var'),
(6,3,'2026-05-12 12:30',20,'Kuyruk Var');

INSERT INTO Tedaviler VALUES
(1,'EKG',500),
(2,'MR',2000),
(3,'Kan Testi',300),
(4,'Röntgen',700),
(5,'Serum',250),
(6,'Ameliyat',10000);

INSERT INTO Malzemeler VALUES
('Enjektör',20),
('Bandaj',15),
('Serum Seti',50),
('Eldiven',10),
('Maske',5);




INSERT INTO Tedavi_Malzeme VALUES
(1,1,2),
(2,2,1),
(3,3,4),
(4,4,2),
(5,5,3),
(6,1,5);


SELECT * FROM Hastalar;

SELECT * FROM Doktorlar;

SELECT * FROM Bolumler;

SELECT * FROM Basvurular;

SELECT * FROM Tedaviler;

SELECT * FROM Malzemeler;


SELECT
    H.AdSoyad AS Hasta,
    D.AdSoyad AS Doktor,
    B.BolumAdi,
    T.TedaviAdi,
    BA.BeklemeSuresi

FROM Basvurular BA

JOIN Hastalar H
ON BA.HastaID = H.HastaID

JOIN Doktorlar D
ON BA.DoktorID = D.DoktorID

JOIN Bolumler B
ON D.BolumID = B.BolumID

JOIN Tedaviler T
ON BA.BasvuruID = T.BasvuruID;



SELECT
    BasvuruID,
    BeklemeSuresi,

    CASE
        WHEN BeklemeSuresi > 15
        THEN 'Kuyruk Var'

        ELSE 'Kuyruk Yok'

    END AS KuyrukAnalizi

FROM Basvurular;


SELECT
AVG(BeklemeSuresi) AS OrtalamaBekleme
FROM Basvurular;


SELECT
SUM(BeklemeSuresi) AS ToplamBekleme
FROM Basvurular;


SELECT TOP 1
    H.AdSoyad,
    BA.BeklemeSuresi

FROM Basvurular BA

JOIN Hastalar H
ON BA.HastaID = H.HastaID

ORDER BY BA.BeklemeSuresi DESC;



SELECT TOP 1
    H.AdSoyad,
    BA.BeklemeSuresi

FROM Basvurular BA

JOIN Hastalar H
ON BA.HastaID = H.HastaID

ORDER BY BA.BeklemeSuresi ASC;



SELECT
    D.AdSoyad,
    COUNT(*) AS HastaSayisi

FROM Basvurular BA

JOIN Doktorlar D
ON BA.DoktorID = D.DoktorID

GROUP BY D.AdSoyad;


SELECT
    B.BolumAdi,
    COUNT(*) AS BasvuruSayisi

FROM Basvurular BA

JOIN Doktorlar D
ON BA.DoktorID = D.DoktorID

JOIN Bolumler B
ON D.BolumID = B.BolumID

GROUP BY B.BolumAdi;


SELECT
SUM(Ucret) AS ToplamTedaviMaliyeti
FROM Tedaviler;


SELECT
    (SELECT COUNT(*) FROM Hastalar) AS ToplamHasta,
    (SELECT COUNT(*) FROM Doktorlar) AS ToplamDoktor,
    (SELECT COUNT(*) FROM Bolumler) AS ToplamBolum,
    (SELECT AVG(BeklemeSuresi) FROM Basvurular) AS OrtalamaBekleme,
    (SELECT SUM(Ucret) FROM Tedaviler) AS ToplamMaliyet;
