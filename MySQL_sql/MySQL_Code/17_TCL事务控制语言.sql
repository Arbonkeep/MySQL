-- TCL事务控制语言

/*
存储引擎：
 在mysql中用的最多的存储引擎有：innodb(5.5之后默认)， myisam ,memory 等。其中innodb支持事务，
 而 myisam、memory等不支持事务
*/

-- 查看mysql支持的存储引 擎
SHOW ENGINES;

/*
	事务的创建
	
	隐式事务：事务没有明显的开启和结束的标记
		  比如insert、update、delete语句

		  delete from 表 where id =1;

	显式事务：事务具有明显的开启和结束的标记
		  前提：必须先设置自动提交功能为禁用

	set autocommit=0;

	步骤1：开启事务
		set autocommit=0;
		start transaction;可选的
	步骤2：编写事务中的sql语句(select insert update delete)
		语句1;
		语句2;
		...

	步骤3：结束事务
		commit;提交事务
		rollback;回滚事务
*/

-- 显示变量(自动提交)
SHOW VARIABLES LIKE 'autocommit';


-- 创建表account
CREATE TABLE account(
	id INT PRIMARY KEY AUTO_INCREMENT,
	username VARCHAR(20),
	balance DOUBLE
);

INSERT INTO account (username,balance)
VALUES('张无忌',1000),('赵敏',1000);



-- 1.演示事务的使用步骤

-- 开启事务
SET autocommit=0;
START TRANSACTION;
-- 编写一组事务的语句
UPDATE account SET balance = 1000 WHERE username='张无忌';
UPDATE account SET balance = 1000 WHERE username='赵敏';

-- 结束事务
ROLLBACK;
COMMIT;

SELECT * FROM account;

-- 总结：当我们开启事务后修改表中数据，提交事务会完成最终修改，回滚事务会回到之前的状态




-- 事务的隔离级别

/*
事务的隔离级别：
		  脏读		不可重复读	幻读
read uncommitted：√		√		√
read committed：  ×		√		√	oracle默认
repeatable read： ×		×		√	mysql默认
serializable	  ×             ×               ×

*/


-- Mysql 默认的事务隔离级别为: REPEATABLE READ

-- 查看当前事务的隔离级别
SELECT @@tx_isolation;


-- 设置隔离级别(read uncommitted)
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


-- 设置编码
SET NAMES gbk;


-- 2.演示事务对于delete和truncate的处理的区别
-- delete 语句是支持回滚的，而trancate不支持回滚

-- 演示delete
SET autocommit=0;
START TRANSACTION;

DELETE FROM account;
ROLLBACK;

-- 演示truncate
SET autocommit=0;
START TRANSACTION;
TRUNCATE TABLE account;
ROLLBACK;





-- 3.演示savepoint 的使用
SET autocommit=0;
START TRANSACTION;

DELETE FROM account WHERE id=25;
SAVEPOINT a;-- 设置保存点
DELETE FROM account WHERE id=28;
ROLLBACK TO a;-- 回滚到保存点


SELECT * FROM account;


