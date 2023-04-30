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
drop materialized view PIRAT_DETAILS_BY_POSADKA;

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
    Pozicia VARCHAR(50),
    Farba_brady VARCHAR(50) NOT NULL,
        CHECK ( Farba_brady IN ('Čierna', 'Červená', 'Ryšavá','Blond','Hnedá','Šedivá', 'Biela')),
    Vek INT NOT NULL
);


/*KAPITAN is a special type of PIRAT, connection is based on shared primary key. This solution is reducing data
  redundancy of attributes which PIRAT and KAPITAN are sharing.
*/
CREATE TABLE KAPITAN (
    /*PK*/
    ID_pirata INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
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
    ID_Posadka INT REFERENCES POSADKA(ID_posadky),
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
values (1,'Afrika',10,'Madagaskar');

INSERT INTO PRISTAV (ID_teritorium_posadky, Lokalita, Kapacita, Nazov_poloostrova)
values (2,'Grecko',12,'Kreta');

INSERT INTO PRISTAV (ID_teritorium_posadky, Lokalita, Kapacita, Nazov_poloostrova)
values (1,'Dunaj',25,'Bratislava');

--bitka
insert into BITKA (ID_pristavu, Pocet_strat, Miesto_odohrania)
values (1,53,'Bratislava');

insert into BITKA (ID_pristavu, Pocet_strat, Miesto_odohrania)
values (2,56,'Kosice');

insert into BITKA (ID_pristavu, Pocet_strat, Miesto_odohrania)
values (1,154,'Bratislava');

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
INSERT INTO KAPITAN(Roky_praxe)
VALUES(5);

INSERT INTO KAPITAN(Roky_praxe)
VALUES(4);

INSERT INTO KAPITAN(Roky_praxe)
VALUES(4);

--flotila
INSERT INTO FLOTILA (ID_posadka, ID_div_kapitana)
VALUES(1,1);
INSERT INTO FLOTILA (ID_posadka, ID_div_kapitana)
VALUES(1,2);
INSERT INTO FLOTILA (ID_posadka, ID_div_kapitana)
VALUES(2,1);
INSERT INTO FLOTILA (ID_posadka, ID_div_kapitana)
VALUES(1000,4);

--lod
INSERT INTO LOD (ID_flotily, ID_bitky, ID_div_kapitana, ID_pristavu,ID_Posadka, Typ_lode, Kapacita)
VALUES (1,1,1,1,1,'Barka',15);
INSERT INTO LOD (ID_flotily, ID_div_kapitana, ID_pristavu,ID_Posadka, Typ_lode, Kapacita)
VALUES (2,1,1,2,'Korzár',40);
INSERT INTO LOD (ID_flotily, ID_bitky, ID_div_kapitana, ID_pristavu, ID_Posadka,Typ_lode, Kapacita)
VALUES (1,2,1,2,1000,'Fregata',20);

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


/*Triggers*/
/*After pirate is added to PIRAT table without specifying value of Pozicia,
  value is set to 'upratovač'*/
CREATE OR REPLACE TRIGGER PIRAT_POZ
    BEFORE INSERT ON PIRAT
    FOR EACH ROW
BEGIN
    IF :NEW.Pozicia IS NULL THEN
        :NEW.Pozicia := 'upratovač';
    END IF;
END;


/*After deleting from table LOD trigger will check if deleted ship was the only one in
  FLOTILA, if it was then it will delete FLOTILA also.
  It had to be compound trigger, becuase otherwise ships could not be counted(accesing table that is being modified)*/
CREATE OR REPLACE TRIGGER DELETE_FLOTILA
    FOR DELETE ON LOD
    COMPOUND TRIGGER

    TYPE t_flotila_ids IS TABLE OF FLOTILA.ID_flotily%TYPE INDEX BY PLS_INTEGER;
    v_flotila_ids t_flotila_ids;

    AFTER EACH ROW IS
    BEGIN
        v_flotila_ids(v_flotila_ids.COUNT + 1) := :OLD.ID_flotily;
    END AFTER EACH ROW;

    AFTER STATEMENT IS
        ship_count NUMBER;
    BEGIN
        FOR i IN v_flotila_ids.FIRST .. v_flotila_ids.LAST LOOP
            SELECT COUNT(*) INTO ship_count
            FROM LOD
            WHERE ID_flotily = v_flotila_ids(i);
            IF ship_count = 0 THEN
                DELETE FROM FLOTILA WHERE ID_flotily = v_flotila_ids(i);
            END IF;
        END LOOP;
    END AFTER STATEMENT;
END;


/*Procedure*/
/*Procedure prints out information about POSADKA, based on ID_posadky passed through argument*/
CREATE OR REPLACE PROCEDURE CREW_INFO (pro_id_posadka IN POSADKA.ID_posadky%TYPE)
AS
    CURSOR CURSOR_CREW IS
        SELECT POSADKA.ID_posadky, POSADKA.Jolly_roger, SUM(Kapacita) AS SHIP_CAPA,
               AVG(Vek) AS PIRATE_AGE
        FROM POSADKA JOIN LOD ON POSADKA.ID_posadky = LOD.ID_Posadka
        JOIN PIRAT ON POSADKA.ID_posadky = PIRAT.ID_posadka
        WHERE POSADKA.ID_posadky = pro_id_posadka
        GROUP BY POSADKA.ID_posadky, POSADKA.Jolly_roger;
    CREW_DATA CURSOR_CREW%ROWTYPE;
BEGIN
    OPEN CURSOR_CREW;
    FETCH CURSOR_CREW INTO CREW_DATA;
    CLOSE CURSOR_CREW;
    IF CREW_DATA.ID_posadky IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Crew ID does not exists');
    ELSE
        DBMS_OUTPUT.PUT_LINE('ID Crew: ' || CREW_DATA.ID_posadky);
        DBMS_OUTPUT.PUT_LINE('Jolly Rogger: ' || CREW_DATA.Jolly_roger);
        DBMS_OUTPUT.PUT_LINE('Capacity of ships: ' || CREW_DATA.SHIP_CAPA);
        DBMS_OUTPUT.PUT_LINE('Average age of pirates: '|| CREW_DATA.PIRATE_AGE);
    END IF;
END;

/*After battle procedure sets ID_pristavu as a territory of winning ALIANCIA,
  also port in which battle has taken place might be damaged so the procedure reduces
  port capacity by (Pocet_strat % 5)*/
CREATE OR REPLACE PROCEDURE CAPACITY_UPDATE(
    pro_aliance_id IN ALIANCIA.ID_aliancie%TYPE,
    pro_bitka_id IN BITKA.ID_bitky%TYPE
)AS
    current_capacity PRISTAV.Kapacita%TYPE;
    new_capacity PRISTAV.Kapacita%TYPE;
    pristav_id PRISTAV.ID_pristavu%TYPE;
    casualties BITKA.Pocet_strat%TYPE;
    aliance_exists NUMBER;
    bitka_exists NUMBER;
BEGIN
    -- Check if specified aliance exists
    SELECT COUNT(*) INTO aliance_exists FROM ALIANCIA WHERE ID_aliancie = pro_aliance_id;
    IF aliance_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Aliance ID does not exist');
    END IF;

    -- Check if specified bitka exists
    SELECT COUNT(*) INTO bitka_exists FROM BITKA WHERE ID_bitky = pro_bitka_id;
    IF bitka_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Battle ID does not exist');
    ELSE
        SELECT Pocet_strat INTO casualties FROM BITKA WHERE ID_bitky = pro_bitka_id;
        casualties := MOD(casualties,5);
    END IF;

    -- Get current capacity and check if reduction is valid
    SELECT PRISTAV.Kapacita,PRISTAV.ID_pristavu INTO current_capacity, pristav_id FROM PRISTAV
        JOIN BITKA on PRISTAV.ID_pristavu = BITKA.ID_pristavu WHERE ID_bitky = pro_bitka_id;
    new_capacity := current_capacity - casualties;
    IF new_capacity < 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Capacity reduction would result in negative capacity for the pristav');
    END IF;

    -- Update capacity of specified pristav
    UPDATE PRISTAV SET Kapacita = new_capacity WHERE ID_pristavu = pristav_id;

    -- Update territory of specified aliance to pristav's
    UPDATE ALIANCIA SET ID_pristavu = pristav_id WHERE ID_aliancie = pro_aliance_id;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;

/*Select use case for capacity of ship*/
WITH lod_info AS (
SELECT l.ID_lode,l.Typ_lode,
CASE
    WHEN l.Kapacita < 20 THEN 'Small'
    WHEN l.Kapacita >= 20 AND l.Kapacita < 50 THEN 'Medium'
    ELSE 'Large'
END AS size_category,f.ID_flotily
FROM LOD l LEFT JOIN FLOTILA f ON l.ID_flotily = f.ID_flotily)

SELECT li.ID_lode,li.Typ_lode,li.size_category,li.ID_flotily
FROM lod_info li;

/*Trigger 1 - adding a pirate without position*/
INSERT INTO PIRAT (ID_posadka, rodne_cislo, Meno, Prezyvka, Farba_brady, Vek)
VALUES(1000, '930101/1234', 'Rudo', 'Sedivy', 'Čierna', 20);
SELECT * FROM PIRAT WHERE Meno = 'Rudo' and Prezyvka = 'Sedivy';

/*Trigger 2 - deleting only ship in fleet -> fleet is deleted too*/
INSERT INTO FLOTILA (ID_posadka, ID_div_kapitana)
VALUES(1000,1);
SELECT * FROM FLOTILA;
INSERT INTO LOD (ID_flotily, ID_bitky, ID_div_kapitana, ID_pristavu,ID_Posadka, Typ_lode, Kapacita)
VALUES (5,2,1,1,1000,'Barka',17);
DELETE FROM LOD WHERE KAPACITA = 17;
SELECT * FROM FLOTILA;

/*Crew info*/
CALL CREW_INFO(1);

/*Capacity update of port*/
CALL CAPACITY_UPDATE(1,1);


/*Explain plan prints out how many ships are anchored in which ports*/
EXPLAIN PLAN FOR SELECT Nazov_poloostrova, COUNT(*)
FROM PRISTAV JOIN LOD on PRISTAV.ID_pristavu = LOD.ID_pristavu
GROUP BY Nazov_poloostrova
ORDER BY Nazov_poloostrova DESC;

SELECT * from table(dbms_xplan.display());
/*By creating index on ID_pristavu in table LOD, accessing full table is not needed so query is faster and cost is smaller*/
CREATE INDEX ix_polo ON LOD(ID_pristavu);

EXPLAIN PLAN FOR SELECT Nazov_poloostrova, COUNT(*)
FROM PRISTAV JOIN LOD on PRISTAV.ID_pristavu = LOD.ID_pristavu
GROUP BY Nazov_poloostrova
ORDER BY Nazov_poloostrova DESC;

SELECT * from table(dbms_xplan.display());

GRANT ALL ON XMAHUT01.ALIANCIA TO XSLUKA00;
GRANT ALL ON XMAHUT01.ALIANCIE_V_BITKE TO XSLUKA00;
GRANT ALL ON XMAHUT01.BITKA TO XSLUKA00;
GRANT ALL ON XMAHUT01.CHARAKTERISTIKY TO XSLUKA00;
GRANT ALL ON XMAHUT01.FLOTILA TO XSLUKA00;
GRANT ALL ON XMAHUT01.KAPITAN TO XSLUKA00;
GRANT ALL ON XMAHUT01.LOD TO XSLUKA00;
GRANT ALL ON XMAHUT01.PIRAT TO XSLUKA00;
GRANT ALL ON XMAHUT01.PIRATSKE_CHARAKTERISTIKY TO XSLUKA00;
GRANT ALL ON XMAHUT01.POSADKA TO XSLUKA00;
GRANT ALL ON XMAHUT01.PRISTAV TO XSLUKA00;

GRANT EXECUTE ON XMAHUT01.CREW_INFO TO XSLUKA00;
GRANT EXECUTE ON XMAHUT01.CAPACITY_UPDATE TO XSLUKA00;

/*Materialized view*/
/*View is accessing tables PIRAT and KAPITAN, prints out details about pirates based on Posadka*/
CREATE MATERIALIZED VIEW PIRAT_DETAILS_BY_POSADKA
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
AS
SELECT
    p.ID_posadka,
    COUNT(*) AS pocet_piratov,
    AVG(p.Vek) AS priemerny_vek,
    k.Roky_praxe AS kapitan_roky_praxe
FROM XSLUKA00.PIRAT p
LEFT JOIN XSLUKA00.KAPITAN k ON p.ID_pirata = k.ID_pirata
GROUP BY p.ID_posadka, k.Roky_praxe;

SELECT * FROM PIRAT_DETAILS_BY_POSADKA;

GRANT ALL ON XMAHUT01.PIRAT_DETAILS_BY_POSADKA TO XSLUKA00;