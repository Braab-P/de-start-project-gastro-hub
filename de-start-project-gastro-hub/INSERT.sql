/*Добавьте в этот файл запросы, которые наполняют данными таблицы в схеме cafe данными*/
-- Заполняем таблицы

-- Заполняем таблицу ресторанов
insert into cafe.restaurants(name, type, menu)
select distinct s.cafe_name,
	s.type::cafe.restaurant_type, 
	m.menu
from raw_data.sales as s
inner join raw_data.menu as m on m.cafe_name = s.cafe_name;

-- Заполняем таблицу менеджеров
insert into cafe.managers(name, phone)
select distinct s.manager, s.manager_phone
from raw_data.sales as s;

-- Заполняем таблицу работы менеджеров
INSERT INTO cafe.restaurant_manager_work_dates (restaurant_uuid, manager_uuid, start_time, end_time)
select DISTINCT
    r.restaurant_uuid,
    m.manager_uuid,
    MIN(s.report_date) AS start_time,
    MAX(s.report_date) AS end_time
FROM raw_data.sales as s
JOIN cafe.restaurants r ON r.name = s.cafe_name
JOIN cafe.managers m ON m.name = s.manager AND m.phone = s.manager_phone
GROUP BY r.restaurant_uuid, m.manager_uuid;

-- Заполняем таблицу продаж
INSERT INTO cafe.sales (restaurant_uuid, date, avg_check)
select DISTINCT  r.restaurant_uuid,
       s.report_date,
       s.avg_check
FROM raw_data.sales s
JOIN cafe.restaurants r ON r.name = s.cafe_name;