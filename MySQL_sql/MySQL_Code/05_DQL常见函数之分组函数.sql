-- 常见函数之分组函数

-- 1.简单使用

-- sum 求和、avg 平均值、max 最大值 、min 最小值 、count 计算个数
-- 逐个求值
SELECT SUM(salary) FROM employees;
SELECT AVG(salary) FROM employees;
SELECT MIN(salary) FROM employees;
SELECT MAX(salary) FROM employees;
SELECT COUNT(salary) FROM employees;

-- 一起求值
SELECT SUM(salary) 和,AVG(salary) 平均值,MAX(salary) 最大值,MIN(salary) 最小值,COUNT(salary) 个数
FROM employees;

-- 将平均值四舍五入小数点后2位
SELECT SUM(salary) 和,ROUND(AVG(salary),2) 平均值,MAX(salary) 最大值,MIN(salary) 最小值,COUNT(salary) 个数
FROM employees;


-- 2.参数支持那些类型

-- sum不支持字符类型和日期类型
SELECT SUM(last_name) ,AVG(last_name) FROM employees;
SELECT SUM(hiredate) ,AVG(hiredate) FROM employees;-- 结果无意义

-- max和min支持字符类型和日期类型（可比较）
SELECT MAX(last_name),MIN(last_name) FROM employees;
SELECT MAX(hiredate),MIN(hiredate) FROM employees;

-- count支持所有类型，都能统计个数
SELECT COUNT(commission_pct) FROM employees;
SELECT COUNT(last_name) FROM employees;

-- 3.是否忽略null

-- 查看sum，avg是否忽略null值计算(如果平均值与除以35相等就说明忽略null值)
SELECT SUM(commission_pct) ,AVG(commission_pct),SUM(commission_pct)/35,SUM(commission_pct)/107 FROM employees;

-- 查看max，min是否忽略null值参与计算
SELECT MAX(commission_pct) ,MIN(commission_pct) FROM employees;

-- -- 查看count是否忽略null值参与计算
SELECT COUNT(commission_pct) FROM employees;
SELECT commission_pct FROM employees;


-- 4.和distinct搭配(能够这样使用)

-- 成功去重后两个值一定不一样
SELECT SUM(DISTINCT salary),SUM(salary) FROM employees;

SELECT COUNT(DISTINCT salary),COUNT(salary) FROM employees;



-- 5.count函数的详细介绍

SELECT COUNT(salary) FROM employees;


SELECT COUNT(*) FROM employees;-- 用于统计行数

SELECT COUNT(1) FROM employees;-- 相当于在每一行都加上一个1，然后统计1的个数

-- 效率：
-- MYISAM存储引擎下  ，COUNT(*)的效率高
-- INNODB存储引擎下，COUNT(*)和COUNT(1)的效率差不多，比COUNT(字段)要高一些


-- 6.和分组函数一同查询的字段有限制

SELECT AVG(salary),employee_id  FROM employees;-- 这种写法无意义，avg只有一行，而employee_id有107个id，不规则表格


-- 要求:查询员工表中最大入职时间与最小入职时间相差的天数(difference)
-- 需要使用到datediff函数：用于计算前者日期与后者日期相差的天数

SELECT DATEDIFF(MAX(hiredate),MIN(hiredate)) difference FROM employees;

-- 查询部门编号为90的员工个数
SELECT COUNT(*) FROM employees WHERE department_id = 90;










