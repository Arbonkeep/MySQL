-- 流程控制结构

/*
    1. 分类
        <1> 顺序结构：程序从上自下依次执行

        <2> 分支结构：程序冲两条或者多条路径中选择一条去执行

        <3> 循环结构：程序在满足一定条件的基础上，重复执行一段代码

*/

-- 一、分支结构

-- 1.if函数
/*
    1) 功能：实现简单的双分支

    2) 语法：
	if(表达式1，表达式2,表达式3)
    
    3) 执行顺序
	如果表达式1成立，则if函数返回表达式2的值，否则返回表达式3的值

    4) 应用场景：任何地方  应用在begin end中或外面


*/

-- 2.case结构
/*
情况1：类似于switch，一般用于实现等值判断

语法：
	case 变量或表达式或字段
	when 值1 then 返回值1或语句1;
	when 值2 then 返回值2或语句2;
	...
	else 要返回的值n或语句n;
	end case;-- 如果是语句需要加上

情况2：类似于java中多重if语句，一般用于实现区间判断

语法：
	case 
	when 条件1 then 返回值1或语句1;
	when 条件2 then 返回值2或语句2;
	...
	else 要返回的值n或语句n;
	end case;-- 如果是语句需要加上

应用在begin end 中或外面

特点：
	  <1> 可以作为表达式，嵌套在其他语句中使用，可以放在任何地方，BEGIN END中
	      或BEGIN END的外面可以作为独立的语句去使用，只能放在BEGIN END中
	  
          <2> 如果WHEN中的值满足或条件成立，则执行对应的THEN后面的语句，并且结束
              CASE如果都不满足，则执行ELSE中的语句或值

	  <3> ELSE可以省略，如果ELSE省略了，并且所有WHEN条件都不满足，则返回NULL


*/

DELIMITER $

-- 案例1：创建存储过程，实现传入成绩，如果成绩>90,显示A，如果成绩>80,显示B，如果成绩>60,显示C，否则显示D

-- 由于是区间判断所以case后面不需要语句
CREATE PROCEDURE case1(IN score INT)
BEGIN
	CASE
	WHEN socre <= 100 AND score >= 90 THEN SELECT 'A';
	WHEN socre >=80 THEN SELECT 'B';
	WHEN socre >=60 THEN SELECT 'C';
	ELSE SELECT 'D';
	END CASE;
	
END$

CALL case1(80)$


-- 3.if结构

/*
语法：
	if 条件1 then 语句1;
	elseif 条件2 then 语句2;
	....
	else 语句n;
	end if;
功能：类似于多重if

应用场景：只能应用在begin end 中

*/

-- 案例1：创建函数，实现传入成绩，如果成绩>90,返回A，如果成绩>80,返回B，如果成绩>60,返回C，否则返回D

CREATE FUNCTION if1(socre INT) RETURNS CHAR
BEGIN
	
	IF socre <= 100 AND socre >= 90 THEN RETURN 'A';
	ELSEIF socre >= 80 THEN RETURN 'B';
	ELSEIF score >= 60 THEN RETURN 'C';
	ELSE SET ch = 'D';
	END IF;
	
END$

SELECT if1(85)$


-- 二、循环结构

/*
分类：
while、loop、repeat

循环控制：

iterate类似于 continue，继续，结束本次循环，继续下一次
leave 类似于  break，跳出，结束当前所在的循环

*/

-- 1.while
/*

语法：

	【标签:】while 循环条件 do
		循环体;
	end while【 标签】;

	联想：

	while(循环条件){

		循环体;
	}

*/

-- 2.loop
/*

语法：
	【标签:】loop
		循环体;
	end loop 【标签】;

	可以用来模拟简单的死循环



*/

-- 3.repeat
/*
语法：
	【标签：】repeat
		循环体;
	until 结束循环的条件
	end repeat 【标签】;


*/


-- 1.没有添加循环控制语句
USE girls;

-- 案例：批量插入，根据次数插入到admin表中多条记录
DROP PROCEDURE pro_while1$

CREATE PROCEDURE pro_while1(IN insertCount INT)
BEGIN
	DECLARE i INT DEFAULT 1;
	WHILE i<=insertCount DO
		INSERT INTO admin(username,`password`) VALUES(CONCAT('Rose',i),'666');
		SET i=i+1;
	END WHILE;
	
END $

CALL pro_while1(100)$

-- 2.添加leave语句

-- 案例：批量插入，根据次数插入到admin表中多条记录，如果次数>20则停止
TRUNCATE TABLE admin$
DROP PROCEDURE test_while1$

CREATE PROCEDURE test_while1(IN insertCount INT)
BEGIN
	DECLARE i INT DEFAULT 1;
	a:WHILE i<=insertCount DO
		INSERT INTO admin(username,`password`) VALUES(CONCAT('xiaohua',i),'0000');
		IF i=20 THEN LEAVE a;
		END IF;
		SET i=i+1;
	END WHILE a;
END $


CALL test_while1(100)$


-- 3.添加iterate语句

-- 案例：批量插入，根据次数插入到admin表中多条记录，只插入偶数次
TRUNCATE TABLE admin$
DROP PROCEDURE test_while1$
CREATE PROCEDURE test_while1(IN insertCount INT)
BEGIN
	DECLARE i INT DEFAULT 0;
	a:WHILE i<=insertCount DO
		SET i=i+1;
		IF MOD(i,2)!=0 THEN ITERATE a;
		END IF;
		
		INSERT INTO admin(username,`password`) VALUES(CONCAT('xiaohua',i),'0000');
		
	END WHILE a;
END $


CALL test_while1(100)$


-- 案例

/*
已知表stringcontent
其中字段：
id 自增长
content varchar(20)

向该表插入指定个数的，随机的字符串
*/
DROP TABLE IF EXISTS stringcontent;
CREATE TABLE stringcontent(
	id INT PRIMARY KEY AUTO_INCREMENT,
	content VARCHAR(20)
	
);
DELIMITER $
CREATE PROCEDURE test_randstr_insert(IN insertCount INT)
BEGIN
	DECLARE i INT DEFAULT 1;
	DECLARE str VARCHAR(26) DEFAULT 'abcdefghijklmnopqrstuvwxyz';
	DECLARE startIndex INT;#代表初始索引
	DECLARE len INT;#代表截取的字符长度
	WHILE i<=insertcount DO
		SET startIndex=FLOOR(RAND()*26+1);#代表初始索引，随机范围1-26
		SET len=FLOOR(RAND()*(20-startIndex+1)+1);#代表截取长度，随机范围1-（20-startIndex+1）
		INSERT INTO stringcontent(content) VALUES(SUBSTR(str,startIndex,len));
		SET i=i+1;
	END WHILE;

END $

CALL test_randstr_insert(10)$
