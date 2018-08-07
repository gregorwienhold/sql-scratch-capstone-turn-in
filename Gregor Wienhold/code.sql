--1
SELECT *
FROM survey
LIMIT 10;

--2
SELECT question, 
  COUNT (DISTINCT user_id) as 'number of users'
FROM survey
GROUP BY 1;

--4
SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;

--5
WITH 'all_data' AS (
  SELECT *
  FROM quiz
  LEFT JOIN home_try_on
    ON quiz.user_id = home_try_on.user_id
  LEFT JOIN purchase
    ON home_try_on.user_id = purchase.user_id)
  SELECT user_id, 
    CASE
      WHEN address IS NOT NULL THEN 'True'
      WHEN address IS NULL THEN 'False'
      ELSE NULL
    END AS 'is_home_try_on',
    CASE
	    WHEN number_of_pairs = '3 pairs' THEN 3
      WHEN number_of_pairs = '5 pairs' THEN 5
      ELSE NULL
    END AS 'number_of_pairs',
    CASE
	    WHEN price IS NOT NULL THEN 'True'
      WHEN price IS NULL THEN 'False'
      ELSE NULL
    END AS 'is_purchase'
FROM 'all_data'
LIMIT 10;

--Queries to confirm I can check entries in home_try_on on adress and in is_purchase on price
SELECT COUNT (*) AS 'total_home_entries'
FROM home_try_on;

SELECT COUNT (address) AS 'address_entries'
FROM home_try_on;

SELECT COUNT (*) AS 'total_purchase_entries'
FROM purchase;

SELECT COUNT (price) AS 'price_entries'
FROM purchase;

--6.1
WITH 'structured_data' AS (
  WITH 'all_data' AS (
    SELECT *
    FROM quiz
    LEFT JOIN home_try_on
      ON quiz.user_id = home_try_on.user_id
    LEFT JOIN purchase
      ON home_try_on.user_id = purchase.user_id)
SELECT user_id, 
  CASE
    WHEN address IS NOT NULL THEN 'True'
    WHEN address IS NULL THEN 'False'
    ELSE NULL
  END AS 'is_home_try_on',
  CASE
	  WHEN number_of_pairs = '3 pairs' THEN 3
    WHEN number_of_pairs = '5 pairs' THEN 5
    ELSE NULL
  END AS 'number_of_pairs',
  CASE
	  WHEN price IS NOT NULL THEN 'True'
    WHEN price IS NULL THEN 'False'
    ELSE NULL
  END AS 'is_purchase'
FROM 'all_data'),
'quiz_step' AS (
  SELECT COUNT (user_id) AS 'quiz_participants'
  FROM structured_data),
'purchase_step' AS (
  SELECT COUNT (is_purchase) as 'buyers'
  FROM structured_data
  WHERE is_purchase = 'True'), 
'step_counts'AS (
  SELECT *
  FROM quiz_step
  CROSS JOIN purchase_step)
SELECT 100.0*buyers/quiz_participants AS 'conversion_rate_in_%'
FROM step_counts;

--6.2.1
WITH 'structured_data' AS (
  WITH 'all_data' AS (
    SELECT *
    FROM quiz
    LEFT JOIN home_try_on
      ON quiz.user_id = home_try_on.user_id
    LEFT JOIN purchase
      ON home_try_on.user_id = purchase.user_id)
SELECT user_id, 
  CASE
    WHEN address IS NOT NULL THEN 'True'
    WHEN address IS NULL THEN 'False'
    ELSE NULL
  END AS 'is_home_try_on',
  CASE
	  WHEN number_of_pairs = '3 pairs' THEN 3
    WHEN number_of_pairs = '5 pairs' THEN 5
    ELSE NULL
  END AS 'number_of_pairs',
  CASE
	  WHEN price IS NOT NULL THEN 'True'
    WHEN price IS NULL THEN 'False'
    ELSE NULL
  END AS 'is_purchase'
FROM 'all_data'),
'quiz_step' AS (
  SELECT COUNT (user_id) AS 'quiz_participants'
  FROM structured_data),
'home_try_on_step' AS (
  SELECT COUNT (is_home_try_on) as 'tried'
  FROM structured_data
  WHERE is_home_try_on = 'True'), 
'step_counts' AS (
  SELECT *
  FROM quiz_step
  CROSS JOIN home_try_on_step)
SELECT 100.0*tried/quiz_participants AS 'conversion_rate_quiz_to_try-on_in_%'
FROM step_counts;

--6.2.2
WITH 'structured_data' AS (
  WITH 'all_data' AS (
    SELECT *
    FROM quiz
    LEFT JOIN home_try_on
      ON quiz.user_id = home_try_on.user_id
    LEFT JOIN purchase
      ON home_try_on.user_id = purchase.user_id)
SELECT user_id, 
  CASE
    WHEN address IS NOT NULL THEN 'True'
    WHEN address IS NULL THEN 'False'
    ELSE NULL
  END AS 'is_home_try_on',
  CASE
	  WHEN number_of_pairs = '3 pairs' THEN 3
    WHEN number_of_pairs = '5 pairs' THEN 5
    ELSE NULL
  END AS 'number_of_pairs',
  CASE
	  WHEN price IS NOT NULL THEN 'True'
    WHEN price IS NULL THEN 'False'
    ELSE NULL
  END AS 'is_purchase'
FROM 'all_data'),
'home_try_on_step' AS (
  SELECT COUNT (is_home_try_on) as 'tried'
  FROM structured_data
  WHERE is_home_try_on = 'True'), 
'purchase_step' AS (
  SELECT COUNT (is_purchase) as 'buyers'
  FROM structured_data
  WHERE is_purchase = 'True'), 
'step_counts'AS (
  SELECT *
  FROM purchase_step
  CROSS JOIN home_try_on_step)
SELECT 100.0*buyers/tried AS 'conversion_rate_try-on_to_purchase_in_%'
FROM step_counts;

--6.2.3

WITH 'structured_data' AS (
  WITH 'all_data' AS (
    SELECT *
    FROM quiz
    LEFT JOIN home_try_on
      ON quiz.user_id = home_try_on.user_id
    LEFT JOIN purchase
      ON home_try_on.user_id = purchase.user_id)
SELECT user_id, 
  CASE
    WHEN address IS NOT NULL THEN 'True'
    WHEN address IS NULL THEN 'False'
    ELSE NULL
  END AS 'is_home_try_on',
  CASE
	  WHEN number_of_pairs = '3 pairs' THEN 3
    WHEN number_of_pairs = '5 pairs' THEN 5
    ELSE NULL
  END AS 'number_of_pairs',
  CASE
	  WHEN price IS NOT NULL THEN 'True'
    WHEN price IS NULL THEN 'False'
    ELSE NULL
  END AS 'is_purchase'
FROM 'all_data'),
'quiz_step' AS (
  SELECT COUNT (user_id) AS 'quiz_participants'
  FROM structured_data),
'home_try_on_step' AS (
  SELECT COUNT (is_home_try_on) as 'tried'
  FROM structured_data
  WHERE is_home_try_on = 'True'),
'purchase_step' AS (
  SELECT COUNT (is_purchase) as 'buyers'
  FROM structured_data
  WHERE is_purchase = 'True'), 
'1st_step_counts'AS (
  SELECT *
  FROM quiz_step
  CROSS JOIN home_try_on_step),
'2nd_step_counts' AS (
  SELECT *
  FROM purchase_step
  CROSS JOIN home_try_on_step),
 '1st_step_conversion' AS (
  SELECT 100.0*tried/quiz_participants AS 'conversion_rate_quiz_to_try-on_in_%'
  FROM '1st_step_counts'),
 '2nd_step_conversion' AS (
  SELECT 100.0*buyers/tried AS 'conversion_rate_try-on_to_purchase_in_%'
  FROM '2nd_step_counts')
SELECT *
FROM '1st_step_conversion'
CROSS JOIN '2nd_step_conversion';

--6.3.1
WITH 'structured_data' AS (
  WITH 'all_data' AS (
    SELECT *
    FROM quiz
    LEFT JOIN home_try_on
      ON quiz.user_id = home_try_on.user_id
    LEFT JOIN purchase
      ON home_try_on.user_id = purchase.user_id)
SELECT user_id, 
  CASE
    WHEN address IS NOT NULL THEN 'True'
    WHEN address IS NULL THEN 'False'
    ELSE NULL
  END AS 'is_home_try_on',
  CASE
	  WHEN number_of_pairs = '3 pairs' THEN 3
    WHEN number_of_pairs = '5 pairs' THEN 5
    ELSE NULL
  END AS 'number_of_pairs',
  CASE
	  WHEN price IS NOT NULL THEN 'True'
    WHEN price IS NULL THEN 'False'
    ELSE NULL
  END AS 'is_purchase'
FROM 'all_data'),
'quiz_step' AS (
  SELECT COUNT (user_id) AS 'quiz_participants'
  FROM structured_data),
'home_try_on_step-3' AS (
  SELECT COUNT (is_home_try_on) AS 'tried'
  FROM structured_data
  WHERE is_home_try_on = 'True' AND 
    number_of_pairs = 3),
'purchase_step-3' AS (
  SELECT COUNT (is_purchase) as 'buyers'
  FROM structured_data
  WHERE is_purchase = 'True' AND 
    number_of_pairs = 3), 
'1st_step_counts-3'AS (
  SELECT *
  FROM 'quiz_step'
  CROSS JOIN 'home_try_on_step-3'),
'2nd_step_counts-3' AS (
  SELECT *
  FROM 'purchase_step-3'
  CROSS JOIN 'home_try_on_step-3'),
 '1st_step_conversion-3' AS (
  SELECT  '3' AS 'no_of_frames', 100.0*tried/quiz_participants AS 'conversion_rate_quiz_to_try-on_in_%'
  FROM '1st_step_counts-3'),
 '2nd_step_conversion-3' AS (
  SELECT ROUND(100.0*buyers/tried, 2) AS 'conversion_rate_try-on_to_purchase_in_%'
  FROM '2nd_step_counts-3'),
'conversion_rates-3' AS (
  SELECT *
  FROM '1st_step_conversion-3'
  CROSS JOIN '2nd_step_conversion-3'),
'home_try_on_step-5' AS (
  SELECT COUNT (is_home_try_on) as 'tried'
  FROM structured_data
  WHERE is_home_try_on = 'True' AND 
    number_of_pairs = 5),
'purchase_step-5' AS (
  SELECT COUNT (is_purchase) as 'buyers'
  FROM structured_data
  WHERE is_purchase = 'True' AND 
    number_of_pairs = 5), 
'1st_step_counts-5'AS (
  SELECT *
  FROM 'quiz_step'
  CROSS JOIN 'home_try_on_step-5'),
'2nd_step_counts-5' AS (
  SELECT *
  FROM 'purchase_step-5'
  CROSS JOIN 'home_try_on_step-5'),
 '1st_step_conversion-5' AS (
  SELECT '5' AS 'no_of_frames', 
    100.0*tried/quiz_participants AS 'conversion_rate_quiz_to_try-on_in_%'
  FROM '1st_step_counts-5'),
 '2nd_step_conversion-5' AS (
  SELECT ROUND(100.0*buyers/tried, 2) AS 'conversion_rate_try-on_to_purchase_in_%'
  FROM '2nd_step_counts-5'),
'conversion_rates-5' AS (
  SELECT *
  FROM '1st_step_conversion-5'
  LEFT JOIN '2nd_step_conversion-5')
SELECT *
FROM 'conversion_rates-3'
UNION 
SELECT *
FROM 'conversion_rates-5';

--6.3.2
WITH 'structured_data' AS (
  WITH 'all_data' AS (
    SELECT *
    FROM quiz
    LEFT JOIN home_try_on
      ON quiz.user_id = home_try_on.user_id
    LEFT JOIN purchase
      ON home_try_on.user_id = purchase.user_id)
SELECT user_id, 
  CASE
    WHEN address IS NOT NULL THEN 'True'
    WHEN address IS NULL THEN 'False'
    ELSE NULL
  END AS 'is_home_try_on',
  CASE
	  WHEN number_of_pairs = '3 pairs' THEN 3
    WHEN number_of_pairs = '5 pairs' THEN 5
    ELSE NULL
  END AS 'number_of_pairs',
  CASE
	  WHEN price IS NOT NULL THEN 'True'
    WHEN price IS NULL THEN 'False'
    ELSE NULL
  END AS 'is_purchase'
FROM 'all_data'),
'quiz_step-3' AS (
  SELECT '3' AS 'no_of_pairs',  
    COUNT (user_id) AS 'quiz_participants'
  FROM structured_data),
'quiz_step-5' AS (
  SELECT '5' AS 'no_of_pairs',
    COUNT (user_id) AS 'quiz_participants'
  FROM structured_data),
'quiz_participants' AS (
  SELECT *
  FROM 'quiz_step-3'
  UNION
  SELECT *
  FROM 'quiz_step-5'),
'home_try_on_step-3' AS (
  SELECT '3' AS 'no_of_pairs', 
    COUNT (is_home_try_on) as 'testers'
  FROM structured_data
  WHERE is_home_try_on = 'True' AND 
    number_of_pairs = 3),
'home_try_on_step-5' AS (
  SELECT '5' AS 'no_of_pairs', 
    COUNT (is_home_try_on) as 'testers'
  FROM structured_data
  WHERE is_home_try_on = 'True' AND 
    number_of_pairs = 5),
'testers' AS (
  SELECT *
  FROM 'home_try_on_step-3' 
  UNION
  SELECT *
  FROM 'home_try_on_step-5'),
'purchase_step-3' AS (
SELECT '3' AS 'no_of_pairs', 
  COUNT (is_purchase) as 'buyers'
FROM structured_data
  WHERE is_purchase = 'True' AND 
    number_of_pairs = 3), 
'purchase_step-5' AS (
SELECT '5' AS 'no_of_pairs', 
  COUNT (is_purchase) as 'buyers'
FROM structured_data
WHERE is_purchase = 'True' AND 
  number_of_pairs = 5), 
'buyers' AS (
  SELECT * 
  FROM 'purchase_step-3'
  UNION
  SELECT * 
  FROM 'purchase_step-5'),
'funnel_steps_volume' AS (
  SELECT *
  FROM quiz_participants
  LEFT JOIN testers
    ON quiz_participants.no_of_pairs = testers.no_of_pairs
  LEFT JOIN buyers 
    ON buyers.no_of_pairs = testers.no_of_pairs)
SELECT no_of_pairs, quiz_participants, testers, buyers
FROM funnel_steps_volume;

--6.4
WITH 'structured_data' AS (
  WITH 'all_data' AS (
    SELECT *
    FROM quiz
    LEFT JOIN home_try_on
      ON quiz.user_id = home_try_on.user_id
    LEFT JOIN purchase
      ON home_try_on.user_id = purchase.user_id)
SELECT user_id, 
  CASE
    WHEN address IS NOT NULL THEN 'True'
    WHEN address IS NULL THEN 'False'
    ELSE NULL
  END AS 'is_home_try_on',
  CASE
	  WHEN number_of_pairs = '3 pairs' THEN 3
    WHEN number_of_pairs = '5 pairs' THEN 5
    ELSE NULL
  END AS 'number_of_pairs',
  CASE
	  WHEN price IS NOT NULL THEN 'True'
    WHEN price IS NULL THEN 'False'
    ELSE NULL
  END AS 'is_purchase'
FROM 'all_data')
SELECT number_of_pairs, 
  COUNT (is_purchase) as 'buyers'
FROM structured_data
WHERE is_purchase = 'True' AND 
  (number_of_pairs = 3 OR 
    number_of_pairs = 5) 
GROUP BY number_of_pairs;


--6.5

SELECT style,
  COUNT (style) AS 'number_of_answers'
FROM quiz
GROUP BY style
ORDER BY COUNT (style) DESC;

SELECT fit,
  COUNT (fit) AS 'number_of_answers'
FROM quiz
GROUP BY fit
ORDER BY COUNT (fit) DESC;

SELECT shape,
  COUNT (shape) AS 'number_of_answers'
FROM quiz
GROUP BY shape
ORDER BY COUNT (shape) DESC;

SELECT color,
  COUNT (color) AS 'number_of_answers'
FROM quiz
GROUP BY color
ORDER BY COUNT (color) DESC;

--6.6
SELECT model_name, 
  COUNT(model_name) AS 'units_sold'
FROM purchase
GROUP BY model_name
ORDER BY COUNT (model_name) DESC;

