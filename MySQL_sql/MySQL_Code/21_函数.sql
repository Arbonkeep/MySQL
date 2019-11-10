-- 函数

-- 函数与存储过程区别：
/*
存储过程：可以有0个返回，也可以有多个返回，适合做批量插入、批量更新
函数：有且仅有1 个返回，适合做处理数据后返回一个结果
*/


-- 一、创建语法
CREATE FUNCTION 函数名(参数列表) RETURNS 返回类型
BEGIN
	函数体
END


/*

注意：
1.参数列表 包含两部分：
参数名 参数类型

2.函数体：肯定会有return语句，如果没有会报错
如果return语句没有放在函数体的最后也不报错，但不建议

return 值;
3.函数体中仅有一句话，则可以省略begin end
4.使用 delimiter语句设置结束标记

*/

-- 二、调用语法

SELECT 函数名(参数列表)


-- ---------------------案例演示-----------------------------

-- 指定结束符号
DELIMITER $

-- 1.无参有返回
-- 案例：返回公司的员工个数

CREATE FUNCTION myfun1() RETURNS INT
BEGIN
	DECLARE c INT DEFAULT 0;-- 定义局部变量
	SELECT COUNT(*) INTO c -- 赋值
	FROM employees;
	
	RETURN c;

END$

SELECT myfun1()$



-- 2.有参有返回
-- 案例1：根据员工名，返回它的工资

CREATE FUNCTION myfun2(empName VARCHAR(20)) RETURN DOUBLE
BEGIN
	SET @sal =0;-- 定义用户变量
	SELECT salary INTO @sal -- 为用户变量赋值
	FROM employees
	WHERE last_name = empName;
	
	RETURN @sal;-- 将值返回
	

END$

SELECT myfun2('Lex')$

SELECT * FROM employees;

-- 案例2：根据部门名，返回该部门的平均工资

CREATE FUNCTION myfun3(deptName VARCHAR(20)) RETURNS DOUBLE
BEGIN
	DECLARE sal DOUBLE ;
	SELECT AVG(salary) INTO sal
	FROM employees e
	JOIN departments d ON e.department_id = d.department_id
	WHERE d.department_name=deptName;
	RETURN sal;
END $

SELECT myfun3('IT')$

-- 三、查看函数

SHOW CREATE FUNCTION myf3;

-- 四、删除函数
DROP FUNCTION myf3;

-- 案例
-- 一、创建函数，实现传入两个float，返回二者之和

CREATE FUNCTION fun1(num1 FLOAT, num2 FLOAT) RETURNS FLOAT
BEGIN
	DECLARE @sum FLOAT DEFAULT 0;
	SET SUM = num1 = num2;
	RETURN SUM;

END$

SELECT fun1(1,2)$


