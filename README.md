# Pirate Fleet Management System created by Ivan Mahút and Dušan Slúka

This project provides a comprehensive database structure for managing pirate fleets, their characteristics, and activities. It includes a range of SQL scripts for creating tables, inserting data, managing relationships, and implementing business logic through triggers and procedures.

## Table of Contents
- [Database Schema](#database-schema)
- [Triggers](#triggers)
- [Procedures](#procedures)
- [Materialized View](#materialized-view)
- [How to Use](#how-to-use)
- [Grants](#grants)

## Database Schema

The database schema includes the following tables:

- **CHARAKTERISTIKY**: Stores characteristics of pirates.
- **POSADKA**: Represents the pirate crew.
- **PRISTAV**: Represents harbors where the crews dock.
- **BITKA**: Stores information about battles.
- **ALIANCIA**: Represents alliances between crews.
- **PIRAT**: Stores information about individual pirates.
- **KAPITAN**: Special type of pirate with additional attributes.
- **FLOTILA**: Represents fleets controlled by pirate crews.
- **LOD**: Stores information about ships.
- **ALIANCIE_V_BITKE**: Junction table linking alliances to battles.
- **PIRATSKE_CHARAKTERISTIKY**: Junction table linking pirates to their characteristics.
- **POSADKY_V_ALIANCII**: Junction table linking crews to alliances.

## Triggers

- **PIRAT_POZ**: Ensures that if a pirate is added without a specified position, it defaults to 'upratovač' (cleaner).
- **DELETE_FLOTILA**: Deletes a fleet if its last ship is removed.

## Procedures

- **CREW_INFO**: Prints out information about a crew based on the provided crew ID.
- **CAPACITY_UPDATE**: Updates the capacity of a harbor after a battle and assigns the harbor to the winning alliance.

## Materialized View

- **PIRAT_DETAILS_BY_POSADKA**: Provides detailed information about pirates based on their crew, including the number of pirates, average age, and years of experience of the captain.

## How to Use

1. **Clear Environment**: Drop existing tables, sequences, and materialized views if they exist.
   ```sql
   DROP TABLE POSADKY_V_ALIANCII;
   DROP TABLE PIRATSKE_CHARAKTERISTIKY;
   DROP TABLE ALIANCIE_V_BITKE;
   DROP TABLE LOD;
   DROP TABLE FLOTILA;
   DROP TABLE KAPITAN;
   DROP TABLE PIRAT;
   DROP TABLE ALIANCIA;
   DROP TABLE BITKA;
   DROP TABLE PRISTAV;
   DROP TABLE POSADKA;
   DROP TABLE CHARAKTERISTIKY;
   DROP SEQUENCE ID_POSADKY_seq;
   DROP MATERIALIZED VIEW PIRAT_DETAILS_BY_POSADKA;
