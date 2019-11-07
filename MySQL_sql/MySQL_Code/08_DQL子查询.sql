-- 子查询

-- 一、where与having后面

/*
1、标量子查询（单行子查询）
2、列子查询（多行子查询）
3、行子查询（多列多行）

特点：
①子查询放在小括号内
②子查询一般放在条件的右侧
③标量子查询，一般搭配着单行操作符使用
> < >= <= = <>

列子查询，一般搭配着多行操作符使用
in、any/some、all

④子查询的执行优先于主查询执行，主查询的条件用到了子查询的结果

*/

-- 1.标量子查询（结果为单行单列）

-- 案例1：谁的工资比 Abel 高?

-- ①查询Abel的工资
SELECT salary
FROM employees
WHERE last_name = 'Abel';

-- ②查询员工的信息，满足 salary>①结果

SELECT * 
FROM employees
WHERE salary > (
	SELECT salary
	FROM employees
	WHERE last_name = 'Abel'
);

-- 案例2：返回job_id与141号员工相同，salary比143号员工多的员工 姓名，job_id 和工资

-- ①查询141号员工的job_id
SELECT job_id
FROM employees
WHERE employee_id = 141;

-- ②查询143号员工的salary
SELECT salary
FROM employees
WHERE employee_id = 143;

-- ③查询员工的姓名，job_id 和工资，要求job_id=①并且salary>②

SELECT last_name, job_id ,salary
FROM employees
WHERE job_id = (
	SELECT job_id
	FROM employees
	WHERE employee_id = 141
)AND salary > (
	SELECT salary
	FROM employees
	WHERE employee_id = 143
);

-- 案例3：返回公司工资最少的员工的last_name,job_id和salary

-- ①查询公司的 最低工资
SELECT MIN(salary)
FROM employees;

-- ②查询last_name,job_id和salary，要求salary=①
SELECT last_name,job_id,salary
FROM employees
WHERE salary = (
	SELECT MIN(salary)
	FROM employees
);

-- 案例4：查询最低工资大于50号部门最低工资的部门id和其最低工资

-- ①查询50号部门的最低工资
SELECT  MIN(salary)
FROM employees
WHERE department_id = 50

-- ②查询每个部门的最低工资

SELECT MIN(salary),department_id
FROM employees
GROUP BY department_id

-- ③ 在②基础上筛选，满足min(salary)>①
SELECT MIN(salary),department_id
FROM employees
GROUP BY department_id
HAVING MIN(salary)>(
	SELECT  MIN(salary)
	FROM employees
	WHERE department_id = 50
);

-- 非法使用标量子查询
-- 就是指内查询的结果不是单行单列

SELECT MIN(salary),department_id
FROM employees
GROUP BY department_id
HAVING MIN(salary)>(
	SELECT  salary
	FROM employees
	WHERE department_id = 250
);


-- 2.列子查询(多行子查询)

/*
	多行子查询中常用的操作符
	
	in：等于列表中任意一个
	any|some：和子查询返回的某一个值比较
	all：和子查询中返回的所有值进行比较

*/

-- 案例1：返回location_id是1400或1700的部门中的所有员工姓名(使用到in)

-- ①查询location_id是1400或1700的部门编号
SELECT DISTINCT department_id -- 最好可以去重
FROM departments
WHERE location_id IN(1400,1700);

-- ②查询员工姓名，要求部门号是①列表中的某一个
SELECT last_name
FROM employees
WHERE department_id IN (-- in可以使用= any替换
	SELECT DISTINCT department_id -- 最好可以去重
	FROM departments
	WHERE location_id IN(1400,1700)
);


SELECT last_name
FROM employees
WHERE department_id <>ALL (-- 都不是内查询里面的内容
	SELECT DISTINCT department_id -- 最好可以去重
	FROM departments
	WHERE location_id IN(1400,1700)
);


-- 案例2：返回其它工种中比job_id为‘IT_PROG’工种任一工资低的员工的员工号、姓名、job_id 以及salary

-- ①查询job_id为‘IT_PROG’部门任一工资

SELECT DISTINCT salary
FROM employees
WHERE job_id = 'IT_PROG'

-- ②查询员工号、姓名、job_id 以及salary，salary<(①)的任意一个
SELECT last_name,employee_id,job_id,salary
FROM employees
WHERE salary<ANY(
	SELECT DISTINCT salary
	FROM employees
	WHERE job_id = 'IT_PROG'

) AND job_id<>'IT_PROG';

-- 或
SELECT last_name,employee_id,job_id,salary
FROM employees
WHERE salary<(
	SELECT MAX(salary)
	FROM employees
	WHERE job_id = 'IT_PROG'

) AND job_id<>'IT_PROG';


-- 案例3：返回其它部门中比job_id为‘IT_PROG’部门所有工资都低的员工的员工号、姓名、job_id 以及salary

SELECT last_name,employee_id,job_id,salary
FROM employees
WHERE salary<ALL(
	SELECT DISTINCT salary
	FROM employees
	WHERE job_id = 'IT_PROG'

) AND job_id<>'IT_PROG';

-- 或

SELECT last_name,employee_id,job_id,salary
FROM employees
WHERE salary<(
	SELECT MIN( salary)
	FROM employees
	WHERE job_id = 'IT_PROG'

) AND job_id<>'IT_PROG';



-- 3.行子查询（结果集为一行多列或多行多列）


-- 案例：查询员工编号最小并且工资最高的员工信息

SELECT * 
FROM employees
WHERE (employee_id,salary)=(
	SELECT MIN(employee_id),MAX(salary)
	FROM employees
);

-- 使用列子查询完成
#①查询最小的员工编号
SELECT MIN(employee_id)
FROM employees

#②查询最高工资
SELECT MAX(salary)
FROM employees

#③查询员工信息
SELECT *
FROM employees
WHERE employee_id=(
	SELECT MIN(employee_id)
	FROM employees
)AND salary=(
	SELECT MAX(salary)
	FROM employees

);


-- 二、select后面(只支持标量子查询)

-- 案例1：查询每个部门的员工个数
SELECT d.*,(
	SELECT COUNT(*)
	FROM employees e
	WHERE e.department_id = d.department_id
) 个数
FROM departments d;


-- 案例2：查询员工号=102的部门名
SELECT (
	SELECT department_name
	FROM departments d
	INNER JOIN employees e
	ON d.department_id=e.department_id
	WHERE e.employee_id=102
	
) 部门名;


-- 三、from后面(将子查询充当一张表，要求必须起别名)

-- 案例：查询每个部门的平均工资的工资等级

-- ①查询每个部门的平均工资
SELECT AVG(salary),department_id
FROM employees
GROUP BY department_id;

SELECT * FROM job_grades;


-- ②连接①的结果集和job_grades表，筛选条件平均工资 between lowest_sal and highest_sal

SELECT  ag_dep.*,g.`grade_level`
FROM (
	SELECT AVG(salary) ag,department_id
	FROM employees
	GROUP BY department_id
) ag_dep
INNER JOIN job_grades g
ON ag_dep.ag BETWEEN lowest_sal AND highest_sal;


-- 四、exists后面（相关子查询）

/*
语法：(就是查看子查询语句中是否有值，有返回1，没有返回0)
exists(完整的查询语句)
结果：
1或0
*/

SELECT EXISTS(SELECT employee_id FROM employees WHERE salary=300000);

-- 案例1：查询有员工的部门名

-- in
SELECT department_name
FROM departments d
WHERE d.`department_id` IN(
	SELECT department_id
	FROM employees
);

-- exists

SELECT department_name
FROM departments d
WHERE EXISTS(
	SELECT *
	FROM employees e
	WHERE d.`department_id`=e.`department_id`
);


#案例2：查询没有女朋友的男神信息

#in
SELECT bo.*
FROM boys bo
WHERE bo.`id` NOT IN(
	SELECT boyfriend_id
	FROM beauty
);

#exists
SELECT bo.*
FROM boys bo
WHERE NOT EXISTS (
	SELECT boyfriend_id
	FROM beauty b
	WHERE bo.`id` = b.`boyfriend_id`
);


-- 练习
-- 1.查询和Zlotkey相同部门的员工姓名和工资

-- <1> 查询与Zlotkey相同的部门有哪些
SELECT department_id
FROM employees
WHERE last_name = 'Zlotkey';

-- <2>在前面的基础上查询salry和last_name
SELECT last_name,salary
FROM employees
WHERE department_id = (-- 前面结果是标量子查询所以使用=
	SELECT department_id
	FROM employees
	WHERE last_name = 'Zlotkey'
);

-- 2.查询工资比公司平均工资高的员工的员工号，姓名和工资

-- <1> 查询平均工资
SELECT AVG(salary)
FROM employees;

-- <2> 在<1>的基础上进行筛选
SELECT employee_id, last_name,salary
FROM employees
WHERE salary > (
	SELECT AVG(salary)
	FROM employees
);
 
-- 3.查询各部门中工资比本部门平均工资高的员工的员工号, 姓名和工资

-- <1> 查询每个部门的平均工资
SELECT AVG(salary),department_id
FROM employees
GROUP BY department_id;

-- 连接<1>结果集和employees表，进行筛选
SELECT employee_id, last_name, salary,e.`department_id`
FROM employees e
INNER JOIN (
	SELECT AVG(salary) ag,department_id
	FROM employees
	GROUP BY department_id
) ag_dep
ON e.department_id = ag_dep.department_id
WHERE salary > ag_dep.ag;

-- 4.查询和姓名中包含字母u的员工在相同部门的员工的员工号和姓名

-- <1>查询姓名中包含字母u的员工的部门
SELECT  DISTINCT department_id
FROM employees
WHERE last_name LIKE '%u%';

-- <2>查询部门号=<1>中的任意一个的员工号和姓名
SELECT last_name,employee_id
FROM employees
WHERE department_id IN(
	SELECT  DISTINCT department_id
	FROM employees
	WHERE last_name LIKE '%u%'
);

-- 5. 查询在部门的location_id为1700的部门工作的员工的员工号

-- <1> 查询location_id为1700的部门

SELECT DISTINCT department_id
FROM departments 
WHERE location_id  = 1700;


-- <2>查询部门号=<1>中的任意一个的员工号
SELECT employee_id
FROM employees
WHERE department_id =ANY(-- 一列多行使用列子查询
	SELECT DISTINCT department_id
	FROM departments 
	WHERE location_id  = 1700

);


-- 6.查询管理者是King的员工姓名和工资

-- <1>查询姓名为king的员工编号
SELECT employee_id
FROM employees
WHERE last_name  = 'K_ing';

-- <2>查询哪个员工的manager_id = <1>
SELECT last_name,salary
FROM employees
WHERE manager_id IN(
	SELECT employee_id
	FROM employees
	WHERE last_name  = 'K_ing'

);

-- 7.查询工资最高的员工的姓名，要求first_name和last_name显示为一列，列名为 姓.名

-- <1>查询最高工资
SELECT MAX(salary)
FROM employees;

-- <2>查询工资=<1>的姓.名

SELECT CONCAT(first_name,last_name) "姓.名"
FROM employees
WHERE salary=(
	SELECT MAX(salary)
	FROM employees

);



-- 子查询：查询各部门中最高工资中最低的那个部门的最低工资是多少
-- <1> 查询各部门的最高工资中最低的部门
SELECT MAX(salary) m,department_id
FROM employees e
GROUP BY e.`department_id`
ORDER BY m 
LIMIT 1;

-- <2> 在<1>的基础上查询

-- 使用内连接查询
SELECT MIN(salary)
FROM employees
INNER JOIN (
	SELECT MAX(salary) m,department_id
	FROM employees e
	GROUP BY e.`department_id`
	ORDER BY m 
	LIMIT 1
) ag_dep
ON ag_dep.department_id = employees.`department_id`

-- 使用子查询
SELECT MIN(salary)
FROM employees
WHERE department_id = (
	SELECT e.department_id-- 不是只有单行单列
	FROM employees e
	GROUP BY e.`department_id`
	ORDER BY MAX(salary)
	LIMIT 1
);


-- 查询平均工资最高的部门manager的详细信息：last_name，department_id,email,salary

-- 连接查询

-- <1> 查询平均工资最高的部门编号
SELECT department_id
FROM employees
GROUP BY department_id
ORDER BY AVG(salary) DESC
LIMIT 1;

-- <2> 查询该部门的领导者
SELECT  DISTINCT manager_id
FROM employees
INNER JOIN (
	SELECT department_id
	FROM employees
	GROUP BY department_id
	ORDER BY AVG(salary) DESC
	LIMIT 1
) ag_dep
ON ag_dep.department_id = employees.`department_id`;

-- <3> 查询详细信息
SELECT last_name,department_id,email,salary
FROM employees
INNER JOIN(
	SELECT  DISTINCT manager_id
	FROM employees
	INNER JOIN (
		SELECT department_id
		FROM employees
		GROUP BY department_id
		ORDER BY AVG(salary) DESC
		LIMIT 1
	) ag_dep
	ON ag_dep.department_id = employees.`department_id`
) i
ON employees.`employee_id` = i.manager_id;



-- 子查询
-- <1> 查询平均工资最高的部门编号
SELECT 
    department_id 
FROM
    employees 
GROUP BY department_id 
ORDER BY AVG(salary) DESC 
LIMIT 1;

-- <2>将employees和departments连接查询，筛选条件是<1>
SELECT 
last_name, d.department_id, email, salary 
FROM
employees e 
INNER JOIN departments d 
    ON d.manager_id = e.employee_id 
WHERE d.department_id = 
(SELECT 
    department_id 
FROM
    employees 
GROUP BY department_id 
ORDER BY AVG(salary) DESC 
LIMIT 1) ;






