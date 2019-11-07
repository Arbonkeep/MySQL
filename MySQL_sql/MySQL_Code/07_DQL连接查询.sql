-- 连接查询（多表查询）

USE girls;

SHOW TABLES;-- 查看所有表

SELECT * FROM beauty;

SELECT * FROM boys;

/*
 笛卡尔乘积现象：表1 有m行，表2有n行，结果=m*n行
    * 发生原因：没有有效的连接条件
    * 如何避免：添加有效的连接条件
*/
-- 完全展示男女朋友关系(只需要加上限定条件即可)
SELECT NAME,boyname FROM boys, beauty
WHERE boys.boyfriend_id = beauty.id; -- 添加限定条件


-- 一、sq192标准

-- [1]等值连接

-- 1.等值连接

-- 查询女神名和对应的男神名
SELECT NAME,boyName 
FROM boys,beauty
WHERE beauty.boyfriend_id= boys.id;

-- 查询员工名和对应的部门名
SELECT last_name,department_name
FROM employees,departments
WHERE employees.`department_id`= departments.`department_id`;

-- 2.为表起别名
/*
①提高语句的简洁度
②区分多个重名的字段

注意：如果为表起了别名，则查询的字段就不能使用原来的表名去限定

*/
#查询员工名、工种号、工种名

-- 没有起别名
SELECT employees.last_name,employees.job_id,jobs.job_title
FROM employees,jobs
WHERE employees.`job_id`=jobs.`job_id`;
-- 起别名
SELECT e.last_name,e.job_id,j.job_title
FROM employees  e,jobs j
WHERE e.`job_id`=j.`job_id`;


-- 3.两个表的顺序是否可以调换

-- 查询员工名、工种号、工种名

SELECT e.last_name,e.job_id,j.job_title
FROM jobs j,employees e
WHERE e.`job_id`=j.`job_id`;


-- 4.可以加筛选

-- 查询有奖金的员工名、部门名

SELECT last_name,department_name,commission_pct
FROM employees AS e,departments AS d
WHERE e.`department_id`= d.`department_id`
AND e.`commission_pct`IS NOT NULL;


-- 查询城市名中第二个字符为o的部门名和城市名
SELECT department_name,city
FROM departments AS d,locations AS l
WHERE d.`location_id` = l.`location_id`
AND city LIKE '_o%';


-- 5.可以加分组


#案例1：查询每个城市的部门个数

SELECT COUNT(*) 个数,city
FROM departments d,locations l
WHERE d.`location_id`=l.`location_id`
GROUP BY city;


#案例2：查询有奖金的每个部门的部门名和部门的领导编号和该部门的最低工资
SELECT department_name,d.`manager_id`,MIN(salary)
FROM departments d,employees e
WHERE d.`department_id`=e.`department_id`
AND commission_pct IS NOT NULL
GROUP BY department_name,d.`manager_id`;


-- 6.可以加排序

-- 查询每个工种的工种名和员工的个数，并且按员工个数降序

SELECT job_title,COUNT(*)
FROM employees e,jobs j
WHERE e.`job_id`=j.`job_id`
GROUP BY job_title
ORDER BY COUNT(*) DESC;

-- 7.可以实现三表连接？

-- 查询员工名、部门名和所在的城市名以s开头的城市，并按部门名降序显示

SELECT last_name,department_name,city
FROM employees e,departments d,locations l
WHERE e.`department_id`=d.`department_id`
AND d.`location_id`=l.`location_id`
AND city LIKE 's%'
ORDER BY department_name DESC;


-- [2]非等值连接

-- 准备：创建等级表
CREATE TABLE job_grades
(grade_level VARCHAR(3),
 lowest_sal  INT,
 highest_sal INT);

INSERT INTO job_grades
VALUES ('A', 1000, 2999);

INSERT INTO job_grades
VALUES ('B', 3000, 5999);

INSERT INTO job_grades
VALUES('C', 6000, 9999);

INSERT INTO job_grades
VALUES('D', 10000, 14999);

INSERT INTO job_grades
VALUES('E', 15000, 24999);

INSERT INTO job_grades
VALUES('F', 25000, 40000);

-- 查询员工的工资和工资级别（涉及employees表与job_grades表），可参考表结构

SELECT salary,grade_level
FROM employees e,job_grades g
WHERE salary BETWEEN g.`lowest_sal` AND g.`highest_sal`;-- 非等值的体现


-- [3]自连接：自己查询自己（只有一张表但是看作两张表）

-- 案例：查询 员工名和上级的名称
SELECT e.employee_id,e.last_name,m.employee_id,m.last_name-- 前面为员工信息，后面m为领导信息
FROM employees e,employees m
WHERE e.`manager_id` = m.`employee_id`;-- 连接条件



-- 二、sql99语法
/*
	select 查询列表
	from 表1 别名 [连接类型]
	join 表2 别名 
	on 连接条件
	[where 筛选条件]
	[group by 分组]
	[having 筛选条件]
	[order by 排序列表]
*/

-- 1.内连接

-- [1]等值连接

-- 案例1:查询员工名、部门名
SELECT last_name,department_name
FROM employees e
INNER JOIN departments d
ON e.`department_id` = d.`department_id`;

-- 案例2:查询名字中包含e的员工名和工种名（添加筛选）
SELECT last_name, job_title
FROM employees e
INNER JOIN jobs j
ON e.`job_id` = j.`job_id`
WHERE e.last_name LIKE '%e%';


-- 案例3：查询部门个数>3的城市名和部门个数，（添加分组+筛选）
-- 查询每个城市的部门个数
-- 在①结果上筛选满足条件的

SELECT city,COUNT(*)
FROM departments d
INNER JOIN locations l
ON d.`location_id` = l.`location_id`
GROUP BY city
HAVING COUNT(*) > 3;

-- 案例4:查询哪个部门的员工个数>3的部门名和员工个数，并按个数降序（添加排序）

-- ①查询每个部门的员工个数
SELECT department_name,COUNT(*)
FROM departments d
INNER JOIN employees e
ON e.`department_id` = d.`department_id`
GROUP BY department_name;

-- 在①结果上筛选员工个数>3的记录，并排序
SELECT department_name,COUNT(*)
FROM departments d
INNER JOIN employees e
ON d.`department_id` = e.`department_id`
GROUP BY department_name
HAVING COUNT(*) > 3
ORDER BY COUNT(*) DESC;

-- 案例5：查询员工名、部门名、工种名，并按部门名降序（添加三表连接）

SELECT last_name,department_name,job_title
FROM employees e
INNER JOIN departments s ON e.`department_id` = s.`department_id`
INNER JOIN jobs j ON e.`job_id` = j.`job_id`
ORDER BY department_name DESC;


-- [2] 非等值连接

-- 查询员工的工资级别
SELECT salary,grade_level
FROM employees e
INNER JOIN job_grades j
ON e.`salary` BETWEEN j.`lowest_sal` AND j.`highest_sal`; -- 非等值条件

-- 查询工资级别的个数>20的个数，并且按工资级别降序
SELECT grade_level,COUNT(*)
FROM employees e
INNER JOIN job_grades j
ON e.`salary` BETWEEN j.`lowest_sal` AND j.`highest_sal`
GROUP BY grade_level
HAVING COUNT(*) > 20
ORDER BY grade_level DESC;

-- [3] 自连接

-- 查询员工的名字、上级的名字
SELECT e.last_name,m.last_name
FROM employees e
INNER JOIN employees m
ON e.`manager_id` = m.`employee_id`;-- 员工的管理者的id = 管理者自己的id

-- 查询姓名中包含字符k的员工的名字、上级的名字
SELECT e.last_name,m.last_name
FROM employees e
JOIN employees m
ON e.`manager_id`= m.`employee_id`
WHERE e.`last_name` LIKE '%k%';




-- 2.外连接

USE girls;
-- 查询男朋友不在男神表的女神名

-- 左外连接
SELECT b.name,bo.*
FROM beauty b
LEFT OUTER JOIN boys bo
ON b.boyfriend_id = bo.id
WHERE bo.id IS NULL;

-- 右外链接
SELECT b.name,bo.*
FROM boys bo
RIGHT OUTER JOIN beauty b
ON b.boyfriend_id = bo.id
WHERE bo.id IS NULL;


-- 案例1：查询哪个部门没有员工
-- 左外
SELECT d.*,e.employee_id
FROM departments d
LEFT OUTER JOIN employees e
ON d.`department_id` = e.`department_id`
WHERE e.`employee_id` IS NULL;

-- 右外
SELECT d.*,e.employee_id
FROM employees e
RIGHT OUTER JOIN departments d
ON d.`department_id` = e.`department_id`
WHERE e.`employee_id` IS NULL;

-- 全外连接
-- 全外连接=内连接的结果+表1中有但表2没有的+表2中有但表1没有的


-- 交叉连接
SELECT b.*,bo.*
FROM beauty b
CROSS JOIN boys bo;
 
 

-- sql92和 sql99pk
/*
功能：sql99支持的较多
可读性：sql99实现连接条件和筛选条件的分离，可读性较高
*/


-- 案例：查出编号>3的女生的男朋友信息，如果有就列出详细信息，如果没有，就用null填充
SELECT b.id,b.name,bo.*
FROM beauty b
LEFT OUTER JOIN boys bo
ON b.`boyfriend_id` = bo.`id`
WHERE b.`id` > 3; 

-- 案例：查询那个城市没有部门
SELECT city,d.*
FROM locations l
LEFT OUTER JOIN departments d
ON l.`location_id` = d.`location_id`
WHERE d.`department_id` IS NULL;

-- 案例：查询部门名为SAL或IT的员工信息

SELECT e.*,d.`department_name`
FROM departments d
LEFT OUTER JOIN employees e
ON e.`department_id` = d.`department_id`
WHERE d.`department_name` IN('SAL','IT');
 
