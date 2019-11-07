#DDL

-- 创建db5判断是否存在，并指定字符集为utf8
CREATE DATABASE IF NOT EXISTS db5 CHARACTER SET gbk;

SHOW CREATE DATABASE db5;-- 显示某个数据库的字符集

SELECT DATABASE();-- 显示数据库名称

USE db5; -- 使用数据库db5

CREATE TABLE student(-- 创建表
	id INT,
	NAME VARCHAR(32),
	age INT
);

SHOW TABLES;-- 查询所有表名称

DESC student;-- 查询表的结构

DROP TABLE student;-- 删除表

DROP TABLE IF EXISTS student; -- 如果存在学生表就删除

ALTER TABLE student RENAME TO person;-- 修改表名为person

ALTER TABLE person CHARACTER SET utf8;-- 修改表的字符集

ALTER TABLE person ADD gender VARCHAR(1);-- 为表增加一列数据（性别）

DESC person;

ALTER TABLE person CHANGE gender sex VARCHAR(1);-- 修改表中列的名称和类型

ALTER TABLE person MODIFY sex VARCHAR(2);-- 修改表中的列的数据类型

ALTER TABLE person DROP sex;-- 删除表中的列



#DML

INSERT INTO person(id,NAME,age)VALUES(1,"zhangsan",23);-- 在表中添加一条数据

INSERT INTO person(id,NAME,age)VALUES(2,"lisi",24);-- 在表中添加一条数据

DELETE FROM person WHERE id = 1;-- 删除表中一条数据（id = 1）

DELETE FROM person;-- 删除表中所有的数据

TRUNCATE TABLE person;-- 删除表中所有数据,然后再创建一个一样的空表

SELECT * FROM person;

UPDATE person SET NAME = "xiaosan",age = 18,sex = "男" WHERE id = 1;-- 修改表中的数据(当id=1时将表的数据修改)
-- 注意如果不加条件那么表中所有数据都会被修改




#DQL 

-- select 字段列表 from 表名 where 条件 group by 分组字段 having 分组之后的条件 order by 排序 limit 分页限定


SELECT NAME,age FROM person WHERE id = 1;-- 查询person表中id = 1的name,age


CREATE TABLE student (
 id INT, -- 编号
 NAME VARCHAR(20), -- 姓名
 age INT, -- 年龄
 sex VARCHAR(5), -- 性别
 address VARCHAR(100), -- 地址
 math INT, -- 数学
 english INT -- 英语
);
INSERT INTO student(id,NAME,age,sex,address,math,english) VALUES (1,'马云',55,'男','
杭州',66,78),(2,'马化腾',45,'女','深圳',98,87),(3,'马景涛',55,'男','香港',56,77),(4,
'柳岩',20,'女','湖南',76,65),(5,'柳青',20,'男','湖南',86,NULL),(6,'刘德华',57,'男',
'香港',99,99),(7,'马德',22,'女','香港',99,99),(8,'德玛西亚',18,'男','南京',56,65);

DROP TABLE student;
SELECT * FROM student;

SELECT address FROM student;-- 查询所有的地址
SELECT DISTINCT address FROM student;-- 使用distinct去除重复的地址

SELECT DISTINCT NAME,address FROM student;-- 只能去除name和address都一样的结果


-- 查询姓名和年龄
SELECT 
	NAME,-- 姓名
	age -- 年龄
FROM 
	student;-- 学生表

SELECT * FROM student;-- 这是查询所有,但是不建议这么写


SELECT address FROM student;-- 查询地址

-- 去除重复的结果集(只有结果集完全一样的才能去除)
SELECT DISTINCT address FROM student;-- 使用distinct去除重复，注意格式不正确（空字符）可能导致删除重复不成功

SELECT NAME , address FROM student;

-- 计算math和english 分数之和
SELECT NAME,math,english,math + english FROM student;

-- 如果有null参与计算的结果都为null(通过ifnull解决)
SELECT NAME,math,english,math + IFNULL (english,0) FROM student;

-- 起别名
SELECT NAME,math 数学,english 英语,math + IFNULL(english,0) AS 总分 FROM student;-- as可以用空格替代


SELECT * FROM student;



/*
条件查询

*/

-- 查询年龄大于20岁
SELECT * FROM student WHERE age > 20;
-- 查询年龄大于等于20岁
SELECT * FROM student WHERE age >= 20;

-- 查询年龄等于20岁
SELECT * FROM student WHERE age = 20;

-- 查询年龄不等于20岁
SELECT * FROM student WHERE age != 20;
SELECT * FROM student WHERE age <> 20;-- 这也是查询不等于20岁的，<>也相当于!=

-- 查询年龄大于等于20,小于等于30
SELECT * FROM student WHERE age >= 20 && age <= 30; -- 不推荐这样使用

SELECT * FROM student WHERE age >= 20 AND age <= 30;
SELECT * FROM student WHERE age BETWEEN 20 AND 30; -- 推荐这样使用 包含20也包含30

-- 查询年龄22岁的,19岁，25岁的信息
SELECT * FROM student WHERE age = 22 OR age = 18 OR age = 25;
SELECT * FROM student WHERE age IN(18,22,25);

-- 查询英语成绩为null
SELECT * FROM student WHERE english = NULL;-- 错误的,null不能使用=（!=）判断
SELECT * FROM student WHERE english IS NULL;

-- 查询英语成绩不为null
SELECT * FROM student WHERE english IS NOT NULL;



/*
like 模糊查询
	占位符:
		_:代表单个任意字符
		%:代表多个任意字符
*/


-- 查询姓马的有哪些？
SELECT * FROM student WHERE NAME LIKE '马%';

-- 查询姓名中第二个字是化的人
SELECT * FROM student WHERE NAME LIKE '_化%';

-- 查询姓名是三个字的人
SELECT * FROM student WHERE NAME LIKE "___";

-- 查询姓名中包含德的人
SELECT * FROM student WHERE NAME LIKE "%德%";


-- DQL排序查询（orderby）

SELECT * FROM student ORDER BY math ASC;-- 升序排序方式（没有加上排序方式默认是升序）

SELECT * FROM student ORDER BY math DESC;-- 降序排序方式

-- 按照数学成绩排名，如果数学成绩一样就按照英语成绩排序,都按照升序

SELECT * FROM student ORDER BY math ASC , english ASC;
-- 意思是先按照数学升序排,如果数学成绩一样,就按照英语成绩升序排
-- 注意：如果有多个排序条件,但前面的条件值一样时,才会判断第二条件(按照第二条件排序)



-- DQL聚合函数（将一列数据作为一个整体,进行纵向的计算）
	-- 注意:聚合函数的计算会排除null值

SELECT COUNT(NAME) FROM student;-- 统计有多少个人
SELECT COUNT(english) FROM student;-- 聚合函数的计算会排除null值
SELECT COUNT(IFNULL (english,0)) FROM student; -- 解决方案一

SELECT COUNT(id) FROM student;-- 不推荐使用,用主键代替

SELECT MAX(math) FROM student;-- 最大值

SELECT MIN(math) FROM student;-- 最小值

SELECT SUM(math) FROM student;-- 数学求和

SELECT SUM(english) FROM student; -- 英语成绩的和(这里排除了null)

SELECT AVG(math) FROM student;-- 数学成绩的平均值



-- DQL分组查询(注意：查询的字段必须是分组的字段或者聚合函数)

SELECT * FROM student;

-- 按照性别分组,分别查询男，女同学的平均分
SELECT sex,AVG (math) FROM student GROUP BY sex;

-- 按照性别分组,分别查询男，女同学的平均分,统计男女人数
SELECT sex , AVG(math) , COUNT(id) FROM student GROUP BY sex; -- 注意：字段必须是分组的字段或者聚合函数

-- 按照性别分组,分别查询男，女同学的平均分,统计男女人数 要求:分数低于70分不参与分组
SELECT sex , AVG(math) , COUNT(id) FROM student WHERE math > 70 GROUP BY sex;

-- 按照性别分组,分别查询男，女同学的平均分,统计男女人数 要求:分数低于70分不参与分组，分组之后人数大于2
SELECT sex , AVG(math) , COUNT(id) FROM student WHERE math >= 70 GROUP BY sex HAVING COUNT(id) > 2;
SELECT sex , AVG(math), COUNT(id) AS 人数 FROM student WHERE math >= 70 GROUP BY sex HAVING 人数 > 2;

-- where 和having的区别
-- 1、where在分组之前进行限定,如果不满足条件不参与分组,having在分组之后参与限定,如果不满足结果,则不会被查询出来
-- 2、where后面不能跟聚合函数(不能进行聚合函数判断),而having可以进行聚合函数的判断




-- DQL分页查询(limit是一种方言)

-- 语法:
	-- limit 开始索引,每页查询的条数;


-- 每页显示三条记录
SELECT * FROM student LIMIT 0 , 3;-- 第1页
SELECT * FROM student LIMIT 3 , 3;-- 第2页
SELECT * FROM student LIMIT 6 , 3;-- 第3页

-- 公式 开始的索引 = （当前的页码 - 1） * 每页显示的条数






## 约束（对表中的数据进行限定,从而保证数据的正确性,有效性和完整性）

-- 非空约束（not null）

-- 第一种方式，创建表的时候添加非空约束
CREATE TABLE stu(
	id INT,
	NAME VARCHAR(20)NOT NULL-- name 为非空
);-- 创建表

SELECT * FROM stu;

INSERT INTO stu(id , NAME) VALUES(1,"张三丰");-- 为表添加数据源

INSERT INTO stu(id , NAME) VALUES(2,NULL);-- 这样不能添加,因为我们在创建表时设置了非空约束

-- 删除name的非空约束(即修改name字段)
ALTER TABLE stu MODIFY NAME VARCHAR(20);


-- 第二种方式，创建表完之后，添加非空约束
ALTER TABLE stu MODIFY NAME VARCHAR(20) NOT NULL;

-- 删除表
DROP TABLE stu;





-- 唯一约束(unique 值不能重复) 

-- 第一种方式,在创建表的时候添加唯一约束
CREATE TABLE stu2(
	id INT,
	phone_number VARCHAR(20) UNIQUE
);

SELECT * FROM stu2;


INSERT INTO stu2(id,phone_number) VALUES (1,1111);

INSERT INTO stu2(id,phone_number) VALUES (2,1111); -- 出错,这里创建表时设置了唯一约束（唯一索引）

-- 注意：mysql中
,唯一约束限定的列的值可以有多个null

-- 删除唯一约束

-- alter table stu2 modify phone_number varchar(20);  唯一约束不能这样删除,这样删不掉
ALTER TABLE stu2 DROP INDEX phone_number;

-- 第二种方式,在创建表之后添加唯一约束
ALTER TABLE stu2 MODIFY phone_number VARCHAR(20) UNIQUE;

-- 删除表
DROP TABLE stu2;





-- 主键约束（primary key ）非空且唯一,一张表只能有一个字段为主键,主键就是表中记录的唯一标识

-- 第一种方式,在创建表时添加主键约束
CREATE TABLE stu3(
	id INT PRIMARY KEY,-- 给id添加主键约束
	NAME VARCHAR(20)
);

SELECT * FROM stu3;

INSERT INTO stu3(id,NAME) VALUES(1,"aaa");

INSERT INTO stu3(id,NAME) VALUES(1,"bbb");-- 不能添加成功,因为在创建表时设置了主键约束(非空且唯一)

INSERT INTO stu3(id,NAME) VALUES(NULL,"ccc");-- 不能添加成功,因为创建表时设置了主键约束(非空且唯一)

-- 删除主键约束
-- alter table stu3 modify id int;  -- 这种方式并不能真正删除主键约束

ALTER TABLE stu3 DROP PRIMARY KEY;

-- 第二种方式,在创建表之后添加主键约束
ALTER TABLE stu3 MODIFY id INT PRIMARY KEY;

-- 删除表
DROP TABLE stu3;




-- 自动增长（一般与主键连在一起用）
	-- 概念:如果某一列是数值类型,使用auto_increment 可以来完成值的自动增长
	-- 注意:自动增长只与上一条记录有关

-- 创建表时,添加主键约束,并且完成主键的自动增长
CREATE TABLE stu4(
	id INT PRIMARY KEY AUTO_INCREMENT,-- 给id添加主键约束,并添加自动增长
	NAME VARCHAR(20)
);

SELECT * FROM stu4;

INSERT INTO stu4 VALUES(NULL,"ccc");-- 在表中添加数据（注意id会自动增长,同时你也可以手动给出）

INSERT INTO stu4 VALUES(3,"bbb");-- 手动给出id值

DELETE FROM stu4 WHERE id = 3;-- 删除id=3的数据

INSERT INTO stu4 VALUES(10,"bbb");-- 手动给出id值

INSERT INTO stu4 VALUES(NULL,"bbb")-- 自动增长(id=11),自动增长只与上一条记录有关

-- 删除自动增长
ALTER TABLE stu4 MODIFY id INT;

-- 在创建表后,添加自动增长
ALTER TABLE stu4 MODIFY id INT AUTO_INCREMENT;







-- 外键约束

CREATE TABLE emp(   -- 创建表emp
	id INT PRIMARY KEY AUTO_INCREMENT,
	NAME VARCHAR(30),
	age INT,
	dep_name VARCHAR(30),-- 部门名称
	dep_location VARCHAR(30)-- 部门地址

);

-- 添加地址

INSERT INTO emp(NAME,age,dep_name,dep_location) VALUES("张三",20,"研发部","广州");
INSERT INTO emp(NAME,age,dep_name,dep_location) VALUES("李四",21,"研发部","广州");
INSERT INTO emp(NAME,age,dep_name,dep_location) VALUES("王五",20,"研发部","广州");
INSERT INTO emp(NAME,age,dep_name,dep_location) VALUES("老王",20,"销售部","深圳");
INSERT INTO emp(NAME,age,dep_name,dep_location) VALUES("大王",22,"销售部","深圳");
INSERT INTO emp(NAME,age,dep_name,dep_location) VALUES("小王",18,"销售部","深圳");

SELECT * FROM emp;

-- 数据有冗余（dep_name和dep_location）



-- 解决方案：表的拆分,分成 2 张表
-- 创建部门表(id,dep_name,dep_location)
-- 一方，主表
CREATE TABLE department(
	id INT PRIMARY KEY AUTO_INCREMENT,
	dep_name VARCHAR(20),
	dep_location VARCHAR(20)
);
-- 创建员工表(id,name,age,dep_id)
-- 多方，从表

-- 创建表时,添加外键约束
CREATE TABLE employee(
	id INT PRIMARY KEY AUTO_INCREMENT,
	NAME VARCHAR(20),
	age INT,
	dep_id INT, -- 外键对应主表的主键（部门编号）
	CONSTRAINT emp_dept_fk FOREIGN KEY (dep_id) REFERENCES department(id)-- 添加外键
);
-- 添加 2 个部门
INSERT INTO department VALUES(NULL, '研发部','广州'),(NULL, '销售部', '深圳');

-- 添加员工,dep_id 表示员工所在的部门
INSERT INTO employee (NAME, age, dep_id) VALUES ('张三', 20, 1);

INSERT INTO employee (NAME, age, dep_id) VALUES ('李四', 21, 1);
INSERT INTO employee (NAME, age, dep_id) VALUES ('王五', 20, 1);
INSERT INTO employee (NAME, age, dep_id) VALUES ('老王', 20, 2);
INSERT INTO employee (NAME, age, dep_id) VALUES ('大王', 22, 2);
INSERT INTO employee (NAME, age, dep_id) VALUES ('小王', 18, 2);


SELECT * FROM employee;


-- 删除三张表
DROP TABLE emp;
DROP TABLE department;
DROP TABLE employee;



-- 删除外键约束
ALTER TABLE employee DROP FOREIGN KEY emp_dept_fk;
--           表名                       外键名

-- 在创建表之后,添加外键约束
ALTER TABLE employee ADD CONSTRAINT emp_dept_fk FOREIGN KEY(dep_id) REFERENCES department(id);
--            表名                    外键名                外键字段名称       主表名称(主表列名称)








-- 级联


-- 修改外键中的的值
UPDATE employee SET dep_id = NULL WHERE dep_id = 1;-- 当dep_id = 1时将其设置为null
-- 注意:外键值可以为null但是不能为原来不存在的外键值

UPDATE employee SET dep_id = 5 WHERE dep_id IS NULL;-- 当dep_id 为null时将其设置为5


-- 删除外键约束
ALTER TABLE employee DROP FOREIGN KEY emp_dept_fk;

-- 添加外键约束,设置级联更新（来修改外键中的值）
ALTER TABLE employee ADD CONSTRAINT emp_dept_fk FOREIGN KEY(dep_id) REFERENCES department(id) ON UPDATE CASCADE;

-- 添加外键约束,设置级联删除（删除外键中的值）
ALTER TABLE employee ADD CONSTRAINT emp_dept_fk FOREIGN KEY(dep_id) REFERENCES department(id) ON DELETE CASCADE;

-- 注意:级联删除和级联更新可以同时设置


SELECT * FROM employee;





## 多表查询


-- 创建部门表
CREATE TABLE dept(
 id INT PRIMARY KEY AUTO_INCREMENT,
 NAME VARCHAR(20)
);
-- 在部门表中添加数据
INSERT INTO dept (NAME) VALUES ('开发部'),('市场部'),('财务部');
# 创建员工表
CREATE TABLE emp (
 id INT PRIMARY KEY AUTO_INCREMENT,
 NAME VARCHAR(10),
 gender CHAR(1), -- 性别
 salary DOUBLE, -- 工资
 join_date DATE, -- 入职日期
 dept_id INT,
 FOREIGN KEY (dept_id) REFERENCES dept(id) -- 外键，关联部门表(部门表的主键)
);

-- 在员工表中添加数据

INSERT INTO emp(NAME,gender,salary,join_date,dept_id) VALUES('孙悟空','男',7200,'2013-02-24',1);
INSERT INTO emp(NAME,gender,salary,join_date,dept_id) VALUES('猪八戒','男',3600,'2010-12-02',2);
INSERT INTO emp(NAME,gender,salary,join_date,dept_id) VALUES('唐僧','男',9000,'2008-08-08',2);
INSERT INTO emp(NAME,gender,salary,join_date,dept_id) VALUES('白骨精','女',5000,'2015-10-07',3);
INSERT INTO emp(NAME,gender,salary,join_date,dept_id) VALUES('蜘蛛精','女',4500,'2011-03-14',1);





SELECT * FROM emp,dept;
SELECT * FROM dept;

-- 笛卡尔积(有两个集合A,B,取这两个集合的所有组合情况)
-- 要完成多表查询,需要消除无用的数据

-- 消除无用的数据
	-- 1、内连接查询
		-- 隐式内连接：使用where条件来消除无用的数据
		-- 显示内连接: select * from 表1 inner join  表二 on 条件
	-- 2、外连接查询
		-- 左外连接：select 字段列表 from 表1 left outer join 表2 on 条件（outer可以省略）
			-- 查询的是左边表的所有数据以及其交集部分
		-- 右外连接：select 字段列表 from 表1 right outer join 表2 on 条件（outer可以省略）
			-- 查询的是右边表的所有数据以及其交集部分
	-- 3、子查询



#内连接查询

--  查询所有员工信息和对应的部门信息(隐式内连接查询)
SELECT * FROM emp,dept WHERE emp.`dept_id` = dept.`id`;

-- 查询员工表的名称,性别,部门表名称
SELECT emp.`name`,emp.`gender`,dept.`name` FROM emp,dept WHERE emp.`dept_id` = dept.`id`;

-- 标准形式(简化：将表名指定为别名)
	-- 注意:一个关键字占一行,一个字段占一行,一个表占一行,一个条件占一行
SELECT
	t1.`name`,-- 员工表的姓名
	t1.`gender`,-- 员工表的性别
	t2.`name`-- 部门表的名称
FROM
	emp t1,-- 员工表
	dept t2-- 部门表
WHERE
	t1.`dept_id`=t2.`id`;


-- 查询所有员工信息和对应部门信息（显式内连接）
SELECT * FROM emp INNER JOIN dept ON emp.`dept_id` = dept.`id`;
SELECT * FROM emp JOIN dept ON emp.`dept_id` = dept.`id`;  -- inner可以省略




#外连接查询

SELECT * FROM dept;
SELECT * FROM emp;

-- 在员工表添加第六条数据
INSERT INTO emp (id,NAME,gender,salary) VALUES (NULL,"小白龙","男",3000);

-- 查询所有员工信息,如果员工有部门,则查询部门名称,如果没有部门就不显示部门名称

-- 使用内连接查询(失败,第六条信息没有部门信息,被认为不合法信息被排除)
SELECT 
	t1.*,t2.`name`
FROM
	emp t1,dept t2
WHERE
	t1.`dept_id` = t2.`id`;
	
-- 使用左外连接查询(成功)
SELECT t1.*,t2.`name` FROM emp t1 LEFT JOIN dept t2 ON t1.`dept_id` = t2.`id`;

-- 使用右外链接查询
SELECT t1.*,t2.`name` FROM emp t1 RIGHT JOIN dept t2 ON t1.`dept_id` = t2.`id`;
-- (第六条数据没查询到,因为这查寻到的是dept表中的记录和交集,第六条数据不在交集中)

SELECT t1.`name`,t2.* FROM dept t1 RIGHT JOIN emp t2 ON t1.`id` = t2.`dept_id`;
-- 交换位置后查询成功





#子查询(查询中嵌套查询,称嵌套的查询为子查询)
	-- 子查询的结果是单行单列的（子查询可以作为条件,使用运算符（>,<,<=,>=,=等）去判断）
	-- 子查询的结果是多行单列的(也可以作为条件,使用运算符in来判断)
	-- 子查询的结果是多行多列的(可以作为一张虚拟表参与查询)


-- 查询工资最高的员工信息（子查询的结果是单行单列的）

-- 1、查询最高工资是多少 9000
SELECT MAX(salary) FROM emp;
-- 2、查询工资=900的员工信息
SELECT * FROM emp WHERE salary = 9000;

-- 合并成一条语句
SELECT * FROM emp WHERE emp.`salary` = (SELECT MAX(salary) FROM emp);

-- 查询员工工资小于平均工资的人
SELECT * FROM emp WHERE emp.`salary` < (SELECT AVG(salary) FROM emp);


-- 查询‘财务部’所有的员工信息
SELECT id FROM dept WHERE NAME = "财务部";
SELECT * FROM emp WHERE id = 3;

-- 查询‘财务部’和"市场部"所有的员工信息（子查询的结果是多行单列的）
SELECT id FROM dept WHERE NAME = "财务部" OR NAME = "市场部";
SELECT * FROM emp WHERE dept_id = 3 OR dept_id = 2;
SELECT * FROM emp WHERE dept_id IN(2,3);
SELECT * FROM emp WHERE dept_id IN(SELECT id FROM dept WHERE NAME = "财务部" OR NAME = "市场部");-- 整合成一句


-- 查询员工入职日期是2011-11-11之后的员工信息和部门信息
SELECT * FROM emp WHERE emp.`join_date` > "2011-11-11";-- 查询的员工信息
-- 子查询（多行多列）
SELECT * FROM dept t1,(SELECT * FROM emp WHERE emp.`join_date` > "2011-11-11") t2 WHERE t1.`id` = t2.dept_id;
-- 内连接查询
SELECT * FROM emp t1,dept t2 WHERE t1.`dept_id` = t2.`id` AND t1.`join_date` > "2011-11-11";





## 事务

-- 创建数据表
CREATE TABLE account (
	id INT PRIMARY KEY AUTO_INCREMENT,
	NAME VARCHAR(10),
	balance DOUBLE
);
-- 添加数据
INSERT INTO account (NAME, balance) VALUES ('zhangsan', 1000),('lisi', 1000);

SELECT * FROM account;


-- 张三给李四转账500元

-- 还原为1000
UPDATE account SET balance = 1000;



-- 开启事务
START TRANSACTION;
-- 张三账户-500
UPDATE account SET balance = balance - 500 WHERE NAME = "zhangsan";
-- 李四账户+500
-- 出错了
UPDATE account SET balance = balance + 500 WHERE NAME = "lisi";

-- 如果出现问题，就回滚事务（注意：使用事务后直接本页查询会出现临时数据的改变,想要查看真实数据需要新建一个查询窗口）
ROLLBACK;

-- 如果没有出现问题,就提交事务
COMMIT;


SELECT * FROM account;

SELECT @@autocommit;-- 1代表自动提交,0代表手动提交

-- mysql默认是是自动提交,oracle默认是手动提交
-- 设置手动提交(注意设置了手动提交之后,要加上commit语句提交事务)
SET @@autocommit = 0;

UPDATE account SET balance = 30;

COMMIT;


-- 事务的四大特征
	-- 1、原子性:是不可分割的最小单位,要么同时成功,要么同时失败
	-- 2、持久性:当事务提交或者回滚之后,数据库会持久化保存数据
	-- 3、隔离性:多个事务之间,相互独立
	-- 4、一致性:事务操作前后,数据总量不变

-- 事务的隔离级别（多个事务之间是隔离的,相互独立的。但是多个事务操作同一批数据，则会引发一些问题,设置不同的隔离级别就可以解决这些问题）
	-- 存在问题:
		-- 1、脏读:一个事务读取到另一个事务中没有提交的数据
		-- 2、不可重复读:在同一个事务中,两次读取到的数据不一样
		-- 3、幻读:一个事务操作（DML）数据表中所有记录,另一个事务添加了一条数据,则第一个事务查询不到自己的修改
	-- 隔离级别:
		-- 1、read uncommitted：读未提交
			-- 产生问题：脏读，不可重复读，幻读
		-- 2、read committed：读已提交（oracle默认）
			-- 产生问题:不可重复读,幻读
		-- 3、repeatable read:可重复读（mysql默认）
			-- 产生问题:幻读
		-- 4、serializable：串行化
			-- 可以解决所有问题

	-- 注意:隔离级别从小到大安全性越来越高,但是效率越来越低


-- 查询隔离级别
SELECT @@tx_isolation;

-- 设置隔离级别
SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED;-- 将隔离级别设置为read committed 



-- 演示产生的问题
	-- 1、设置隔离级别:
		-- set global transaction isolation level read uncommitted;
	-- 2、开启事务:
		-- start transaction;
	-- 3、转账操作
		-- update account set balance = balance - 500 where id = 1;
		-- update account set balance = balance + 500 where id = 2;





## DCL
	-- 管理用户,授权


-- 管理用户
	-- 创建用户
	-- 删除用户
	-- 修改用户密码
	-- 查询用户
	
	
	
-- 查询用户(注意: 通配符:% 表示可以在任意主机使用用户登录数据库)
-- 1、切换到mysql数据库
USE mysql;
-- 2、查询user表
SELECT * FROM USER ;


-- 创建用户
-- 语法:create user "用户名"@"主机名" identified by "密码";（注意:@两边不能夹空格）
CREATE USER 'zhangsan'@'localhost' IDENTIFIED BY '123';
CREATE USER "lisi"@"%" IDENTIFIED BY "123";-- 创建一个任意主机可以登录数据库的用户lisi


-- 删除用户
-- 语法:drop user "用户名"@"主机名";
DROP USER "zhangsan"@"localhost";


-- 修改用户密码
-- 语法:update user set password = password("新密码") where user = "用户名";

-- 修改lisi用户密码为abc
UPDATE USER SET PASSWORD = PASSWORD('abc') WHERE USER = 'lisi';-- 注意:有问题

-- 简写形式
-- 语法: set password for '用户名'@'主机名' = password('新密码');
SET PASSWORD FOR 'lisi'@'%' = PASSWORD('123');


-- mysql忘记密码怎么办?
	-- 1、cmd-->执行 net stop mysql 停止mysql服务(注意:需要管理员运行cmd)
	-- 2、使用无验证方式启动mysql服务:mysqld --skip-grant-tables
	-- 3、打开新的cmd窗口直接输入mysql命令,敲回车就可以登录成功
	-- 4、use mysql;
	-- 5、update user set password = password("新密码") where user = 'root'
	-- 6、关闭两个窗口
	-- 7、打开任务管理器,手动结束mysqld.exe进程
	-- 8、启动mysql服务
	-- 9、使用新密码登录





