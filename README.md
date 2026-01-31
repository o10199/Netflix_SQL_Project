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
);



🔍 Project Questions & Analysis

This project answers the following 15 questions:

Count the number of Movies vs TV Shows

Find the most common rating for Movies and TV Shows

List all movies released in a specific year

Find the top countries with the most Netflix content

Identify the longest movie

Find content added in the last 5 years

Find all content by a specific director

List TV shows with more than 5 seasons

Count the number of content items in each genre

Find the top 5 years with the highest average content release for a specific country

List all documentary movies

Find content without a director

Find how many movies an actor appeared in over the last 10 years

Find the top 10 actors with the most appearances in movies produced in Mexico

Categorize content as Good or Bad based on keywords in the description

📈 Sample Query

Most common rating by content type:

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
) t
WHERE ranking = 1;

🧠 SQL Concepts Used

Data Definition Language (DDL)

Aggregate functions (COUNT)

GROUP BY

Window functions (RANK() OVER)

Subqueries

String functions (UNNEST, STRING_TO_ARRAY, SPLIT_PART)

Date functions and filtering

Conditional logic with CASE

📁 Repository Structure
Netflix_SQL_Project/
│
├── netflix.sql        # Table creation + all 15 queries
├── README.md          # Project documentation
├── netflixlogo.webp   # Project image

✅ Conclusion

This project demonstrates the use of SQL to analyze streaming platform data and extract meaningful insights. It highlights how relational databases and SQL queries can be used to explore trends, categorize content, and perform ranking and aggregation tasks.

🔗 Links

🔗 Add your GitHub repository link here (optional):
https://github.com/o10199/Netflix_SQL_Project

🔗 Add LinkedIn or portfolio link here (optional):
https://www.linkedin.com/in/your-profile
