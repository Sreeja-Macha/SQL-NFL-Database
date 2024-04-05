# NFL Statistics Database Project

## Introduction

In the age of data-driven decision-making, the ability to efficiently store, retrieve, and analyze sports statistics is invaluable. The NFL Statistics Database project serves this exact purpose within the realm of professional American football. The objective is to provide an intricate yet accessible relational database for the analysis of NFL players' performances, trends, and statistical relationships. This SQL database could significantly aid analysts, sports enthusiasts, team managers, and fantasy league participants by providing a rich source of data for nuanced analysis and strategic decision-making.

## Purpose and Value

With a growing interest in sports analytics, this project offers a structured dataset enabling complex queries that can:

- Inform team strategies.
- Guide player training programs.
- Influence fantasy football decisions.
- Support sports journalists and commentators with in-depth analyses.

## Project Scope

- Data Sourcing: Comprehensive NFL player statistics gathered from Kaggle.
- Schema Design: A normalized database schema that mirrors the real-world relationships between players, teams, and their statistics (passing, receiving, rushing and defensive).
- Database Creation: A SQL script for database and table creation.
- Data Processing Script: A Python script for data cleaning, preparation, and importation to streamline database population and management.
- Query Collection: A compilation of SQL queries addressing complex business questions, revealing patterns and trends in the data.
- Analysis: An analysis answering key questions about player performances and their impact.

## Data Source

The project utilizes data from Kaggle [NFL-Statistics-Dataset]{https://www.kaggle.com/datasets/kendallgillies/nflstatistics}, which encompasses various files such as basic player statistics and career performance metrics.

## Data Structure

The database schema includes the following entities:

- player
- team
- college
- high_school
- yearly_statistics
- passing_statistics
- receiving_statistics
- rushing_statistics
- defensive_statistics

## Project Contents

### Folder `NFL-Datasets`

Contains the datasets used for database population.

### Folder `NFL-Scripts`

Contains the scripts for database creation and data manipulation tasks.

### Folder `NFL-Database-Design`

Contains the ERD and database design documentation.

### `NFL-BusinessQueries-and-Results`

Details the analytical queries run against the database and their outcomes.

## Licensing

This project is released under the MIT License.

## Acknowledgements

I'm grateful for the guidance and knowledge imparted by Professor Mehul Rangwala from UC Davis, which have been instrumental to the development of this project.
