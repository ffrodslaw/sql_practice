-- SQL project looking at officer-involved shootings in Philadelphia
-- I chose Philadelphia PD because it has lots of data available
-- data set can be found here: https://opendataphilly.org/dataset/shooting-victims

BULK INSERT test
FROM "~/Documents/projects/CAP_Philly/data/shootings.csv"
WITH
(
    FIRSTROW = 2, -- as 1st one is header
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)


SELECT year, date_, race, sex, age, officer_involved, fatal
FROM shootings
ORDER BY 1

-- These data involve all shootings, subsetting to officer-involved ones

SELECT year, date_, race, sex, age, officer_involved, fatal
FROM shootings
WHERE officer_involved = "Y"
ORDER BY 1

-- race, age and fatal are all missing for this subset

-- look at aggregate shootings by year

SELECT year, COUNT(*) AS officer_involved
FROM shootings
WHERE officer_involved IS "Y"
GROUP BY year

-- percentage of officer-involved shootings out of all shootings per year


SELECT year, COUNT(*) AS num_ids,
       AVG(CASE WHEN ois = 'Y' THEN 1 ELSE 0 END) AS ois_ratio
FROM (SELECT year, objectid, COUNT(*) AS cnt,
             MIN(officer_involved) AS ois
      FROM shootings
      GROUP BY year, objectid
     ) 
GROUP BY year;
