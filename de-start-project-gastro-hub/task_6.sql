/*добавьте сюда запросы для решения задания 6*/
BEGIN;

-- Блокируем строки с заведениями, где есть капучино
-- Используем FOR UPDATE, чтобы блокировать выбранные строки
WITH cappuccino_restaurants AS (
    SELECT name
    FROM cafe.restaurants
    WHERE menu -> 'Кофе' ? 'Капучино'
    FOR UPDATE
),
-- Рассчитываем новые цены для капучино
updated_prices AS (
    SELECT
        name,
        jsonb_set(
            menu,
            '{Кофе,Капучино}',
            to_jsonb( ((menu->'Кофе'->>'Капучино')::numeric * 1.2)::int )
        ) AS new_menu
    FROM cafe.restaurants
    WHERE name IN (SELECT name FROM cappuccino_restaurants)
)
-- Обновляем меню в таблице
UPDATE cafe.restaurants r
SET menu = u.new_menu
FROM updated_prices u
WHERE r.name = u.name;

-- Фиксируем изменения и снимаем блокировки
COMMIT;