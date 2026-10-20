/*добавьте сюда запрос для решения задания 5*/
WITH menu_cte AS (
    SELECT
        name AS restaurant_name,
        'Пицца' AS dish_type,
        key AS pizza_name,
        value::int AS price
    FROM cafe.restaurants,
         jsonb_each_text(menu->'Пицца')
    WHERE type = 'pizzeria'
),
menu_with_rank AS (
    SELECT
        restaurant_name,
        dish_type,
        pizza_name,
        price,
        ROW_NUMBER() OVER (PARTITION BY restaurant_name ORDER BY price DESC) AS price_rank
    FROM menu_cte
)
SELECT
    restaurant_name AS "Название заведения",
    dish_type AS "Тип блюда",
    pizza_name AS "Название пиццы",
    price AS "Цена"
FROM menu_with_rank
WHERE price_rank = 1
ORDER BY restaurant_name ASC;