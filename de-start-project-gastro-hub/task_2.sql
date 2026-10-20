/*добавьте сюда запрос для решения задания 2*/
CREATE MATERIALIZED VIEW cafe.avg_check_dynamics AS
WITH yearly_avg AS (
    SELECT
        r.restaurant_uuid,
        r.name,
        r.type,
        EXTRACT(YEAR FROM s.date)::INT AS year,
        ROUND(AVG(s.avg_check)::numeric, 2) AS avg_check
    FROM cafe.sales s
    JOIN cafe.restaurants r ON r.restaurant_uuid = s.restaurant_uuid
    WHERE EXTRACT(YEAR FROM s.date) <> 2023
    GROUP BY r.restaurant_uuid, r.name, r.type, year
),
with_prev AS (
    SELECT
        curr.year,
        curr.name,
        curr.type,
        curr.avg_check AS avg_check_current,
        prev.avg_check AS avg_check_prev,
        CASE 
            WHEN prev.avg_check IS NULL THEN NULL
            WHEN prev.avg_check = 0 THEN NULL
            ELSE ROUND(((curr.avg_check - prev.avg_check) / prev.avg_check) * 100, 2)
        END AS change_percent
    FROM yearly_avg curr
    LEFT JOIN yearly_avg prev
      ON curr.restaurant_uuid = prev.restaurant_uuid
     AND curr.year = prev.year + 1
)
SELECT
    year AS "Год",
    name AS "Название заведения",
    type AS "Тип заведения",
    avg_check_current AS "Средний чек в текущем году (относительно значения в поле Год)",
    avg_check_prev AS "Средний чек в предыдущем году (относительно значения в поле Год)",
    change_percent AS "Изменение среднего чека в %"
FROM with_prev
ORDER BY name, year;