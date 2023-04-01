/*Clear environment*/

drop table POSADKY_V_ALIANCII;
drop table PIRATSKE_CHARAKTERISTIKY;
drop table ALIANCIE_V_BITKE;
drop table  LOD;
drop table  FLOTILA;
drop table  KAPITAN;
drop table  PIRAT;
drop table  ALIANCIA;
drop table  BITKA;
drop table  PRISTAV;
drop table  POSADKA;
drop table  CHARAKTERISTIKY;
drop sequence ID_POSADKY_seq;

/*Table POSADKA is using required automatic sequence(starting 1000) combined with manual sequence*/
/*Tables*/
CREATE TABLE CHARAKTERISTIKY (
    /*PK*/
    ID_charakteristiky INT GENERATED AS IDENTITY PRIMARY KEY,
    /*Attributes*/
    Nazov VARCHAR(50) NOT NULL,
    Popis VARCHAR(250) NOT NULL
);

CREATE SEQUENCE ID_POSADKY_seq START WITH 1000;

CREATE TABLE POSADKA (
    /*PK*/
    ID_posadky INT DEFAULT ID_POSADKY_seq.nextval NOT NULL PRIMARY KEY,
    /*Attributes*/
    Jolly_roger VARCHAR(250) NOT NULL
);
CREATE TABLE PRISTAV (
    /*PK*/
    ID_pristavu INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    /*FK*/
    ID_teritorium_posadky INT REFERENCES POSADKA(ID_posadky),
    /*Attributes*/
    Lokalita VARCHAR(250) NOT NULL,
    Kapacita INT NOT NULL,
    Nazov_poloostrova VARCHAR(150) NOT NULL
);
CREATE TABLE BITKA (
    /*PK*/
    ID_bitky INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    /*FK*/
    ID_pristavu INT REFERENCES PRISTAV(ID_pristavu),
    /*Attributes*/
    Pocet_strat INT NOT NULL,
    Miesto_odohrania VARCHAR(150) NOT NULL
);
CREATE TABLE ALIANCIA (
    /*PK*/
    ID_aliancie INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    /*FK*/
    ID_pristavu INT REFERENCES PRISTAV(ID_pristavu),
    /*Attributes*/
    Nazov VARCHAR(50) NOT NULL
);

CREATE TABLE PIRAT (
    /*PK*/
    ID_pirata INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    /*FK*/
    ID_posadka INT REFERENCES POSADKA(ID_posadky),
    /*Attributes*/
    rodne_cislo VARCHAR(11) ,
    CHECK (REGEXP_LIKE(rodne_cislo ,'^[0-9]{6}/[0-9]{4}$')),
    Meno VARCHAR(50) NOT NULL,
    Prezyvka VARCHAR(50) NOT NULL,
    Pozicia VARCHAR(50) NOT NULL,
    Farba_brady VARCHAR(50) NOT NULL,
        CHECK ( Farba_brady IN ('Čierna', 'Červená', 'Ryšavá','Blond','Hnedá','Šedivá', 'Biela')),
    Vek INT NOT NULL
);


/*KAPITAN is a special type of PIRAT, connection is based on shared primary key. This solution is reducing data
  redundancy of attributes which PIRAT and KAPITAN are sharing.
*/
CREATE TABLE KAPITAN (
     ID_pirata UNIQUE,
    /*FK*/
    FOREIGN KEY (ID_pirata) REFERENCES  PIRAT (ID_pirata),
    /*Attributes*/
    Roky_praxe INT NOT NULL
);
CREATE TABLE FLOTILA (
    /*PK*/
    ID_flotily INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    /*FK*/
    ID_posadka INT REFERENCES POSADKA(ID_posadky),
    ID_div_kapitana INT REFERENCES PIRAT(ID_pirata)
    /*Attributes*/
);

CREATE TABLE LOD (
    /*PK*/
    ID_lode INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    /*FK*/
    ID_flotily INT REFERENCES FLOTILA(ID_flotily),
    ID_bitky INT REFERENCES BITKA(ID_bitky),
    ID_div_kapitana INT REFERENCES KAPITAN(ID_PIRATA),
    ID_pristavu INT REFERENCES PRISTAV(ID_pristavu),
    /*Attributes*/
    Typ_lode VARCHAR(50) NOT NULL,
        CHECK ( Typ_lode IN ('Fregata', 'Korzár','Barka','Galey','Šalupa','Brigantína','Fluyta')),
    Kapacita INT NOT NULL
);
/*junction tables*/
CREATE TABLE ALIANCIE_V_BITKE (
    ID_aliancie INT NOT NULL,
    ID_bitky INT NOT NULL,
    PRIMARY KEY (ID_aliancie, ID_bitky),
    FOREIGN KEY (ID_aliancie) REFERENCES ALIANCIA(ID_aliancie),
    FOREIGN KEY (ID_bitky) REFERENCES BITKA(ID_bitky)
);
CREATE TABLE PIRATSKE_CHARAKTERISTIKY (
    ID_charakteristiky INT NOT NULL,
    ID_pirata INT NOT NULL,
    PRIMARY KEY (ID_charakteristiky, ID_pirata),
    FOREIGN KEY (ID_charakteristiky) REFERENCES CHARAKTERISTIKY(ID_charakteristiky),
    FOREIGN KEY (ID_pirata) REFERENCES PIRAT(ID_pirata)
);
CREATE TABLE POSADKY_V_ALIANCII (
    ID_posadky INT NOT NULL,
    ID_aliancie INT NOT NULL,
    PRIMARY KEY (ID_posadky, ID_aliancie),
    FOREIGN KEY (ID_posadky) REFERENCES POSADKA(ID_posadky),
    FOREIGN KEY (ID_aliancie) REFERENCES ALIANCIA(ID_aliancie)
);

/*Inserting values*/
--charakteristiky
INSERT INTO CHARAKTERISTIKY (Nazov, Popis)
VALUES ('Páska cez oko', 'oko má prekryté páskou');

INSERT INTO CHARAKTERISTIKY (Nazov, Popis)
VALUES ('Drevená noha', 'chýbajúca noha bola nahradená drevenou protézou');

INSERT INTO CHARAKTERISTIKY (Nazov, Popis)
VALUES ('Papagáj', 'pirát vlastní papagája, ktorý mu vačšinou sedí na ramene');

INSERT INTO CHARAKTERISTIKY (Nazov, Popis)
VALUES ('Klobúk', 'pirát nosí klobúk, najčastejšie 3-hranný');

INSERT INTO CHARAKTERISTIKY (Nazov, Popis)
VALUES ('Šatka', 'šatka na hlave,na ochranu pred slnkom');

--posadka
INSERT INTO POSADKA (ID_posadky,JOLLY_ROGER)
VALUES (1,'čierna s lebkou');

INSERT INTO POSADKA (ID_posadky,JOLLY_ROGER)
VALUES (2,'horiace mravce');

INSERT INTO POSADKA (JOLLY_ROGER)
VALUES ('červená s dvomi šablami');

INSERT INTO POSADKA (JOLLY_ROGER)
VALUES ('žltá s papagájom');

INSERT INTO POSADKA (JOLLY_ROGER)
VALUES ('čierna s kosťami a lebkou');

--pristav
INSERT INTO PRISTAV (ID_teritorium_posadky, Lokalita, Kapacita, Nazov_poloostrova)
values (1,'Afrika',4,'Madagaskar');

INSERT INTO PRISTAV (ID_teritorium_posadky, Lokalita, Kapacita, Nazov_poloostrova)
values (2,'Grecko',4,'Kreta');

INSERT INTO PRISTAV (ID_teritorium_posadky, Lokalita, Kapacita, Nazov_poloostrova)
values (1,'Dunaj',5,'Bratislava');

--bitka
insert into BITKA (ID_pristavu, Pocet_strat, Miesto_odohrania)
values (1,50,'Bratislava');

insert into BITKA (ID_pristavu, Pocet_strat, Miesto_odohrania)
values (2,50,'Kosice');

insert into BITKA (ID_pristavu, Pocet_strat, Miesto_odohrania)
values (1,150,'Bratislava');

--aliancia
insert into ALIANCIA (ID_pristavu, Nazov)
values (2,'Cool Guild');

insert into ALIANCIA (ID_pristavu, Nazov)
values (1,'BAD Guild');

insert into ALIANCIA (ID_pristavu, Nazov)
values (1,'Lolko guild');

--pirat
INSERT INTO PIRAT (ID_posadka, rodne_cislo, Meno, Prezyvka, Pozicia, Farba_brady, Vek)
VALUES(1, '930101/1234', 'Jack', 'Sparrow', 'Kapitán', 'Čierna', 45);

INSERT INTO PIRAT (ID_posadka, rodne_cislo, Meno, Prezyvka, Pozicia, Farba_brady, Vek)
VALUES(2, '880601/4321', 'Hector', 'Barbossa', 'Kapitán', 'Biela', 60);

INSERT INTO PIRAT (ID_posadka, rodne_cislo, Meno, Prezyvka, Pozicia, Farba_brady, Vek)
VALUES(1, '940504/2468', 'Will', 'Turner', 'Upratovač', 'Blond', 30);

INSERT INTO PIRAT (ID_posadka, rodne_cislo, Meno, Prezyvka, Pozicia, Farba_brady, Vek)
VALUES(1000, '940555/2468', 'Phil', 'Sailor', 'Kapitán', 'Ryšavá', 43);

INSERT INTO PIRAT (ID_posadka, rodne_cislo, Meno, Prezyvka, Pozicia, Farba_brady, Vek)
VALUES(1000, '940804/2468', 'Robo', 'Morský vlk', 'Kormidelník', 'Čierna', 34);

INSERT INTO PIRAT (ID_posadka, rodne_cislo, Meno, Prezyvka, Pozicia, Farba_brady, Vek)
VALUES(1, '640504/2468', 'Henry', 'Čiernofúz', 'Strelec', 'Biela', 20);

--kapitan
INSERT INTO KAPITAN(ID_pirata, Roky_praxe)
VALUES(1,5);

INSERT INTO KAPITAN(ID_pirata, Roky_praxe)
VALUES(2,4);

INSERT INTO KAPITAN(ID_pirata, Roky_praxe)
VALUES(3,4);

--flotila
INSERT INTO FLOTILA (ID_posadka, ID_div_kapitana)
VALUES(1,1);
INSERT INTO FLOTILA (ID_posadka, ID_div_kapitana)
VALUES(1,2);
INSERT INTO FLOTILA (ID_posadka, ID_div_kapitana)
VALUES(2,1);

--lod
INSERT INTO LOD (ID_flotily, ID_bitky, ID_div_kapitana, ID_pristavu, Typ_lode, Kapacita)
VALUES (1,1,1,1,'Barka',15);
INSERT INTO LOD (ID_flotily, ID_div_kapitana, ID_pristavu, Typ_lode, Kapacita)
VALUES (2,1,1,'Korzár',40);
INSERT INTO LOD (ID_flotily, ID_bitky, ID_div_kapitana, ID_pristavu, Typ_lode, Kapacita)
VALUES (1,2,1,2,'Fregata',20);

--aliancie v bitke
INSERT INTO ALIANCIE_V_BITKE (ID_aliancie, ID_bitky)
VALUES (1,1);
INSERT INTO ALIANCIE_V_BITKE (ID_aliancie, ID_bitky)
VALUES (1,2);
INSERT INTO ALIANCIE_V_BITKE (ID_aliancie, ID_bitky)
VALUES (2,3);
INSERT INTO ALIANCIE_V_BITKE (ID_aliancie, ID_bitky)
VALUES (1,3);

--piratske charakteristiky
INSERT INTO PIRATSKE_CHARAKTERISTIKY(ID_charakteristiky, ID_pirata)
VALUES (1,1);
INSERT INTO PIRATSKE_CHARAKTERISTIKY(ID_charakteristiky, ID_pirata)
VALUES (2,1);
INSERT INTO PIRATSKE_CHARAKTERISTIKY(ID_charakteristiky, ID_pirata)
VALUES (1,2);

--posadka v aliancii
INSERT INTO POSADKY_V_ALIANCII(ID_posadky, ID_aliancie)
VALUES (1,1);
INSERT INTO POSADKY_V_ALIANCII(ID_posadky, ID_aliancie)
VALUES (1,2);
INSERT INTO POSADKY_V_ALIANCII(ID_posadky, ID_aliancie)
VALUES (2,1);
INSERT INTO POSADKY_V_ALIANCII(ID_posadky, ID_aliancie)
VALUES (1000,2);



/*Selecting data from database*/

/* 1. Which ships are currently anchored in port on Madagaskar ?*/
SELECT LOD.ID_lode,LOD.Typ_lode
FROM LOD JOIN PRISTAV on LOD.ID_pristavu = PRISTAV.ID_pristavu
WHERE PRISTAV.Nazov_poloostrova = 'Madagaskar';

/*2. Territory of which crew are ports ?*/
SELECT PRISTAV.Nazov_poloostrova, POSADKA.ID_posadky, POSADKA.Jolly_roger
FROM PRISTAV JOIN POSADKA on PRISTAV.ID_teritorium_posadky = POSADKA.ID_posadky;

/*3. Which pirates are in  guild alliance*/
SELECT PIRAT.Meno, PIRAT.Prezyvka
FROM PIRAT JOIN POSADKY_V_ALIANCII on PIRAT.ID_posadka = POSADKY_V_ALIANCII.ID_posadky
JOIN ALIANCIA on POSADKY_V_ALIANCII.ID_aliancie = ALIANCIA.ID_aliancie
WHERE ALIANCIA.Nazov = 'Cool Guild';

/*4. What is average age of pirates in crews */
SELECT  POSADKA.ID_posadky, AVG(PIRAT.Vek) AS "Average age"
FROM POSADKA JOIN PIRAT on POSADKA.ID_posadky = PIRAT.ID_posadka
GROUP BY POSADKA.ID_posadky;

/*5. How many ships are in fleets */
SELECT FLOTILA.ID_Flotily, COUNT(LOD.ID_Lode) AS "Number of ships"
FROM FLOTILA JOIN LOD on FLOTILA.ID_flotily = LOD.ID_flotily
GROUP BY FLOTILA.ID_Flotily;

/*6. Which pirates have eye patch as a characteristic */
SELECT PIRAT.Meno, PIRAT.Prezyvka
FROM PIRAT
WHERE EXISTS(
    SELECT CHARAKTERISTIKY.Nazov FROM CHARAKTERISTIKY
    JOIN PIRATSKE_CHARAKTERISTIKY on CHARAKTERISTIKY.ID_charakteristiky = PIRATSKE_CHARAKTERISTIKY.ID_charakteristiky
    WHERE PIRAT.ID_pirata = PIRATSKE_CHARAKTERISTIKY.ID_pirata
    AND CHARAKTERISTIKY.Nazov = 'Páska cez oko');

/*7. Which crews were in battles, where number of casualties was greater then 100 */
SELECT * FROM POSADKA
WHERE POSADKA.ID_posadky IN (
    SELECT POSADKY_V_ALIANCII.ID_posadky FROM POSADKY_V_ALIANCII
    JOIN ALIANCIE_V_BITKE on POSADKY_V_ALIANCII.ID_aliancie = ALIANCIE_V_BITKE.ID_aliancie
    JOIN BITKA on ALIANCIE_V_BITKE.ID_bitky = BITKA.ID_bitky
    WHERE BITKA.Pocet_strat > 100
    );
