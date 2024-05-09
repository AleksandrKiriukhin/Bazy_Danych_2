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
 [Płeć] nvarchar(1) not null check ([Płeć] IN ('M', 'K')),
 [Kraj] nvarchar(60) not null,
 [Miasto] nvarchar(60) not null,
 [Adres] nvarchar(60) not null,
 [Uwagi] nvarchar(max) null,

 [Szef] int null,
 [Rola_pracownika] int not null

);

go

if OBJECT_ID(N'Działy',N'U') is not null
drop table Działy;
go
drop table if exists dbo.Działy;
go


CREATE TABLE Działy (

 [Id_Działu] int identity(1,1) not null primary key,
 [Nazwa_działu] nvarchar(50) not null,
 [Data_otwarcia] date not null,
 [Data_zamknięcia] date null,
 [Status_działu] nvarchar(15) not null check ([Status_działu] IN ('Otwarty', 'Zamknięty')),
 [Kraj] nvarchar(60) not null,
 [Miasto] nvarchar(60) not null,
 [Adres] nvarchar(60) not null,
 [Uwagi] nvarchar(max) null,

 [Id_kierownika] int not null

);

go

if OBJECT_ID(N'Stanowiska',N'U') is not null
drop table Stanowiska;
go
drop table if exists dbo.Stanowiska;
go


CREATE TABLE Stanowiska (

 [Id_Stanowiska] int identity(1,1) not null primary key,
 [Nazwa_stanowiska] nvarchar(max) not null,
 [Opis] nvarchar(max) null

);

go

if OBJECT_ID(N'Telefony',N'U') is not null
drop table Telefony;
go
drop table if exists dbo.Telefony;
go


CREATE TABLE Telefony (

    [Numer_telefonu] nvarchar(12) not null primary key
        CHECK (
            [Numer_telefonu] like '48 [0-9][0-9][0-9] [0-9][0-9][0-9] [0-9][0-9][0-9]'
            and len([Numer_telefonu]) = 12
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
 [Nazwa_firmy] nvarchar(max) not null,
 [Kraj] nvarchar(60) not null,
 [Miasto] nvarchar(60) not null,
 [Adres] nvarchar(60) not null,
 [Uwagi] nvarchar(max) null

);

go

if OBJECT_ID(N'Projekty',N'U') is not null
drop table Projekty;
go
drop table if exists dbo.Projekty;
go


CREATE TABLE Projekty (

 [Id_Projektu] int identity(1,1) not null primary key,
 [Nazwa_projektu] nvarchar(max) not null,
 [Cel_projektu] nvarchar(max) not null,
 [Uwagi] nvarchar(max) null,

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
 [Nazwa_zadania] nvarchar(max) not null,
 [Opis] nvarchar(max) null,
 [Uwagi] nvarchar(max) null

);

go

if OBJECT_ID(N'Role_Pracowników',N'U') is not null
drop table Role_Pracowników;
go
drop table if exists dbo.Role_Pracowników;
go


CREATE TABLE Role_Pracowników (

 [Id_Roli] int identity(1,1) not null primary key,
 [Nazwa_roli] nvarchar(max) not null,
 [Opis] nvarchar(max) null,
 [Uwagi] nvarchar(max) null

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
 [Id_działu] int not null

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
 [Data_końcowa] date null

);

go

if OBJECT_ID(N'Posiadanie_Telefonu',N'U') is not null
drop table Posiadanie_Telefonu;
go
drop table if exists dbo.Posiadanie_Telefonu;
go


CREATE TABLE Posiadanie_Telefonu (

 [Id_Posiadania] int identity(1,1) not null primary key,

 [Numer_telefonu] nvarchar(12) not null, 
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
 [Wysokość_pensji] float null,

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
 [Status_projektu] nvarchar(15) not null check ([Status_projektu] IN ('W trakcie', 'Nieaktywny', '‘Skończony', 'Odrzucony')),
 [Budżet] float not null,

 PRIMARY KEY ([Id_projektu], [Id_działu])

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

 [Stawka_godzinowa] float not null,
 [Liczba_godzin] int null,

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
 [Status_zadania] nvarchar(15) not null check ([Status_zadania] IN ('W trakcie', 'Aktywne', 'Nieaktywne', '‘Skończone', 'Odrzucone')),
 [Miejsce_realizacji] nvarchar(50) null,
 [Liczba_godzin] int not null,

 PRIMARY KEY ([Id_pracownika], [Id_zadania])

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
