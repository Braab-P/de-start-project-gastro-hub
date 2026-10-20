/*добавьте сюда запрос для решения задания 1*/
CREATE VIEW cafe.top_3_restaurants AS
WITH avg_checks AS (
    SELECT
        r.name,
        r.type,
        ROUND(AVG(s.avg_check)::numeric, 2) AS avg_check_rounded
    FROM cafe.restaurants r
    JOIN cafe.sales s ON r.restaurant_uuid = s.restaurant_uuid
    GROUP BY r.restaurant_uuid, r.name, r.type
),
ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY type ORDER BY avg_check_rounded DESC) AS rn
    FROM avg_checks
)
SELECT
    name as "Название заведения",
    type as "Тип заведения",
    avg_check_rounded as "Средний чек"
FROM ranked
WHERE rn <= 3
ORDER BY type, avg_check_rounded DESC;