
-- DQL的基础查询

USE `myemployees`; -- 使用该数据库

-- 1.查询表中单个字段
SELECT `department_name` FROM`departments`;

-- 2.查询表中多个字段
SELECT `department_id`,`department_name` FROM `departments`;

-- 3.查询表中所有字段
-- 方式1
SELECT `department_id`,`department_name`,`manager_id`,`location_id` FROM `departments`;

-- 方式2
SELECT * FROM `departments`;

-- 4.查询常量值(字符型和日期性必须使用单引号引起来，数值型可以不需要)
SELECT 100;
SELECT 'john';

-- 5.查询表达式
SELECT 100%22;

-- 6.查询函数
SELECT VERSION();

-- 7.起别名
/*
好处：
　　(１)便于理解
　　(２)如果需要查询的关键字有重名的情况，使用别名可以区分　
*/

-- 方式1
SELECT last_name AS 姓 , first_name AS 名 FROM `employees`;

-- 方式2
SELECT last_name 姓 , first_name 名 FROM `employees`;

-- 8.去重(只需要加上distinct关键字)

-- 查询员工表中涉及到的所有的部门编号(去重)
SELECT DISTINCT department_id FROM employees;

-- 9.+号的作用(MySQL中只充当运算符)

SELECT 100+90; -- 两个操作数都为数值型，则做加法运算
			-- 只要其中一方为字符型，试图将字符型数值转换成数值型
SELECT '123'+90;	-- 如果转换成功，则继续做加法运算
SELECT 'john'+90;	-- 如果转换失败，则将字符型数值转换成0
SELECT NULL+10;   	-- 只要其中一方为null，则结果肯定为null

-- 10.拼接使用concat()函数（null与任何拼接都为null）
SELECT CONCAT('帅','哥') AS 结果;

-- 查询员工名和姓连接成一个字段，并显示为姓名(也就是需要拼接名和姓)

SELECT 
	CONCAT(last_name,first_name) AS 姓名
FROM
	employees;
	
-- 11.ifnull 函数
-- 功能：判断某字或表达式是否为null，如果为null返回指定的值，如果不为null返回原本的值

SELECT IFNULL(commission_pct,0) FROM employees;

-- 12.isnull 函数
-- 如果为null就返回1，不为null就返回0

SELECT ISNULL(commission_pct),commission_pct FROM employees;











