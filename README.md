# Netflix SQL Data Analysis Project

![Netflix Logo](https://github.com/o10199/Netflix_SQL_Project/blob/main/netflixlogo.0.0.1466448626.webp)

## 📌 Project Overview
This project analyzes a Netflix dataset using **PostgreSQL** to answer **15 analytical questions** related to content types, ratings, release trends, countries, genres, directors, actors, and descriptions. The project demonstrates core SQL concepts along with more advanced techniques such as **window functions, subqueries, string manipulation, and date filtering**.

---

## 🛠️ Tools & Technologies
- PostgreSQL  
- pgAdmin  
- SQL  
- GitHub

---
  
## 📂 Dataset
The dataset contains Netflix titles with the following fields:
- Show ID  
- Type (Movie / TV Show)  
- Title  
- Director  
- Cast  
- Country  
- Date Added  
- Release Year  
- Rating  
- Duration  
- Genre  
- Description

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)


## 🗄️ Database Schema
The following table was created to store the Netflix dataset:

```sql
DROP TABLE IF EXISTS Netflix;

CREATE TABLE Netflix (
    show_id VARCHAR(6),
    type VARCHAR(10),
    title VARCHAR(150),
    director VARCHAR(208),
    casts VARCHAR(1000),
    country VARCHAR(150),
    date_added VARCHAR(50),
    release_year INT,
    rating VARCHAR(10),
    duration VARCHAR(15),
    listed_in VARCHAR(100),
    description VARCHAR(250)
);

```

## Problems and Solutions

## 🔍 Project Questions & Analysis

This section outlines the analytical questions explored in this project along with a brief explanation of what each query accomplishes.

---

### 1️⃣ Count the number of Movies vs TV Shows
Analyzes the distribution of content types available on Netflix by counting how many Movies and TV Shows exist in the dataset.

```sql
select 
	type,
	COUNT (*) AS total_contetnt
from Netflix
GROUP BY type
```
---

### 2️⃣ Find the most common rating for Movies and TV Shows
Uses aggregation and a window function (`RANK() OVER`) to determine the most frequently occurring rating for each content type.

```sql
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
```

---

### 3️⃣ List all movies released in a specific year
Filters the dataset to return all movies released in a given year (e.g., 2020), allowing year-based content analysis.

```sql
SELECT * FROM Netflix
WHERE 
	type = 'Movie'
	AND
	release_year = 2020
```

---

### 4️⃣ Find the top countries with the most Netflix content
Splits multi-country entries and counts the number of titles associated with each country to identify regions producing the most content.

```sql
Select * from Netflix 

SELECT 
	      distinct(UNNEST(STRING_TO_ARRAY(country, ','))) as new_COUNTRY,
		  COUNT(show_id) as Total_Contents
    FROM netflix
	GROUP BY new_COUNTRY
	ORDER BY Total_Contents DESC
	;
```

---

### 5️⃣ Identify the longest movie
Extracts the numeric duration from the `duration` field and identifies the movie with the longest runtime.

```sql
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
```

---

### 6️⃣ Find content added in the last 5 years
Converts string-based dates into date format and filters records to return titles added within the last five years.

```sql
Select 
	*
from Netflix
where 
	TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'
```

---

### 7️⃣ Find all movies and TV shows by a specific director
Searches for content created by a given director using case-insensitive pattern matching.

```sql
Select * from Netflix
where director ILIKE '%Cathy Garcia-Molina%'
```

---

### 8️⃣ List TV shows with more than 5 seasons
Identifies long-running TV shows by extracting season counts from the duration field.

```sql
Select * from Netflix
Where 
	type = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1)::INT > 5
```

---

### 9️⃣ Count the number of content items in each genre
Splits genre values and counts how many titles fall under each genre category.

```sql
SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(*) as total_content
FROM Netflix
GROUP BY 1
```

---

### 🔟 Find the top 5 years with the highest average content release for a specific country
Analyzes yearly release trends for a selected country and ranks the years based on average content output.

```sql
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
```

---

### 1️⃣1️⃣ List all movies that are documentaries
Filters the dataset to return all movies categorized under documentaries.

```sql
SELECT * FROM netflix
WHERE listed_in LIKE '%Documentaries%'
```

---

### 1️⃣2️⃣ Find all content without a director
Identifies records where director information is missing.

```sql
SELECT * FROM netflix
WHERE director IS NULL
```

---

### 1️⃣3️⃣ Find how many movies an actor appeared in during the last 10 years
Filters content by actor name and release year to analyze recent appearances.

```sql
SELECT * FROM netflix
WHERE 
	casts LIKE '%Maya Rudolph%'
	AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10
```

---

### 1️⃣4️⃣ Find the top 10 actors with the most movie appearances in Mexico
Breaks down cast lists and ranks actors based on their frequency of appearances in Mexican-produced movies.

```sql
SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actor,
	COUNT(*)
FROM netflix
WHERE country = 'Mexico'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10
```

---

### 1️⃣5️⃣ Categorize content as “Good” or “Bad” based on description keywords
Uses conditional logic to classify content based on the presence of keywords such as *kill* or *violence*, then counts items in each category.

```sql
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
```

