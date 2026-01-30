--Netflix Project
Drop Table if EXISTS Netflix;
Create Table Netflix 
(
	show_id	VARCHAR(6),
	type	VARCHAR (10),
	title	VARCHAR (150),
	director	VARCHAR (208),
	casts	VARCHAR (1000),
	country	VARCHAR (150),
	date_added	VARCHAR (50),
	release_year	INT,
	rating	VARCHAR (10),
	duration	VARCHAR (15),
	listed_in	VARCHAR (100),
	description VARCHAR (250)
	)
	
select * from Netflix;

select 
	Distinct type
from Netflix;

select * from Netflix;

-- 15 Problems 
--1. Count the number of Movies vs TV Shows

select 
	type,
	COUNT (*) AS total_contetnt
from Netflix
GROUP BY type


--2. Find the most common rating for movies and TV shows

SELECT *
FROM (
    SELECT
        type,
        rating,
        COUNT(*) AS cnt,
        RANK() OVER (
            PARTITION BY type
            ORDER BY COUNT(*) DESC
        ) AS ranking
    FROM netflix
    GROUP BY type, rating
) AS t1
WHERE ranking = 1;


--3. List all movies released in a specific year (e.g., 2020)

SELECT * FROM Netflix
WHERE 
	type = 'Movie'
	AND
	release_year = 2020


--4. Find the top 5 countries with the most content on Netflix

Select * from Netflix 

SELECT 
	      distinct(UNNEST(STRING_TO_ARRAY(country, ','))) as new_COUNTRY,
		  COUNT(show_id) as Total_Contents
    FROM netflix
	GROUP BY new_COUNTRY
	ORDER BY Total_Contents DESC
	;

--5. Identify the longest movie

SELECT 
    title,
    CAST(REPLACE(duration, ' min', '') AS INTEGER) AS duration_minutes
FROM 
    netflix
WHERE 
    type = 'Movie' 
    AND duration IS NOT NULL
ORDER BY 
    duration_minutes DESC
LIMIT 1;


--6. Find content added in the last 5 years

Select 
	*
from Netflix
where 
	TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'


--7. Find all the movies/TV shows by director 'Cathy Garcia-Molina'!

Select * from Netflix
where director ILIKE '%Cathy Garcia-Molina%'


--8. List all TV shows with more than 5 seasons

Select * from Netflix
Where 
	type = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1)::INT > 5

-- 9. Count the number of content items in each genre

SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(*) as total_content
FROM Netflix
GROUP BY 1

--10.Find each year and the average numbers of content release in India on netflix. 
--return top 5 year with highest avg content release!

SELECT 
	country,
	release_year,
	COUNT(show_id) as total_release,
	ROUND(
		COUNT(show_id)::numeric/
								(SELECT COUNT(show_id) FROM netflix WHERE country = 'Turkey')::numeric * 100 
		,2
		)
		as avg_release
FROM netflix
WHERE country = 'Turkey' 
GROUP BY country, 2
ORDER BY avg_release DESC 
LIMIT 5

--11. List all movies that are documentaries

 SELECT * FROM netflix
WHERE listed_in LIKE '%Documentaries%'

--12. Find all content without a director

SELECT * FROM netflix
WHERE director IS NULL

--13. Find how many movies actor 'Maya Rudolph' appeared in last 10 years!

SELECT * FROM netflix
WHERE 
	casts LIKE '%Maya Rudolph%'
	AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10


--14. Find the top 10 actors who have appeared in the highest number of movies produced in Mexico.

SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actor,
	COUNT(*)
FROM netflix
WHERE country = 'Mexico'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

/*
15.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
*/

SELECT 
    category,
	TYPE,
    COUNT(*) AS content_count
FROM (
    SELECT 
		*,
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY 1,2
ORDER BY 2


