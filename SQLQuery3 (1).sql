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
BasvuruID,
BeklemeSuresi
FROM Basvurular;


SELECT
TedaviAdi,
Ucret
FROM Tedaviler;

