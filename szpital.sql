CREATE TABLE IF NOT EXISTS PRACOWNICY(
nr_pracownika INTEGER PRIMARY KEY,
imie TEXT NOT NULL,
nazwisko TEXT NOT NULL,
stanowisko TEXT NOT NULL,
miejscowosc TEXT NOT NULL,
kod_pocztowy INTEGER NOT NULL CHECK (typeof(kod_pocztowy) = 'integer'),
ulica TEXT NOT NULL,
nr_domu INTEGER NOT NULL CHECK (typeof(nr_domu) = 'integer'),
nr_mieszkania INTEGER NULL,
pensja REAL,
stawka_godz REAL,
CHECK (pensja>0 or stawka_godz>0)
);

CREATE TABLE IF NOT EXISTS ODDZIALY(
nr_oddzialu INTEGER PRIMARY KEY,
nazwa TEXT NOT NULL UNIQUE,
oddzialowa INTEGER NOT NULL UNIQUE,
ordynator INTEGER NOT NULL UNIQUE,
FOREIGN KEY (oddzialowa) REFERENCES PRACOWNICY(nr_pracownika) ON DELETE RESTRICT ON UPDATE CASCADE
FOREIGN KEY (ordynator) REFERENCES PRACOWNICY(nr_pracownika) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS LOZKA(
nr_lozka INTEGER PRIMARY KEY,
nr_pokoju INTEGER NOT NULL CHECK (typeof(nr_pokoju) = 'integer'),
nr_oddzialu INTEGER NOT NULL,
FOREIGN KEY (nr_oddzialu) REFERENCES ODDZIALY(nr_oddzialu) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS PACJENCI(
PESEL INTEGER PRIMARY KEY CHECK (typeof(PESEL) = 'integer'),
imie TEXT NOT NULL,
nazwisko TEXT NOT NULL,
data_urodzenia DATE NOT NULL,
miejscowosc TEXT NOT NULL,
kod_pocztowy INTEGER NOT NULL,
ulica TEXT NOT NULL,
nr_domu INTEGER NOT NULL CHECK (typeof(nr_domu) = 'integer'),
nr_mieszkania INTEGER NULL,
krewna_osoba TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS SRODKI(
nr_srodka INTEGER PRIMARY KEY,
nazwa TEXT NOT NULL UNIQUE,
koszt_jednostkowy REAL NOT NULL
);

CREATE TABLE IF NOT EXISTS CHOROBY(
nr_choroby INTEGER PRIMARY KEY,
nazwa TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS LEKARZE(
id_lekarza INTEGER PRIMARY KEY,
imie TEXT NOT NULL,
nazwisko TEXT NOT NULL,
specjalnosc TEXT NOT NULL,
nr_telefonu INTEGER UNIQUE CHECK (typeof(nr_telefonu) = 'integer')
);

CREATE TABLE IF NOT EXISTS TESTY(
nr_testu INTEGER PRIMARY KEY,
nazwa TEXT NOT NULL UNIQUE,
nr_pracownika INTEGER NOT NULL,
FOREIGN KEY (nr_pracownika) REFERENCES PRACOWNICY(nr_pracownika) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Pracownik_Oddzial(
nr_pracownika INTEGER NOT NULL,
nr_oddzialu INTEGER NOT NULL,
ilosc_godzin INTEGER NOT NULL CHECK (typeof(ilosc_godzin) = 'integer'),
FOREIGN KEY (nr_pracownika) REFERENCES PRACOWNICY(nr_pracownika) ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY (nr_oddzialu) REFERENCES ODDZIALY(nr_oddzialu) ON DELETE RESTRICT ON UPDATE CASCADE,
PRIMARY KEY (nr_pracownika, nr_oddzialu)
);

CREATE TABLE IF NOT EXISTS Pracownik_Lekarz (
nr_pracownika INTEGER NOT NULL,
id_lekarza INTEGER NOT NULL,
FOREIGN KEY (nr_pracownika) REFERENCES PRACOWNICY(nr_pracownika) ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY (id_lekarza) REFERENCES LEKARZE(id_lekarza) ON DELETE RESTRICT ON UPDATE CASCADE,
PRIMARY KEY (nr_pracownika, id_lekarza)
);

CREATE TABLE IF NOT EXISTS Lekarz_Pacjent (
id_lekarza INTEGER NOT NULL,
PESEL INTEGER NOT NULL,
data DATE NOT NULL,
godz TIME NOT NULL,
wynik TEXT NOT NULL,
nr_choroby INTEGER NOT NULL,
FOREIGN KEY (id_lekarza) REFERENCES LEKARZE(id_lekarza) ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY (PESEL) REFERENCES PACJENCI(PESEL) ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY (nr_choroby) REFERENCES CHOROBY(nr_choroby) ON DELETE RESTRICT ON UPDATE CASCADE,
PRIMARY KEY (id_lekarza, PESEL, data, godz)
);

CREATE TABLE IF NOT EXISTS Lekarz_Pacjent_Srodek (
id_lekarza INTEGER NOT NULL,
PESEL INTEGER NOT NULL,
nr_srodka INTEGER,
data DATE NOT NULL,
godz TIME NOT NULL,
ilosc INTEGER NOT NULL,
FOREIGN KEY (id_lekarza) REFERENCES LEKARZE(id_lekarza) ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY (PESEL) REFERENCES PACJENCI(PESEL) ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY (nr_srodka) REFERENCES SRODKI(nr_srodka) ON DELETE RESTRICT ON UPDATE CASCADE,
PRIMARY KEY (id_lekarza, PESEL, nr_srodka, data, godz)
);

CREATE TABLE IF NOT EXISTS Lekarz_Pacjent_Test (
id_lekarza INTEGER NOT NULL,
PESEL INTEGER NOT NULL,
nr_testu INTEGER NOT NULL,
data DATE NOT NULL,
godz TIME NOT NULL,
wynik TEXT NOT NULL,
FOREIGN KEY (id_lekarza) REFERENCES LEKARZE(id_lekarza) ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY (PESEL) REFERENCES PACJENCI(PESEL) ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY (nr_testu) REFERENCES TESTY(nr_testu) ON DELETE RESTRICT ON UPDATE CASCADE,
PRIMARY KEY (id_lekarza, PESEL, nr_testu, data, godz)
);

CREATE TABLE IF NOT EXISTS PRZYJECIA (
nr_przyjecia INTEGER PRIMARY KEY,
id_lekarza INTEGER NOT NULL,
PESEL INTEGER NOT NULL,
nr_lozka INTEGER NOT NULL,
FOREIGN KEY (id_lekarza) REFERENCES LEKARZE(id_lekarza) ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY (PESEL) REFERENCES PACJENCI(PESEL) ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY (nr_lozka) REFERENCES LOZKA(nr_lozka) ON DELETE RESTRICT ON UPDATE CASCADE
);

INSERT INTO ODDZIALY
VALUES
(1,'chirurgia',7,1),(2,'ginekologia',8,2),(3,'pediatria',9,3),(4,'urologia',10,4),
(5,'kardiologia',11,5),(6,'onkologia',12,6);


INSERT INTO PRACOWNICY
VALUES
(1,'Renata','Niechciał','ordynator','Wrocław',53124,'Szybowcowa',13,4,8900,NULL),
(2,'Milena','Trela','ordynator','Wrocław',50210,'Nowa',5,12,8000,NULL),
(3,'Magdalena','Szybka','ordynator','Wrocław',54134,'Relska',178,3,7800,NULL),
(4,'Irena','Ciężka','ordynator','Wrocław',54239,'Kopernika',5,2,7400,NULL),
(5,'Weronika','Waleska','ordynator','Wrocław',51298,'Rynek',67,3,8500,NULL),
(6,'Mikołaj','Rogalski','ordynator','Wrocław',57323,'Kolorowa',17,4,7600,NULL),

(7,'Aneta','Kalinowska','pielęgniarka oddziałowa','Wrocław',53425,'Płytka',121,4,3800,NULL),
(8,'Marzena','Gibka','pielęgniarka oddziałowa','Wrocław',50310,'Spacerowa',5,2,3900,NULL),
(9,'Diana','Wieczna','pielęgniarka oddziałowa','Wrocław',54132,'Niska',18,3,3900,NULL),
(10,'Halina','Kowalska','pielęgniarka oddziałowa','Wrocław',54239,'Hubska',5,2,3400,NULL),
(11,'Natalia','Bolańska','pielęgniarka oddziałowa','Wrocław',51298,'Nowowiejska',2,3,3700,NULL),
(12,'Ula','Jaszewska','pielęgniarka oddziałowa','Wrocław',51243,'Wenecka',17,4,3600,NULL),

(13,'Arleta','Nosek','technik','Wrocław',52123,'Kromera',11,3,NULL,16.5),
(14,'Bogdan','Nowak','technik','Wrocław',57323,'Śliczna',17,4,NULL,18.4),
(15,'Ewa','Kowalska','technik','Wrocław',57123,'Zamkowa',34,31,NULL,17.7),
(16,'Janek','Lisek','technik','Wrocław',57123,'Parkowa',2,32,2500,NULL),
(17,'Ewa','Nosowska','technik','Wrocław',53324,'Tęczowa',13,4,NULL,12),
(18,'Milena','Trela','technik','Wrocław',50210,'Chrzanowa',5,12,NULL,11),

(19,'Tomasz','Nowak','lekarz','Wrocław',54134,'Fajna',178,3,3700,NULL),
(20,'Cezary','Ciężki','lekarz','Wrocław',54239,'Lipna',5,2,3400,NULL),
(21,'Aleksandra','Gąska','lekarz','Wrocław',51298,'Parkowa',67,3,3500,NULL),
(22,'Mikołaj','Górski','lekarz','Wrocław',57323,'Aktorska',17,4,3600,NULL),
(23,'Nina','Kochanowska','lekarz','Wrocław',52123,'Hubska',11,3,3850,NULL),
(24,'Bogdan','Pająk','lekarz','Wrocław',57323,'Śliczna',17,4,NULL,25),

(25,'Ewa','Nowak','pielęgniarka','Wrocław',57123,'Rynek',34,31,2750,NULL),
(26,'Daria','Szewska','pielęgniarka','Wrocław',57123,'Katedralna',2,32,3100,NULL),
(27,'Kazimiera','Biedna','pielęgniarka','Wrocław',57123,'Bema',34,31,2750,NULL),
(28,'Danuta','Seska','pielęgniarka','Wrocław',57123,'Mickiewicza',2,32,3100,NULL),
(29,'Eliza','Lipowska','pielęgniarka','Wrocław',57123,'Sienkiewicza',34,31,NULL,19),
(30,'Sonia','Lisek','pielęgniarka','Wrocław',57123,'Parkowa',2,32,NULL,18.5);

INSERT INTO LOZKA
VALUES
(8100,1,1),(8101,1,1),(8102,2,1),(8103,2,1),
(8104,3,1),(8105,3,1),(8106,4,1),(8107,4,1),
(8108,5,1),(8109,5,1),(8110,6,1),(8111,6,1),
(8112,7,1),(8113,7,1),(8114,8,1),(8115,8,1),

(8200,9,2),(8201,9,2),(8202,10,2),(8203,10,2),
(8204,11,2),(8205,11,2),(8206,12,2),(8207,12,2),
(8208,13,2),(8209,13,2),(8210,14,2),(8211,14,2),

(8300,15,3),(8301,15,3),(8302,16,3),(8303,16,3),
(8304,17,3),(8305,17,3),(8306,18,3),(8307,18,3),
(8308,19,3),(8309,19,3),(8310,20,3),(8311,20,3),

(8400,21,4),(8401,21,4),(8402,22,4),(8403,22,4),
(8404,23,1),(8405,23,4),(8406,24,4),(8407,25,4),

(8500,26,5),(8501,26,5),(8502,27,5),(8503,27,5),
(8504,28,5),(8505,28,5),(8506,29,5),(8507,29,5),
(8508,30,5),(8509,30,5),(8510,31,5),(8511,31,5),

(8600,32,6),(8601,32,6),(8602,33,6),(8603,33,6),
(8604,34,6),(8605,34,6),(8606,35,6),(8607,35,6);



INSERT INTO PACJENCI
VALUES
(91021206565,'Alicja','Konieczko',date('1991-02-12'),'Wrocław',52342,'Sportowa',2,3,'Tomek Konieczko'),
(92051406153,'Dorota','Michalak',date('1992-05-14'),'Wrocław',51842,'Piękna',12,NULL,'Czarek Matusiak'),
(72021206561,'Paweł','Rychło',date('1972-02-12'),'Wrocław',53042,'Kochanowskiego',22,11,'Anita Rawińska'),
(85032605814,'Urszula','Nijaka',date('1985-03-26'),'Wrocław',53042,'Szewska',23,1,'Anita Nosek'),

(92022206565,'Mateusz','Synowicz',date('1992-02-22'),'Wrocław',52312,'Górska',2,3,'Mikołaj Kowalski'),
(82051606343,'Frania','Kalinowska',date('1982-05-16'),'Wrocław',51442,'Rzeczna',12,NULL,'Hubert Nowak'),
(62041206231,'Maciej','Howski',date('1962-04-12'),'Wrocław',53032,'Skłodowskiej',22,11,'Alina Trela'),
(98032605124,'Sebastian','Rowski',date('1978-03-26'),'Wrocław',51042,'Mickiewicza',22,11,'Monika Szymańska'),

(80021206567,'Teresa','Nowak',date('1980-02-12'),'Wrocław',52212,'Szybka',2,3,'Bartek Górski'),
(87051406177,'Anastazja','Kochanwoska',date('1987-05-14'),'Wrocław',51242,'Kromera',12,32,'Marcin Welska'),
(82072206560,'Danuta','Szyszka',date('1982-07-22'),'Wrocław',51044,'Bema',1,11,'Zygmunt Wesoły'),
(95092102394,'Damian','Kiszka',date('1995-09-21'),'Wrocław',54043,'Rynek',7,7,'Aneta Nikowska'),

(93121206563,'Wera','Ogórek',date('1993-12-12'),'Wrocław',51342,'Lipowa',2,1,'Feliks Lewicka'),
(78081706156,'Irena','Salemska',date('1978-08-17'),'Wrocław',57242,'Piękna',12,NULL,'Robert Poniatowski'),
(74021202661,'Grzegorz','Rybacki',date('1974-02-12'),'Wrocław',53212,'Parkowa',22,11,'Genek Leonik'),
(85112605813,'Anna','Grześkowiak',date('1985-11-26'),'Wrocław',51012,'Spacerowa',2,11,'Wojciech Dętka'),

(95122204233,'Jolanta','Salon',date('1995-12-22'),'Wrocław',52342,'Kasztanowa',2,14,'Henryk Salon'),
(99051206121,'Tadeusz','Nowczak',date('1999-05-12'),'Wrocław',57712,'Nowa',13,32,'Anna Nowczak'),
(84022201261,'Beata','Serdeczna',date('1984-02-22'),'Wrocław',53332,'Targowa',12,11,'Dariusz Hanke'),
(81110705834,'Oliwia','Tyszka',date('1981-11-07'),'Wrocław',53012,'Grunwaldzka',31,11,'Urszula Antowska'),

(94120406163,'Nina','Susek',date('1994-12-04'),'Wrocław',51342,'Piramowicza',2,3,'Franek Tyszkiewcz'),
(72041703156,'Patrycja','Morawiecka',date('1972-04-17'),'Wrocław',57742,'Ryska',4,NULL,'Tomasz Jasny'),
(77031202661,'Ryszard','Tczewski',date('1977-03-12'),'Wrocław',53122,'Niska',5,2,'Piotr Ciemny'),
(75112625833,'Katarzyna','Nikoś',date('1975-11-26'),'Wrocław',53022,'Kiczowa',16,NULL,'Aneta Nowak'),

(93111206123,'Fabian','Rawski',date('1993-11-12'),'Wrocław',51342,'Niebiańska',2,32,'Alicja Kowalska'),
(88080706156,'Nataniel','Opocki',date('1988-08-07'),'Wrocław',57122,'Słoneczna',4,NULL,'Danuta Poniatowska'),
(94092212621,'Kamil','Jankowski',date('1994-09-22'),'Wrocław',53123,'Deszczowa',2,13,'Halina Rewska'),
(95110625813,'Eliza','Tysiewska',date('1995-11-06'),'Wrocław',53011,'Bagienna',3,NULL,'Mateusz Pyszkiewicz');


INSERT INTO LEKARZE
VALUES
(95001,'Irena','Ciężka','urolog',984752236),
(95002,'Weronika','Waleska','kardiolog',542362154),
(95003,'Mikołaj','Rogalski','onkolog',632541254),
(95004,'Antek','Młotek','ogólny',874621546),
(95005,'Tomasz','Nowak','kardiolog',895632145),
(95006,'Cezary','Ciężki','chirurg',896245751),
(95007,'Aleksandra','Gąska','ginekolog',326751245),
(95008,'Nina','Kochanowska','pediatra',987456321),
(95009,'Bogdan','Pająk','ogólny',123456852),
(95010,'John','Samuel','ginekolog',896512451);


INSERT INTO CHOROBY
VALUES
(1000,'nieokreślona'),
(1001,'cukrzyca'),
(1002,'anemia'),
(1003,'nadciśnienie'),
(1004,'białaczka'),
(1005,'gruźlica'),
(1006,'ospa'),
(1007,'zapalenie wyrostka robaczkowego');

INSERT INTO SRODKI
VALUES
(2001,'apap',0.5),
(2002,'ketonal',1.2),
(2003,'plaster',0.3),
(2004,'IPP',1.4),
(2005,'Kardiolek',3.2),
(2006,'Gaza',0.6),
(2007,'Cetol-2',2.6);

INSERT INTO TESTY
VALUES
(3001,'morfologia',14),
(3002,'tomograf',18),
(3003,'wymaz',15),
(3004,'badanie moczu',16),
(3005,'USG',13),
(3006,'ECHO serca',17);


INSERT INTO Lekarz_Pacjent
VALUES
(95004,91021206565,date('2019-01-10'),'12:00','przyjecie na oddzial',1007),
(95004,92051406153,date('2019-01-10'),'12:30','przyjecie na oddzial',1007),
(95001,72021206561,date('2019-01-10'),'13:00','skierowany na badania',1000),
(95002,85032605814,date('2019-01-10'),'13:30','przyjecie na oddzial',1003),
(95002,92022206565,date('2019-01-10'),'14:00','przyjecie na oddzial',1003),
(95008,82051606343,date('2019-01-10'),'14:30','leczenie ambulatoryjne',1001),

(95003,62041206231,date('2019-01-11'),'12:00','przyjecie na oddzial',1004),
(95003,98032605124,date('2019-01-11'),'12:30','skierowany na badania',1000),
(95010,82051606343,date('2019-01-11'),'13:00','przyjecie na oddzial',1007),
(95010,80021206567,date('2019-01-11'),'13:30','wizyta kontrolna OK',1000),
(95004,93121206563,date('2019-01-11'),'14:00','przyjecie na oddzial',1001),
(95004,78081706156,date('2019-01-11'),'14:30','leczenie ambulatoryjne',1001),

(95005,98032605124,date('2019-01-12'),'12:00','przyjecie na oddzial',1006),
(95006,72021206561,date('2019-01-12'),'12:30','przyjecie na oddzial',1007),
(95006,80021206567,date('2019-01-12'),'13:00','przyjecie na oddzial',1007),
(95006,87051406177,date('2019-01-12'),'13:30','przyjecie na oddzial',1007),
(95007,82072206560,date('2019-01-12'),'14:00','skierowany na badania',1002),
(95007,85112605813,date('2019-01-12'),'14:30','leczenie ambulatoryjne',1001),

(95008,95122204233,date('2019-01-13'),'12:00','przyjecie na oddzial',1007),
(95008,99051206121,date('2019-01-13'),'12:30','skierowany na badania',1002),
(95009,84022201261,date('2019-01-13'),'13:00','skierowany na badania',1003),
(95009,78081706156,date('2019-01-13'),'13:30','leczenie ambulatoryjne',1001),
(950010,81110705834,date('2019-01-13'),'14:00','przyjecie na oddzial',1002),
(950010,94120406163,date('2019-01-13'),'14:30','przyjecie na oddzial',1002),

(95009,84022201261,date('2019-01-14'),'12:00','leczenie ambulatoryjne',1003);

INSERT INTO Lekarz_Pacjent_Srodek
VALUES
(95002,82051606343,2007,date('2019-01-10'),'15:00',2),
(95004,78081706156,2005,date('2019-01-11'),'14:30',2),
(95007,85112605813,2007,date('2019-01-12'),'15:00',1),
(95009,78081706156,2007,date('2019-01-13'),'14:00',3),
(95009,84022201261,2005,date('2019-01-14'),'12:30',2);

INSERT INTO Lekarz_Pacjent_Test
VALUES
(95003,98032605124,3001,date('2019-01-11'),'12:30','podwyższone wyniki - konieczna wizyta'),
(95001,72021206561,3001,date('2019-01-12'),'13:00','podwyższone wyniki - konieczna wizyta'),
(95007,82072206560,3001,date('2019-01-12'),'14:30','niska hemoglobina'),
(95008,99051206121,3001,date('2019-01-13'),'13:00','w normie'),
(95009,84022201261,3006,date('2019-01-13'),'13:30','w normie');

INSERT INTO PRZYJECIA
VALUES
(8001,95004,91021206565,8100),
(8002,95004,92051406153,8101),
(8003,95002,85032605814,8500),
(8004,95002,92022206565,8501),

(8005,95003,62041206231,8600),
(8006,95010,82051606343,8102),
(8007,95004,93121206563,8200),

(8008,95005,98032605124,8300),
(8009,95006,72021206561,8103),
(8010,95006,80021206567,8104),
(8011,95006,87051406177,8105),

(8012,95008,95122204233,8106),
(8013,95010,81110705834,8502),
(8014,95010,94120406163,8301);


INSERT INTO Pracownik_Oddzial
VALUES
(1,1,40),
(2,2,40),
(3,3,40),
(4,4,40),
(5,5,40),
(6,6,40),

(7,1,40),
(8,2,40),
(9,3,40),
(10,4,40),
(11,5,40),
(12,6,40),

(13,1,40),
(14,2,40),
(15,3,40),
(16,4,40),
(17,5,40),
(18,6,40),

(19,5,40),
(20,1,40),
(21,2,40),
(22,4,40),
(23,3,40),
(24,6,40),

(25,1,40),
(26,2,40),
(27,3,40),
(28,4,40),
(29,5,40),
(30,6,40);

INSERT INTO Pracownik_Lekarz
VALUES
(4,95001),
(5,95002),
(6,95003),
(19,95005),
(20,95006),
(21,95007),
(23,95008),
(24,95009);
