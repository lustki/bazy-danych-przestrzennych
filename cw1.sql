-- Zadanie 2
CREATE SCHEMA ksiegowosc;

-- Zadanie 3
CREATE TABLE ksiegowosc.pracownicy (
	id_pracownika SERIAl PRIMARY KEY,
	imie VARCHAR(50) NOT NULL,
	nazwisko VARCHAR(50) NOT NULL,
	adres VARCHAR(150) NOT NULL,
	telefon VARCHAR(15)
);

CREATE TABLE ksiegowosc.godziny (
	id_godziny SERIAl PRIMARY KEY,
	data DATE NOT NULL,
	liczba_godzin INT NOT NULL,
	id_pracownika INT NOT NULL,
	FOREIGN KEY (id_pracownika) REFERENCES ksiegowosc.pracownicy(id_pracownika)
);

CREATE TABLE ksiegowosc.pensja (
	id_pensji SERIAl PRIMARY KEY,
	stanowsko VARCHAR(50) NOT NULL,
	kwota NUMERIC(10,2) NOT NULL
);

CREATE TABLE ksiegowosc.premia (
	id_premii SERIAl PRIMARY KEY,
	rodzaj VARCHAR(50) NOT NULL,
	kwota NUMERIC(10,2) NOT NULL
);

CREATE TABLE ksiegowosc.wynagrodzenie (
	id_wynagrodzenia SERIAl PRIMARY KEY,
	data DATE NOT NULL,
	id_pracownika INT NOT NULL,
	id_godziny INT NOT NULL,
	id_pensji INT NOT NULL,
	id_premii INT,
	FOREIGN KEY (id_pracownika) REFERENCES ksiegowosc.pracownicy(id_pracownika),
	FOREIGN KEY (id_godziny) REFERENCES ksiegowosc.godziny (id_godziny),
	FOREIGN KEY (id_pensji) REFERENCES ksiegowosc.pensja (id_pensji),
	FOREIGN KEY (id_premii) REFERENCES ksiegowosc.premia (id_premii)
);

-- Zadanie 4

INSERT INTO ksiegowosc.pracownicy (imie, nazwisko, adres, telefon) VALUES
('Jan', 'Kowalski', 'Warszawa, ul. Prosta 1', '123456789'),
('Anna', 'Nowak', 'Warszawa, ul. Prosta 2', '987654321'),
('Piotr', 'Wiśniewski', 'Warszawa, ul. Prosta 3', '123123123'),
('Karolina', 'Wójcik', 'Warszawa, ul. Prosta 4', '321321321'),
('Tomasz', 'Kowalczyk', 'Warszawa, ul. Prosta 5', '456456456'),
('Agnieszka', 'Kamińska', 'Warszawa, ul. Prosta 6', '789789789'),
('Marek', 'Lewandowski', 'Warszawa, ul. Prosta 7', '111222333'),
('Mateusz', 'Zieliński', 'Warszawa, ul. Prosta 8', '444555666'),
('Karol', 'Woźniak', 'Warszawa, ul. Prosta 9', '777888999'),
('Patrycja', 'Dąbrowska', 'Warszawa, ul. Prosta 10', '000111222');

INSERT INTO ksiegowosc.godziny (data, liczba_godzin, id_pracownika) VALUES
('2024-10-01', 8, 1),
('2024-10-01', 7, 2),
('2024-10-01', 6, 3),
('2024-10-02', 8, 4),
('2024-10-02', 7, 5),
('2024-10-03', 5, 6),
('2024-10-03', 9, 7),
('2024-10-04', 8, 8),
('2024-10-04', 7, 9),
('2024-10-05', 8, 10);

INSERT INTO ksiegowosc.pensja (stanowsko, kwota) VALUES
('Manager', 8000.00),
('Kierownik', 8500.00),
('Dyrektor', 10000.00),
('Asystent', 5000.00),
('Sprzedawca', 4500.00);

INSERT INTO ksiegowosc.premia (rodzaj, kwota) VALUES
('Świąteczna', 1500.00),
('Roczna', 2000.00),
('Motywacyjna', 750.00),
('Specjalna', 2500.00);

INSERT INTO ksiegowosc.wynagrodzenie (data, id_pracownika, id_godziny, id_pensji, id_premii) VALUES
('2024-10-01', 1, 1, 1, 1),
('2024-10-01', 2, 2, 2, NULL),
('2024-10-01', 3, 3, 3, NULL),
('2024-10-02', 4, 4, 4, 3),
('2024-10-02', 5, 5, 5, 4),
('2024-10-03', 6, 6, 1, 4),
('2024-10-03', 7, 7, 2, 1),
('2024-10-04', 8, 8, 3, NULL),
('2024-10-04', 9, 9, 4, 2),
('2024-10-05', 10, 10, 5, 4);

-- Zadanie 5
-- a
SELECT id_pracownika, nazwisko
FROM ksiegowosc.pracownicy;

-- b
SELECT id_pracownika
FROM ksiegowosc.wynagrodzenie AS w
JOIN ksiegowosc.pensja AS p ON p.id_pensji = w.id_pensji
WHERE p.kwota > 7000;

-- c
SELECT id_pracownika
FROM ksiegowosc.wynagrodzenie AS w
JOIN ksiegowosc.pensja AS p ON p.id_pensji = w.id_pensji
LEFT JOIN ksiegowosc.premia AS pr ON pr.id_premii = w.id_premii
WHERE p.kwota > 2000 AND pr.kwota IS NULL;

-- d
SELECT * 
FROM ksiegowosc.pracownicy
WHERE imie LIKE 'J%';

-- e
SELECT * 
FROM ksiegowosc.pracownicy
WHERE imie LIKE '%n%' AND nazwisko LIKE '%a';

-- f
SELECT p.id_pracownika, p.nazwisko, GREATEST(SUM(g.liczba_godzin)-160,0) AS nadgodziny
FROM ksiegowosc.pracownicy AS p
JOIN ksiegowosc.godziny AS g ON p.id_pracownika = g.id_pracownika
GROUP BY p.id_pracownika;

-- g
SELECT p.imie, p.nazwisko
FROM ksiegowosc.wynagrodzenie AS w
JOIN ksiegowosc.pracownicy AS p ON p.id_pracownika = w.id_pracownika
JOIN ksiegowosc.pensja AS pe ON pe.id_pensji = w.id_pensji
WHERE pe.kwota BETWEEN 1500 AND 5000;

-- h
WITH pr_godziny AS (
	SELECT g.id_pracownika, SUM(g.liczba_godzin) AS l_godzin
     FROM ksiegowosc.godziny AS g
	 GROUP BY g.id_pracownika
)
SELECT p.imie, p.nazwisko
FROM ksiegowosc.pracownicy AS p
JOIN pr_godziny AS g ON p.id_pracownika = g.id_pracownika
LEFT JOIN  ksiegowosc.wynagrodzenie AS w ON p.id_pracownika = w.id_pracownika
WHERE g.l_godzin > 160 AND w.id_premii IS NULL;

-- i
SELECT w.id_pracownika, p.kwota
FROM ksiegowosc.wynagrodzenie AS w
JOIN ksiegowosc.pensja AS p ON p.id_pensji = w.id_pensji
ORDER BY p.kwota DESC;

-- j
SELECT w.id_pracownika, p.kwota, pr.kwota
FROM ksiegowosc.wynagrodzenie AS w
JOIN ksiegowosc.pensja AS p ON p.id_pensji = w.id_pensji
JOIN ksiegowosc.premia AS pr ON pr.id_premii = w.id_premii
ORDER BY p.kwota, pr.kwota;

-- k
SELECT p.stanowsko, COUNT(p.stanowsko) AS l_pracownikow
FROM ksiegowosc.pensja AS p 
JOIN ksiegowosc.wynagrodzenie AS w ON p.id_pensji = w.id_pensji
JOIN ksiegowosc.pracownicy AS pr ON pr.id_pracownika = w.id_pracownika
GROUP BY p.stanowsko
ORDER BY l_pracownikow DESC;

-- l
SELECT p.stanowsko, AVG(p.kwota) AS mean, MIN(p.kwota) AS min ,MAX(p.kwota) AS max
FROM ksiegowosc.pensja AS p
JOIN ksiegowosc.wynagrodzenie AS w ON p.id_pensji = w.id_pensji
WHERE p.stanowsko = 'Kierownik'
GROUP BY p.stanowsko;

-- m
SELECT SUM(p.kwota)
FROM ksiegowosc.pensja AS p
JOIN ksiegowosc.wynagrodzenie AS w ON p.id_pensji = w.id_pensji;

-- n
SELECT p.stanowsko, SUM(p.kwota)
FROM ksiegowosc.pensja AS p
JOIN ksiegowosc.wynagrodzenie AS w ON p.id_pensji = w.id_pensji
GROUP BY p.stanowsko;

-- o
SELECT pe.stanowsko, SUM(p.kwota)
FROM ksiegowosc.premia AS p
JOIN ksiegowosc.wynagrodzenie AS w ON p.id_premii = w.id_premii
JOIN ksiegowosc.pensja AS pe ON pe.id_pensji = w.id_pensji
GROUP BY pe.stanowsko;