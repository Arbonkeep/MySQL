-- DQL条件查询


-- 1.按条件表达式查询

-- 查询工资>12000的员工信息

SELECT 
	*
FROM
	employees
WHERE
	salary>12000;
	
	
-- 查询部门编号不等于90号的员工名和部门编号
SELECT 
	last_name,
	department_id
FROM
	employees
WHERE
	department_id<>90;-- 也会使用!= 建议使用<>
	
-- 2.按逻辑表达式查询

-- 查询工资z在10000到20000之间的员工名、工资以及奖金
SELECT
	last_name,
	salary,
	commission_pct
FROM
	employees
WHERE
	salary>=10000 AND salary<=20000;
	
-- 查询部门编号不是在90到110之间，或者工资高于15000的员工信息
SELECT
	*
FROM
	employees
WHERE
	NOT(department_id>=90 AND  department_id<=110) OR salary>15000;
	

-- 3.模糊查询

/*
* like
    - 一般like会与通配符配合使用。常用通配符有%(表示任意多个字符，包含0个字符)和_(表示任意单个字符)

    - 注意：一般默认通配符为\，但是我们可以通过escape关键字指定某个字符为通配符使用
	如  这里我们通过ESCAPE将字符x指定为通配符：last_name LIKE '_x_%' ESCAPE 'x';

* between and
    - 使用between and 可以提高语句的简洁度
    - 包含临界值
    - 两个临界值不要调换顺序

* in
    - 含义：判断某字段的值是否属于in列表中的某一项
    - 使用in提高语句简洁度
    - in列表的值类型必须一致或兼容
    - in列表中不支持通配符

* is null
    - =或<>不能用于判断null值
    - is null或is not null 可以判断null值

*/


-- 3.1 like

-- 查询员工名中包含字符a的员工信息

SELECT 
	*
FROM
	employees
WHERE
	last_name LIKE '%a%';#abc

-- 查询员工名中第三个字符为e，第五个字符为a的员工名和工资
SELECT
	last_name,
	salary
FROM
	employees
WHERE
	last_name LIKE '__n_l%';

-- 查询员工名中第二个字符为_的员工名

SELECT
	last_name
FROM
	employees
WHERE
	last_name LIKE '_x_%' ESCAPE 'x';-- 这里我们通过ESCAPE将字符x指定为通配符
	
-- 3.2 between and

-- 查询员工编号在100到120之间的员工信息

SELECT
	*
FROM
	employees
WHERE
	employee_id >= 120 AND employee_id<=100;
-- ----------------------
SELECT
	*
FROM
	employees
WHERE
	employee_id BETWEEN 120 AND 100;

-- 3.3 in

-- 查询员工的工种编号是 IT_PROG、AD_VP、AD_PRES中的一个员工名和工种编号

SELECT
	last_name,
	job_id
FROM
	employees
WHERE
	job_id = 'IT_PROT' OR job_id = 'AD_VP' OR JOB_ID ='AD_PRES';

-- ------------------

SELECT
	last_name,
	job_id
FROM
	employees
WHERE
	job_id IN( 'IT_PROT' ,'AD_VP','AD_PRES');

-- 3.4 is null

-- 查询没有奖金的员工名和奖金率
SELECT
	last_name,
	commission_pct
FROM
	employees
WHERE
	commission_pct IS NULL;

-- 查询有奖金的员工名和奖金率
SELECT
	last_name,
	commission_pct
FROM
	employees
WHERE
	commission_pct IS NOT NULL;


-- 4.安全等于
	
-- 查询没有奖金的员工名和奖金率
SELECT
	last_name,
	commission_pct
FROM
	employees
WHERE
	commission_pct <=>NULL;
	
	
-- 查询工资为12000的员工信息
SELECT
	last_name,
	salary
FROM
	employees

WHERE 
	salary <=> 12000;
