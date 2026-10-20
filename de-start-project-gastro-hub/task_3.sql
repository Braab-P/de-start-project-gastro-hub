/*добавьте сюда запрос для решения задания 3*/
SELECT
    r.name AS "Название заведения",
    GREATEST(COUNT(*) - 1, 0) AS "Сколько раз менялся менеджер"
FROM cafe.restaurant_manager_work_dates rmwd
JOIN cafe.restaurants r ON r.restaurant_uuid = rmwd.restaurant_uuid
GROUP BY r.restaurant_uuid, r.name
ORDER BY "Сколько раз менялся менеджер" DESC, r.name
LIMIT 3;