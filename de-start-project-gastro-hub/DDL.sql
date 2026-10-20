/*Добавьте в этот файл все запросы, для создания схемы сafe и
 таблиц в ней в нужном порядке*/
-- Создаем схему
create schema if not exists cafe;


-- Создаем тип
CREATE TYPE cafe.restaurant_type AS ENUM ('coffee_shop', 'restaurant', 'bar', 'pizzeria');


--Создаем таблицы

-- Создаем таблицу ресторанов
CREATE table cafe.restaurants (
    restaurant_uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    type cafe.restaurant_type NOT NULL,
    menu jsonb
);

-- Создаем таблицу менеджеров
create table cafe.managers (
	manager_uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
	name varchar,
	phone varchar
);

-- Создаем таблицу работы менеджеров
CREATE TABLE cafe.restaurant_manager_work_dates (
    restaurant_uuid UUID NOT NULL,
    manager_uuid UUID NOT NULL,
    start_time DATE NOT NULL,
    end_time DATE NOT NULL,
    PRIMARY KEY (restaurant_uuid, manager_uuid),
    FOREIGN KEY (restaurant_uuid) REFERENCES cafe.restaurants(restaurant_uuid),
    FOREIGN KEY (manager_uuid) REFERENCES cafe.managers(manager_uuid)
);

-- Создаем таблицу продаж
CREATE TABLE cafe.sales (
    restaurant_uuid UUID NOT NULL,
    date DATE NOT NULL,
    avg_check NUMERIC(6, 2),
    FOREIGN KEY (restaurant_uuid) REFERENCES cafe.restaurants(restaurant_uuid)
);