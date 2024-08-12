use master
go
if exists (
select name from master.dbo.sysdatabases
where name = N'Projekt_Bazy_Danych_2'
)
begin
drop database Projekt_Bazy_Danych_2
end
go
CREATE DATABASE Projekt_Bazy_Danych_2
ON PRIMARY
(NAME = pr_bz2_01,
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\pr_bz2_01.mdf',
SIZE = 100MB, MAXSIZE = 200MB, FILEGROWTH = 10MB)
LOG ON
(NAME = pr_bz2_001,
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\pr_bz2_001.ldf',
SIZE = 100MB, MAXSIZE = 200MB, FILEGROWTH = 10MB);
go 
select 'Utworzono [Projekt_Bazy_Danych_2]' as komunikat
go

use [Projekt_Bazy_Danych_2]
go
if OBJECT_ID(N'Pracownicy',N'U') is not null
drop table [Pracownicy];
go
drop table if exists dbo.[Pracownicy];
go


CREATE TABLE Pracownicy (

 [Id_Pracownika] int identity(1,1) not null primary key,
 [Imię] nvarchar(50) not null,
 [Nazwisko] nvarchar(50) not null,
 [Data_urodzenia] date not null,
 [Płeć] nvarchar(1) COLLATE Latin1_General_CS_AS not null CHECK ([Płeć] IN ('M', 'K')),
 [Kraj] nvarchar(60) not null,
 [Miasto] nvarchar(60) not null,
 [Adres] nvarchar(60) not null,
 [Uwagi] nvarchar(max) default '- brak -',

 [Szef] int null,
 [Rola_pracownika] int not null,

 CONSTRAINT CK_Wiek_Pracownika CHECK (Data_urodzenia <= DATEADD(year, -18, GETDATE()))

);

go

if OBJECT_ID(N'Działy',N'U') is not null
drop table Działy;
go
drop table if exists dbo.Działy;
go


CREATE TABLE Działy (

 [Id_Działu] int identity(1,1) not null primary key,
 [Nazwa_działu] nvarchar(50) not null unique,
 [Data_otwarcia] date not null,
 [Data_zamknięcia] date null,
 [Status_działu] nvarchar(15) not null check ([Status_działu] IN ('Otwarty', 'Zamknięty')),
 [Kraj] nvarchar(60) not null,
 [Miasto] nvarchar(60) not null,
 [Adres] nvarchar(60) not null,
 [Uwagi] nvarchar(max) default '- brak -',

 [Id_kierownika] int not null,

  CONSTRAINT CK_Data_zamknięcia_dzialu CHECK (Data_zamknięcia IS NULL OR Data_zamknięcia >= Data_otwarcia)

);

go

if OBJECT_ID(N'Stanowiska',N'U') is not null
drop table Stanowiska;
go
drop table if exists dbo.Stanowiska;
go


CREATE TABLE Stanowiska (

 [Id_Stanowiska] int identity(1,1) not null primary key,
 [Nazwa_stanowiska] nvarchar(70) not null unique,
 [Opis] nvarchar(max) default '- brak -'

);

go

if OBJECT_ID(N'Telefony',N'U') is not null
drop table Telefony;
go
drop table if exists dbo.Telefony;
go


CREATE TABLE Telefony (

    [Numer_telefonu] nvarchar(14) not null primary key
        CHECK (
            [Numer_telefonu] like '48 [0-9][0-9][0-9] [0-9][0-9][0-9] [0-9][0-9][0-9]'
            and len([Numer_telefonu]) = 14
        )
);

go

if OBJECT_ID(N'Klienci',N'U') is not null
drop table Klienci;
go
drop table if exists dbo.Klienci;
go


CREATE TABLE Klienci (

 [Id_Klienta] nvarchar(15) not null primary key,
 [Nazwa_firmy] nvarchar(255) unique not null,
 [Kraj] nvarchar(60) not null,
 [Miasto] nvarchar(60) not null,
 [Adres] nvarchar(60) not null,
 [Uwagi] nvarchar(max) default '- brak -'

);

go

if OBJECT_ID(N'Projekty',N'U') is not null
drop table Projekty;
go
drop table if exists dbo.Projekty;
go


CREATE TABLE Projekty (

 [Id_Projektu] int identity(1,1) not null primary key,
 [Nazwa_projektu] nvarchar(255) unique not null,
 [Cel_projektu] nvarchar(max) not null,
 [Uwagi] nvarchar(max) default '- brak -',

 [Id_klienta] nvarchar(15) not null

);

go

if OBJECT_ID(N'Zadania_Projektów',N'U') is not null
drop table Zadania_Projektów;
go
drop table if exists dbo.Zadania_Projektów;
go


CREATE TABLE Zadania_Projektów (

 [Id_Zadania] int identity(1,1) not null primary key,
 [Nazwa_zadania] nvarchar(255) unique not null,
 [Opis] nvarchar(max) default '- brak -',
 [Uwagi] nvarchar(max) default '- brak -'

);

go

if OBJECT_ID(N'Role_Pracowników',N'U') is not null
drop table Role_Pracowników;
go
drop table if exists dbo.Role_Pracowników;
go


CREATE TABLE Role_Pracowników (

 [Id_Roli] int identity(1,1) not null primary key,
 [Nazwa_roli] nvarchar(255) unique not null,
 [Opis] nvarchar(max) default '- brak -',
 [Uwagi] nvarchar(max) default '- brak -'

);

go

if OBJECT_ID(N'Pracownicy_Należą_do_Działow',N'U') is not null
drop table Pracownicy_Należą_do_Działow;
go
drop table if exists dbo.Pracownicy_Należą_do_Działow;
go


CREATE TABLE Pracownicy_Należą_do_Działow (

 [Id_Przypisania] int identity(1,1) not null primary key,
 [Data_zatrudnienia] date not null,
 [Data_zwolnienia] date null,
 [Status_pracownika] nvarchar(15) not null check ([Status_pracownika] IN ('Aktywny', 'Nieaktywny', 'Zwolniony')),

 [Id_pracownika] int not null,
 [Id_działu] int not null,

 CONSTRAINT CK_Data_zwolnienia_pracownika CHECK (Data_zwolnienia IS NULL OR Data_zwolnienia >= Data_zatrudnienia)

);

go

if OBJECT_ID(N'Pracownicy_posiadają_stanowiska',N'U') is not null
drop table Pracownicy_posiadają_stanowiska;
go
drop table if exists dbo.Pracownicy_posiadają_stanowiska;
go


CREATE TABLE Pracownicy_posiadają_stanowiska (

 [Id_Posiadania] int identity(1,1) not null primary key,

 [Id_pracownika] int not null,
 [Id_stanowiska] int not null,

 [Data_startowa] date not null,
 [Data_końcowa] date null,

 CONSTRAINT CK_Data_koncowa_posiadania_stanowiska CHECK (Data_końcowa IS NULL OR Data_końcowa >= Data_startowa)

);

go

if OBJECT_ID(N'Posiadanie_Telefonu',N'U') is not null
drop table Posiadanie_Telefonu;
go
drop table if exists dbo.Posiadanie_Telefonu;
go


CREATE TABLE Posiadanie_Telefonu (

 [Id_Posiadania] int identity(1,1) not null primary key,

 [Numer_telefonu] nvarchar(14) not null, 
 [Id_pracownika] int null, 
 [Id_działu] int null,
 [Id_klienta] nvarchar(15) null,

);

go

if OBJECT_ID(N'Działy_Wyplacają_pensję',N'U') is not null
drop table Działy_Wyplacają_pensję;
go
drop table if exists dbo.Działy_Wyplacają_pensję;
go


CREATE TABLE Działy_Wyplacają_pensję (

 [Id_Wypłaty] int identity(1,1) not null primary key,
 [Data_wypłaty] date not null,
 [Wysokość_pensji] float null check(Wysokość_pensji >= 0),

 [Id_pracownika] int not null, 
 [Id_działu] int not null

);

go

if OBJECT_ID(N'Działy_zarządzają_projektami',N'U') is not null
drop table Działy_zarządzają_projektami;
go
drop table if exists dbo.Działy_zarządzają_projektami;
go


CREATE TABLE Działy_zarządzają_projektami (

 [Id_projektu] int not null,
 [Id_działu] int not null, 

 [Liczba_godzin] int null,
 [Data_początku] date not null,
 [Data_ukończenia] date null,
 [Status_projektu] nvarchar(15) null check ([Status_projektu] IN ('W trakcie', 'Nieaktywny', 'Skonczony', 'Odrzucony')),
 [Budżet] float not null check(Budżet > 0),

 PRIMARY KEY ([Id_projektu], [Id_działu]),

 CONSTRAINT CK_Data_ukonczenia_projektu CHECK (Data_ukończenia IS NULL OR Data_ukończenia >= Data_początku)

);

go

if OBJECT_ID(N'Pracownicy_realizują_projekty',N'U') is not null
drop table Pracownicy_realizują_projekty;
go
drop table if exists dbo.Pracownicy_realizują_projekty;
go


CREATE TABLE Pracownicy_realizują_projekty (

 [Id_pracownika] int not null,
 [Id_projektu] int not null,

 [Stawka_godzinowa] float not null check(Stawka_godzinowa > 0),
 [Liczba_godzin] int null check(Liczba_godzin >= 0),

 PRIMARY KEY ([Id_pracownika], [Id_projektu])

);

go

if OBJECT_ID(N'Pracownicy_realizują_zadania',N'U') is not null
drop table Pracownicy_realizują_zadania;
go
drop table if exists dbo.Pracownicy_realizują_zadania;
go


CREATE TABLE Pracownicy_realizują_zadania (

 [Id_pracownika] int not null, 
 [Id_zadania] int not null, 

 [Data_początku] date not null,
 [Data_ukończenia] date null,
 [Status_zadania] nvarchar(15) not null check ([Status_zadania] IN ('W trakcie', 'Aktywne', 'Nieaktywne', 'Skończone', 'Odrzucone')),
 [Miejsce_realizacji] nvarchar(50) null,
 [Liczba_godzin] int not null check(Liczba_godzin > 0),

 PRIMARY KEY ([Id_pracownika], [Id_zadania]),

 CONSTRAINT CK_Data_ukonczenia_zadania CHECK (Data_ukończenia IS NULL OR Data_ukończenia >= Data_początku)

);

go

if OBJECT_ID(N'Projekty_zawierają_zadania',N'U') is not null
drop table Projekty_zawierają_zadania;
go
drop table if exists dbo.Projekty_zawierają_zadania;
go


CREATE TABLE Projekty_zawierają_zadania (

 [Id_projektu] int not null, 
 [Id_zadania] int not null, 

 [Stan_zadania] nvarchar(15) not null check ([Stan_zadania] IN ('W trakcie', 'Aktywne', 'Nieaktywne', '‘Skończone', 'Odrzucone')),

 PRIMARY KEY ([Id_projektu], [Id_zadania])

);

go

if OBJECT_ID(N'Projekty_zawierają_role',N'U') is not null
drop table Projekty_zawierają_role;
go
drop table if exists dbo.Projekty_zawierają_role;
go


CREATE TABLE Projekty_zawierają_role (

 [Id_projektu] int not null,
 [Id_roli] int not null,

 PRIMARY KEY ([Id_projektu], [Id_roli])
);

go

if OBJECT_ID(N'Zadania_zawierają_role',N'U') is not null
drop table Zadania_zawierają_role;
go
drop table if exists dbo.Zadania_zawierają_role;
go


CREATE TABLE Zadania_zawierają_role (

 [Id_zadania] int not null,
 [Id_roli] int not null,

 PRIMARY KEY ([Id_zadania], [Id_roli])

);

go

if OBJECT_ID('dbo.[FK_Szef_Pracownicy]', 'FK') is not null
alter table dbo.[Pracownicy] drop constraint FK_Szef_Pracownicy
go
alter table [Pracownicy] add constraint FK_Szef_Pracownicy FOREIGN KEY ([Szef]) REFERENCES Pracownicy([Id_Pracownika]);
go

if OBJECT_ID('dbo.[FK_Rola_Pracownicy]', 'FK') is not null
alter table dbo.[Pracownicy] drop constraint FK_Rola_Pracownicy
go
alter table [Pracownicy] add constraint FK_Rola_Pracownicy FOREIGN KEY ([Rola_pracownika]) REFERENCES Role_Pracowników([Id_Roli]);
go

if OBJECT_ID('dbo.[FK_Kierownik_Dzial]', 'FK') is not null
alter table dbo.[Działy] drop constraint FK_Kierownik_Dzial
go
alter table [Działy] add constraint FK_Kierownik_Dzial FOREIGN KEY ([Id_kierownika]) REFERENCES Pracownicy([Id_Pracownika]);
go

if OBJECT_ID('dbo.[FK_Projekt_Klient]', 'FK') is not null
alter table dbo.[Projekty] drop constraint FK_Projekt_Klient
go
alter table [Projekty] add constraint FK_Projekt_Klient FOREIGN KEY ([Id_klienta]) REFERENCES Klienci([Id_Klienta]);
go

if OBJECT_ID('dbo.[FK_Pracownik_do_Dzialu]', 'FK') is not null
alter table dbo.[Pracownicy_Należą_do_Działow] drop constraint FK_Pracownik_do_Dzialu
go
alter table [Pracownicy_Należą_do_Działow] add constraint FK_Pracownik_do_Dzialu FOREIGN KEY ([Id_pracownika]) REFERENCES Pracownicy([Id_pracownika]);
go

if OBJECT_ID('dbo.[FK_dzial_do_pracownika]', 'FK') is not null
alter table dbo.[Pracownicy_Należą_do_Działow] drop constraint FK_dzial_do_pracownika
go
alter table [Pracownicy_Należą_do_Działow] add constraint FK_dzial_do_pracownika FOREIGN KEY ([Id_działu]) REFERENCES Działy([Id_działu]);
go

if OBJECT_ID('dbo.[FK_pracownik_do_stanowiska]', 'FK') is not null
alter table dbo.[Pracownicy_posiadają_stanowiska] drop constraint FK_pracownik_do_stanowiska
go
alter table [Pracownicy_posiadają_stanowiska] add constraint FK_pracownik_do_stanowiska FOREIGN KEY ([Id_pracownika]) REFERENCES Pracownicy([Id_pracownika]);
go

if OBJECT_ID('dbo.[FK_stanowisko_do_pracownika]', 'FK') is not null
alter table dbo.[Pracownicy_posiadają_stanowiska] drop constraint FK_stanowisko_do_pracownika
go
alter table [Pracownicy_posiadają_stanowiska] add constraint FK_stanowisko_do_pracownika FOREIGN KEY ([Id_stanowiska]) REFERENCES Stanowiska([Id_stanowiska]);
go

if OBJECT_ID('dbo.[FK_numer_telefonu]', 'FK') is not null
alter table dbo.[Posiadanie_Telefonu] drop constraint FK_numer_telefonu
go
alter table [Posiadanie_Telefonu] add constraint FK_numer_telefonu FOREIGN KEY ([Numer_telefonu]) REFERENCES Telefony([Numer_telefonu]);
go

if OBJECT_ID('dbo.[FK_pracownik]', 'FK') is not null
alter table dbo.[Posiadanie_Telefonu] drop constraint FK_pracownik
go
alter table [Posiadanie_Telefonu] add constraint FK_pracownik FOREIGN KEY ([Id_pracownika]) REFERENCES Pracownicy([Id_pracownika]);
go

if OBJECT_ID('dbo.[FK_dzial]', 'FK') is not null
alter table dbo.[Posiadanie_Telefonu] drop constraint FK_dzial
go
alter table [Posiadanie_Telefonu] add constraint FK_dzial FOREIGN KEY ([Id_działu]) REFERENCES Działy([Id_działu]);
go

if OBJECT_ID('dbo.[FK_klient]', 'FK') is not null
alter table dbo.[Posiadanie_Telefonu] drop constraint FK_klient
go
alter table [Posiadanie_Telefonu] add constraint FK_klient FOREIGN KEY ([Id_klienta]) REFERENCES Klienci([Id_klienta]);
go

if OBJECT_ID('dbo.[FK_id_pracownika_wyplaty]', 'FK') is not null
alter table dbo.[Działy_Wyplacają_pensję] drop constraint FK_id_pracownika_wyplaty
go
alter table [Działy_Wyplacają_pensję] add constraint FK_id_pracownika_wyplaty FOREIGN KEY ([Id_pracownika]) REFERENCES Pracownicy([Id_pracownika]);
go

if OBJECT_ID('dbo.[FK_id_dzialu_wyplaty]', 'FK') is not null
alter table dbo.[Działy_Wyplacają_pensję] drop constraint FK_id_dzialu_wyplaty
go
alter table [Działy_Wyplacają_pensję] add constraint FK_id_dzialu_wyplaty FOREIGN KEY ([Id_działu]) REFERENCES Działy([Id_działu]);
go

if OBJECT_ID('dbo.[FK_id_projektu_zarzadzanie]', 'FK') is not null
alter table dbo.[Działy_zarządzają_projektami] drop constraint FK_id_projektu_zarzadzanie
go
alter table [Działy_zarządzają_projektami] add constraint FK_id_projektu_zarzadzanie FOREIGN KEY ([Id_projektu]) REFERENCES Projekty([Id_projektu]);
go

if OBJECT_ID('dbo.[FK_id_dzialu_zarzadzanie]', 'FK') is not null
alter table dbo.[Działy_zarządzają_projektami] drop constraint FK_id_dzialu_zarzadzanie
go
alter table [Działy_zarządzają_projektami] add constraint FK_id_dzialu_zarzadzanie FOREIGN KEY ([Id_działu]) REFERENCES Działy([Id_działu]);
go

if OBJECT_ID('dbo.[FK_id_pracownika_do_projektu]', 'FK') is not null
alter table dbo.[Pracownicy_realizują_projekty] drop constraint FK_id_pracownika_do_projektu
go
alter table [Pracownicy_realizują_projekty] add constraint FK_id_pracownika_do_projektu FOREIGN KEY ([Id_pracownika]) REFERENCES Pracownicy([Id_pracownika]);
go

if OBJECT_ID('dbo.[FK_id_projekt_do_pracownika]', 'FK') is not null
alter table dbo.[Pracownicy_realizują_projekty] drop constraint FK_id_projekt_do_pracownika
go
alter table [Pracownicy_realizują_projekty] add constraint FK_id_projekt_do_pracownika FOREIGN KEY ([Id_projektu]) REFERENCES Projekty([Id_projektu]);
go

if OBJECT_ID('dbo.[FK_id_pracownika_do_zadania]', 'FK') is not null
alter table dbo.[Pracownicy_realizują_zadania] drop constraint FK_id_pracownika_do_zadania
go
alter table [Pracownicy_realizują_zadania] add constraint FK_id_pracownika_do_zadania FOREIGN KEY ([Id_pracownika]) REFERENCES Pracownicy([Id_pracownika]);
go

if OBJECT_ID('dbo.[FK_id_zadania_do_pracownika]', 'FK') is not null
alter table dbo.[Pracownicy_realizują_zadania] drop constraint FK_id_zadania_do_pracownika
go
alter table [Pracownicy_realizują_zadania] add constraint FK_id_zadania_do_pracownika FOREIGN KEY ([Id_zadania]) REFERENCES Zadania_projektów([Id_Zadania]);
go

if OBJECT_ID('dbo.[FK_id_projektu_do_zadania]', 'FK') is not null
alter table dbo.[Projekty_zawierają_zadania] drop constraint FK_id_projektu_do_zadania
go
alter table [Projekty_zawierają_zadania] add constraint FK_id_projektu_do_zadania FOREIGN KEY ([Id_projektu]) REFERENCES Projekty([Id_projektu]);
go

if OBJECT_ID('dbo.[FK_id_zadania_do_projektu]', 'FK') is not null
alter table dbo.[Projekty_zawierają_zadania] drop constraint FK_id_zadania_do_projektu
go
alter table [Projekty_zawierają_zadania] add constraint FK_id_zadania_do_projektu FOREIGN KEY ([Id_zadania]) REFERENCES Zadania_projektów([Id_Zadania]);
go

if OBJECT_ID('dbo.[FK_id_projektu_do_roli]', 'FK') is not null
alter table dbo.[Projekty_zawierają_role] drop constraint FK_id_projektu_do_roli
go
alter table [Projekty_zawierają_role] add constraint FK_id_projektu_do_roli FOREIGN KEY ([Id_projektu]) REFERENCES Projekty([Id_projektu]);
go

if OBJECT_ID('dbo.[FK_id_roli_do_projektu]', 'FK') is not null
alter table dbo.[Projekty_zawierają_role] drop constraint FK_id_roli_do_projektu
go
alter table [Projekty_zawierają_role] add constraint FK_id_roli_do_projektu FOREIGN KEY ([Id_roli]) REFERENCES Role_pracowników([Id_roli]);
go

if OBJECT_ID('dbo.[FK_id_zadania_do_roli]', 'FK') is not null
alter table dbo.[Zadania_zawierają_role] drop constraint FK_id_zadania_do_roli
go
alter table [Zadania_zawierają_role] add constraint FK_id_zadania_do_roli FOREIGN KEY ([Id_zadania]) REFERENCES Zadania_projektów([Id_zadania]);
go

if OBJECT_ID('dbo.[FK_id_roli_do_zadania]', 'FK') is not null
alter table dbo.[Zadania_zawierają_role] drop constraint FK_id_roli_do_zadania
go
alter table [Zadania_zawierają_role] add constraint FK_id_roli_do_zadania FOREIGN KEY ([Id_roli]) REFERENCES Role_pracowników([Id_roli]);
go

-------------------------------

USE [Projekt_Bazy_Danych_2]
GO

IF EXISTS (
    SELECT * 
    FROM sys.triggers 
    WHERE name = 'status_ukonczony_prac_zad'
)
BEGIN

    DROP TRIGGER status_ukonczony_prac_zad;

END

go

CREATE TRIGGER status_ukonczony_prac_zad ON [Pracownicy_realizują_zadania]
AFTER UPDATE
AS

BEGIN 
    SET NOCOUNT ON;
    IF (UPDATE(Data_ukończenia))
    BEGIN
        UPDATE [Pracownicy_realizują_zadania]
        SET Status_zadania = 'Skończone'
        WHERE Data_ukończenia IS NOT NULL
    END

	IF (UPDATE(Data_ukończenia))
    BEGIN
        UPDATE [Pracownicy_realizują_zadania]
        SET Status_zadania = 'W trakcie'
        WHERE Data_ukończenia IS NULL and Status_zadania not like 'Odrzucone' and Status_zadania not like 'Nieaktywne' and Status_zadania not like 'Aktywne'
    END

END;


-------------------------------


IF EXISTS (
    SELECT * 
    FROM sys.triggers 
    WHERE name = 'status_ukonczony_dzial_proj'
)
BEGIN

    DROP TRIGGER status_ukonczony_dzial_proj;

END

go

CREATE TRIGGER status_ukonczony_dzial_proj ON [Działy_zarządzają_projektami]
AFTER UPDATE
AS

BEGIN 
    SET NOCOUNT ON;
    IF (UPDATE(Data_ukończenia))
    BEGIN
        UPDATE [Działy_zarządzają_projektami]
        SET Status_projektu = 'Skonczony'
        WHERE Data_ukończenia IS NOT NULL
    END

	IF (UPDATE(Data_ukończenia))
    BEGIN
        UPDATE [Działy_zarządzają_projektami]
        SET Status_projektu = 'W trakcie'
        WHERE Data_ukończenia IS NULL and Status_projektu not like 'Odrzucony' and Status_projektu not like 'Nieaktywny'
    END

END;

----------------------------------------


IF EXISTS (
    SELECT * 
    FROM sys.triggers 
    WHERE name = 'status_ukonczony_prac_dzial'
)
BEGIN

    DROP TRIGGER status_ukonczony_prac_dzial;

END

go

CREATE TRIGGER status_ukonczony_prac_dzial ON [Pracownicy_Należą_do_Działow]
AFTER UPDATE
AS

BEGIN 
    SET NOCOUNT ON;
    IF (UPDATE(Data_zwolnienia))
    BEGIN
        UPDATE [Pracownicy_Należą_do_Działow]
        SET Status_pracownika = 'Zwolniony'
        WHERE Data_zwolnienia IS NOT NULL
    END

	IF (UPDATE(Data_zwolnienia))
    BEGIN
        UPDATE [Pracownicy_Należą_do_Działow]
        SET Status_pracownika = 'Aktywny'
        WHERE Data_zwolnienia IS NULL and Status_pracownika not like 'Nieaktywny'
    END

END;

------------------------------------

IF EXISTS (
    SELECT * 
    FROM sys.triggers 
    WHERE name = 'status_ukonczony_dział'
)
BEGIN

    DROP TRIGGER status_ukonczony_dział;

END

go

CREATE TRIGGER status_ukonczony_dział ON [Działy]
AFTER UPDATE
AS

BEGIN 
    SET NOCOUNT ON;
    BEGIN
	PRINT 'Status działu został aktualizowany';
        UPDATE [Działy]
        SET Status_działu = 'Zamknięty'
        WHERE Data_zamknięcia IS NOT NULL
		UPDATE [Działy]
        SET Status_działu = 'Otwarty'
        WHERE Data_zamknięcia IS NULL
    END

END;


---------------------------------


IF EXISTS (
    SELECT * 
    FROM sys.triggers 
    WHERE name = 'status_sprawdzenie'
)
BEGIN

    DROP TRIGGER status_sprawdzenie;

END

go

CREATE TRIGGER status_sprawdzenie
ON [Pracownicy_realizują_zadania]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Projekty_zawierają_zadania
    SET Stan_zadania = 'Ukończony'
    FROM Projekty_zawierają_zadania AS p
    INNER JOIN inserted AS i ON p.Id_zadania = i.Id_zadania
    WHERE i.Status_zadania = 'Ukończony';
END;

go

------------------------------------------------------
IF EXISTS (
    SELECT * 
    FROM sys.procedures 
    WHERE name = 'Dodaj_Pracownika'
)
BEGIN

    DROP procedure Dodaj_Pracownika;

END

go

CREATE PROCEDURE Dodaj_Pracownika
    @Imię nvarchar(50),
    @Nazwisko nvarchar(50),
    @Data_urodzenia date,
    @Płeć nvarchar(1),
    @Kraj nvarchar(60),
    @Miasto nvarchar(60),
    @Adres nvarchar(60),
    @Uwagi nvarchar(max) = null,
    @Szef int,
    @Rola_pracownika int
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO Pracownicy (Imię, Nazwisko, Data_urodzenia, Płeć, Kraj, Miasto, Adres, Uwagi, Szef, Rola_pracownika)
        VALUES (@Imię, @Nazwisko, @Data_urodzenia, @Płeć, @Kraj, @Miasto, @Adres, COALESCE(@Uwagi, '- brak -'), @Szef, @Rola_pracownika);
        
        DECLARE @Id_Pracownika int;
        SET @Id_Pracownika = SCOPE_IDENTITY();

        PRINT 'Pracownik został dodany:';
        PRINT 'ID pracownika: ' + CAST(@Id_Pracownika AS nvarchar(10));
        PRINT 'Imię: ' + @Imię;
        PRINT 'Nazwisko: ' + @Nazwisko;
        PRINT 'Data urodzenia: ' + CONVERT(nvarchar(10), @Data_urodzenia, 120);
        PRINT 'Płeć: ' + @Płeć;
        PRINT 'Kraj: ' + @Kraj;
        PRINT 'Miasto: ' + @Miasto;
        PRINT 'Adres: ' + @Adres;
        PRINT 'Uwagi: ' + COALESCE(@Uwagi, '- brak -');
        PRINT 'Szef: ' + ISNULL(CAST(@Szef AS nvarchar(10)), 'Brak');
        PRINT 'Rola pracownika: ' + CAST(@Rola_pracownika AS nvarchar(10));
    END TRY
    BEGIN CATCH
        PRINT 'Wystąpił błąd podczas dodawania pracownika: ';
        PRINT ERROR_MESSAGE();
    END CATCH;
END;

go

------------------------------------------

IF EXISTS (
    SELECT * 
    FROM sys.procedures 
    WHERE name = 'Dodaj_Telefon'
)
BEGIN

    DROP procedure Dodaj_Telefon;

END

go

CREATE PROCEDURE Dodaj_Telefon
    @Numer_telefonu nvarchar(14)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO Telefony(Numer_telefonu)
        VALUES (@Numer_telefonu);

        PRINT 'Telefon został dodany:';
        PRINT 'Numer Telefonu: ' + @Numer_telefonu;
    END TRY
    BEGIN CATCH
        PRINT 'Wystąpił błąd podczas dodawania telefonu: ';
        PRINT ERROR_MESSAGE();
    END CATCH;
END;

go

------------------------------------------
IF EXISTS (
    SELECT * 
    FROM sys.procedures 
    WHERE name = 'Dodaj_Dział'
)
BEGIN

    DROP procedure Dodaj_Dział;

END

go

CREATE PROCEDURE Dodaj_Dział
    @Nazwa_działu nvarchar(50),
    @Data_otwarcia date,
    @Data_zamknięcia date = NULL,
    @Status_działu nvarchar(15),
    @Kraj nvarchar(60),
    @Miasto nvarchar(60),
    @Adres nvarchar(60),
    @Id_kierownika int,
    @Uwagi nvarchar(max) = null
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO Działy (Nazwa_działu, Data_otwarcia, Data_zamknięcia, Status_działu, Kraj, Miasto, Adres, Id_kierownika, Uwagi)
        VALUES (@Nazwa_działu, @Data_otwarcia, @Data_zamknięcia, @Status_działu, @Kraj, @Miasto, @Adres, @Id_kierownika, COALESCE(@Uwagi, '- brak -'));
        
        DECLARE @Id_Działu int;
        SET @Id_Działu = SCOPE_IDENTITY();

        PRINT 'Dział został dodany:';
        PRINT 'ID działu: ' + CAST(@Id_Działu AS nvarchar(10));
        PRINT 'Nazwa działu: ' + @Nazwa_działu;
        PRINT 'Data otwarcia: ' + CONVERT(nvarchar(10), @Data_otwarcia, 120);
        PRINT 'Data zamknięcia: ' + ISNULL(CONVERT(nvarchar(10), @Data_zamknięcia, 120), 'Brak');
        PRINT 'Status działu: ' + @Status_działu;
        PRINT 'Kraj: ' + @Kraj;
        PRINT 'Miasto: ' + @Miasto;
        PRINT 'Adres: ' + @Adres;
        PRINT 'ID kierownika: ' + CAST(@Id_kierownika AS nvarchar(10));
        PRINT 'Uwagi: ' + COALESCE(@Uwagi, '- brak -');
    END TRY
    BEGIN CATCH
        PRINT 'Wystąpił błąd podczas dodawania działu:';
        PRINT ERROR_MESSAGE();
    END CATCH;
END;

go
-------------------------------------------

IF EXISTS (
    SELECT * 
    FROM sys.procedures 
    WHERE name = 'Dodaj_Stanowisko'
)
BEGIN

    DROP procedure Dodaj_Stanowisko;

END

go

CREATE PROCEDURE Dodaj_Stanowisko
    @Nazwa_stanowiska nvarchar(max),
    @Opis nvarchar(max) = null
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Stanowiska WHERE Nazwa_stanowiska = @Nazwa_stanowiska)
        BEGIN
            PRINT 'Stanowisko o takiej nazwie już istnieje.';
            RETURN;
        END

		INSERT INTO Stanowiska (Nazwa_stanowiska, Opis)
        VALUES (@Nazwa_stanowiska, COALESCE(@Opis, '- brak -'));
        
        DECLARE @Id_Stanowiska int;
        SET @Id_Stanowiska = SCOPE_IDENTITY();

        PRINT 'Stanowisko zostało dodane:';
        PRINT 'ID stanowiska: ' + CAST(@Id_Stanowiska AS nvarchar(10));
        PRINT 'Nazwa stanowiska: ' + @Nazwa_stanowiska;
        PRINT 'Opis: ' + COALESCE(@Opis, '- brak -');
    END TRY
    BEGIN CATCH
        PRINT 'Wystąpił błąd podczas dodawania stanowiska:';
        PRINT ERROR_MESSAGE();
    END CATCH;
END;

go

-----------------------------------------------

IF EXISTS (
    SELECT * 
    FROM sys.procedures 
    WHERE name = 'Dodaj_Klienta'
)
BEGIN

    DROP procedure Dodaj_Klienta;

END

go

CREATE PROCEDURE Dodaj_Klienta
    @Id_Klienta nvarchar(15),
    @Nazwa_firmy nvarchar(255),
    @Kraj nvarchar(60),
    @Miasto nvarchar(60),
    @Adres nvarchar(60),
    @Uwagi nvarchar(max) = null
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO Klienci (Id_Klienta, Nazwa_firmy, Kraj, Miasto, Adres, Uwagi)
        VALUES (@Id_Klienta, @Nazwa_firmy, @Kraj, @Miasto, @Adres, COALESCE(@Uwagi, '- brak -'));
        
        PRINT 'Klient został dodany:';
        PRINT 'ID klienta: ' + @Id_Klienta;
        PRINT 'Nazwa firmy: ' + @Nazwa_firmy;
        PRINT 'Kraj: ' + @Kraj;
        PRINT 'Miasto: ' + @Miasto;
        PRINT 'Adres: ' + @Adres;
        PRINT 'Uwagi: ' + COALESCE(@Uwagi, '- brak -');
    END TRY
    BEGIN CATCH
        PRINT 'Wystąpił błąd podczas dodawania klienta:';
        PRINT ERROR_MESSAGE();
    END CATCH;
END;
go

--------------------------------

IF EXISTS (
    SELECT * 
    FROM sys.procedures 
    WHERE name = 'Dodaj_Projekt'
)
BEGIN

    DROP procedure Dodaj_Projekt;

END

go

CREATE PROCEDURE Dodaj_Projekt
    @Nazwa_projektu nvarchar(255),
    @Cel_projektu nvarchar(max),
    @Id_klienta nvarchar(15),
    @Uwagi nvarchar(max) = null
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO Projekty (Nazwa_projektu, Cel_projektu, Uwagi, Id_klienta)
        VALUES (@Nazwa_projektu, @Cel_projektu, COALESCE(@Uwagi, '- brak -'), @Id_klienta);
        
        DECLARE @Id_Projektu int;
        SET @Id_Projektu = SCOPE_IDENTITY();

        PRINT 'Projekt został dodany:';
        PRINT 'ID projektu: ' + CAST(@Id_Projektu AS nvarchar(10));
        PRINT 'Nazwa projektu: ' + @Nazwa_projektu;
        PRINT 'Cel projektu: ' + @Cel_projektu;
        PRINT 'Id klienta: ' + @Id_klienta;
        PRINT 'Uwagi: ' + COALESCE(@Uwagi, '- brak -');
    END TRY
    BEGIN CATCH
        PRINT 'Wystąpił błąd podczas dodawania projektu:';
        PRINT ERROR_MESSAGE();
    END CATCH;
END;
go

--------------------------------

IF EXISTS (
    SELECT * 
    FROM sys.procedures 
    WHERE name = 'Dodaj_Zadanie_Projektowe'
)
BEGIN

    DROP procedure Dodaj_Zadanie_Projektowe;

END

go

CREATE PROCEDURE Dodaj_Zadanie_Projektowe
    @Nazwa_zadania nvarchar(255),
    @Opis nvarchar(max) = null,
    @Uwagi nvarchar(max) = null
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO Zadania_Projektów (Nazwa_zadania, Opis, Uwagi)
        VALUES (@Nazwa_zadania, COALESCE(@Opis, '- brak -'), COALESCE(@Uwagi, '- brak -'));
        
        DECLARE @Id_Zadania int;
        SET @Id_Zadania = SCOPE_IDENTITY();

        PRINT 'Zadanie projektowe zostało dodane:';
        PRINT 'ID zadania: ' + CAST(@Id_Zadania AS nvarchar(10));
        PRINT 'Nazwa zadania: ' + @Nazwa_zadania;
        PRINT 'Opis: ' + COALESCE(@Opis, '- brak -');
        PRINT 'Uwagi: ' + COALESCE(@Uwagi, '- brak -');
    END TRY
    BEGIN CATCH
        PRINT 'Wystąpił błąd podczas dodawania zadania projektowego:';
        PRINT ERROR_MESSAGE();
    END CATCH;
END;
go

--------------------------------

IF EXISTS (
    SELECT * 
    FROM sys.procedures 
    WHERE name = 'Dodaj_Role_Pracownikow'
)
BEGIN

    DROP procedure Dodaj_Role_Pracownikow;

END

go

CREATE PROCEDURE Dodaj_Role_Pracownikow
    @Nazwa_roli nvarchar(255),
    @Opis nvarchar(max) = null,
    @Uwagi nvarchar(max) = null
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO Role_Pracowników (Nazwa_roli, Opis, Uwagi)
        VALUES (@Nazwa_roli, COALESCE(@Opis, '- brak -'), COALESCE(@Uwagi, '- brak -'));
        
        DECLARE @Id_Roli int;
        SET @Id_Roli = SCOPE_IDENTITY();

        PRINT 'Rola pracownika została dodana:';
        PRINT 'ID roli: ' + CAST(@Id_Roli AS nvarchar(10));
        PRINT 'Nazwa roli: ' + @Nazwa_roli;
        PRINT 'Opis: ' + COALESCE(@Opis, '- brak -');
        PRINT 'Uwagi: ' + COALESCE(@Uwagi, '- brak -');
    END TRY
    BEGIN CATCH
        PRINT 'Wystąpił błąd podczas dodawania roli pracownika:';
        PRINT ERROR_MESSAGE();
    END CATCH;
END;
go

--------------------------------------

IF EXISTS (
    SELECT * 
    FROM sys.objects 
    WHERE type_desc = 'SQL_SCALAR_FUNCTION'
    AND name = 'Wypisz_pensje_pracownika'
)
BEGIN

    DROP function Wypisz_pensje_pracownika;

END

go

CREATE FUNCTION dbo.Wypisz_pensje_pracownika
(
    @id_pracownika INT,
    @rok INT,
    @miesiac INT
)
RETURNS FLOAT
AS
BEGIN
    DECLARE @pensja FLOAT;

    SELECT @pensja = Wysokość_pensji
    FROM Działy_Wyplacają_pensję
    WHERE Id_pracownika = @id_pracownika
    AND YEAR(Data_wypłaty) = @rok
    AND MONTH(Data_wypłaty) = @miesiac;

    RETURN @pensja;
END;
go

-------------------------------------------------------

IF EXISTS (
    SELECT * 
    FROM sys.procedures 
    WHERE name = 'Wypisz_pensje_pracownika_proc'
)
BEGIN

    DROP procedure Wypisz_pensje_pracownika_proc;

END

go

CREATE PROCEDURE Wypisz_pensje_pracownika_proc
    @id_pracownika INT,
    @rok INT,
    @miesiac INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        
        IF NOT EXISTS (SELECT 1 FROM Pracownicy WHERE Id_Pracownika = @id_pracownika)
        BEGIN
            PRINT 'Pracownik o podanym id nie istnieje!';
            RETURN;
        END

        IF NOT EXISTS (
            SELECT 1 
            FROM Działy_Wyplacają_pensję 
            WHERE Id_pracownika = @id_pracownika 
            AND YEAR(Data_wypłaty) = @rok 
            AND MONTH(Data_wypłaty) = @miesiac
        )
        BEGIN
            PRINT 'Wypłaty za podany okres nie ma!';
            RETURN;
        END

        SELECT p.Id_Pracownika, 
               p.Imię + ' ' + p.Nazwisko AS Pracownik, 
               dbo.Wypisz_pensje_pracownika(@id_pracownika, @rok, @miesiac) AS Wysokosc
        FROM Pracownicy p
        WHERE p.Id_Pracownika = @id_pracownika;

    END TRY
    BEGIN CATCH
        PRINT 'Wystąpił błąd: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


-------------------------------------------------------

IF EXISTS (
    SELECT * 
    FROM sys.objects 
    WHERE type_desc = 'SQL_SCALAR_FUNCTION'
    AND name = 'Wypisz_wiek_pracownika'
)
BEGIN

    DROP function Wypisz_wiek_pracownika;

END

go

CREATE FUNCTION dbo.Wypisz_wiek_pracownika
(
    @id_pracownika INT
)
RETURNS int
AS
BEGIN
	DECLARE @wiek int;
    set @wiek = (
        select DATEDIFF(YEAR, Data_urodzenia, GETDATE()) - 
               case when DATEADD(YEAR, DATEDIFF(YEAR, Data_urodzenia, GETDATE()), Data_urodzenia) > GETDATE()
                    THEN 1 ELSE 0 END
        from Pracownicy
        where Id_Pracownika = @id_pracownika
    );

return @wiek;

END;

go

---------------------------------------------

IF EXISTS (
    SELECT * 
    FROM sys.procedures 
    WHERE name = 'Wypisz_wiek_pracownika_proc'
)
BEGIN

    DROP procedure Wypisz_wiek_pracownika_proc;

END

go

CREATE PROCEDURE Wypisz_wiek_pracownika_proc
    @id_pracownika INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        
        IF NOT EXISTS (SELECT 1 FROM Pracownicy WHERE Id_Pracownika = @id_pracownika)
        BEGIN
            PRINT 'Pracownik o podanym id nie istnieje!';
            RETURN;
        END

        SELECT p.Id_Pracownika, 
               p.Imię + ' ' + p.Nazwisko AS Pracownik, 
               dbo.Wypisz_wiek_pracownika(@id_pracownika) AS Wiek
        FROM Pracownicy p
        WHERE p.Id_Pracownika = @id_pracownika;

    END TRY
    BEGIN CATCH
        PRINT 'Wystąpił błąd: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-----------------------------------------------------------------

IF EXISTS (
    SELECT * 
    FROM sys.procedures 
    WHERE name = 'Przypisz_Stanowisko_Pracownikom'
)
BEGIN
    DROP PROCEDURE Przypisz_Stanowisko_Pracownikom;
END
GO

CREATE PROCEDURE Przypisz_Stanowisko_Pracownikom
    @Id_pracownika INT,
    @Id_stanowiska INT,
    @Data_startowa DATE,
    @Data_końcowa DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

	if CONVERT(DATE, @Data_startowa) < (select CONVERT(DATE, Data_zatrudnienia) from Pracownicy_Należą_do_Działow where Id_pracownika = @Id_pracownika)
	begin
	RAISERROR('Pracownik nie może otrzymać stanowisko przed zatrudnieniem.', 16, 1);
        RETURN;
	end 

	if exists (select 1 from Pracownicy_posiadają_stanowiska where Id_pracownika = @Id_pracownika and Id_stanowiska = @Id_stanowiska and Data_startowa = @Data_startowa)
	BEGIN
        RAISERROR('Pracownik nie może posiadać to samo stanowisko znowu w ten sam dzień.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Pracownicy WHERE Id_pracownika = @Id_pracownika)
    BEGIN
        RAISERROR('Pracownik o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Stanowiska WHERE Id_stanowiska = @Id_stanowiska)
    BEGIN
        RAISERROR('Stanowisko o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END

    INSERT INTO Pracownicy_posiadają_stanowiska (Id_pracownika, Id_stanowiska, Data_startowa, Data_końcowa)
    VALUES (@Id_pracownika, @Id_stanowiska, @Data_startowa, @Data_końcowa);

    PRINT 'Stanowisko zostało przypisane pracownikowi.';
END;
GO

----------------------------------------

IF EXISTS (
    SELECT * 
    FROM sys.procedures 
    WHERE name = 'Dodaj_pracownika_do_działu'
)
BEGIN
    DROP PROCEDURE Dodaj_pracownika_do_działu;
END
GO

CREATE PROCEDURE Dodaj_pracownika_do_działu
    @Data_zatrudnienia date,
    @Data_zwolnienia date = null,
    @Status_pracownika nvarchar(15),
    @Id_pracownika int,
	@Id_działu int
AS
BEGIN
    SET NOCOUNT ON;

	if CONVERT(DATE, @Data_zatrudnienia) < (select CONVERT(DATE, Data_otwarcia) from Działy where Id_Działu = @Id_działu)
	begin
	RAISERROR('Pracownik nie może być zatrudniony przed otwarciem działu.', 16, 1);
        RETURN;
	end 

	if CONVERT(DATE, @Data_zatrudnienia) < (select CONVERT(DATE, Data_urodzenia) from Pracownicy where Id_Pracownika = @Id_pracownika)
	begin
	RAISERROR('Pracownik nie może być zatrudniony przed jego urodzeniem.', 16, 1);
        RETURN;
	end 

	if CONVERT(DATE, @Data_zatrudnienia) > (select CONVERT(DATE, Data_zamknięcia) from Działy where Id_Działu = @Id_działu)
	begin
	RAISERROR('Pracownik nie może być zatrudniony po zamknięciu działu.', 16, 1);
        RETURN;
	end 

    IF NOT EXISTS (SELECT 1 FROM Pracownicy WHERE Id_pracownika = @Id_pracownika)
    BEGIN
        RAISERROR('Pracownik o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Działy WHERE Id_Działu = @Id_działu)
    BEGIN
        RAISERROR('Dzial o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END

	IF EXISTS (SELECT 1 FROM Pracownicy_Należą_do_Działow WHERE Id_pracownika = @Id_pracownika AND Id_działu = @Id_działu)
    BEGIN
        RAISERROR('Pracownik jest już przypisany do tego działu.', 16, 1);
        RETURN;
    END

    INSERT INTO Pracownicy_Należą_do_Działow (Id_pracownika, Id_działu, Data_zatrudnienia, Data_zwolnienia, Status_pracownika)
    VALUES (@Id_pracownika, @Id_działu, @Data_zatrudnienia, @Data_zwolnienia, @Status_pracownika);

    PRINT 'Pracownik został dodany do działu.';
END;
GO

---------------------------------------------

IF EXISTS (
    SELECT * 
    FROM sys.procedures 
    WHERE name = 'Przypisz_telefon'
)
BEGIN
    DROP PROCEDURE Przypisz_telefon;
END
GO

CREATE PROCEDURE Przypisz_telefon

    @Numer_telefonu nvarchar(14),
    @Id_pracownika int = null,
    @Id_klienta nvarchar(15) = null,
	@Id_działu int = null

AS
BEGIN
    SET NOCOUNT ON;

	IF NOT EXISTS (SELECT 1 FROM Telefony WHERE Numer_telefonu = @Numer_telefonu)
    BEGIN
        RAISERROR('Takiego telefonu nie ma w tabeli Telefony.', 16, 1);
        RETURN;
    END

	IF EXISTS (SELECT 1 FROM Posiadanie_Telefonu WHERE Numer_telefonu = @Numer_telefonu)
    BEGIN
        RAISERROR('Ten numer telefonu jest już przypisany.', 16, 1);
        RETURN;
    END

    IF @Id_pracownika is not null and NOT EXISTS (SELECT 1 FROM Pracownicy WHERE Id_pracownika = @Id_pracownika)
    BEGIN
        RAISERROR('Pracownik o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END

    IF @Id_działu is not null and NOT EXISTS (SELECT 1 FROM Działy WHERE Id_Działu = @Id_działu)
    BEGIN
        RAISERROR('Dzial o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END

	IF  @Id_klienta is not null and NOT EXISTS (SELECT 1 FROM Klienci WHERE Id_Klienta = @Id_klienta)
    BEGIN
        RAISERROR('Klient o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END

    INSERT INTO Posiadanie_Telefonu (Numer_telefonu, Id_pracownika, Id_działu, Id_klienta)
    VALUES (@Numer_telefonu, @Id_pracownika, @Id_działu, @Id_klienta);

    PRINT 'Numer telefonu został przypisany.';
END;
GO

--------------------------------------------------------------------------

IF EXISTS (
    SELECT * 
    FROM sys.procedures 
    WHERE name = 'Wypisz_telefony_pracowników'
)
BEGIN
    DROP PROCEDURE Wypisz_telefony_pracowników;
END
GO

CREATE PROCEDURE Wypisz_telefony_pracowników
AS
BEGIN
    SET NOCOUNT ON;

    select p.Id_Pracownika, p.Imię, p.Nazwisko, tel.Numer_telefonu
	from Pracownicy p, Posiadanie_Telefonu tel
	where p.Id_Pracownika = tel.Id_pracownika and tel.Id_pracownika is not null

END;
GO

-----------------------------------------------------------------------------

IF EXISTS (
    SELECT * 
    FROM sys.procedures 
    WHERE name = 'Wypisz_telefony_działów'
)
BEGIN
    DROP PROCEDURE Wypisz_telefony_działów;
END
GO

CREATE PROCEDURE Wypisz_telefony_działów
AS
BEGIN
    SET NOCOUNT ON;

    select d.Id_Działu, d.Nazwa_działu, tel.Numer_telefonu
	from Działy d, Posiadanie_Telefonu tel
	where d.Id_Działu = tel.Id_działu and tel.Id_działu is not null

END;
GO

-----------------------------------------------------------------------------

IF EXISTS (
    SELECT * 
    FROM sys.procedures 
    WHERE name = 'Wypisz_telefony_klientów'
)
BEGIN
    DROP PROCEDURE Wypisz_telefony_klientów;
END
GO

CREATE PROCEDURE Wypisz_telefony_klientów
AS
BEGIN
    SET NOCOUNT ON;

    select k.Id_Klienta, k.Nazwa_firmy, tel.Numer_telefonu
	from Klienci k, Posiadanie_Telefonu tel
	where k.Id_Klienta = tel.Id_klienta and tel.Id_klienta is not null

END;
GO

------------------------------------------------------------------------

IF EXISTS (
    SELECT * 
    FROM sys.procedures 
    WHERE name = 'Pracownicy_przypisani_do_działu'
)
BEGIN
    DROP PROCEDURE Pracownicy_przypisani_do_działu;
END
GO

CREATE PROCEDURE Pracownicy_przypisani_do_działu
    @Id_działu INT
AS
BEGIN
    SET NOCOUNT ON;

	select pd.Id_Pracownika, p.Imię, p.Nazwisko, pd.Id_działu, d.Nazwa_działu
	from Pracownicy p, Pracownicy_Należą_do_Działow pd, Działy d
	where p.Id_Pracownika = pd.Id_pracownika and d.Id_Działu = pd.Id_działu and pd.Id_działu = @Id_działu
   
END;
GO

-----------------------------------------------------------

IF EXISTS (
    SELECT * 
    FROM sys.procedures 
    WHERE name = 'Dodaj_zadanie_do_projektu'
)
BEGIN
    DROP PROCEDURE Dodaj_zadanie_do_projektu;
END
GO

CREATE PROCEDURE Dodaj_zadanie_do_projektu
   @Id_projektu int,
   @Id_zadania int,
   @Stan_zadania nvarchar(15)
AS
BEGIN
    SET NOCOUNT ON;

	IF EXISTS (SELECT 1 FROM Projekty_zawierają_zadania WHERE Id_Projektu = @Id_projektu and Id_zadania = @Id_zadania)
    BEGIN
        RAISERROR('To zadanie juz przypisane do tego projektu.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Projekty WHERE Id_Projektu = @Id_projektu)
    BEGIN
        RAISERROR('Projekt o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Zadania_Projektów WHERE Id_Zadania = @Id_zadania)
    BEGIN
        RAISERROR('Zadanie o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END

    INSERT INTO Projekty_zawierają_zadania (Id_projektu, Id_zadania, Stan_zadania)
    VALUES (@Id_projektu, @Id_zadania, @Stan_zadania);

    PRINT 'Zadanie zostało dodane do projektu.';
END;
GO

--------------------------------------------------------------

IF EXISTS (
    SELECT * 
    FROM sys.procedures 
    WHERE name = 'Zadania_przypisane_do_projektu'
)
BEGIN
    DROP PROCEDURE Zadania_przypisane_do_projektu;
END
GO

CREATE PROCEDURE Zadania_przypisane_do_projektu
    @Id_projektu INT
AS
BEGIN
    SET NOCOUNT ON;

	select pzd.Id_projektu, p.Nazwa_projektu, pzd.Id_zadania, zp.Nazwa_zadania
	from Projekty p, Zadania_Projektów zp, Projekty_zawierają_zadania pzd
	where p.Id_Projektu = pzd.Id_projektu and zp.Id_Zadania = pzd.Id_zadania and pzd.Id_projektu = @Id_projektu
   
END;
GO

--------------------------------------------------------------

IF EXISTS (
    SELECT * 
    FROM sys.procedures 
    WHERE name = 'Przypisz_projekt_do_działu'
)
BEGIN
    DROP PROCEDURE Przypisz_projekt_do_działu;
END
GO

CREATE PROCEDURE Przypisz_projekt_do_działu
   @Id_projektu int,
   @Id_działu int,
   @Liczba_godzin int = null,
   @Data_początku date,
   @Data_ukończenia date = null,
   @Status_projektu nvarchar(15),
   @Budżet float
AS
BEGIN
    SET NOCOUNT ON;

	if CONVERT(DATE, @Data_początku) < (select CONVERT(DATE, Data_otwarcia) from Działy where Id_Działu = @Id_działu)
	begin
	RAISERROR('Projekt nie może zostać uruchomiony przed otwarciem działu', 16, 1);
        RETURN;
	end 

	if CONVERT(DATE, @Data_początku) > CONVERT(DATE, getdate()) 
	begin
	RAISERROR('Projekt nie może zostać uruchomiony po dzisiejszym dniu.', 16, 1);
        RETURN;
	end 

    IF NOT EXISTS (SELECT 1 FROM Projekty WHERE Id_Projektu = @Id_projektu)
    BEGIN
        RAISERROR('Projekt o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Działy WHERE Id_Działu = @Id_działu)
    BEGIN
        RAISERROR('Dział o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END


	IF EXISTS (SELECT 1 FROM Działy_zarządzają_projektami WHERE Id_działu = @Id_działu AND Id_projektu = @Id_projektu)
    BEGIN
        RAISERROR('Ten projekt już jest zarzadzany przez swoj dział.', 16, 1);
        RETURN;
    END

    INSERT INTO Działy_zarządzają_projektami (Id_projektu, Id_działu, Liczba_godzin, Data_początku, Data_ukończenia, Status_projektu, Budżet)
    VALUES (@Id_projektu, @Id_działu, @Liczba_godzin, @Data_początku, @Data_ukończenia, @Status_projektu, @Budżet);

    PRINT 'Projekt został przypisany do działu.';
END;
GO

-----------------------------------------------------------------------

IF EXISTS (
    SELECT * 
    FROM sys.procedures 
    WHERE name = 'Projekty_przypisane_do_działów'
)
BEGIN
    DROP PROCEDURE Projekty_przypisane_do_działów;
END
GO

CREATE PROCEDURE Projekty_przypisane_do_działów
    @Id_działu INT
AS
BEGIN
    SET NOCOUNT ON;

	select dzp.Id_działu, d.Nazwa_działu, dzp.Id_projektu, p.Nazwa_projektu
	from Działy d, Projekty p, Działy_zarządzają_projektami dzp
	where d.Id_Działu = dzp.Id_działu and p.Id_Projektu = dzp.Id_projektu and dzp.Id_działu = @Id_działu
   
END;
GO

------------------------------------------------

IF EXISTS (
    SELECT * 
    FROM sys.procedures 
    WHERE name = 'Przypisz_role_do_zadania'
)
BEGIN
    DROP PROCEDURE Przypisz_role_do_zadania;
END
GO

CREATE PROCEDURE Przypisz_role_do_zadania
   @Id_zadania int,
   @Id_roli int
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Zadania_Projektów WHERE Id_Zadania = @Id_zadania)
    BEGIN
        RAISERROR('Zadanie o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Role_Pracowników WHERE Id_Roli = @Id_roli)
    BEGIN
        RAISERROR('Rola o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END

	IF EXISTS (SELECT 1 FROM Zadania_zawierają_role WHERE Id_Roli = @Id_roli and Id_zadania = @Id_zadania)
    BEGIN
        RAISERROR('Rola jest juz przypisana do tego zadania.', 16, 1);
        RETURN;
    END

    INSERT INTO Zadania_zawierają_role (Id_zadania, Id_roli)
    VALUES (@Id_zadania, @Id_roli);

    PRINT 'Rola została przypisana do zadania.';
END;
GO

--------------------------------------------


IF EXISTS (
    SELECT * 
    FROM sys.procedures 
    WHERE name = 'Wypisz_pracowników_i_ich_role'
)
BEGIN
    DROP PROCEDURE Wypisz_pracowników_i_ich_role;
END
GO

CREATE PROCEDURE Wypisz_pracowników_i_ich_role
 @Id_pracownika INT
AS
BEGIN
    SET NOCOUNT ON;

	select p.Id_Pracownika, p.Imię, p.Nazwisko, p.Rola_pracownika [Id_roli], r.Nazwa_roli
	from Pracownicy p, Role_Pracowników r
	where p.Rola_pracownika = r.Id_Roli and p.Id_Pracownika = @Id_pracownika

END;
GO

--------------------------------------------------------------

IF EXISTS (
    SELECT * 
    FROM sys.procedures 
    WHERE name = 'Wypisz_role_zadania_i_pracownika_przypisanego'
)
BEGIN
    DROP PROCEDURE Wypisz_role_zadania_i_pracownika_przypisanego;
END
GO

CREATE PROCEDURE Wypisz_role_zadania_i_pracownika_przypisanego
 @Id_zadania INT
AS
BEGIN
    SET NOCOUNT ON;

	select zzr.Id_Zadania, z.Nazwa_zadania, zzr.Id_roli, ro.Nazwa_roli, p.Id_Pracownika, p.Imię + ' ' + p.Nazwisko as [Pracownik przypisany]
	from Pracownicy p, Role_Pracowników ro, Zadania_zawierają_role zzr, Zadania_Projektów z
	where p.Rola_pracownika = ro.Id_Roli and zzr.Id_roli = ro.Id_Roli and zzr.Id_zadania = z.Id_Zadania and zzr.Id_zadania = @Id_zadania

END;
GO

----------------------------------------------

IF EXISTS (
    SELECT * 
    FROM sys.procedures 
    WHERE name = 'Przypisz_pracownika_do_zadania'
)
BEGIN
    DROP PROCEDURE Przypisz_pracownika_do_zadania;
END
GO

CREATE PROCEDURE Przypisz_pracownika_do_zadania
   @Id_pracownika int,
   @Id_zadania int,
   @Data_początku date,
   @Data_ukończenia date = null,
   @Status_zadania nvarchar(15),
   @Miejsce_realizacji nvarchar(50) = null,
   @Liczba_godzin int
AS
BEGIN
    SET NOCOUNT ON;

	if CONVERT(DATE, @Data_początku) < (select CONVERT(DATE, Data_zatrudnienia) from Pracownicy_Należą_do_Działow where Id_pracownika = @Id_pracownika )
	begin
	RAISERROR('Zadanie nie może zostać uruchomione przed zatrudnieniem pracownika.', 16, 1);
        RETURN;
	end 

	if CONVERT(DATE, @Data_początku) > CONVERT(DATE, getdate()) 
	begin
	RAISERROR('Zadanie nie może zostać uruchomione po dzisiejszym dniu.', 16, 1);
        RETURN;
	end 

    IF NOT EXISTS (SELECT 1 FROM Zadania_Projektów WHERE Id_Zadania = @Id_zadania)
    BEGIN
        RAISERROR('Zadanie o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Pracownicy WHERE Id_Pracownika = @Id_pracownika)
    BEGIN
        RAISERROR('Pracownik o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END

	IF EXISTS (SELECT 1 FROM Pracownicy_realizują_zadania WHERE Id_pracownika = @Id_pracownika AND Id_zadania = @Id_zadania)
    BEGIN
        RAISERROR('To zadanie juz przypisane do tego pracownika.', 16, 1);
        RETURN;
    END

    INSERT INTO Pracownicy_realizują_zadania (Id_pracownika, Id_zadania, Data_początku, Data_ukończenia, Status_zadania, Miejsce_realizacji, Liczba_godzin)
    VALUES (@Id_pracownika, @Id_zadania, @Data_początku, @Data_ukończenia, @Status_zadania, @Miejsce_realizacji, @Liczba_godzin);

    PRINT 'Pracownik został przypisany do zadania.';
END;
GO

---------------------------------------------------------

IF EXISTS (
    SELECT * 
    FROM sys.procedures 
    WHERE name = 'Wypisz_pracownika_zadanie_projekt_i_role'
)
BEGIN
    DROP PROCEDURE Wypisz_pracownika_zadanie_projekt_i_role;
END
GO

CREATE PROCEDURE Wypisz_pracownika_zadanie_projekt_i_role
 @Id_pracownika INT
AS
BEGIN
    SET NOCOUNT ON;

	select prrezad.Id_pracownika, p.Imię + ' ' + p.Nazwisko as [Pracownik], prrezad.Id_zadania, 
	zad.Nazwa_zadania, p.Rola_pracownika as [Id_roli], ro.Nazwa_roli as [Rola_pracownika]
	from Pracownicy p, Zadania_Projektów zad, Pracownicy_realizują_zadania prrezad, Role_Pracowników ro
	where p.Id_Pracownika = prrezad.Id_pracownika and zad.Id_Zadania = prrezad.Id_zadania and ro.Id_Roli = p.Rola_pracownika 
	and prrezad.Id_pracownika = @Id_pracownika

END;
GO

--------------------------------------------------------

IF EXISTS (
    SELECT * 
    FROM sys.procedures 
    WHERE name = 'Dodaj_wyplate'
)
BEGIN
    DROP PROCEDURE Dodaj_wyplate;
END
GO

CREATE PROCEDURE Dodaj_wyplate
   @Id_pracownika int,
   @Id_działu int,
   @Data_wypłaty date,
   @Wysokość_pensji float = null
AS
BEGIN
    SET NOCOUNT ON;

	if CONVERT(DATE, @Data_wypłaty) < (select CONVERT(DATE, Data_zatrudnienia) from Pracownicy_Należą_do_Działow where Id_pracownika = @Id_pracownika)
	begin
	RAISERROR('Pensja nie może być wyplacona przed zatrudnieniem pracownika.', 16, 1);
        RETURN;
	end 

	if CONVERT(DATE, @Data_wypłaty) > CONVERT(DATE, GETDATE())
	begin
	RAISERROR('Pensja nie może być wyplacona po dacie aktualnej.', 16, 1);
        RETURN;
	end 

    IF NOT EXISTS (SELECT 1 FROM Działy WHERE Id_Działu = @Id_działu)
    BEGIN
        RAISERROR('Dział o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Pracownicy WHERE Id_Pracownika = @Id_pracownika)
    BEGIN
        RAISERROR('Pracownik o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END

	IF EXISTS (SELECT 1 FROM Działy_Wyplacają_pensję WHERE Id_pracownika = @Id_pracownika AND Id_działu = @Id_działu AND Data_wypłaty = @Data_wypłaty)
    BEGIN
        RAISERROR('Taka wypłata już istnieje.', 16, 1);
        RETURN;
    END

    INSERT INTO Działy_Wyplacają_pensję (Id_pracownika, Id_działu, Data_wypłaty, Wysokość_pensji)
    VALUES (@Id_pracownika, @Id_działu, @Data_wypłaty, @Wysokość_pensji);

    PRINT 'Wypłata została dodana.';
END;
GO

----------------------------------------------------------

IF EXISTS (
    SELECT * 
    FROM sys.procedures 
    WHERE name = 'Wypisz_historie_wyplat_dla_pracownika'
)
BEGIN
    DROP PROCEDURE Wypisz_historie_wyplat_dla_pracownika;
END
GO

CREATE PROCEDURE Wypisz_historie_wyplat_dla_pracownika
 @Id_pracownika INT
AS
BEGIN
    SET NOCOUNT ON;

	select p.Id_Pracownika, p.Imię + ' ' + p.Nazwisko as [Pracownik], wy.Data_wypłaty, wy.Wysokość_pensji, d.Nazwa_działu
	from Pracownicy p, Działy_Wyplacają_pensję wy, Działy d
	where p.Id_Pracownika = wy.Id_pracownika and wy.Id_działu = d.Id_Działu and wy.Id_pracownika = @Id_pracownika

END;
GO

-----------------------------------------------

IF EXISTS (
    SELECT * 
    FROM sys.procedures 
    WHERE name = 'Wypisz_srednia_dla_pracownika'
)
BEGIN
    DROP PROCEDURE Wypisz_srednia_dla_pracownika;
END
GO

CREATE PROCEDURE Wypisz_srednia_dla_pracownika
    @Id_pracownika INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        AVG(wyplaty.pensja) AS [Srednia dla pracownika],
        p.Imię + ' ' + p.Nazwisko AS [Pracownik]
    FROM 
        ( 
            SELECT wy.Wysokość_pensji AS pensja
            FROM Pracownicy p
            INNER JOIN Działy_Wyplacają_pensję wy ON p.Id_Pracownika = wy.Id_pracownika
            WHERE p.Id_Pracownika = @Id_pracownika
        ) AS wyplaty
    INNER JOIN Pracownicy p ON p.Id_Pracownika = @Id_pracownika
    GROUP BY 
        p.Imię, p.Nazwisko, p.Id_Pracownika;
END;
GO


---------------------------------------------------------

IF EXISTS (
    SELECT * 
    FROM sys.procedures 
    WHERE name = 'Przypisz_pracownika_do_projektu'
)
BEGIN
    DROP PROCEDURE Przypisz_pracownika_do_projektu;
END
GO

CREATE PROCEDURE Przypisz_pracownika_do_projektu
   @Id_pracownika int,
   @Id_projektu int,
   @Stawka_godzinowa float,
   @Liczba_godzin int = null
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Pracownicy WHERE Id_Pracownika = @Id_pracownika)
    BEGIN
        RAISERROR('Pracownik o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Projekty WHERE Id_Projektu = @Id_projektu)
    BEGIN
        RAISERROR('Projekt o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END

	IF EXISTS (SELECT 1 FROM Pracownicy_realizują_projekty WHERE Id_pracownika = @Id_pracownika AND Id_projektu = @Id_projektu)
    BEGIN
        RAISERROR('Ten projekt juz przypisany do tego pracownika.', 16, 1);
        RETURN;
    END

    INSERT INTO Pracownicy_realizują_projekty(Id_pracownika, Id_projektu, Stawka_godzinowa, Liczba_godzin)
    VALUES (@Id_pracownika, @Id_projektu, @Stawka_godzinowa, @Liczba_godzin);

    PRINT 'Pracownik został przypisany do projektu.';
END;
GO

----------------------------------------------------

IF EXISTS (
    SELECT * 
    FROM sys.procedures 
    WHERE name = 'Przypisz_role_do_projektu'
)
BEGIN
    DROP PROCEDURE Przypisz_role_do_projektu;
END
GO

CREATE PROCEDURE Przypisz_role_do_projektu
   @Id_projektu int,
   @Id_roli int
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Projekty WHERE Id_Projektu = @Id_projektu)
    BEGIN
        RAISERROR('Projekt o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Role_Pracowników WHERE Id_Roli = @Id_roli)
    BEGIN
        RAISERROR('Rola o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END

	IF EXISTS (SELECT 1 FROM Projekty_zawierają_role WHERE Id_projektu = @Id_projektu AND Id_roli = @Id_roli)
    BEGIN
        RAISERROR('Ta rola juz przypisana do tego projektu.', 16, 1);
        RETURN;
    END

    INSERT INTO Projekty_zawierają_role(Id_projektu, Id_roli)
    VALUES (@Id_projektu, @Id_roli);

    PRINT 'Rola została przypisana do projektu.';
END;
GO

--------------------Stanowiska---------------------------

EXEC Dodaj_Stanowisko 
    @Nazwa_stanowiska = N'Project Manager',
    @Opis = N'Organizuje cały projekt';

EXEC Dodaj_Stanowisko 
    @Nazwa_stanowiska = N'UI Designer',
    @Opis = N'Zajmuje się wyglądem projektu (interfejsem)';

EXEC Dodaj_Stanowisko 
    @Nazwa_stanowiska = N'UX Designer',
    @Opis = N'Projektuje ścieżki użytkowników';

	EXEC Dodaj_Stanowisko 
    @Nazwa_stanowiska = N'Architekt systemu',
    @Opis = N'Zarządza programistami w zespole';

EXEC Dodaj_Stanowisko 
    @Nazwa_stanowiska = N'Programista',
    @Opis = N'Zajmuje się konkretnym obszarem oprogramowania';

EXEC Dodaj_Stanowisko 
    @Nazwa_stanowiska = N'Tester',
    @Opis = N'Testuje oprogramowanie';

EXEC Dodaj_Stanowisko 
    @Nazwa_stanowiska = N'Wsparcie techniczne',
	@Opis = default;

EXEC Dodaj_Stanowisko 
    @Nazwa_stanowiska = N'Analityk danych';

EXEC Dodaj_Stanowisko 
    @Nazwa_stanowiska = N'Analityk danych';


----------------------Telefony---------------------------

EXEC Dodaj_Telefon
@Numer_telefonu = '48 671 009 671';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 280 190 888';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 911 023 230';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 018 901 263';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 090 307 122';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 109 169 022';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 123 091 122';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 900 003 080';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 001 009 188';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 004 118 122';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 121 343 122';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 009 133 901';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 019 133 101';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 411 901 001';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 322 871 100';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 097 488 711';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 097 488 771';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 021 481 771';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 011 486 711';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 171 233 191';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 101 105 888';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 119 984 567';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 119 924 551';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 209 781 439';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 809 121 091';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 187 871 331';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 109 891 209';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 578 486 209';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 498 332 111';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 101 207 899';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 901 984 211';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 091 111 650';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 109 123 203';

EXEC Dodaj_Telefon
@Numer_telefonu = '48097 488 771';

EXEC Dodaj_Telefon
@Numer_telefonu = '48 097 488 77111';

----------------------KLienci---------------------------
	
EXEC Dodaj_Klienta
@Id_Klienta = 'TECH_SOL',
@Nazwa_Firmy = 'Tech Solutions Inc.',
@Kraj = 'Australia',
@Miasto = 'Sydney',
@Adres = '123 Main Street',
@Uwagi = 'Innowacyjne rozwiązania technologiczne dla biznesu';

EXEC Dodaj_Klienta
@Id_Klienta = 'CYB_INN',
@Nazwa_Firmy = 'CyberTech Innovations',
@Kraj = 'Singapur',
@Miasto = 'Singapur',
@Adres = '456 Orchard Road',
@Uwagi = 'Pionier w dziedzinie cyberbezpieczeństwa i innowacji';

EXEC Dodaj_Klienta
@Id_Klienta = 'CODECR',
@Nazwa_Firmy = 'CodeCrafters Ltd.',
@Kraj = 'Kanada',
@Miasto = 'Toronto',
@Adres = '789 Bay Street',
@Uwagi = 'Tworzymy oprogramowanie z pasją i precyzją';

EXEC Dodaj_Klienta
@Id_Klienta = 'DIG_NEX',
@Nazwa_Firmy = 'Digital Nexus Group',
@Kraj = 'Niemcy',
@Miasto = 'Berlin',
@Adres = '101 Friedrichstrasse',
@Uwagi = 'Łączymy cyfrowe idee z rzeczywistością biznesową';

EXEC Dodaj_Klienta
@Id_Klienta = 'BYBL_TECH',
@Nazwa_Firmy = 'ByteBlast Technologies',
@Kraj = 'Stany Zjednoczone',
@Miasto = 'San Francisco',
@Adres = '555 Market Street',
@Uwagi = 'Eksplozja kreatywności w świecie cyfrowej technologii';

EXEC Dodaj_Klienta
@Id_Klienta = 'DADRI_DY',
@Nazwa_Firmy = 'DataDriven Dynamics',
@Kraj = 'Holandia',
@Miasto = 'Amsterdam',
@Adres = '888 Keizersgracht',
@Uwagi = 'Analizujemy dane, przekształcając je w dynamiczne rozwiązania';

EXEC Dodaj_Klienta
@Id_Klienta = 'CLO_SOL',
@Nazwa_Firmy = 'CloudGenius Solutions',
@Kraj = 'Wielka Brytania',
@Miasto = 'Londyn',
@Adres = '22 Baker Street',
@Uwagi = 'Genialne rozwiązania w chmurze dla biznesu i technologii';

EXEC Dodaj_Klienta
@Id_Klienta = 'INF_SYS',
@Nazwa_Firmy = 'InfraLogic Systems',
@Kraj = 'Indie',
@Miasto = 'Bangalore',
@Adres = '333 MG Road',
@Uwagi = 'Nowoczesne rozwiązania infrastrukturalne dla biznesu';

EXEC Dodaj_Klienta
@Id_Klienta = 'WEBWIZZ_CORP',
@Nazwa_Firmy = 'WebWizards Corporation',
@Kraj = 'Szwajcaria',
@Miasto = 'Zurich',
@Adres = '71/1a Bahnhofstrasse',
@Uwagi = default;

EXEC Dodaj_Klienta
@Id_Klienta = 'SOSYN_LAB',
@Nazwa_Firmy = 'SoftwareSynergy Labs',
@Kraj = 'Francja',
@Miasto = 'Paryż',
@Adres = '441 Avenue des Champs-Élysées';

----------------------Projekty--------------------------

EXEC Dodaj_Projekt
@Nazwa_projektu = 'Wirtualna platforma współpracy biznesowej',
@Cel_projektu = 'Stworzenie innowacyjnej platformy umożliwiającej efektywną współpracę biznesową na odległość',
@Id_klienta = 'TECH_SOL',
@Uwagi = 'Zintegrowany z najnowszymi technologiami';

EXEC Dodaj_Projekt
@Nazwa_projektu = 'System detekcji zagrożeń cybernetycznych',
@Cel_projektu = 'Opracowanie zaawansowanego systemu detekcji i reagowania na zagrożenia cybernetyczne',
@Id_klienta = 'CYB_INN',
@Uwagi = 'Zapewnienie bezpieczeństwa danych klientów';

EXEC Dodaj_Projekt
@Nazwa_projektu = 'Platforma zarządzania projektami IT',
@Cel_projektu = 'Stworzenie kompleksowej platformy do zarządzania projektami IT',
@Id_klienta = 'CODECR',
@Uwagi = 'Umożliwiający śledzenie postępów, alokację zasobów i harmonogramowanie zadań';

EXEC Dodaj_Projekt
@Nazwa_projektu = 'System analizy danych biznesowych',
@Cel_projektu = 'Rozwój zaawansowanego systemu analizy danych biznesowych',
@Id_klienta = 'CODECR',
@Uwagi = 'Umożliwia klientom lepsze zrozumienie ich danych i podejmowanie lepszych decyzji';

EXEC Dodaj_Projekt
@Nazwa_projektu = 'Aplikacja mobilna do zarządzania zadaniami',
@Cel_projektu = 'Stworzenie intuicyjnej aplikacji mobilnej do zarządzania zadaniami',
@Id_klienta = 'BYBL_TECH',
@Uwagi = 'Umożliwia elastyczność i efektywność w pracy zdalnej';

EXEC Dodaj_Projekt
@Nazwa_projektu = 'Platforma do analizy rynku i trendów',
@Cel_projektu = 'Opracowanie zaawansowanej platformy analitycznej',
@Id_klienta = 'DADRI_DY';

EXEC Dodaj_Projekt
@Nazwa_projektu = 'Platforma do analizy rynku i trendów',
@Cel_projektu = 'Opracowanie zaawansowanej platformy analitycznej',
@Id_klienta = 'DADRI_DY';

EXEC Dodaj_Projekt
@Nazwa_projektu = 'Testowy z niepoprawnym id klienta',
@Cel_projektu = 'Opracowanie zaawansowanej platformy analitycznej',
@Id_klienta = 'DADRI_D1';

--------------------Zadania projektowe------------------

EXEC Dodaj_Zadanie_Projektowe
@Nazwa_zadania = 'Przygotowanie infrastruktury danych',
@Opis = 'Przygotowanie infrastruktury danych potrzebnej do gromadzenia, przetwarzania i analizy danych biznesowych',
@Uwagi = 'Upewnij się, że infrastruktura jest skalowalna i zapewnia wysoką dostępność danych';

EXEC Dodaj_Zadanie_Projektowe
@Nazwa_zadania = 'Implementacja funkcji czatu online',
@Opis = 'Implementacja funkcji czatu online, umożliwiającej natychmiastową komunikację między użytkownikami platformy',
@Uwagi = 'Zapewnij szyfrowanie end-to-end dla komunikacji w celu zapewnienia bezpieczeństwa danych';

EXEC Dodaj_Zadanie_Projektowe
@Nazwa_zadania = 'Integracja z systemami zewnętrznymi',
@Opis = 'Integracja platformy z systemami zewnętrznymi, takimi jak CRM czy systemy zarządzania zasobami ludzkimi',
@Uwagi = 'Upewnij się, że integracja jest płynna i zapewnia kompleksową synchronizację danych';

EXEC Dodaj_Zadanie_Projektowe
@Nazwa_zadania = 'Analiza wymagań bezpieczeństwa',
@Opis = 'Przeprowadzenie analizy wymagań bezpieczeństwa w celu zidentyfikowania potencjalnych zagrożeń i luk w zabezpieczeniach',
@Uwagi = 'Skonsultuj się z ekspertami ds. bezpieczeństwa w celu określenia kluczowych obszarów do zabezpieczenia';

EXEC Dodaj_Zadanie_Projektowe
@Nazwa_zadania = 'Opracowanie systemu monitorowania aktywności sieciowej',
@Opis = 'Opracowanie systemu monitorowania aktywności sieciowej w celu wykrywania podejrzanych zachowań i incydentów bezpieczeństwa',
@Uwagi = 'Skonfiguruj system monitorowania w czasie rzeczywistym, aby umożliwić szybką reakcję na zagrożenia';

EXEC Dodaj_Zadanie_Projektowe
@Nazwa_zadania = 'Szkolenie personelu w zakresie cyberbezpieczeństwa',
@Opis = 'Przeprowadzenie szkoleń dla personelu w zakresie cyberbezpieczeństwa, aby zwiększyć świadomość i zapobiegać incydentom związanym z bezpieczeństwem',
@Uwagi = 'Zapewnij spersonalizowane szkolenia dostosowane do różnych poziomów wiedzy i doświadczenia pracowników';

EXEC Dodaj_Zadanie_Projektowe
@Nazwa_zadania = 'Implementacja mechanizmu wizualizacji danych';

EXEC Dodaj_Zadanie_Projektowe
@Nazwa_zadania = 'Optymalizacja wydajności systemu';

EXEC Dodaj_Zadanie_Projektowe
@Nazwa_zadania = 'Projektowanie prototypu interfejsu',
@Opis = 'Stworzenie prototypu interfejsu aplikacji mobilnej, aby zaprezentować koncepcję użytkownikom i uzyskać ich opinie';

EXEC Dodaj_Zadanie_Projektowe
@Nazwa_zadania = 'Przetestowanie oprogramowania'

--------------------Role pracowników------------------

EXEC Dodaj_Role_Pracownikow
@Nazwa_roli = 'Lider zespołu',
@Opis = 'Osoba odpowiedzialna za koordynację działań zespołu',
@Uwagi = 'Zapewnia, że cele projektowe są osiągane w terminie i zgodnie z oczekiwaniami klienta';

EXEC Dodaj_Role_Pracownikow
@Nazwa_roli = 'Ekspert dziedzinowy',
@Opis = 'Osoba posiadająca głęboką wiedzę w konkretnej dziedzinie';

EXEC Dodaj_Role_Pracownikow
@Nazwa_roli = 'Użytkownik końcowy',
@Opis = 'Osoba, której głównym zadaniem jest testowanie oprogramowania lub produktu pod kątem użyteczności i zgodności z oczekiwaniami użytkowników końcowych';

EXEC Dodaj_Role_Pracownikow
@Nazwa_roli = 'Ambasador klienta',
@Opis = 'Osoba reprezentująca interesy klienta w zespole projektowym',
@Uwagi = 'Dbająca o to, żeby rozwiązania były zgodne z oczekiwaniami klienta';

EXEC Dodaj_Role_Pracownikow
@Nazwa_roli = 'Rozwiązujący problemy',
@Opis = 'Osoba specjalizująca się w rozwiązywaniu problemów';

EXEC Dodaj_Role_Pracownikow
@Nazwa_roli = 'Badacz',
@Opis = 'Osoba odpowiedzialna za przeprowadzenie badań i analizę danych',
@Uwagi = 'Zbieranie informacji potrzebnych do podejmowania decyzji projektowych';

EXEC Dodaj_Role_Pracownikow
@Nazwa_roli = 'Programista główny';

EXEC Dodaj_Role_Pracownikow
@Nazwa_roli = 'Programista front-end';

EXEC Dodaj_Role_Pracownikow
@Nazwa_roli = 'Programista back-end';

EXEC Dodaj_Role_Pracownikow
@Nazwa_roli = 'Programista full-stack',
@Uwagi = 'Posiada umiejętności zarówno front-endowe, jak i back-endowe';


--------------------Pracownicy------------------

    exec Dodaj_Pracownika
    @Imię = 'Marta' ,
    @Nazwisko = 'Kowalska' , 
    @Data_urodzenia = '1991-02-02',
    @Płeć = 'K',
    @Kraj = 'Polska' ,
    @Miasto = 'Poznań' ,
    @Adres = 'Warszawska 19',
	  @Szef = null,
    @Rola_pracownika = 8;

	  exec Dodaj_Pracownika
    @Imię = 'Michał' ,
    @Nazwisko = 'Nowak' , 
    @Data_urodzenia = '1988-07-11',
    @Płeć = 'M',
    @Kraj = 'Polska' ,
    @Miasto = 'Warszawa' ,
    @Adres = 'Zielona 19/10a',
    @Szef = 1,
    @Rola_pracownika = 2;

	exec Dodaj_Pracownika
    @Imię = 'Anna' ,
    @Nazwisko = 'Wiśniewska' , 
    @Data_urodzenia = '1981-01-19',
    @Płeć = 'K',
    @Kraj = 'Polska' ,
    @Miasto = 'Nowy Sącz' ,
    @Adres = 'Krakowska 199' ,
    @Uwagi = 'Nowy pracownik',
    @Szef = 2,
    @Rola_pracownika = 9;

	exec Dodaj_Pracownika
    @Imię = 'Piotr' ,
    @Nazwisko = 'Kaczmarek' , 
    @Data_urodzenia = '1988-09-09',
    @Płeć = 'M',
    @Kraj = 'Polska' ,
    @Miasto = 'Kraków' ,
    @Adres = 'Nowa 11',
    @Szef = 1,
    @Rola_pracownika = 6;

	exec Dodaj_Pracownika
    @Imię = 'Magdalena' ,
    @Nazwisko = 'Wojciechowska' , 
    @Data_urodzenia = '1980-11-11',
    @Płeć = 'K',
    @Kraj = 'Polska' ,
    @Miasto = 'Katowice' ,
    @Adres = 'Dworcowa 11/90' ,
    @Uwagi = 'Termin próbny wkrótce się kończy',
    @Szef = 2,
    @Rola_pracownika = 9;

	exec Dodaj_Pracownika
    @Imię = 'Łukasz' ,
    @Nazwisko = 'Jankowski' , 
    @Data_urodzenia = '2002-10-05',
    @Płeć = 'M',
    @Kraj = 'Polska' ,
    @Miasto = 'Katowice' ,
    @Adres = 'Długa 111/1' ,
    @Szef = 4,
    @Rola_pracownika = 10;

	exec Dodaj_Pracownika
    @Imię = 'Katarzyna' ,
    @Nazwisko = 'Wójcik' , 
    @Data_urodzenia = '2001-03-12',
    @Płeć = 'K',
    @Kraj = 'Polska' ,
    @Miasto = 'Gdańsk' ,
    @Adres = 'Morska 90' ,
    @Uwagi = 'Pracownik jest zatrudniony na termin próbny przez 2 tygodnie',
    @Szef = 4,
    @Rola_pracownika = 5;

	exec Dodaj_Pracownika
    @Imię = 'Marcin' ,
    @Nazwisko = 'Wóźniak' , 
    @Data_urodzenia = '2000-01-11',
    @Płeć = 'M',
    @Kraj = 'Polska' ,
    @Miasto = 'Sopot' ,
    @Adres = 'Warszawska 9/91',
    @Szef = null,
    @Rola_pracownika = 10;

	exec Dodaj_Pracownika
    @Imię = 'Karolina' ,
    @Nazwisko = 'Mazur' , 
    @Data_urodzenia = '1994-12-08',
    @Płeć = 'K',
    @Kraj = 'Polska' ,
    @Miasto = 'Zielona Góra' ,
    @Adres = 'Zachodnia 81',
    @Szef = 8,
    @Rola_pracownika = 9;

	exec Dodaj_Pracownika
    @Imię = 'Paweł' ,
    @Nazwisko = 'Krawczyk' , 
    @Data_urodzenia = '1994-04-06',
    @Płeć = 'M',
    @Kraj = 'Polska' ,
    @Miasto = 'Warszawa' ,
    @Adres = 'Centralna 811',
    @Szef = 4,
    @Rola_pracownika = 2;

	exec Dodaj_Pracownika
    @Imię = 'Aleksandra' ,
    @Nazwisko = 'Kubiak' , 
    @Data_urodzenia = '2000-07-11',
    @Płeć = 'K',
    @Kraj = 'Polska' ,
    @Miasto = 'Warszawa' ,
    @Adres = 'Plac Wolności 72',
    @Szef = 8,
    @Rola_pracownika = 3;

	exec Dodaj_Pracownika
    @Imię = 'Tomasz' ,
    @Nazwisko = 'Kowalczyk' , 
    @Data_urodzenia = '1998-08-08',
    @Płeć = 'M',
    @Kraj = 'Polska' ,
    @Miasto = 'Łódź' ,
    @Adres = 'Katowicka 13',
    @Szef = null,
    @Rola_pracownika = 4;

	exec Dodaj_Pracownika
    @Imię = 'Monika' ,
    @Nazwisko = 'Szymańska' , 
    @Data_urodzenia = '1993-05-03',
    @Płeć = 'K',
    @Kraj = 'Polska' ,
    @Miasto = 'Białystok' ,
    @Adres = 'Placowa 98',
    @Szef = null,
    @Rola_pracownika = 7;

	exec Dodaj_Pracownika
    @Imię = 'Krzysztof' ,
    @Nazwisko = 'Grabowski' , 
    @Data_urodzenia = '1999-01-19',
    @Płeć = 'M',
    @Kraj = 'Polska' ,
    @Miasto = 'Gdańsk' ,
    @Adres = 'Przymorska 117',
    @Szef = 13,
    @Rola_pracownika = 8;

	exec Dodaj_Pracownika
    @Imię = 'Agnieszka' ,
    @Nazwisko = 'Pawłowska' , 
    @Data_urodzenia = '1991-08-11',
    @Płeć = 'K',
    @Kraj = 'Polska' ,
    @Miasto = 'Warszawa' ,
    @Adres = 'Wysoka 25/80',
    @Szef = 8,
    @Rola_pracownika = 4;

	exec Dodaj_Pracownika
    @Imię = 'Jan' ,
    @Nazwisko = 'Kowalski' , 
    @Data_urodzenia = '1983-04-12',
    @Płeć = 'M',
    @Kraj = 'Polska' ,
    @Miasto = 'Kraków' ,
    @Adres = 'Warszawska 11/7',
    @Szef = 4,
    @Rola_pracownika = 6;

	exec Dodaj_Pracownika
    @Imię = 'Aleksander' ,
    @Nazwisko = 'Kowalski' , 
    @Data_urodzenia = '1982-09-10',
    @Płeć = 'M',
    @Kraj = 'Polska' ,
    @Miasto = 'Kraków' ,
    @Adres = 'Końcowa 11/7',
    @Szef = 13,
    @Rola_pracownika = 1;


	--exec Dodaj_Pracownika
 --   @Imię = 'Jan' ,
 --   @Nazwisko = 'Testowy' , 
 --   @Data_urodzenia = '2001-09-10',
 --   @Płeć = 'M',
 --   @Kraj = 'Polska' ,
 --   @Miasto = 'Kraków' ,
 --   @Adres = 'Końcowa 11/7',
 --   @Szef = 13,
 --   @Rola_pracownika = 1;


-----------------------Działy-------------------------------

	exec Dodaj_Dział

	@Nazwa_działu = 'Dział Rozwoju Oprogramowania' ,
    @Data_otwarcia = '2021-11-01' ,
    @Data_zamknięcia  = null ,
    @Status_działu  = 'Otwarty' ,
    @Kraj  = 'Polska' ,
    @Miasto  = 'Warszawa' ,
    @Adres  = 'Plac Centralny 12/8' ,
    @Id_kierownika  = 4 ,
    @Uwagi  = 'Pierwszy otwarty dział' ;

	exec Dodaj_Dział

	@Nazwa_działu = 'Dział Technologii Informacyjnych' ,
    @Data_otwarcia = '2021-11-05' ,
    @Data_zamknięcia  = null ,
    @Status_działu  = 'Otwarty' ,
    @Kraj  = 'Polska' ,
    @Miasto  = 'Warszawa' ,
    @Adres  = 'Plac Centralny 12/8' ,
    @Id_kierownika  = 13 ;

	exec Dodaj_Dział

	@Nazwa_działu = 'Dział Infrastruktury IT' ,
    @Data_otwarcia = '2021-11-13' ,
    @Data_zamknięcia  = null ,
    @Status_działu  = 'Otwarty' ,
    @Kraj  = 'Polska' ,
    @Miasto  = 'Warszawa' ,
    @Adres  = 'Plac Centralny 12/8' ,
    @Id_kierownika  = 8 ;

	exec Dodaj_Dział

	@Nazwa_działu = 'Dział Bezpieczeństwa Cybernetycznego' ,
    @Data_otwarcia = '2021-11-21' ,
    @Data_zamknięcia  = null ,
    @Status_działu  = 'Otwarty' ,
    @Kraj  = 'Polska' ,
    @Miasto  = 'Katowice' ,
    @Adres  = 'Dworcowa 112' ,
    @Id_kierownika  = 2 ;

	exec Dodaj_Dział

	@Nazwa_działu = 'Dział Wsparcia Technicznego' ,
    @Data_otwarcia = '2021-12-02' ,
    @Data_zamknięcia  = null ,
    @Status_działu  = 'Otwarty' ,
    @Kraj  = 'Polska' ,
    @Miasto  = 'Katowice' ,
    @Adres  = 'Dworcowa 112' ,
    @Id_kierownika  = 9 ;

	exec Dodaj_Dział

	@Nazwa_działu = 'Dział Analityki Danych' ,
    @Data_otwarcia = '2021-12-05' ,
	@Data_zamknięcia  = '2021-12-18' ,
    @Status_działu  = 'Otwarty' ,
    @Kraj  = 'Polska' ,
    @Miasto  = 'Katowice' ,
    @Adres  = 'Dworcowa 112' ,
    @Id_kierownika  = 2 ;

--	exec Dodaj_Dział

--	@Nazwa_działu = 'Testowy' ,
--    @Data_otwarcia = '2021-12-05' ,
--	@Data_zamknięcia  = '2021-12-28' ,
--    @Status_działu  = 'Otwarty' ,
--    @Kraj  = 'Polska' ,
--    @Miasto  = 'Katowice' ,
--    @Adres  = 'Dworcowa 112' ,
--    @Id_kierownika  = 2 ;

--	update Działy
--	set
--	Data_zamknięcia  = '2020-12-05'
--    Where Nazwa_działu = 'Dzial Wsparcia Technicznego'

--select * from Działy

------------------------Pracownicy_należą_do_działów-----------------------------------

exec Dodaj_pracownika_do_działu
	@Data_zatrudnienia = '2023-11-03',
    @Data_zwolnienia = null,
    @Status_pracownika = 'Aktywny',
    @Id_pracownika = '1',
	@Id_działu = '1';

	exec Dodaj_pracownika_do_działu
	@Data_zatrudnienia = '2023-11-03',
    @Data_zwolnienia = null,
    @Status_pracownika = 'Aktywny',
    @Id_pracownika = '2',
	@Id_działu = '4';

	exec Dodaj_pracownika_do_działu
	@Data_zatrudnienia = '2023-11-12',
    @Data_zwolnienia = null,
    @Status_pracownika = 'Aktywny',
    @Id_pracownika = '3',
	@Id_działu = '1';

	exec Dodaj_pracownika_do_działu
	@Data_zatrudnienia = '2023-11-19',
    @Data_zwolnienia = null,
    @Status_pracownika = 'Aktywny',
    @Id_pracownika = '4',
	@Id_działu = '1';

	exec Dodaj_pracownika_do_działu
	@Data_zatrudnienia = '2023-11-19',
    @Data_zwolnienia = null,
    @Status_pracownika = 'Aktywny',
    @Id_pracownika = '5',
	@Id_działu = '1';

	exec Dodaj_pracownika_do_działu
	@Data_zatrudnienia = '2023-11-21',
    @Data_zwolnienia = null,
    @Status_pracownika = 'Aktywny',
    @Id_pracownika = '6',
	@Id_działu = '1';

	exec Dodaj_pracownika_do_działu
	@Data_zatrudnienia = '2023-11-21',
    @Data_zwolnienia = null,
    @Status_pracownika = 'Aktywny',
    @Id_pracownika = '7',
	@Id_działu = '3';

	exec Dodaj_pracownika_do_działu
	@Data_zatrudnienia = '2023-12-02',
    @Data_zwolnienia = null,
    @Status_pracownika = 'Aktywny',
    @Id_pracownika = '8',
	@Id_działu = '1';

	exec Dodaj_pracownika_do_działu
	@Data_zatrudnienia = '2023-12-04',
    @Data_zwolnienia = null,
    @Status_pracownika = 'Aktywny',
    @Id_pracownika = '9',
	@Id_działu = '5';

	exec Dodaj_pracownika_do_działu
	@Data_zatrudnienia = '2023-11-08',
    @Data_zwolnienia = null,
    @Status_pracownika = 'Aktywny',
    @Id_pracownika = '10',
	@Id_działu = '4';

	exec Dodaj_pracownika_do_działu
	@Data_zatrudnienia = '2023-12-04',
    @Data_zwolnienia = null,
    @Status_pracownika = 'Aktywny',
    @Id_pracownika = '11',
	@Id_działu = '4';

	exec Dodaj_pracownika_do_działu
	@Data_zatrudnienia = '2023-12-04',
    @Data_zwolnienia = null,
    @Status_pracownika = 'Aktywny',
    @Id_pracownika = '12',
	@Id_działu = '3';

	exec Dodaj_pracownika_do_działu
	@Data_zatrudnienia = '2023-12-14',
    @Data_zwolnienia = null,
    @Status_pracownika = 'Aktywny',
    @Id_pracownika = '13',
	@Id_działu = '2';

	exec Dodaj_pracownika_do_działu
	@Data_zatrudnienia = '2023-12-04',
    @Data_zwolnienia = null,
    @Status_pracownika = 'Aktywny',
    @Id_pracownika = '14',
	@Id_działu = '3';

	exec Dodaj_pracownika_do_działu
	@Data_zatrudnienia = '2023-12-04',
    @Data_zwolnienia = null,
    @Status_pracownika = 'Aktywny',
    @Id_pracownika = '15',
	@Id_działu = '2';

	exec Dodaj_pracownika_do_działu
	@Data_zatrudnienia = '2023-12-04',
    @Data_zwolnienia = null,
    @Status_pracownika = 'Aktywny',
    @Id_pracownika = '16',
	@Id_działu = '5';

	exec Dodaj_pracownika_do_działu
	@Data_zatrudnienia = '2023-12-04',
    @Data_zwolnienia = null,
    @Status_pracownika = 'Aktywny',
    @Id_pracownika = '17',
	@Id_działu = '2';

	--update Pracownicy_Należą_do_Działow
	--set Data_zwolnienia = null
	--where Id_pracownika = 1

	--update Pracownicy_Należą_do_Działow
	--set Status_pracownika = 'Nieaktywny'
	--where Id_pracownika = 2




--------------------------Stanowiska pracownikow---------------------------

exec Przypisz_Stanowisko_Pracownikom
	@Id_pracownika = 1,
    @Id_stanowiska = 5,
    @Data_startowa = '2023-11-04',
    @Data_końcowa = null;

	exec Przypisz_Stanowisko_Pracownikom
	@Id_pracownika = 2,
    @Id_stanowiska = 8,
    @Data_startowa = '2023-11-04',
    @Data_końcowa = null;

	exec Przypisz_Stanowisko_Pracownikom
	@Id_pracownika = 3,
    @Id_stanowiska = 4,
    @Data_startowa = '2023-11-13',
    @Data_końcowa = null;

	exec Przypisz_Stanowisko_Pracownikom
	@Id_pracownika = 4,
    @Id_stanowiska = 6,
    @Data_startowa = '2023-11-20',
    @Data_końcowa = null;

	exec Przypisz_Stanowisko_Pracownikom
	@Id_pracownika = 5,
    @Id_stanowiska = 5,
    @Data_startowa = '2023-11-20',
    @Data_końcowa = null;

	exec Przypisz_Stanowisko_Pracownikom
	@Id_pracownika = 6,
    @Id_stanowiska = 5,
    @Data_startowa = '2023-11-22',
    @Data_końcowa = null;

	exec Przypisz_Stanowisko_Pracownikom
	@Id_pracownika = 7,
    @Id_stanowiska = 7,
    @Data_startowa = '2023-11-22',
    @Data_końcowa = null;

	exec Przypisz_Stanowisko_Pracownikom
	@Id_pracownika = 8,
    @Id_stanowiska = 5,
    @Data_startowa = '2023-12-04',
    @Data_końcowa = null;

	exec Przypisz_Stanowisko_Pracownikom
	@Id_pracownika = 9,
    @Id_stanowiska = 5,
    @Data_startowa = '2023-12-05',
    @Data_końcowa = null;

	exec Przypisz_Stanowisko_Pracownikom
	@Id_pracownika = 10,
    @Id_stanowiska = 8,
    @Data_startowa = '2023-11-12',
    @Data_końcowa = null;

	exec Przypisz_Stanowisko_Pracownikom
	@Id_pracownika = 11,
    @Id_stanowiska = 6,
    @Data_startowa = '2023-12-05',
    @Data_końcowa = null;

	exec Przypisz_Stanowisko_Pracownikom
	@Id_pracownika = 12,
    @Id_stanowiska = 8,
    @Data_startowa = '2023-12-06',
    @Data_końcowa = null;

	exec Przypisz_Stanowisko_Pracownikom
	@Id_pracownika = 13,
    @Id_stanowiska = 5,
    @Data_startowa = '2023-12-16',
    @Data_końcowa = null;

	exec Przypisz_Stanowisko_Pracownikom
	@Id_pracownika = 14,
    @Id_stanowiska = 5,
    @Data_startowa = '2023-12-16',
    @Data_końcowa = null;

	exec Przypisz_Stanowisko_Pracownikom
	@Id_pracownika = 15,
    @Id_stanowiska = 1,
    @Data_startowa = '2023-12-16',
    @Data_końcowa = null;

	exec Przypisz_Stanowisko_Pracownikom
	@Id_pracownika = 16,
    @Id_stanowiska = 6,
    @Data_startowa = '2023-12-16',
    @Data_końcowa = null;

	exec Przypisz_Stanowisko_Pracownikom
	@Id_pracownika = 17,
    @Id_stanowiska = 1,
    @Data_startowa = '2023-12-16',
    @Data_końcowa = null;


--	------------------Przypisanie telefonow------------

	exec Przypisz_telefon
	@Numer_telefonu = '48 009 133 901',
    @Id_pracownika = null,
    @Id_klienta = null,
	@Id_działu = 1;

	exec Przypisz_telefon
	@Numer_telefonu = '48 011 486 711',
    @Id_pracownika = null,
    @Id_klienta = null,
	@Id_działu = 2;

	exec Przypisz_telefon
	@Numer_telefonu = '48 019 133 101',
    @Id_pracownika = null,
    @Id_klienta = null,
	@Id_działu = 3;

	exec Przypisz_telefon
	@Numer_telefonu = '48 021 481 771',
    @Id_pracownika = null,
    @Id_klienta = null,
	@Id_działu = 4;

	exec Przypisz_telefon
	@Numer_telefonu = '48 091 111 650',
    @Id_pracownika = null,
    @Id_klienta = null,
	@Id_działu = 5;

	exec Przypisz_telefon
	@Numer_telefonu = '48 097 488 711',
    @Id_pracownika = null,
    @Id_klienta = null,
	@Id_działu = 6;

	exec Przypisz_telefon
	@Numer_telefonu = '48 097 488 771',
    @Id_pracownika = null,
    @Id_klienta = null,
	@Id_działu = 7;

    exec Przypisz_telefon
	@Numer_telefonu = '48 101 105 888',
    @Id_pracownika = 1,
    @Id_klienta = null,
	@Id_działu = null;

	exec Przypisz_telefon
	@Numer_telefonu = '48 101 207 899',
    @Id_pracownika = 2,
    @Id_klienta = null,
	@Id_działu = null;

	exec Przypisz_telefon
	@Numer_telefonu = '48 109 123 203',
    @Id_pracownika = 2,
    @Id_klienta = null,
	@Id_działu = null;

	exec Przypisz_telefon
	@Numer_telefonu = '48 109 891 209',
    @Id_pracownika = 3,
    @Id_klienta = null,
	@Id_działu = null;

	exec Przypisz_telefon
	@Numer_telefonu = '48 119 924 551',
    @Id_pracownika = 4,
    @Id_klienta = null,
	@Id_działu = null;

	exec Przypisz_telefon
	@Numer_telefonu = '48 119 984 567',
    @Id_pracownika = 5,
    @Id_klienta = null,
	@Id_działu = null;

	exec Przypisz_telefon
	@Numer_telefonu = '48 121 343 122',
    @Id_pracownika = 6,
    @Id_klienta = null,
	@Id_działu = null;

	exec Przypisz_telefon
	@Numer_telefonu = '48 171 233 191',
    @Id_pracownika = 7,
    @Id_klienta = null,
	@Id_działu = null;

	exec Przypisz_telefon
	@Numer_telefonu = '48 187 871 331',
    @Id_pracownika = 8,
    @Id_klienta = null,
	@Id_działu = null;

	exec Przypisz_telefon
	@Numer_telefonu = '48 209 781 439',
    @Id_pracownika = 9,
    @Id_klienta = null,
	@Id_działu = null;

	exec Przypisz_telefon
	@Numer_telefonu = '48 322 871 100',
    @Id_pracownika = 10,
    @Id_klienta = null,
	@Id_działu = null;

	exec Przypisz_telefon
	@Numer_telefonu = '48 411 901 001',
    @Id_pracownika = 11,
    @Id_klienta = null,
	@Id_działu = null;

	exec Przypisz_telefon
	@Numer_telefonu = '48 498 332 111',
    @Id_pracownika = 12,
    @Id_klienta = null,
	@Id_działu = null;

	exec Przypisz_telefon
	@Numer_telefonu = '48 578 486 209',
    @Id_pracownika = 13,
    @Id_klienta = null,
	@Id_działu = null;

	exec Przypisz_telefon
	@Numer_telefonu = '48 809 121 091',
    @Id_pracownika = 14,
    @Id_klienta = null,
	@Id_działu = null;

	exec Przypisz_telefon
	@Numer_telefonu = '48 901 984 211',
    @Id_pracownika = 16,
    @Id_klienta = null,
	@Id_działu = null;

	exec Przypisz_telefon
	@Numer_telefonu = '48 671 009 671',
    @Id_pracownika = null,
    @Id_klienta = BYBL_TECH,
	@Id_działu = null;

	exec Przypisz_telefon
	@Numer_telefonu = '48 280 190 888',
    @Id_pracownika = null,
    @Id_klienta = CLO_SOL,
	@Id_działu = null;

	exec Przypisz_telefon
	@Numer_telefonu = '48 911 023 230',
    @Id_pracownika = null,
    @Id_klienta = CODECR,
	@Id_działu = null;
	
	exec Przypisz_telefon
	@Numer_telefonu = '48 018 901 263',
    @Id_pracownika = null,
    @Id_klienta = CYB_INN,
	@Id_działu = null;

	exec Przypisz_telefon
	@Numer_telefonu = '48 090 307 122',
    @Id_pracownika = null,
    @Id_klienta = DADRI_DY,
	@Id_działu = null;

	exec Przypisz_telefon
	@Numer_telefonu = '48 109 169 022',
    @Id_pracownika = null,
    @Id_klienta = DIG_NEX,
	@Id_działu = null;

	exec Przypisz_telefon
	@Numer_telefonu = '48 123 091 122',
    @Id_pracownika = null,
    @Id_klienta = INF_SYS,
	@Id_działu = null;

	exec Przypisz_telefon
	@Numer_telefonu = '48 900 003 080',
    @Id_pracownika = null,
    @Id_klienta = SOSYN_LAB,
	@Id_działu = null;

	exec Przypisz_telefon
	@Numer_telefonu = '48 001 009 188',
    @Id_pracownika = null,
    @Id_klienta = TECH_SOL,
	@Id_działu = null;

	exec Przypisz_telefon
	@Numer_telefonu = '48 004 118 122',
    @Id_pracownika = null,
    @Id_klienta = WEBWIZZ_CORP,
	@Id_działu = null;

	--select*from Posiadanie_Telefonu
	
--	-------------------Wyplaty-------------------

	--select * from Działy_Wyplacają_pensję

   exec Dodaj_wyplate
   @Id_pracownika = 1,
   @Id_działu = 1,
   @Data_wypłaty = '2023-12-01',
   @Wysokość_pensji = 4515.00;

   exec Dodaj_wyplate
   @Id_pracownika = 1,
   @Id_działu = 1,
   @Data_wypłaty = '2024-01-01',
   @Wysokość_pensji = 4715.00;

   exec Dodaj_wyplate
   @Id_pracownika = 1,
   @Id_działu = 1,
   @Data_wypłaty = '2024-02-01',
   @Wysokość_pensji = 4815.00;

   exec Dodaj_wyplate
   @Id_pracownika = 1,
   @Id_działu = 1,
   @Data_wypłaty = '2024-03-01',
   @Wysokość_pensji = 5100.00;

   exec Dodaj_wyplate
   @Id_pracownika = 2,
   @Id_działu = 4,
   @Data_wypłaty = '2023-12-01',
   @Wysokość_pensji = 5515.00;

   exec Dodaj_wyplate
   @Id_pracownika = 2,
   @Id_działu = 4,
   @Data_wypłaty = '2024-01-01',
   @Wysokość_pensji = 5415.00;

   exec Dodaj_wyplate
   @Id_pracownika = 2,
   @Id_działu = 4,
   @Data_wypłaty = '2024-02-01',
   @Wysokość_pensji = 5815.00;

   exec Dodaj_wyplate
   @Id_pracownika = 2,
   @Id_działu = 4,
   @Data_wypłaty = '2024-03-01',
   @Wysokość_pensji = 5910.00;

   exec Dodaj_wyplate
   @Id_pracownika = 3,
   @Id_działu = 1,
   @Data_wypłaty = '2023-12-01',
   @Wysokość_pensji = 6515.00;

   exec Dodaj_wyplate
   @Id_pracownika = 3,
   @Id_działu = 1,
   @Data_wypłaty = '2024-01-01',
   @Wysokość_pensji = 6415.00;

   exec Dodaj_wyplate
   @Id_pracownika = 3,
   @Id_działu = 1,
   @Data_wypłaty = '2024-02-01',
   @Wysokość_pensji = 6815.00;

   exec Dodaj_wyplate
   @Id_pracownika = 3,
   @Id_działu = 1,
   @Data_wypłaty = '2024-03-01',
   @Wysokość_pensji = 6910.00;

   exec Dodaj_wyplate
   @Id_pracownika = 4,
   @Id_działu = 1,
   @Data_wypłaty = '2023-12-01',
   @Wysokość_pensji = 3515.00;

   exec Dodaj_wyplate
   @Id_pracownika = 4,
   @Id_działu = 1,
   @Data_wypłaty = '2024-01-01',
   @Wysokość_pensji = 6415.00;

   exec Dodaj_wyplate
   @Id_pracownika = 4,
   @Id_działu = 1,
   @Data_wypłaty = '2024-02-01',
   @Wysokość_pensji = 5815.00;

   exec Dodaj_wyplate
   @Id_pracownika = 4,
   @Id_działu = 1,
   @Data_wypłaty = '2024-03-01',
   @Wysokość_pensji = 6910.00;

   exec Dodaj_wyplate
   @Id_pracownika = 5,
   @Id_działu = 1,
   @Data_wypłaty = '2023-12-01',
   @Wysokość_pensji = 2515.00;

   exec Dodaj_wyplate
   @Id_pracownika = 5,
   @Id_działu = 1,
   @Data_wypłaty = '2024-01-01',
   @Wysokość_pensji = 7415.00;

   exec Dodaj_wyplate
   @Id_pracownika = 5,
   @Id_działu = 1,
   @Data_wypłaty = '2024-02-01',
   @Wysokość_pensji = 6815.00;

   exec Dodaj_wyplate
   @Id_pracownika = 5,
   @Id_działu = 1,
   @Data_wypłaty = '2024-03-01',
   @Wysokość_pensji = 7910.00;

   exec Dodaj_wyplate
   @Id_pracownika = 6,
   @Id_działu = 1,
   @Data_wypłaty = '2023-12-01',
   @Wysokość_pensji = 2515.00;

   exec Dodaj_wyplate
   @Id_pracownika = 6,
   @Id_działu = 1,
   @Data_wypłaty = '2024-01-01',
   @Wysokość_pensji = 7415.00;

   exec Dodaj_wyplate
   @Id_pracownika = 6,
   @Id_działu = 1,
   @Data_wypłaty = '2024-02-01',
   @Wysokość_pensji = 8815.00;

   exec Dodaj_wyplate
   @Id_pracownika = 6,
   @Id_działu = 1,
   @Data_wypłaty = '2024-03-01',
   @Wysokość_pensji = 8910.00;

   exec Dodaj_wyplate
   @Id_pracownika = 7,
   @Id_działu = 3,
   @Data_wypłaty = '2023-12-01',
   @Wysokość_pensji = 2515.00;

   exec Dodaj_wyplate
   @Id_pracownika = 7,
   @Id_działu = 3,
   @Data_wypłaty = '2024-01-01',
   @Wysokość_pensji = 7415.00;

   exec Dodaj_wyplate
   @Id_pracownika = 7,
   @Id_działu = 3,
   @Data_wypłaty = '2024-02-01',
   @Wysokość_pensji = 7815.00;

   exec Dodaj_wyplate
   @Id_pracownika = 7,
   @Id_działu = 3,
   @Data_wypłaty = '2024-03-01',
   @Wysokość_pensji = 7910.00;

   exec Dodaj_wyplate
   @Id_pracownika = 8,
   @Id_działu = 1,
   @Data_wypłaty = '2024-01-01',
   @Wysokość_pensji = 11415.00;

   exec Dodaj_wyplate
   @Id_pracownika = 8,
   @Id_działu = 1,
   @Data_wypłaty = '2024-02-01',
   @Wysokość_pensji = 10815.00;

   exec Dodaj_wyplate
   @Id_pracownika = 8,
   @Id_działu = 1,
   @Data_wypłaty = '2024-03-01',
   @Wysokość_pensji = 10910.00;

   exec Dodaj_wyplate
   @Id_pracownika = 9,
   @Id_działu = 5,
   @Data_wypłaty = '2024-01-01',
   @Wysokość_pensji = 9415.00;

   exec Dodaj_wyplate
   @Id_pracownika = 9,
   @Id_działu = 5,
   @Data_wypłaty = '2024-02-01',
   @Wysokość_pensji = 10815.00;

   exec Dodaj_wyplate
   @Id_pracownika = 9,
   @Id_działu = 5,
   @Data_wypłaty = '2024-03-01',
   @Wysokość_pensji = 10910.00;

   exec Dodaj_wyplate
   @Id_pracownika = 10,
   @Id_działu = 4,
   @Data_wypłaty = '2024-01-01',
   @Wysokość_pensji = 11415.00;

   exec Dodaj_wyplate
   @Id_pracownika = 10,
   @Id_działu = 4,
   @Data_wypłaty = '2024-02-01',
   @Wysokość_pensji = 11815.00;

   exec Dodaj_wyplate
   @Id_pracownika = 10,
   @Id_działu = 4,
   @Data_wypłaty = '2024-03-01',
   @Wysokość_pensji = 11910.00;

   exec Dodaj_wyplate
   @Id_pracownika = 11,
   @Id_działu = 4,
   @Data_wypłaty = '2024-01-01',
   @Wysokość_pensji = 12415.00;

   exec Dodaj_wyplate
   @Id_pracownika = 11,
   @Id_działu = 4,
   @Data_wypłaty = '2024-02-01',
   @Wysokość_pensji = 11815.00;

   exec Dodaj_wyplate
   @Id_pracownika = 11,
   @Id_działu = 4,
   @Data_wypłaty = '2024-03-01',
   @Wysokość_pensji = 11910.00;

   exec Dodaj_wyplate
   @Id_pracownika = 12,
   @Id_działu = 3,
   @Data_wypłaty = '2024-01-01',
   @Wysokość_pensji = 9415.00;

   exec Dodaj_wyplate
   @Id_pracownika = 12,
   @Id_działu = 3,
   @Data_wypłaty = '2024-02-01',
   @Wysokość_pensji = 10815.00;

   exec Dodaj_wyplate
   @Id_pracownika = 12,
   @Id_działu = 3,
   @Data_wypłaty = '2024-03-01',
   @Wysokość_pensji = 10910.00;

   exec Dodaj_wyplate
   @Id_pracownika = 13,
   @Id_działu = 2,
   @Data_wypłaty = '2024-01-01',
   @Wysokość_pensji = 10415.00;

   exec Dodaj_wyplate
   @Id_pracownika = 13,
   @Id_działu = 2,
   @Data_wypłaty = '2024-02-01',
   @Wysokość_pensji = 11815.00;

   exec Dodaj_wyplate
   @Id_pracownika = 13,
   @Id_działu = 2,
   @Data_wypłaty = '2024-03-01',
   @Wysokość_pensji = 11910.00;

   exec Dodaj_wyplate
   @Id_pracownika = 14,
   @Id_działu = 3,
   @Data_wypłaty = '2024-01-01',
   @Wysokość_pensji = 11415.00;

   exec Dodaj_wyplate
   @Id_pracownika = 14,
   @Id_działu = 3,
   @Data_wypłaty = '2024-02-01',
   @Wysokość_pensji = 12815.00;

   exec Dodaj_wyplate
   @Id_pracownika = 14,
   @Id_działu = 3,
   @Data_wypłaty = '2024-03-01',
   @Wysokość_pensji = 12910.00;

   exec Dodaj_wyplate
   @Id_pracownika = 15,
   @Id_działu = 2,
   @Data_wypłaty = '2024-01-01',
   @Wysokość_pensji = 8415.00;

   exec Dodaj_wyplate
   @Id_pracownika = 15,
   @Id_działu = 2,
   @Data_wypłaty = '2024-02-01',
   @Wysokość_pensji = 8815.00;

   exec Dodaj_wyplate
   @Id_pracownika = 15,
   @Id_działu = 2,
   @Data_wypłaty = '2024-03-01',
   @Wysokość_pensji = 8910.00;

   exec Dodaj_wyplate
   @Id_pracownika = 16,
   @Id_działu = 5,
   @Data_wypłaty = '2024-01-01',
   @Wysokość_pensji = 10415.00;

   exec Dodaj_wyplate
   @Id_pracownika = 16,
   @Id_działu = 5,
   @Data_wypłaty = '2024-02-01',
   @Wysokość_pensji = 10815.00;

   exec Dodaj_wyplate
   @Id_pracownika = 16,
   @Id_działu = 5,
   @Data_wypłaty = '2024-03-01',
   @Wysokość_pensji = 10910.00;

   exec Dodaj_wyplate
   @Id_pracownika = 17,
   @Id_działu = 2,
   @Data_wypłaty = '2024-01-01',
   @Wysokość_pensji = 11415.00;

   exec Dodaj_wyplate
   @Id_pracownika = 17,
   @Id_działu = 2,
   @Data_wypłaty = '2024-02-01',
   @Wysokość_pensji = 10815.00;

   exec Dodaj_wyplate
   @Id_pracownika = 17,
   @Id_działu = 2,
   @Data_wypłaty = '2024-03-01',
   @Wysokość_pensji = 10910.00;


--   ----------------Dzialy zarz projektami----------------

--   select * from Projekty
--   select * from Działy

   exec Przypisz_projekt_do_działu
   @Id_projektu = 1,
   @Id_działu = 2,
   @Liczba_godzin = 790,
   @Data_początku = '2023-11-10',
   @Data_ukończenia = null,
   @Status_projektu = 'W trakcie',
   @Budżet = 200000;

   exec Przypisz_projekt_do_działu
   @Id_projektu = 2,
   @Id_działu = 4,
   @Liczba_godzin = 1590,
   @Data_początku = '2023-12-10',
   @Data_ukończenia = null,
   @Status_projektu = 'W trakcie',
   @Budżet = 370000;

   exec Przypisz_projekt_do_działu
   @Id_projektu = 3,
   @Id_działu = 1,
   @Liczba_godzin = 990,
   @Data_początku = '2023-01-10',
   @Data_ukończenia = null,
   @Status_projektu = 'Odrzucony',
   @Budżet = 310000;

   exec Przypisz_projekt_do_działu
   @Id_projektu = 4,
   @Id_działu = 3,
   @Liczba_godzin = 1790,
   @Data_początku = '2023-02-10',
   @Data_ukończenia = null,
   @Status_projektu = 'W trakcie',
   @Budżet = 430000;

   exec Przypisz_projekt_do_działu
   @Id_projektu = 5,
   @Id_działu = 1,
   @Liczba_godzin = 590,
   @Data_początku = '2023-03-10',
   @Data_ukończenia = null,
   @Status_projektu = 'W trakcie',
   @Budżet = 170000;

   exec Przypisz_projekt_do_działu
   @Id_projektu = 6,
   @Id_działu = 2,
   @Liczba_godzin = 690,
   @Data_początku = '2023-05-10',
   @Data_ukończenia = null,
   @Status_projektu = 'Nieaktywny',
   @Budżet = 197000;

   --update Działy_zarządzają_projektami
   --set Data_ukończenia = null
   --where Id_projektu = 5

   --select * from Działy_zarządzają_projektami

----------------------Pracownicy realizuja projekty------------------------

exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 1,
   @Id_projektu = 1111,
   @Stawka_godzinowa = 280,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 1,
   @Id_projektu = 4,
   @Stawka_godzinowa = 280,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 2,
   @Id_projektu = 1,
   @Stawka_godzinowa = 273,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 2,
   @Id_projektu = 2,
   @Stawka_godzinowa = 273,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 2,
   @Id_projektu = 3,
   @Stawka_godzinowa = 273,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 3,
   @Id_projektu = 4,
   @Stawka_godzinowa = 276,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 3,
   @Id_projektu = 1,
   @Stawka_godzinowa = 276,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 4,
   @Id_projektu = 1,
   @Stawka_godzinowa = 281,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 4,
   @Id_projektu = 5,
   @Stawka_godzinowa = 281,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 4,
   @Id_projektu = 6,
   @Stawka_godzinowa = 281,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 5,
   @Id_projektu = 5,
   @Stawka_godzinowa = 266,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 5,
   @Id_projektu = 2,
   @Stawka_godzinowa = 266,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 6,
   @Id_projektu = 5,
   @Stawka_godzinowa = 276,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 6,
   @Id_projektu = 6,
   @Stawka_godzinowa = 276,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 7,
   @Id_projektu = 1,
   @Stawka_godzinowa = 266,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 7,
   @Id_projektu = 3,
   @Stawka_godzinowa = 266,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 8,
   @Id_projektu = 6,
   @Stawka_godzinowa = 266,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 8,
   @Id_projektu = 2,
   @Stawka_godzinowa = 266,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 9,
   @Id_projektu = 3,
   @Stawka_godzinowa = 286,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 9,
   @Id_projektu = 6,
   @Stawka_godzinowa = 286,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 10,
   @Id_projektu = 1,
   @Stawka_godzinowa = 296,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 10,
   @Id_projektu = 5,
   @Stawka_godzinowa = 296,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 10,
   @Id_projektu = 6,
   @Stawka_godzinowa = 296,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 11,
   @Id_projektu = 4,
   @Stawka_godzinowa = 296,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 11,
   @Id_projektu = 5,
   @Stawka_godzinowa = 296,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 11,
   @Id_projektu = 1,
   @Stawka_godzinowa = 296,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 12,
   @Id_projektu = 1,
   @Stawka_godzinowa = 266,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 12,
   @Id_projektu = 2,
   @Stawka_godzinowa = 266,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 13,
   @Id_projektu = 3,
   @Stawka_godzinowa = 276,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 13,
   @Id_projektu = 1,
   @Stawka_godzinowa = 276,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 14,
   @Id_projektu = 3,
   @Stawka_godzinowa = 296,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 15,
   @Id_projektu = 3,
   @Stawka_godzinowa = 296,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 15,
   @Id_projektu = 4,
   @Stawka_godzinowa = 296,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 15,
   @Id_projektu = 6,
   @Stawka_godzinowa = 296,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 16,
   @Id_projektu = 2,
   @Stawka_godzinowa = 296,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 16,
   @Id_projektu = 3,
   @Stawka_godzinowa = 296,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 16,
   @Id_projektu = 4,
   @Stawka_godzinowa = 296,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 17,
   @Id_projektu = 1,
   @Stawka_godzinowa = 276,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 17,
   @Id_projektu = 2,
   @Stawka_godzinowa = 296,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 17,
   @Id_projektu = 3,
   @Stawka_godzinowa = 296,
   @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 17,
   @Id_projektu = 4,
   @Stawka_godzinowa = 296,
    @Liczba_godzin = 160;

   exec Przypisz_pracownika_do_projektu
   @Id_pracownika = 17,
   @Id_projektu = 5,
   @Stawka_godzinowa = 296,
   @Liczba_godzin = 160;


   


-- ----------------------Pracownicy realiz zadania---------------------


  exec Przypisz_pracownika_do_zadania
   @Id_pracownika = 1,
   @Id_zadania = 1,
   @Data_początku = '2024-01-10',
   @Data_ukończenia = null,
   @Status_zadania = 'W trakcie',
   @Miejsce_realizacji = 'Katowice',
   @Liczba_godzin = 50;

   exec Przypisz_pracownika_do_zadania
   @Id_pracownika = 2,
   @Id_zadania = 2,
   @Data_początku = '2024-01-10',
   @Data_ukończenia = null,
   @Status_zadania = 'W trakcie',
   @Miejsce_realizacji = 'Katowice',
   @Liczba_godzin = 50;

   exec Przypisz_pracownika_do_zadania
   @Id_pracownika = 3,
   @Id_zadania = 2,
   @Data_początku = '2024-01-10',
   @Data_ukończenia = null,
   @Status_zadania = 'W trakcie',
   @Miejsce_realizacji = 'Katowice',
   @Liczba_godzin = 50;

   exec Przypisz_pracownika_do_zadania
   @Id_pracownika = 4,
   @Id_zadania = 3,
   @Data_początku = '2024-01-10',
   @Data_ukończenia = null,
   @Status_zadania = 'W trakcie',
   @Miejsce_realizacji = 'Katowice',
   @Liczba_godzin = 30;

   exec Przypisz_pracownika_do_zadania
   @Id_pracownika = 5,
   @Id_zadania = 1,
   @Data_początku = '2024-01-10',
   @Data_ukończenia = null,
   @Status_zadania = 'W trakcie',
   @Miejsce_realizacji = 'Katowice',
   @Liczba_godzin = 10;

   exec Przypisz_pracownika_do_zadania
   @Id_pracownika = 6,
   @Id_zadania = 4,
   @Data_początku = '2024-01-10',
   @Data_ukończenia = null,
   @Status_zadania = 'W trakcie',
   @Miejsce_realizacji = 'Katowice',
   @Liczba_godzin = 40;

   exec Przypisz_pracownika_do_zadania
   @Id_pracownika = 7,
   @Id_zadania = 5,
   @Data_początku = '2024-01-10',
   @Data_ukończenia = null,
   @Status_zadania = 'W trakcie',
   @Miejsce_realizacji = 'Katowice',
   @Liczba_godzin = 50;

   exec Przypisz_pracownika_do_zadania
   @Id_pracownika = 8,
   @Id_zadania = 6,
   @Data_początku = '2024-01-10',
   @Data_ukończenia = null,
   @Status_zadania = 'W trakcie',
   @Miejsce_realizacji = 'Katowice',
   @Liczba_godzin = 60;

   exec Przypisz_pracownika_do_zadania
   @Id_pracownika = 9,
   @Id_zadania = 6,
   @Data_początku = '2024-01-10',
   @Data_ukończenia = null,
   @Status_zadania = 'W trakcie',
   @Miejsce_realizacji = 'Katowice',
   @Liczba_godzin = 60;

   exec Przypisz_pracownika_do_zadania
   @Id_pracownika = 10,
   @Id_zadania = 7,
   @Data_początku = '2024-01-10',
   @Data_ukończenia = null,
   @Status_zadania = 'W trakcie',
   @Miejsce_realizacji = 'Katowice',
   @Liczba_godzin = 70;

   exec Przypisz_pracownika_do_zadania
   @Id_pracownika = 11,
   @Id_zadania = 2,
   @Data_początku = '2024-01-10',
   @Data_ukończenia = null,
   @Status_zadania = 'W trakcie',
   @Miejsce_realizacji = 'Katowice',
   @Liczba_godzin = 20;

   exec Przypisz_pracownika_do_zadania
   @Id_pracownika = 12,
   @Id_zadania = 10,
   @Data_początku = '2024-01-10',
   @Data_ukończenia = null,
   @Status_zadania = 'W trakcie',
   @Miejsce_realizacji = 'Katowice',
   @Liczba_godzin = 100;

   exec Przypisz_pracownika_do_zadania
   @Id_pracownika = 13,
   @Id_zadania = 7,
   @Data_początku = '2024-01-10',
   @Data_ukończenia = null,
   @Status_zadania = 'W trakcie',
   @Miejsce_realizacji = 'Katowice',
   @Liczba_godzin = 70;

   exec Przypisz_pracownika_do_zadania
   @Id_pracownika = 14,
   @Id_zadania = 8,
   @Data_początku = '2024-01-10',
   @Data_ukończenia = null,
   @Status_zadania = 'W trakcie',
   @Miejsce_realizacji = 'Katowice',
   @Liczba_godzin = 80;

   exec Przypisz_pracownika_do_zadania
   @Id_pracownika = 15,
   @Id_zadania = 9,
   @Data_początku = '2024-01-10',
   @Data_ukończenia = null,
   @Status_zadania = 'W trakcie',
   @Miejsce_realizacji = 'Katowice',
   @Liczba_godzin = 90;

   exec Przypisz_pracownika_do_zadania
   @Id_pracownika = 15,
   @Id_zadania = 7,
   @Data_początku = '2024-01-10',
   @Data_ukończenia = null,
   @Status_zadania = 'W trakcie',
   @Miejsce_realizacji = 'Katowice',
   @Liczba_godzin = 70;

   exec Przypisz_pracownika_do_zadania
   @Id_pracownika = 16,
   @Id_zadania = 10,
   @Data_początku = '2024-01-10',
   @Data_ukończenia = null,
   @Status_zadania = 'W trakcie',
   @Miejsce_realizacji = 'Katowice',
   @Liczba_godzin = 100;

   exec Przypisz_pracownika_do_zadania
   @Id_pracownika = 16,
   @Id_zadania = 6,
   @Data_początku = '2024-01-10',
   @Data_ukończenia = null,
   @Status_zadania = 'Nieaktywne',
   @Miejsce_realizacji = 'Katowice',
   @Liczba_godzin = 60;

   exec Przypisz_pracownika_do_zadania
   @Id_pracownika = 17,
   @Id_zadania = 8,
   @Data_początku = '2024-01-10',
   @Data_ukończenia = null,
   @Status_zadania = 'Odrzucone',
   @Miejsce_realizacji = 'Katowice',
   @Liczba_godzin = 80;

   exec Przypisz_pracownika_do_zadania
   @Id_pracownika = 17,
   @Id_zadania = 7,
   @Data_początku = '2024-01-10',
   @Data_ukończenia = null,
   @Status_zadania = 'W trakcie',
   @Miejsce_realizacji = 'Katowice',
   @Liczba_godzin = 90;

   --select * from Pracownicy_realizują_zadania

   --update Pracownicy_realizują_zadania
   --set Data_ukończenia = null
   --where Id_pracownika = 1 and Id_zadania = 1

--   --------------Zadanie przypisane do projektow----------------

   exec Dodaj_zadanie_do_projektu
   @Id_projektu = 1,
   @Id_zadania = 1,
   @Stan_zadania = 'Aktywne';

   exec Dodaj_zadanie_do_projektu
   @Id_projektu = 1,
   @Id_zadania = 2,
   @Stan_zadania = 'Aktywne';

   exec Dodaj_zadanie_do_projektu
   @Id_projektu = 1,
   @Id_zadania = 3,
   @Stan_zadania = 'Nieaktywne';

   exec Dodaj_zadanie_do_projektu
   @Id_projektu = 2,
   @Id_zadania = 3,
   @Stan_zadania = 'Nieaktywne';

   exec Dodaj_zadanie_do_projektu
   @Id_projektu = 2,
   @Id_zadania = 4,
   @Stan_zadania = 'Aktywne';

   exec Dodaj_zadanie_do_projektu
   @Id_projektu = 2,
   @Id_zadania = 5,
   @Stan_zadania = 'Aktywne';

    exec Dodaj_zadanie_do_projektu
   @Id_projektu = 3,
   @Id_zadania = 6,
   @Stan_zadania = 'Aktywne';

    exec Dodaj_zadanie_do_projektu
   @Id_projektu = 3,
   @Id_zadania = 7,
   @Stan_zadania = 'Aktywne';

    exec Dodaj_zadanie_do_projektu
   @Id_projektu = 3,
   @Id_zadania = 8,
   @Stan_zadania = 'Aktywne';

   exec Dodaj_zadanie_do_projektu
   @Id_projektu = 4,
   @Id_zadania = 8,
   @Stan_zadania = 'Aktywne';

    exec Dodaj_zadanie_do_projektu
   @Id_projektu = 4,
   @Id_zadania = 9,
   @Stan_zadania = 'Aktywne';

   exec Dodaj_zadanie_do_projektu
   @Id_projektu = 5,
   @Id_zadania = 7,
   @Stan_zadania = 'Aktywne';

    exec Dodaj_zadanie_do_projektu
   @Id_projektu = 5,
   @Id_zadania = 1,
   @Stan_zadania = 'Aktywne';

   exec Dodaj_zadanie_do_projektu
   @Id_projektu = 3,
   @Id_zadania = 10,
   @Stan_zadania = 'Aktywne';

    exec Dodaj_zadanie_do_projektu
   @Id_projektu = 6,
   @Id_zadania = 8,
   @Stan_zadania = 'Aktywne';

   
-------------------------Projekty i role----------------------------------

exec Przypisz_role_do_projektu
   @Id_projektu = 1,
   @Id_roli = 1;

   exec Przypisz_role_do_projektu
   @Id_projektu = 1,
   @Id_roli = 2;

   exec Przypisz_role_do_projektu
   @Id_projektu = 1,
   @Id_roli = 3;

   exec Przypisz_role_do_projektu
   @Id_projektu = 1,
   @Id_roli = 4;

   exec Przypisz_role_do_projektu
   @Id_projektu = 1,
   @Id_roli = 5;

   exec Przypisz_role_do_projektu
   @Id_projektu = 1,
   @Id_roli = 6;

   exec Przypisz_role_do_projektu
   @Id_projektu = 1,
   @Id_roli = 7;

   exec Przypisz_role_do_projektu
   @Id_projektu = 1,
   @Id_roli = 8;

   exec Przypisz_role_do_projektu
   @Id_projektu = 1,
   @Id_roli = 9;

   exec Przypisz_role_do_projektu
   @Id_projektu = 1,
   @Id_roli = 10;

   exec Przypisz_role_do_projektu
   @Id_projektu = 2,
   @Id_roli = 1;

   exec Przypisz_role_do_projektu
   @Id_projektu = 2,
   @Id_roli = 2;

   exec Przypisz_role_do_projektu
   @Id_projektu = 2,
   @Id_roli = 3;

   exec Przypisz_role_do_projektu
   @Id_projektu = 2,
   @Id_roli = 4;

   exec Przypisz_role_do_projektu
   @Id_projektu = 2,
   @Id_roli = 5;

   exec Przypisz_role_do_projektu
   @Id_projektu = 2,
   @Id_roli = 6;

   exec Przypisz_role_do_projektu
   @Id_projektu = 2,
   @Id_roli = 7;

   exec Przypisz_role_do_projektu
   @Id_projektu = 2,
   @Id_roli = 8;

   exec Przypisz_role_do_projektu
   @Id_projektu = 2,
   @Id_roli = 9;

   exec Przypisz_role_do_projektu
   @Id_projektu = 2,
   @Id_roli = 10;

   exec Przypisz_role_do_projektu
   @Id_projektu = 3,
   @Id_roli = 1;

   exec Przypisz_role_do_projektu
   @Id_projektu = 3,
   @Id_roli = 2;

   exec Przypisz_role_do_projektu
   @Id_projektu = 3,
   @Id_roli = 3;

   exec Przypisz_role_do_projektu
   @Id_projektu = 3,
   @Id_roli = 4;

   exec Przypisz_role_do_projektu
   @Id_projektu = 3,
   @Id_roli = 5;

   exec Przypisz_role_do_projektu
   @Id_projektu = 3,
   @Id_roli = 6;

   exec Przypisz_role_do_projektu
   @Id_projektu = 3,
   @Id_roli = 7;

   exec Przypisz_role_do_projektu
   @Id_projektu = 3,
   @Id_roli = 8;

   exec Przypisz_role_do_projektu
   @Id_projektu = 3,
   @Id_roli = 9;

   exec Przypisz_role_do_projektu
   @Id_projektu = 3,
   @Id_roli = 10;

   exec Przypisz_role_do_projektu
   @Id_projektu = 4,
   @Id_roli = 1;

   exec Przypisz_role_do_projektu
   @Id_projektu = 4,
   @Id_roli = 2;

   exec Przypisz_role_do_projektu
   @Id_projektu = 4,
   @Id_roli = 3;

   exec Przypisz_role_do_projektu
   @Id_projektu = 4,
   @Id_roli = 4;

   exec Przypisz_role_do_projektu
   @Id_projektu = 4,
   @Id_roli = 5;

   exec Przypisz_role_do_projektu
   @Id_projektu = 4,
   @Id_roli = 6;

   exec Przypisz_role_do_projektu
   @Id_projektu = 4,
   @Id_roli = 7;

   exec Przypisz_role_do_projektu
   @Id_projektu = 4,
   @Id_roli = 8;

   exec Przypisz_role_do_projektu
   @Id_projektu = 4,
   @Id_roli = 9;

   exec Przypisz_role_do_projektu
   @Id_projektu = 4,
   @Id_roli = 10;

   exec Przypisz_role_do_projektu
   @Id_projektu = 5,
   @Id_roli = 1;

   exec Przypisz_role_do_projektu
   @Id_projektu = 5,
   @Id_roli = 2;

   exec Przypisz_role_do_projektu
   @Id_projektu = 5,
   @Id_roli = 3;

   exec Przypisz_role_do_projektu
   @Id_projektu = 5,
   @Id_roli = 4;

   exec Przypisz_role_do_projektu
   @Id_projektu = 5,
   @Id_roli = 5;

   exec Przypisz_role_do_projektu
   @Id_projektu = 5,
   @Id_roli = 6;

   exec Przypisz_role_do_projektu
   @Id_projektu = 5,
   @Id_roli = 7;

   exec Przypisz_role_do_projektu
   @Id_projektu = 5,
   @Id_roli = 8;

   exec Przypisz_role_do_projektu
   @Id_projektu = 5,
   @Id_roli = 9;

   exec Przypisz_role_do_projektu
   @Id_projektu = 5,
   @Id_roli = 10;

   exec Przypisz_role_do_projektu
   @Id_projektu = 6,
   @Id_roli = 1;

   exec Przypisz_role_do_projektu
   @Id_projektu = 6,
   @Id_roli = 2;

   exec Przypisz_role_do_projektu
   @Id_projektu = 6,
   @Id_roli = 3;

   exec Przypisz_role_do_projektu
   @Id_projektu = 6,
   @Id_roli = 4;

   exec Przypisz_role_do_projektu
   @Id_projektu = 6,
   @Id_roli = 5;

   exec Przypisz_role_do_projektu
   @Id_projektu = 6,
   @Id_roli = 6;

   exec Przypisz_role_do_projektu
   @Id_projektu = 6,
   @Id_roli = 7;

   exec Przypisz_role_do_projektu
   @Id_projektu = 6,
   @Id_roli = 8;

   exec Przypisz_role_do_projektu
   @Id_projektu = 6,
   @Id_roli = 9;

   exec Przypisz_role_do_projektu
   @Id_projektu = 6,
   @Id_roli = 10;

   

--------------------------Zadania i role---------------------------

exec Przypisz_role_do_zadania
   @Id_zadania = 1,
   @Id_roli = 1;

   exec Przypisz_role_do_zadania
   @Id_zadania = 1,
   @Id_roli = 10;

   exec Przypisz_role_do_zadania
   @Id_zadania = 1,
   @Id_roli = 5;

   exec Przypisz_role_do_zadania
   @Id_zadania = 1,
   @Id_roli = 6;

   exec Przypisz_role_do_zadania
   @Id_zadania = 2,
   @Id_roli = 2;

   exec Przypisz_role_do_zadania
   @Id_zadania = 2,
   @Id_roli = 10;

   exec Przypisz_role_do_zadania
   @Id_zadania = 2,
   @Id_roli = 4;

   exec Przypisz_role_do_zadania
   @Id_zadania = 2,
   @Id_roli = 8;

   exec Przypisz_role_do_zadania
   @Id_zadania = 3,
   @Id_roli = 9;

   exec Przypisz_role_do_zadania
   @Id_zadania = 3,
   @Id_roli = 7;

   exec Przypisz_role_do_zadania
   @Id_zadania = 3,
   @Id_roli = 6;

   exec Przypisz_role_do_zadania
   @Id_zadania = 3,
   @Id_roli = 5;

   exec Przypisz_role_do_zadania
   @Id_zadania = 4,
   @Id_roli = 1;

   exec Przypisz_role_do_zadania
   @Id_zadania = 4,
   @Id_roli = 2;

   exec Przypisz_role_do_zadania
   @Id_zadania = 4,
   @Id_roli = 4;

   exec Przypisz_role_do_zadania
   @Id_zadania = 4,
   @Id_roli = 8;

   exec Przypisz_role_do_zadania
   @Id_zadania = 5,
   @Id_roli = 9;

   exec Przypisz_role_do_zadania
   @Id_zadania = 5,
   @Id_roli = 6;

   exec Przypisz_role_do_zadania
   @Id_zadania = 5,
   @Id_roli = 8;

   exec Przypisz_role_do_zadania
   @Id_zadania = 5,
   @Id_roli = 3;

   exec Przypisz_role_do_zadania
   @Id_zadania = 6,
   @Id_roli = 10;

   exec Przypisz_role_do_zadania
   @Id_zadania = 6,
   @Id_roli = 6;

   exec Przypisz_role_do_zadania
   @Id_zadania = 6,
   @Id_roli = 4;

   exec Przypisz_role_do_zadania
   @Id_zadania = 6,
   @Id_roli = 7;

   exec Przypisz_role_do_zadania
   @Id_zadania = 7,
   @Id_roli = 2;

   exec Przypisz_role_do_zadania
   @Id_zadania = 7,
   @Id_roli = 1;

   exec Przypisz_role_do_zadania
   @Id_zadania = 7,
   @Id_roli = 3;

   exec Przypisz_role_do_zadania
   @Id_zadania = 7,
   @Id_roli = 7;

   exec Przypisz_role_do_zadania
   @Id_zadania = 8,
   @Id_roli = 2;

   exec Przypisz_role_do_zadania
   @Id_zadania = 8,
   @Id_roli = 8;

   exec Przypisz_role_do_zadania
   @Id_zadania = 8,
   @Id_roli = 6;

   exec Przypisz_role_do_zadania
   @Id_zadania = 8,
   @Id_roli = 5;

   exec Przypisz_role_do_zadania
   @Id_zadania = 9,
   @Id_roli = 1;

   exec Przypisz_role_do_zadania
   @Id_zadania = 9,
   @Id_roli = 10;

   exec Przypisz_role_do_zadania
   @Id_zadania = 9,
   @Id_roli = 5;

   exec Przypisz_role_do_zadania
   @Id_zadania = 9,
   @Id_roli = 6;

   exec Przypisz_role_do_zadania
   @Id_zadania = 10,
   @Id_roli = 4;

   exec Przypisz_role_do_zadania
   @Id_zadania = 10,
   @Id_roli = 7;

   exec Przypisz_role_do_zadania
   @Id_zadania = 10,
   @Id_roli = 3;

   exec Przypisz_role_do_zadania
   @Id_zadania = 10,
   @Id_roli = 9;


--  ----------------------------------------------------
--  select *
--  from Pracownicy

--DECLARE @id_pracownika INT = 2; 
--DECLARE @rok INT = 2024;
--DECLARE @miesiac INT = 2; 

--EXEC Wypisz_pensje_pracownika_proc @id_pracownika, @rok, @miesiac;

--DECLARE @id_pracownika INT = 1011; 
--EXEC Wypisz_wiek_pracownika_proc @id_pracownika
