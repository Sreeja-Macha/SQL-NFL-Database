CREATE DATABASE IF NOT EXISTS nfl_statistics;
USE nfl_statistics;

CREATE TABLE IF NOT EXISTS `TEAM` (
    `TeamID` INT NOT NULL AUTO_INCREMENT,
    `TeamName` VARCHAR(255),
    PRIMARY KEY (`TeamID`)
);

CREATE TABLE IF NOT EXISTS `COLLEGE` (
    `CollegeID` INT NOT NULL AUTO_INCREMENT,
    `Name` VARCHAR(255),
    PRIMARY KEY (`CollegeID`)
);

CREATE TABLE IF NOT EXISTS `HIGH_SCHOOL` (
    `HighSchoolID` INT NOT NULL AUTO_INCREMENT,
    `Name` VARCHAR(255),
    `Location` VARCHAR(255),
    PRIMARY KEY (`HighSchoolID`)
);

CREATE TABLE IF NOT EXISTS PLAYER (
    PlayerID VARCHAR(100) PRIMARY KEY,
    PlayerName VARCHAR(255),
    Number INT,
    YearsPlayed VARCHAR(11),
    Position VARCHAR(3),
    CurrentStatus VARCHAR(100),
    Height DECIMAL(5, 2),
    Weight DECIMAL(5, 2),
    Age INT,
    Birthday DATE,
    BirthPlace VARCHAR(100),
    Experience VARCHAR(100),
    CurrentTeamID INT,
    CollegeID INT,
    HighSchoolID INT,
    FOREIGN KEY (CurrentTeamID) REFERENCES TEAM(TeamID),
    FOREIGN KEY (CollegeID) REFERENCES COLLEGE(CollegeID),
    FOREIGN KEY (HighSchoolID) REFERENCES HIGH_SCHOOL(HighSchoolID)
);

CREATE TABLE IF NOT EXISTS YEARLY_STATISTICS (
    `StatID` INT NOT NULL AUTO_INCREMENT,
    PlayerID VARCHAR(100),
    TeamID INT,
    Year INT,
    GamesPlayed INT,
    StatsType VARCHAR(10),
    FOREIGN KEY (TeamID) REFERENCES TEAM(TeamID),
    FOREIGN KEY (PlayerID) REFERENCES PLAYER(PlayerID),
    PRIMARY KEY (`StatID`)
);

CREATE TABLE PASSING_STATISTICS (
    StatID INT PRIMARY KEY,
    PassesAttempted INT,
    PassesCompleted INT,
    CompletionPercentage FLOAT,
    PassAttemptsPerGame FLOAT,
    PassingYards INT,
    PassingYardsPerAttempt FLOAT,
    PassingYardsPerGame FLOAT,
    TDPasses INT,
    PercentageTDsPerAttempt FLOAT,
    Ints INT,
    IntRate FLOAT,
    LongestPass VARCHAR(5),
    PassesLongerThan20Yards INT,
    PassesLongerThan40Yards INT,
    Sacks INT,
    SackedYardsLost INT,
    PasserRating FLOAT,
    FOREIGN KEY (StatID) REFERENCES YEARLY_STATISTICS(StatID)
);

CREATE TABLE RECEIVING_STATISTICS (
    StatID INT PRIMARY KEY,
    Receptions INT,
    ReceivingYards INT,
    YardsPerReception FLOAT,
    YardsPerGame FLOAT,
    LongestReception VARCHAR(5),
    ReceivingTDs INT,
    ReceptionsLongerThan20Yards INT,
    ReceptionsLongerThan40Yards INT,
    FirstDownReceptions INT,
    Fumbles INT,
    FOREIGN KEY (StatID) REFERENCES YEARLY_STATISTICS(StatID)
);

CREATE TABLE RUSHING_STATISTICS (
    StatID INT PRIMARY KEY,
    RushingAttempts INT,
    RushingAttemptsPerGame FLOAT,
    RushingYards INT,
    YardsPerCarry FLOAT,
    RushingYardsPerGame FLOAT,
    RushingTDs INT,
    LongestRushingRun VARCHAR(5),
    RushingFirstDowns INT,
    PercentageRushingFirstDowns FLOAT,
    RushingMoreThan20Yards INT,
    RushingMoreThan40Yards INT,
    Fumbles INT,
    FOREIGN KEY (StatID) REFERENCES YEARLY_STATISTICS(StatID)
);

CREATE TABLE DEFENSIVE_STATISTICS (
    StatID INT PRIMARY KEY,
    TotalTackles INT,
    SoloTackles INT,
    AssistedTackles INT,
    Sacks FLOAT,
    Safties INT,
    PassesDefended INT,
    Ints INT,
    IntsforTDs INT,
    IntYards INT,
    YardsPerInt FLOAT,
    LongestIntReturn VARCHAR(5),
    FOREIGN KEY (StatID) REFERENCES YEARLY_STATISTICS(StatID)
);
