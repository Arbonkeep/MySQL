-- 排序查询

-- 1.按单个字段排序
SELECT * FROM employees ORDER BY salary DESC;

-- 2.添加筛选条件再排序

-- 查询部门编号>=90的员工信息，并按员工编号降序

SELECT *
FROM employees
WHERE department_id>=90
ORDER BY employee_id DESC;

-- 3.按表达式排序
-- 查询员工信息 按年薪降序

SELECT *,salary*12*(1+IFNULL(commission_pct,0))
FROM employees
ORDER BY salary*12*(1+IFNULL(commission_pct,0)) DESC;


-- 4.按别名排序
-- 查询员工信息 按年薪升序

SELECT *,salary*12*(1+IFNULL(commission_pct,0)) 年薪
FROM employees
ORDER BY 年薪 ASC;

-- 5.按函数排序
-- 查询员工名，并且按名字的长度降序

SELECT LENGTH(last_name),last_name 
FROM employees
ORDER BY LENGTH(last_name) DESC;

-- 6.按多个字段排序
-- 查询员工信息，要求先按工资降序，再按employee_id升序
SELECT *
FROM employees
ORDER BY salary DESC,employee_id ASC;






