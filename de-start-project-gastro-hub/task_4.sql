/*добавьте сюда запрос для решения задания 4*/
WITH pizza_data AS (
    SELECT
        name AS restaurant_name,
        menu->'Пицца' AS pizza_menu
    FROM cafe.restaurants
    WHERE type = 'pizzeria'
),
pizza_items AS (
    SELECT
        restaurant_name,
        key AS pizza_name,
        value AS pizza_value
    FROM pizza_data,
         jsonb_each_text(pizza_menu)
),
pizza_counts AS (
    SELECT
        restaurant_name,
        COUNT(*) AS pizza_count
    FROM pizza_items
    GROUP BY restaurant_name
),
ranked_pizzerias AS (
    SELECT
        restaurant_name,
        pizza_count,
        DENSE_RANK() OVER (ORDER BY pizza_count DESC) AS rank
    FROM pizza_counts
)
SELECT
    restaurant_name AS "Название заведения",
    pizza_count AS "Количество пицц в меню"
FROM ranked_pizzerias
WHERE rank = 1
ORDER BY restaurant_name;
