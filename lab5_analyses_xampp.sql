-- LAB 5: medical lab analysis data, source: итог2025(1).ods, sheet Лист1.
-- Original A:F rows 1..143 are preserved, including blank cells as NULL, zeros, headers and subtotals. Header texts stored in source_headers.
-- B,C = columns under ИТОГ: план, экс; E,F = декабрь24: план, экстр.
-- MariaDB/MySQL (XAMPP/phpMyAdmin). IMPORTANT: re-running resets database lab5_analyses.
SET NAMES utf8mb4;
CREATE DATABASE IF NOT EXISTS lab5_analyses CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE lab5_analyses;

DROP VIEW IF EXISTS v_analyses;
DROP TABLE IF EXISTS analysis_rows;
DROP TABLE IF EXISTS sections;
DROP TABLE IF EXISTS source_headers;

CREATE TABLE source_headers (
  source_row INT PRIMARY KEY,
  col_b VARCHAR(50), col_c VARCHAR(50), col_e VARCHAR(50), col_f VARCHAR(50)
) ENGINE=InnoDB;
INSERT INTO source_headers VALUES
(1,'ИТОГ',NULL,'декабрь24',NULL),
(2,'план','экс','план','экстр');

CREATE TABLE sections (
  section_id INT PRIMARY KEY,
  section_name VARCHAR(120) NOT NULL UNIQUE
) ENGINE=InnoDB;
CREATE TABLE analysis_rows (
  row_num INT PRIMARY KEY,
  section_id INT NULL,
  row_type ENUM('header','analysis','note','subtotal','grand_total') NOT NULL,
  analysis_name VARCHAR(255) NULL,
  total_planned BIGINT NULL,
  total_emergency BIGINT NULL,
  source_col_d VARCHAR(255) NULL,
  dec24_planned BIGINT NULL,
  dec24_emergency BIGINT NULL,
  CONSTRAINT fk_rows_section FOREIGN KEY (section_id) REFERENCES sections(section_id)
) ENGINE=InnoDB;

-- ALTER TABLE: actual structure change without modifying source values
ALTER TABLE analysis_rows ADD COLUMN source_sheet VARCHAR(30) NOT NULL DEFAULT 'Лист1';

INSERT INTO sections(section_id, section_name) VALUES
(1, 'Гематология'),
(2, 'Инфекционная им.'),
(3, 'Хим-микроскопич'),
(4, 'БИОХИМИЯ'),
(5, 'Коагулология'),
(6, 'Цитология'),
(7, 'Иммунология');

-- All original 143 physical rows; source_col_d is empty in the file.
INSERT INTO analysis_rows
(row_num, section_id, row_type, analysis_name, total_planned, total_emergency, source_col_d, dec24_planned, dec24_emergency)
VALUES
(1, NULL, 'note', NULL, NULL, NULL, NULL, NULL, NULL),
(2, NULL, 'note', NULL, NULL, NULL, NULL, NULL, NULL),
(3, NULL, 'note', NULL, NULL, NULL, NULL, NULL, NULL),
(4, 1, 'header', 'Гематология', 0, 0, NULL, 0, 0),
(5, 1, 'analysis', 'Общий анализ крови', 0, 0, NULL, 0, 0),
(6, 1, 'note', 'в т.ч.', 0, 0, NULL, 0, 0),
(7, 1, 'analysis', 'Гемоглобин', 24910, 33105, NULL, 2413, 3202),
(8, 1, 'analysis', 'Эритроциты', 24910, 33105, NULL, 2413, 3202),
(9, 1, 'analysis', 'Цветовой показатель', 24910, 33105, NULL, 2413, 3202),
(10, 1, 'analysis', 'Лейкоциты', 24910, 33103, NULL, 2413, 3202),
(11, 1, 'analysis', 'Тромбоциты', 24910, 33093, NULL, 2219, 3202),
(12, 1, 'analysis', 'Гематокрит', 24910, 33098, NULL, 2419, 3202),
(13, 1, 'analysis', 'Описание кр.крови', 4778, 1344, NULL, 247, 111),
(14, 1, 'analysis', 'Лейкоформула (ручн)', 18477, 19121, NULL, 625, 1707),
(15, 1, 'analysis', 'Ретикулоциты (ручной)', 7237, 1182, NULL, 241, 111),
(16, 1, 'analysis', 'СОЭ', 19441, 23962, NULL, 1821, 2608),
(17, 1, 'analysis', 'LЕ-клетки', 12, 0, NULL, 2, 0),
(18, 1, 'analysis', 'Тромбоциты (ручной)', 1156, 0, NULL, 60, 53),
(19, 1, 'subtotal', 'ИТОГО', 200561, 244218, NULL, 17286, 23802),
(20, 2, 'header', 'Инфекционная им.', 0, 0, NULL, 0, 0),
(21, 2, 'analysis', 'ВИЧ-тест', 0, 1651, NULL, 121, 0),
(22, 2, 'subtotal', 'ИТОГО', 0, 1651, NULL, 121, 0),
(23, 2, 'analysis', 'кос. Мозг', 1, 0, NULL, NULL, NULL),
(24, 3, 'header', 'Хим-микроскопич', 0, 0, NULL, NULL, NULL),
(25, 3, 'analysis', 'Общие свойства мочи ', 0, 0, NULL, 0, 0),
(26, 3, 'note', 'в т.ч.', 0, 0, NULL, 0, 0),
(27, 3, 'analysis', 'Относительная плотность', 24961, 19895, NULL, 2270, 1819),
(28, 3, 'analysis', 'рН ( реакция )', 24961, 19895, NULL, 2270, 1859),
(29, 3, 'analysis', 'Обнаружение белка', 24961, 19952, NULL, 2270, 1859),
(30, 3, 'analysis', 'Обнаружение глюкозы', 24967, 19910, NULL, 2270, 1859),
(31, 3, 'analysis', 'глюкоза колич', 2528, 2729, NULL, 270, 40),
(32, 3, 'analysis', 'Белок количеств', 6970, 7469, NULL, 893, 1578),
(33, 3, 'analysis', 'Ацетон', 24980, 19948, NULL, 2270, 1859),
(34, 3, 'analysis', 'Желч. пигм.', 2870, 2818, NULL, 522, 413),
(35, 3, 'analysis', 'Уробилин', 2870, 2818, NULL, 522, 413),
(36, 3, 'analysis', 'Микроскопия', 24961, 19832, NULL, 2270, 1859),
(37, 3, 'note', NULL, 0, 0, NULL, NULL, 0),
(38, 3, 'analysis', 'Нечипоренко', 2218, 2, NULL, 118, 0),
(39, 3, 'analysis', 'Зимницкого * 1', 2, 0, NULL, 0, 0),
(40, 3, 'analysis', 'Белок Бен-Джонса', 0, 0, NULL, 0, 0),
(41, 3, 'analysis', 'Сок простаты* 2', 26, 0, NULL, 12, 0),
(42, 3, 'analysis', 'Мокрота общий* 2', 201, 0, NULL, 15, 0),
(43, 3, 'analysis', 'стеркобилин', 44, 0, NULL, 0, 0),
(44, 3, 'analysis', 'Простейшие', 0, 0, NULL, 0, 0),
(45, 3, 'analysis', 'Копрол.( об.ан  кала*4)', 42, 0, NULL, 6, 0),
(46, 3, 'analysis', 'Скрытая кровь в кале', 16, 0, NULL, 0, 0),
(47, 3, 'analysis', 'Ликвор * 2', 101, 101, NULL, 8, 4),
(48, 3, 'analysis', 'Выпоты * 1', 81, 18, NULL, 3, 1),
(49, 3, 'analysis', 'Отделяемое м- половых орг', 7796, 1, NULL, 737, 0),
(50, 3, 'analysis', 'Гормональ. зеркало', 1251, 0, NULL, 120, 0),
(51, 3, 'analysis', 'Мокрота по ГРАМУ* 1', 8, 6, NULL, 0, 0),
(52, 3, 'subtotal', 'ИТОГО', 176815, 135394, NULL, 16846, 13563),
(53, 3, 'note', NULL, 0, 0, NULL, 0, 0),
(54, 4, 'header', 'БИОХИМИЯ ', 0, 0, NULL, NULL, NULL),
(55, 4, 'analysis', 'Глюкоза палец', 0, 0, NULL, NULL, NULL),
(56, 4, 'analysis', 'Глюкоза  вена', 14407, 22275, NULL, 1196, 2144),
(57, 4, 'analysis', 'Лактат', 423, 9156, NULL, 220, 1117),
(58, 4, 'analysis', 'Общий белок', 14664, 19458, NULL, 1196, 2148),
(59, 4, 'analysis', 'Альбумин', 3558, 2099, NULL, 319, 371),
(60, 4, 'analysis', 'Форез белка', 0, 0, NULL, 0, 0),
(61, 4, 'analysis', 'Мочевина', 14652, 19744, NULL, 1196, 1764),
(62, 4, 'analysis', 'Креатинин', 16847, 19750, NULL, 1385, 1864),
(63, 4, 'analysis', 'Билирубин', 16079, 21970, NULL, 1532, 2080),
(64, 4, 'analysis', 'Билубин фракции', 13638, 20448, NULL, 1283, 2080),
(65, 4, 'analysis', 'АСТ', 14174, 19438, NULL, 1385, 1847),
(66, 4, 'analysis', 'АЛТ', 14179, 19438, NULL, 1385, 1847),
(67, 4, 'analysis', 'Амилаза', 1928, 12455, NULL, 357, 1327),
(68, 4, 'analysis', 'Щелочная фосфатаза', 3878, 7030, NULL, 365, 633),
(69, 4, 'analysis', 'ЛДГ', 4222, 2843, NULL, 487, 293),
(70, 4, 'analysis', 'Липаза', 512, 2270, NULL, 59, 195),
(71, 4, 'analysis', 'ГГТП', 1738, 466, NULL, 160, 49),
(72, 4, 'analysis', 'Креатинкиназа -МВ', 1126, 1864, NULL, 165, 291),
(73, 4, 'analysis', 'КФК общая', 48, 390, NULL, 9, 47),
(74, 4, 'analysis', 'Холестерин', 7812, 1343, NULL, 749, 204),
(75, 4, 'analysis', 'Триглицериды', 7805, 1326, NULL, 793, 206),
(76, 4, 'analysis', 'ЛПНП', 3363, 818, NULL, 402, 145),
(77, 4, 'analysis', 'ЛПОНП', 3363, 818, NULL, 402, 145),
(78, 4, 'analysis', 'ЛПВП', 3363, 817, NULL, 402, 145),
(79, 4, 'analysis', 'Железо', 1674, 27, NULL, 90, 3),
(80, 4, 'analysis', 'ОЖСС', 1232, 4, NULL, 106, 0),
(81, 4, 'analysis', 'Трансферрин', 971, 0, NULL, 66, 0),
(82, 4, 'analysis', 'Мочевая кислота', 1169, 17, NULL, 137, 1),
(83, 4, 'analysis', 'Магний', 2193, 3020, NULL, 209, 316),
(84, 4, 'analysis', 'Фосфор', 887, 368, NULL, 57, 20),
(85, 4, 'analysis', 'кнт', 243, 0, NULL, 28, 0),
(86, 4, 'analysis', 'Калий', 14088, 18946, NULL, 1196, 1747),
(87, 4, 'note', 'в т.ч.', 0, 0, NULL, 189, 100),
(88, 4, 'analysis', 'Натрий', 14080, 18946, NULL, 1196, 1747),
(89, 4, 'analysis', 'Кальций иониз', 3243, 4555, NULL, 419, 753),
(90, 4, 'analysis', 'Хлор', 783, 2242, NULL, 26, 745),
(91, 4, 'analysis', 'осмолярность', 0, 557, NULL, 20, 134),
(92, 4, 'analysis', 'пр Реберга *2', 1083, 1, NULL, 139, 0),
(93, 4, 'analysis', 'Аммиак крови', 0, 54, NULL, 1, 1),
(94, 4, 'analysis', 'Свободный Hb', 25, 40, NULL, 3, 0),
(95, 4, 'analysis', 'СОHb', 16, 32, NULL, 6, 1),
(96, 4, 'analysis', 'Мет Hb', 14, 22, NULL, 4, 0),
(97, 4, 'analysis', 'Холинэстераза', 0, 0, NULL, 0, 0),
(98, 4, 'analysis', 'КЩС', 0, 6184, NULL, 0, 515),
(99, 4, 'analysis', 'Диастаза мочи', 44, 2522, NULL, 2, 78),
(100, 4, 'analysis', 'Микроальбумин в моче', 709, 26, NULL, 38, 0),
(101, 4, 'subtotal', 'ИТОГО', 202067, 263779, NULL, 10768, 12850),
(102, 4, 'note', NULL, 0, 0, NULL, NULL, NULL),
(103, 5, 'header', 'Коагулология ', 0, 0, NULL, 0, 0),
(104, 5, 'analysis', 'ПТВ(для ПТИ+МНО)', 12011, 15359, NULL, 1047, 1365),
(105, 5, 'note', 'в т.ч.', 0, 0, NULL, NULL, 37),
(106, 5, 'analysis', 'ТВ', 5, 955, NULL, 0, 135),
(107, 5, 'analysis', 'Фибриноген', 12011, 15359, NULL, 1047, 1365),
(108, 5, 'analysis', 'АПТВ', 12011, 15359, NULL, 1154, 1402),
(109, 5, 'analysis', 'РФМК', 5, 856, NULL, 0, 135),
(110, 5, 'analysis', 'Время свертывания', 0, 0, NULL, 0, 0),
(111, 5, 'analysis', 'Д-димер', 232, 3836, NULL, 8, 362),
(112, 5, 'subtotal', 'ИТОГ', 36275, 51724, NULL, 3256, 4801),
(113, 5, 'note', NULL, 0, 0, NULL, NULL, NULL),
(114, 6, 'header', 'Цитология  ', 0, 0, NULL, NULL, NULL),
(115, 6, 'analysis', 'Аспират из полости матки', 2058, 0, NULL, 280, 0),
(116, 6, 'analysis', 'Соскоб с шейки матки', 57, 0, NULL, 2, 0),
(117, 6, 'analysis', 'Соскоб с цервикального канала', 136, 0, NULL, 8, 0),
(118, 6, 'analysis', 'Мокрота на атипические клетки', 1060, 0, NULL, 0, 0),
(119, 6, 'analysis', 'Браш/биопсия', 17, 0, NULL, 85, 0),
(120, 6, 'analysis', 'Асцитическая жидкость', 115, 0, NULL, 0, 0),
(121, 6, 'analysis', 'Плевральная жидкость', 385, 0, NULL, 25, 0),
(122, 6, 'analysis', 'Пунктаты различные, синови', 115, 0, NULL, 30, 0),
(123, 6, 'analysis', 'Соскобы различной этиологии', 30, 0, NULL, 0, 0),
(124, 6, 'analysis', 'Операц матертал', 0, 0, NULL, 0, 0),
(125, 6, 'analysis', 'Выделения из молочных желез и прочие моча', 0, 0, NULL, 0, 0),
(126, 6, 'subtotal', 'ИТОГ', 3973, 0, NULL, 430, 0),
(127, 6, 'note', NULL, 0, 0, NULL, NULL, NULL),
(128, 7, 'header', 'Иммунология ', 0, 0, NULL, NULL, NULL),
(129, 7, 'analysis', 'Тропонин ИФА', 1554, 2011, NULL, 338, 100),
(130, 7, 'analysis', 'Ревмофактор', 0, 0, NULL, 0, 0),
(131, 7, 'analysis', 'СРБ', 6361, 10158, NULL, 437, 755),
(132, 7, 'analysis', 'Тропонин ', 2, 6, NULL, 0, 0),
(133, 7, 'analysis', 'Ферритин ифа', 2165, 0, NULL, 186, 1),
(134, 7, 'analysis', 'Натр- урет пептид ифа', 1773, 118, NULL, 149, 15),
(135, 7, 'analysis', 'ПКТ ифа', 2560, 1377, NULL, 356, 11),
(136, 7, 'analysis', 'ХГЧ', 3068, 6, NULL, 0, 0),
(137, 7, 'analysis', 'Нейтр жир', 0, 26, NULL, 0, 2),
(138, 7, 'analysis', 'миоглобин', 2, 31, NULL, 0, 0),
(139, 7, 'analysis', 'Резус-фактор', 2, 156, NULL, NULL, 5),
(140, 7, 'analysis', 'Группа крови', 2, 158, NULL, NULL, 5),
(141, 7, 'subtotal', 'ИТОГО', 17489, 14004, NULL, 1466, 894),
(142, NULL, 'grand_total', 'Всего', 293984, 314816, NULL, NULL, NULL),
(143, NULL, 'note', NULL, 0, 0, NULL, NULL, NULL);

-- Integrity checks: must be 143 rows, 7 sections
SELECT COUNT(*) AS total_original_rows FROM analysis_rows;
SELECT * FROM analysis_rows ORDER BY row_num;

-- UPDATE: demonstration applied to a temporary row, preserving original data
INSERT INTO analysis_rows (row_num, section_id, row_type, analysis_name, total_planned, total_emergency)
VALUES (10000, 1, 'analysis', 'Тестовая запись', 1, 0);
UPDATE analysis_rows SET total_planned = 2 WHERE row_num = 10000;
-- DELETE FROM: remove the demonstration row
DELETE FROM analysis_rows WHERE row_num = 10000;

-- Users / rights. Some XAMPP/MySQL configurations require administrator privileges.
-- For a reproducible demo this creates local read-only and editor accounts.
CREATE USER IF NOT EXISTS 'lab5_viewer'@'localhost' IDENTIFIED BY 'ChangeMe_Lab5_Viewer_2026!';
CREATE USER IF NOT EXISTS 'lab5_editor'@'localhost' IDENTIFIED BY 'ChangeMe_Lab5_Editor_2026!';
GRANT SELECT ON lab5_analyses.* TO 'lab5_viewer'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON lab5_analyses.* TO 'lab5_editor'@'localhost';

-- DESCRIBE: table metadata
DESCRIBE source_headers;
DESCRIBE sections;
DESCRIBE analysis_rows;

-- Part 2: SELECT + implicit join WHERE + ORDER BY
SELECT s.section_name, r.analysis_name, r.total_planned, r.total_emergency
FROM analysis_rows AS r, sections AS s
WHERE r.section_id = s.section_id AND r.row_type = 'analysis'
  AND r.total_emergency > 1000
ORDER BY r.total_emergency DESC;

-- Explicit JOIN
SELECT s.section_name, r.row_num, r.analysis_name, r.dec24_planned, r.dec24_emergency
FROM sections AS s
JOIN analysis_rows AS r ON r.section_id = s.section_id
WHERE r.row_type = 'analysis'
ORDER BY s.section_id, r.row_num;

-- SUM, AVG, COUNT, MAX, MIN (exclude published subtotals to avoid double counting)
SELECT COUNT(*) AS analyses_count,
       SUM(total_planned) AS sum_planned,
       AVG(total_planned) AS avg_planned,
       MAX(total_emergency) AS max_emergency,
       MIN(total_emergency) AS min_emergency
FROM analysis_rows WHERE row_type = 'analysis';

-- GROUP BY / HAVING
SELECT s.section_name, COUNT(*) AS analyses_count,
       SUM(COALESCE(r.total_planned,0)) AS planned_sum
FROM sections AS s JOIN analysis_rows AS r ON r.section_id=s.section_id
WHERE r.row_type='analysis'
GROUP BY s.section_id, s.section_name
HAVING SUM(COALESCE(r.total_planned,0)) > 10000
ORDER BY planned_sum DESC;

-- Nested subquery with IN
SELECT analysis_name, total_emergency
FROM analysis_rows
WHERE row_type='analysis'
  AND section_id IN (SELECT section_id FROM sections WHERE section_name IN ('Гематология','БИОХИМИЯ'))
ORDER BY total_emergency DESC;

-- Nested subquery with ALL
SELECT analysis_name, total_planned
FROM analysis_rows
WHERE row_type='analysis' AND total_planned IS NOT NULL
  AND total_planned >= ALL (
    SELECT total_planned FROM analysis_rows
    WHERE row_type='analysis' AND total_planned IS NOT NULL
  );

-- IF and CASE to classify relative emergency share
SELECT analysis_name, total_planned, total_emergency,
       IF(COALESCE(total_emergency,0)>COALESCE(total_planned,0), 'Экстренных больше','Плановых не меньше') AS comparison,
       CASE
         WHEN total_planned IS NULL OR total_emergency IS NULL THEN 'Недостаточно данных'
         WHEN total_planned+total_emergency=0 THEN 'Нет исследований'
         WHEN total_emergency > total_planned THEN 'Преобладает экстренная нагрузка'
         ELSE 'Преобладает плановая нагрузка'
       END AS workload_label
FROM analysis_rows WHERE row_type='analysis';

-- VIEW: common query, details per analysis with section
CREATE OR REPLACE VIEW v_analyses AS
SELECT r.row_num, s.section_name, r.analysis_name,
       r.total_planned, r.total_emergency, r.dec24_planned, r.dec24_emergency
FROM analysis_rows AS r
JOIN sections AS s ON s.section_id=r.section_id
WHERE r.row_type='analysis';
SELECT * FROM v_analyses ORDER BY row_num;

-- CTE WITH: use on MariaDB 10.2+/MySQL 8+
WITH section_stats AS (
 SELECT section_name, COUNT(*) AS item_count,
        SUM(COALESCE(total_emergency,0)) AS emergency_sum
 FROM v_analyses GROUP BY section_name
)
SELECT * FROM section_stats WHERE item_count>0 ORDER BY emergency_sum DESC;

-- EXPLAIN before adding index
EXPLAIN SELECT row_num, analysis_name, total_emergency
FROM analysis_rows WHERE row_type='analysis' AND total_emergency>10000
ORDER BY total_emergency DESC;
CREATE INDEX idx_rows_type_emergency ON analysis_rows(row_type, total_emergency);
-- EXPLAIN after adding index
EXPLAIN SELECT row_num, analysis_name, total_emergency
FROM analysis_rows WHERE row_type='analysis' AND total_emergency>10000
ORDER BY total_emergency DESC;

-- Transaction: temporary insert and rollback, no change to original 143 rows
START TRANSACTION;
INSERT INTO analysis_rows(row_num, section_id, row_type, analysis_name, total_planned, total_emergency)
VALUES (10001,4,'analysis','Тест в транзакции',10,5);
UPDATE analysis_rows SET total_planned=11 WHERE row_num=10001;
SELECT * FROM analysis_rows WHERE row_num=10001;
ROLLBACK;
SELECT COUNT(*) AS original_row_count_after_rollback FROM analysis_rows;

-- Prepared statement, bound parameter: data from the original records
SET @min_count=20000;
PREPARE lab5_stmt FROM
 'SELECT analysis_name, total_planned FROM v_analyses WHERE total_planned > ? ORDER BY total_planned DESC';
EXECUTE lab5_stmt USING @min_count;
DEALLOCATE PREPARE lab5_stmt;
