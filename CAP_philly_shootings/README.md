## SQL practice: Officer-involved shootings in Philadelphia

This short project looks at officer-involved shootings in Philadelphia. I chose the Philadelphia PD because it has lots of data available. The data set I'm using can be found [here](https://opendataphilly.org/dataset/shooting-victims).



#### Loading data

```
BULK INSERT test
FROM "~/Documents/projects/CAP_Philly/data/shootings.csv"
WITH
(
    FIRSTROW = 2, -- as 1st one is header
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)
```
These data include all shootings, we're subsetting to officer-involved ones.

```
SELECT year, date_, race, sex, age, officer_involved, fatal
FROM shootings
WHERE officer_involved = "Y"
ORDER BY 1
LIMIT 5
```


| year | date_      | race | sex  | age  | officer_involved | fatal |
| ---- | ---------- | ---- | ---- | ---- | ---------------- | ----- |
| 2015 | 2015-02-04 |      | M    |      | Y                |       |
| 2015 | 2015-06-22 |      | M    |      | Y                |       |
| 2015 | 2015-04-23 |      | M    |      | Y                |       |
| 2015 | 2015-05-12 |      | M    |      | Y                |       |
| 2015 | 2015-05-24 |      | M    |      | Y                |       |

Race, age, and fatal variables are all missing for this subset.



#### Aggregate shootings by year

```
SELECT year, COUNT(*) AS officer_involved
FROM shootings
WHERE officer_involved IS "Y"
GROUP BY year
```

| year | officer_involved |
| ---- | ---------------- |
| 2015 | 23               |
| 2016 | 23               |
| 2017 | 13               |
| 2018 | 12               |
| 2019 | 9                |
| 2020 | 15               |
| 2021 | 7                |
| 2022 | 8                |



### Percentage of officer-involved shootings out of all shooting each year

```	
SELECT year, COUNT(*) AS total_shootings,
       ROUND(AVG(CASE WHEN ois = 'Y' THEN 1 ELSE 0 END)*100, 2) AS ois_perc
FROM (SELECT year, objectid, COUNT(*) AS cnt,
             MIN(officer_involved) AS ois
      FROM shootings
      GROUP BY year, objectid
     ) 
GROUP BY year
```

| year | total_shootings | ois_perc |
| ---- | --------------- | -------- |
| 2015 | 1303            | 1.77     |
| 2016 | 1345            | 1.71     |
| 2017 | 1268            | 1.03     |
| 2018 | 1449            | 0.83     |
| 2019 | 1473            | 0.61     |
| 2020 | 2258            | 0.66     |
| 2021 | 2342            | 0.3      |
| 2022 | 1653            | 0.48     |

The share of officer-involved shootings has mainly decreased in the last seven years, even though the number of all shootings has increased. Note that the data for 2022 do not yet cover the whole year.