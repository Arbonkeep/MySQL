-- 分组查询

-- 1.简单的分组查询

-- 查询每个工种的员工平均工资
SELECT MAX(salary),job_id
FROM employees
GROUP BY job_id;

-- 统计每个位置的部门个数
SELECT COUNT(*),location_id
FROM departments
GROUP BY location_id;

-- 2.可以实现分组前的筛选

-- 查询邮箱中包含a字符的 每个部门的平均工资

SELECT AVG(salary),department_id
FROM employees
WHERE email LIKE '%a%'
GROUP BY department_id;


-- 查询有奖金的每个领导手下员工的最高工资

SELECT MAX(salary),manager_id
FROM employees
WHERE commission_pct IS NOT NULL
GROUP BY manager_id;


-- 3.添加分组后的筛选条件(需要使用having关键字)

-- 查询哪个部门的员工个数>5

-- <1>每个部门的员工个数
SELECT COUNT(*),department_id
FROM employees
GROUP BY department_id;

-- <2>筛选出员工个数大于5的结果
SELECT COUNT(*),department_id
FROM employees
GROUP BY department_id
HAVING COUNT(*)>5;


-- 查询每个工种有奖金的员工的最高工资>12000的工种编号和最高工资

SELECT MAX(salary),job_id
FROM employees
WHERE commission_pct IS NOT NULL
GROUP BY job_id
HAVING MAX(salary) > 12000;


-- 查询领导编号>102的每个领导手下的最低工资大于5000的领导编号和最低工资

-- 分析首先查询最低工资，然后查询领导编号>102,最后查询工资大于5000
SELECT MIN(salary),manager_id
FROM employees
WHERE manager_id > 102
GROUP BY manager_id
HAVING MIN(salary)>5000;


-- 4.按表达式或函数分组

-- 按员工姓名的长度分组，查询每一组员工个数，筛选员工个数>5的有哪些

-- <1> 查询每个长度的员工个数 
SELECT COUNT(*),LENGTH(last_name) AS len_name
FROM employees
GROUP BY LENGTH(last_name);

-- <2> 添加筛选条件
SELECT COUNT(*),LENGTH(last_name) AS len_name
FROM employees
GROUP BY LENGTH(last_name)
HAVING COUNT(*) > 5;


-- 5.按多个字段分组(直接用逗号隔开)

-- 查询每个部门每个工种的员工的平均工资
SELECT AVG(salary),job_id,department_id
FROM employees
GROUP department_id,job_id;

-- 查询每个部门每个工种的最低工资,并按最低工资降序
SELECT MIN(salary),job_id,department_id
FROM employees
GROUP BY department_id,job_id
ORDER BY MIN(salary) DESC;



-- 查询各个管理者手下员工的最低工资，其中最低工资不低于6000，没有管理者的员工不计算在内

SELECT MIN(salary), manager_id
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id
HAVING MIN(salary) >= 6000;

-- 选择具有各个job_id的员工人数
SELECT COUNT(*),job_id
FROM employees
GROUP BY job_id;

