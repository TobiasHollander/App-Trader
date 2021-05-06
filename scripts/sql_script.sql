--First CTE
WITH all_app_data AS (SELECT DISTINCT app.name,
				 			 app.price as app_price, 
				 			 play.price as play_price, 
 				 			 CAST(app.price as money) + CAST(play.price as money) as total_app_price, 
 				 			 ROUND(((app.rating + play.rating)/2),2) AS avg_app_rating, 
 				 			 app.primary_genre AS app_genre, 
 				 			 play.genres as play_genre
FROM app_store_apps AS app
LEFT JOIN play_store_apps AS play
on app.name = play.name),
--Second CTE
app_trader_purchase_price AS (SELECT *,
								CASE WHEN (total_app_price > '1') THEN (total_app_price * '10000')
		 						ELSE '10000' END AS app_trader_purchase_price
								FROM all_app_data),
--Third CTE rounded ratings
rounded_avg_rating AS (SELECT *,
						CASE WHEN avg_app_rating BETWEEN 0 AND 0.24 THEN 0
						WHEN avg_app_rating BETWEEN 0.25 and 0.74 THEN 0.50
						WHEN avg_app_rating BETWEEN 0.75 and 1.24 THEN 1.00
						WHEN avg_app_rating BETWEEN 1.25 and 1.74 THEN 1.50
						WHEN avg_app_rating BETWEEN 1.75 and 2.24 THEN 2.00
						WHEN avg_app_rating BETWEEN 2.25 and 2.74 THEN 2.50
						WHEN avg_app_rating BETWEEN 2.75 and 3.24 THEN 3.00
						WHEN avg_app_rating BETWEEN 3.25 and 3.74 THEN 3.50
						WHEN avg_app_rating BETWEEN 3.75 and 4.24 THEN 4.00
						WHEN avg_app_rating BETWEEN 4.25 and 4.74 THEN 4.50
					    WHEN avg_app_rating BETWEEN 4.75 and 5.00 THEN 5.00
 						END as avg_app_rating_rounded
			FROM app_trader_purchase_price)

--Outter query
SELECT *,
		CASE WHEN avg_app_rating_rounded > 0 THEN ((avg_app_rating_rounded * 2) +1)
		ELSE 1 END AS expected_app_lifestpan_years
FROM rounded_avg_rating
ORDER BY app_trader_purchase_price DESC;
