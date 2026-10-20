/*добавьте сюда запросы для решения задания 6*/
BEGIN;

-- Блокируем таблицу managers, так чтобы таблицу можно было читать, но не изменять
LOCK TABLE cafe.managers IN SHARE ROW EXCLUSIVE MODE;

-- Добавляем новое поле, чтобы хранить номера телефонов
ALTER TABLE cafe.managers ADD COLUMN IF NOT exists phone_numbers text[];

-- Обновляем таблицу, рассчитывая порядковый номер менеджера по алфавиту,
WITH numbered_managers AS (
    SELECT
        manager_uuid,
        ROW_NUMBER() OVER (ORDER BY name) AS rn,
        phone AS old_phone
    FROM cafe.managers
)
UPDATE cafe.managers m -- формируем новый номер телефона и заносим в массив
SET phone_numbers = ARRAY[
    CONCAT('8-800-2500-', (99 + nm.rn)::text),  -- новый номер
    nm.old_phone                              -- старый номер
]
FROM numbered_managers nm
WHERE m.manager_uuid = nm.manager_uuid;

-- Удаляем старое поле, так как теперь номера хранятся в массиве
ALTER TABLE cafe.managers DROP COLUMN phone;

-- Фиксируем изменения и снимаем блокировку
COMMIT;