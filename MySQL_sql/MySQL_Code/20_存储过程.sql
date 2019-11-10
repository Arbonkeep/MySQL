-- 存储过程与函数

/*
存储过程和函数：类似于java中的方法
好处：
1、提高代码的重用性
2、简化操作



*/
-- 存储过程

/*
含义：一组预先编译好的SQL语句的集合，理解成批处理语句
	1、提高代码的重用性
	2、简化操作
	3、减少了编译次数并且减少了和数据库服务器的连接次数，提高了效率

*/


-- 一、创建语法

CREATE PROCEDURE 存储过程名(参数列表)
BEGIN

	存储过程体（一组合法的SQL语句）
END

-- 注意：
/*
1、参数列表包含三部分
参数模式  参数名  参数类型
举例：
in stuname varchar(20)

参数模式：
in：该参数可以作为输入，也就是该参数需要调用方传入值
out：该参数可以作为输出，也就是该参数可以作为返回值
inout：该参数既可以作为输入又可以作为输出，也就是该参数既需要传入值，又可以返回值

2、如果存储过程体仅仅只有一句话，begin end可以省略
存储过程体中的每条sql语句的结尾要求必须加分号。
存储过程的结尾可以使用 delimiter 重新设置
语法：
delimiter 结束标记
案例：
delimiter $
*/


-- 二、调用语法
CALL 存储过程名(实参列表);




-- -------------------------案例演示(需要在cmd命令行操作)----------------------------
-- 1. 空参列表

-- 案例：插入到admin表中五条记录

SELECT * FROM admin;

-- 创建
DELIMITER $
CREATE PROCEDURE myp1()
BEGIN
	INSERT INTO admin(username,`password`) 
	VALUES('john1','0000'),('lily','0000'),('rose','0000'),('jack','0000'),('tom','0000');
END $


-- 调用
CALL myp1()$

-- 2.创建带in模式参数的存储过程

-- 案例1：创建存储过程实现 根据女神名，查询对应的男神信息

-- 创建
CREATE PROCEDURE myp2(IN beautyname VARCHAR(20))
BEGIN
	SELECT bo.*
	FROM boys bo
	RIGHT JOIN beauty b ON bo.id = b.boyfriend_id
	WHERE b.name = beautyname;

END $

-- 使用
CALL myp2('柳岩')$

SELECT * FROM beauty;
SELECT * FROM boys;


-- 案例2 ：创建存储过程实现，用户是否登录成功

-- 创建存储过程
CREATE PROCEDURE myp3(IN username VARCHAR(20),IN PASSWORD VARCHAR(20))
BEGIN
	DECLARE result INT DEFAULT 0;-- 声明变量并初始化
	
	SELECT COUNT(*) INTO result-- 为变量赋值
	FROM admin
	WHERE  admin.`username` = username-- 由于我们定义的局部变量为username，所以需要前缀限定
	AND admin.`password` = PASSWORD;
	
	SELECT IF(result > 0, '成功','失败') AS 结果;-- 变量的使用 

END $

-- 使用存储过程
CALL myp3('lily','0000')$


-- 3.创建out 模式参数的存储过程

-- 案例1：根据输入的女神名，返回对应的男神名
 
-- 创建
CREATE PROCEDURE myp4(IN beautyname VARCHAR(20),OUT boyname VARCHAR(20))
BEGIN
	SELECT bo.boyname INTO boyname
	FROM boys bo
	INNER JOIN beauty b ON bo.id = b.boyfriend_id
	WHERE b.name = beautyname;

END $

-- 使用
SET @bName$-- 声明用户变量
CALL myp4('刘亦菲',@bName)$-


SELECT @bNmae$


-- 案例2：根据输入的女神名，返回对应的男神名和魅力值

CREATE PROCEDURE myp5(IN beautyname VARCHAR(20),OUT boyname VARCHAR(20),OUT userCP INT)
BEGIN
	SELECT bo.boyname,bo.userCP INTO boyname,userCP
	FROM boys bo
	INNER JOIN beauty b ON bo.id = b.boyfriend_id
	WHERE b.name = beautyname;

END $

-- 调用
CALL myp5('蒋欣',@bName,@userCP)$



-- 4. 创建带inout模式参数的存储过程

-- 案例1：传入a和b两个值，最终a和b都翻倍并返回

CREATE PROCEDURE myp8(INOUT a INT ,INOUT b INT)
BEGIN
	SET a=a*2;
	SET b=b*2;
END $

-- 调用
SET @m=10$	-- 设置变量并赋予值
SET @n=20$	
CALL myp8(@m,@n)$ -- 这里传入的必须是两个变量
SELECT @m,@n$



-- 案例：创建存储过程或函数实现传入两个女神的生日，返回大小

CREATE PROCEDURE test(IN birth1 DATETIME,IN birth2 DATETIME,OUT result INT)
BEGIN

	SELECT DATEDIFF(birth1,birth2) INTO result;
END$

CALL test('1998-1-1',NOW(),@result)$


-- 三、删除存储过程
-- 语法：drop procedure 存储过程名;

DROP PROCEDURE p1;
DROP PROCEDURE p2,p3;-- 错误

-- 四、查看存储过程的信息
-- 语法： SHOW CREATE PROCEDURE 存储过程名;

DESC myp2;-- 错误
SHOW CREATE PROCEDURE  myp2;

-- 案例

-- 创建存储过程或函数实现传入一个日期，格式化成xx年xx月xx日并返回

CREATE PROCEDURE test2(IN mydate DATETIME,OUT strdate VARCHAR(50))
BEGIN
	SELECT DATE_FORMAT(mydate, '%y年%m月%d日')INTO strdate;
	
END$

CALL test2(NOW(), @str)$
SELECT @str$


-- 创建存储过程或函数实现传入女神名称，返回：女神 and 男神  格式的字符串
-- 如 传入 ：小昭
-- 返回： 小昭 AND 张无忌

CREATE PROCEDURE test3(IN beautyname VARCHAR(20),OUT str VARCHAR(20))
BEGIN
	SELECT CONCAT(beautyname,'and',IFNULL(boyname,'null')) INTO str
	FROM boys bo
	RIGHT OUTER JOIN beauty b ON bo.id = b.boyfriend_id
	WHERE b.name = beautyname;

END$

CALL test3('苍老师',@str)$
SELECT @str$;


-- 创建存储过程或函数，根据传入的条目数和起始索引，查询beauty表的记录
CREATE PROCEDURE test4(IN startIndex INT,IN size INT)
BEGIN
	SELECT * FROM beauty LIMIT startIndex,size;
END $

CALL test_pro6(3,5)$




