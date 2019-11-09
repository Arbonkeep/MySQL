-- 常见约束

-- 一、创建表时添加约束

CREATE DATABASE students;-- 创建students库
USE students;

-- 1.添加列级约束
/*
语法：

直接在字段名和类型后面追加 约束类型即可。

只支持：默认、非空、主键、唯一

*/

CREATE TABLE stuinfo(
	id INT PRIMARY KEY,#主键
	stuName VARCHAR(20) NOT NULL UNIQUE,#非空
	gender CHAR(1) CHECK(gender='男' OR gender ='女'),#检查(mysql中不支持但是语法不报错)
	seat INT UNIQUE,#唯一
	age INT DEFAULT  18,#默认约束
	majorId INT REFERENCES major(id)#外键(mysql中不支持)与major表关联

);

DROP TABLE IF EXISTS major;
CREATE TABLE major(
	id INT PRIMARY KEY,
	majorName VARCHAR(20)
);

-- 查看stuinfo中的所有索引，包括主键、外键、唯一
SHOW INDEX FROM stuinfo;


-- 2. 添加表级约束

/*

语法：在各个字段的最下面
 [constraint 约束名] 约束类型(字段名) 
*/

-- 方式一：为各个表级约束添加名字
DROP TABLE IF EXISTS stuinfo;
CREATE TABLE stuinfo(
	id INT,
	stuname VARCHAR(20),
	gender CHAR(1),
	seat INT,
	age INT,
	majorid INT,
	
	CONSTRAINT pk PRIMARY KEY(id,stuname),#主键(将两个字段组合成一个主键)
	CONSTRAINT uq UNIQUE(seat),#唯一键
	CONSTRAINT ck CHECK(gender ='男' OR gender  = '女'),#检查
	--CONSTRAINT fk_stuinfo_major FOREIGN KEY(majorid) REFERENCES major(id)#外键
	
);


-- 方式二：不为表级约束添加名字主键约束默认名为primary，其余默认都是字段名

DROP TABLE IF EXISTS stuinfo;
CREATE TABLE stuinfo(
	id INT,
	stuname VARCHAR(20),
	gender CHAR(1),
	seat INT,
	age INT,
	majorid INT,
	
	PRIMARY KEY(id),#主键
	UNIQUE(seat),#唯一键
	CHECK(gender ='男' OR gender  = '女'),#检查
	FOREIGN KEY(majorid) REFERENCES major(id)#外键
	
);


-- 通用写法

CREATE TABLE IF NOT EXISTS stuinfo(
	id INT PRIMARY KEY,
	stuname VARCHAR(20),
	sex CHAR(1),
	age INT DEFAULT 18,
	seat INT UNIQUE,
	majorid INT,
	CONSTRAINT fk_stuinfo_major FOREIGN KEY(majorid) REFERENCES major(id)
	-- 为外键起名一般是:外键单词的首字母_主表名_副表名

);


-- 组合主键

-- 如方式一所示，我们将id和stuname组合成主键，接下来添加数据进行分析
-- 只有在id与stuname都相同的时候，才会导致添加失败（主键约束的限制），如下所示
INSERT INTO stuinfo VALUES(1,'jhon','男',NULL,19,1);
INSERT INTO stuinfo VALUES(1,'jhon','男',NULL,19,2);


-- 外键

/*
	<1> 要求在从表设置外键关系

	<2> 从表的外键列的类型和主表的关联列的类型要求一致或兼容，名称无要求

	<3> 主表的关联列必须是一个key（一般是主键或唯一键）。如果不是的话就会关联失败，从而报错

	<4> 插入数据时，先插入主表，再插入从表删除数据时，先删除从表，再删除主表	
*/

-- 演示：主表的关联列必须是一个key（一般是主键或唯一键）。如果不是的话就会关联失败，从而报错

DROP TABLE IF EXISTS major;
CREATE TABLE major(
	id INT PRIMARY KEY,-- 如果将主键去掉，那么下面stuinfo就不能添加该外键约束
	majorName VARCHAR(20)
);

DROP TABLE IF EXISTS stuinfo;
CREATE TABLE IF NOT EXISTS stuinfo(
	id INT PRIMARY KEY,
	stuname VARCHAR(20),
	sex CHAR(1),
	age INT DEFAULT 18,
	seat INT UNIQUE,
	majorid INT,
	CONSTRAINT fk_stuinfo_major FOREIGN KEY(majorid) REFERENCES major(id)
	-- 为外键起名一般是:外键单词的首字母_主表名_副表名

);


-- 注意：添加约束可以在一个字段添加多个约束
CREATE TABLE major(
	id INT PRIMARY KEY DEFAULT 1 UNIQUE,
	majorName VARCHAR(20)
);


-- 二、修改表时添加约束


DROP TABLE IF EXISTS stuinfo;
CREATE TABLE IF NOT EXISTS stuinfo(
	id INT ,
	stuname VARCHAR(20),
	sex CHAR(1),
	age INT DEFAULT 18,
	seat INT UNIQUE,
	majorid INT
);

DESC stuinfo;

-- 1.添加非空约束
ALTER TABLE stuinfo MODIFY COLUMN stuname VARCHAR(20) NOT NULL;

-- 2.添加默认约束
ALTER TABLE stuinfo MODIFY COLUMN age INT DEFAULT 18;

-- 3.添加主键

-- <1>列级约束
ALTER TABLE stuinfo MODIFY COLUMN id INT PRIMARY KEY;
-- <2>表级约束
ALTER TABLE stuinfo ADD PRIMARY KEY(id);

-- 4.添加唯一

-- <1>列级约束
ALTER TABLE stuinfo MODIFY COLUMN seat INT UNIQUE;
-- <2>表级约束
ALTER TABLE stuinfo ADD UNIQUE(seat);

-- 5.添加外键
ALTER TABLE stuinfo ADD CONSTRAINT fk_stuinfo_major FOREIGN KEY(majorid) REFERENCES major(id); 


-- 三、修改表时删除约束

-- 1.删除非空约束
ALTER TABLE stuinfo MODIFY COLUMN stuname VARCHAR(20) NULL;

-- 2.删除默认约束
ALTER TABLE stuinfo MODIFY COLUMN age INT ;

-- 3.删除主键
ALTER TABLE stuinfo MODIFY COLUMN id INT;

ALTER TABLE stuinfo DROP PRIMARY KEY;

-- 4.删除唯一
ALTER TABLE stuinfo DROP INDEX seat;

-- 5.删除外键
ALTER TABLE stuinfo DROP FOREIGN KEY fk_stuinfo_major;

SHOW INDEX FROM stuinfo;


