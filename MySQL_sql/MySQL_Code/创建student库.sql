DROP DATABASE IF EXISTS student;
CREATE DATABASE student;
USE student;

CREATE TABLE student(
	studentno VARCHAR(10) NOT NULL PRIMARY KEY,
	studentname VARCHAR(20) NOT NULL,
	loginpwd VARCHAR(8) NOT NULL,
	sex CHAR(1) ,
	majorid INT NOT NULL REFERENCES grade(majorid),
	phone VARCHAR(11),
	email VARCHAR(20) ,
	borndate DATETIME
);

CREATE TABLE major(
	majorid INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	majorname VARCHAR(20) NOT  NULL

);
CREATE TABLE result(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	studentno VARCHAR(10) NOT NULL REFERENCES student(studentno),
	score DOUBLE
);


INSERT INTO major VALUES(NULL,'javaee');
INSERT INTO major VALUES(NULL,'html5');
INSERT INTO major VALUES(NULL,'android');


INSERT INTO student VALUES('S001','张三封','8888','男',1,'13288886666','zhangsanfeng@126.com','1966-9-1');
INSERT INTO student VALUES('S002','殷天正','8888','男',1,'13888881234','yintianzheng@qq.com','1976-9-2');
INSERT INTO student VALUES('S003','周伯通','8888','男',2,'13288886666','zhoubotong@126.com','1986-9-3');
INSERT INTO student VALUES('S004','张翠山','8888','男',1,'13288886666',NULL,'1995-9-4');
INSERT INTO student VALUES('S005','小小张','8888','女',3,'13288885678','xiaozhang@126.com','1990-9-5');

INSERT INTO student VALUES('S006','张无忌','8888','男',2,'13288886666','zhangwuji@126.com','1998-8-9');
INSERT INTO student VALUES('S007','赵敏','0000','女',1,'13288880987','zhaomin@126.com','1998-6-9');
INSERT INTO student VALUES('S008','周芷若','6666','女',1,'13288883456','zhouzhiruo@126.com','1996-7-9');
INSERT INTO student VALUES('S009','殷素素','8888','女',1,'13288886666','yinsusu@163.com','1986-1-9');
INSERT INTO student VALUES('S010','宋远桥','6666','男',3,'1328888890','songyuanqiao@qq.com','1996-2-9');


INSERT INTO student VALUES('S011','杨不悔','6666','女',2,'13288882345',NULL,'1995-9-9');
INSERT INTO student VALUES('S012','杨逍','9999','男',1,'13288885432',NULL,'1976-9-9');
INSERT INTO student VALUES('S013','纪晓芙','9999','女',3,'13288888765',NULL,'1976-9-9');
INSERT INTO student VALUES('S014','谢逊','9999','男',1,'13288882211',NULL,'1946-9-9');
INSERT INTO student VALUES('S015','宋青书','9999','男',3,'13288889900',NULL,'1976-6-8');



INSERT INTO result VALUES(NULL,'s001',100);
INSERT INTO result VALUES(NULL,'s002',90);
INSERT INTO result VALUES(NULL,'s003',80);

INSERT INTO result VALUES(NULL,'s004',70);
INSERT INTO result VALUES(NULL,'s005',60);
INSERT INTO result VALUES(NULL,'s006',50);
INSERT INTO result VALUES(NULL,'s006',40);
INSERT INTO result VALUES(NULL,'s005',95);
INSERT INTO result VALUES(NULL,'s006',88);

-- 查询每个专业的男生人数和女生人数分别是多少

-- 方式1
SELECT COUNT(*) 个数,sex,majorid
FROM student
GROUP BY sex,majorid;

-- 方式2
SELECT majorid,
(SELECT COUNT(*) FROM student WHERE sex='男' AND s.`majorid` = majorid) 男,
(SELECT COUNT(*) FROM student WHERE sex='女' AND s.`majorid` = majorid) 女
FROM student s
GROUP BY majorid;


-- 查询专业和张翠山一样的学生的最低分
-- <1> 查询张翠山的专业编号
SELECT majorid
FROM student
WHERE studentname = '张翠山'

-- <2> 查询与他同专业的所有学生的学生编号
SELECT studentno
FROM student
WHERE majorid= (
	SELECT majorid
	FROM student
	WHERE studentname = '张翠山'
);

-- <3>查询该专业最低分
SELECT MIN(score)
FROM result
WHERE studentno IN(
	SELECT studentno
	FROM student
	WHERE majorid= (
		SELECT majorid
		FROM student
		WHERE studentname = '张翠山'
	)
);


-- 查询哪个专业没有学生

-- 左外链接
SELECT m.`majorid`,m.`majorname`,s.`studentno`
FROM major m
LEFT OUTER JOIN student s
ON m.`majorid` = s.`majorid`
WHERE s.`studentno` IS NULL;

-- 右外连接
SELECT m.`majorid`,m.`majorname`,s.`studentno`
FROM student s
RIGHT OUTER JOIN major m
ON m.`majorid` = s.`majorid`
WHERE s.`studentno` IS NULL;











