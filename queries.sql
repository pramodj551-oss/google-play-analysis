-- ============================================================================
-- SQL SCRIPT FOR GOOGLE PLAY STORE APPS DATABASE ENGINE
-- Target Architecture: SQLite / ANSI SQL Compatible
-- ============================================================================

-- Query 1: Filter using BETWEEN for app prices within an affordable range
-- Purpose: Identifies budget paid apps for conversion optimization analysis.
SELECT App, Category, Rating, Price
FROM apps
WHERE Price BETWEEN 1.0 AND 4.99
LIMIT 5;

-- Query 2: Multi-Aggregation with a GROUP BY grouping
-- Purpose: Provides high-level operational statistics by application sector.
SELECT Category, COUNT(*) as Total_Apps, AVG(Rating) as Avg_Rating, SUM(Reviews) as Total_Reviews
FROM apps
GROUP BY Category;

-- Query 3: Value filtering on aggregated results utilizing HAVING clauses
-- Purpose: Isolates highly populated categories to identify dominant markets.
SELECT Category, COUNT(*) as Total_Apps
FROM apps
GROUP BY Category
HAVING Total_Apps > 200;

-- Query 4: Multi-Conditional statement with explicit logic processing (AND, OR)
-- Purpose: Filters highly successful target elements across target genres.
SELECT App, Category, Installs, Type
FROM apps
WHERE (Category = 'GAME' OR Category = 'FAMILY')
  AND Installs >= 10000000
LIMIT 5;

-- Query 5: Sorting operations combined with extraction boundaries (ORDER BY + LIMIT)
-- Purpose: Evaluates top-tier user acquisition components in free app models.
SELECT App, Rating, Reviews
FROM apps
WHERE Type = 'Free'
ORDER BY Rating DESC, Reviews DESC
LIMIT 5;

-- Query 6: Comprehensive data evaluation tracking extremes per classification
-- Purpose: Highlights operational variance between Free and Paid business models.
SELECT Type, MIN(Rating) as Min_Rating, MAX(Rating) as Max_Rating, AVG(Price) as Avg_Price
FROM apps
GROUP BY Type;
