-- 常见的数据类型

-- 一、整型

/*

特点:
    1) 如果不设置无符号还是有符号，默认是有符号，如果想设置无符号，需要添加unsigned关键字

    2) 如果插入的数值超出了整型的范围,会报out of range异常，并且插入临界值

    3) 如果不设置长度，会有默认的长度。长度代表了显示的最大宽度，如果不够会用0在左边填充，但必须搭配
       zerofill使用！ 
*/

USE test;

-- 1.如何设置无符号和有符号

DROP TABLE IF EXISTS tab_int;

CREATE TABLE tab_int(
	t1 INT(7) ZEROFILL, -- 注意：长度是指显示的长度，并不是用于指定int值大小的
	t2 INT(7) UNSIGNED, -- 后面加上unsigned就是指定无符号显示
	t3 INT(7) ZEROFILL, -- 如果指定了zerofill（0填充显示），默认就是无符号显示
);

DESC tab_int;

INSERT INTO tab_int VALUES(-123456);
INSERT INTO tab_int VALUES(-123456,-123456);
INSERT INTO tab_int VALUES(2147483648,4294967296);-- 如果超出范围就会取临界值填充

INSERT INTO tab_int VALUES(123,123);

SELECT * FROM tab_int;


-- 二、小数

/*

特点：
①
M：整数部位+小数部位
D：小数部位
如果超过范围，则插入临界值

②
M和D都可以省略
如果是decimal，则M默认为10，D默认为0
如果是float和double，则会根据插入的数值的精度来决定精度

③定点型的精确度较高，如果要求插入数值的精度较高如货币运算等则考虑使用




*/

-- 测试M和D
/*
其中D表示小数点后显示几位
M代表整数部位和小数不位总共显示几位
*/

CREATE TABLE tab_float(
	f1 FLOAT(5,2),-- 5表示整数部位和小数不为总共长度为5位，而2表示小数部位为2位（也就是整数部位为3位）
	f2 DOUBLE(5,2),
	f3 DECIMAL(5,2)	
);

SELECT * FROM tab_float;


INSERT INTO tab_float VALUES(123.4523,123.4523,123.4523);
INSERT INTO tab_float VALUES(123.456,123.456,123.456);
INSERT INTO tab_float VALUES(123.4,123.4,123.4);-- 小数点后显示2位
INSERT INTO tab_float VALUES(1523.4,1523.4,1523.4);



-- 三、字符型


-- 测试枚举类型（只能添加指定的内容，忽略大小写）
CREATE TABLE tab_char(
	c1 ENUM('a','b','c')


);


INSERT INTO tab_char VALUES('a');
INSERT INTO tab_char VALUES('b');
INSERT INTO tab_char VALUES('c');
INSERT INTO tab_char VALUES('m');-- 不能添加成功
INSERT INTO tab_char VALUES('A');

SELECT * FROM tab_char;


-- 测试集合类型
CREATE TABLE tab_set(
	s1 SET('a','b','c','d')

);
INSERT INTO tab_set VALUES('a');
INSERT INTO tab_set VALUES('A,B');
INSERT INTO tab_set VALUES('a,c,d');
INSERT INTO tab_set VALUES('a,c,d,f');-- 添加失败，set中没有f

SELECT * FROM tab_set;


-- 四、日期型

/*

分类：
date只保存日期
time 只保存时间
year只保存年

datetime保存日期+时间
timestamp保存日期+时间


特点：

		字节		范围		时区等的影响
datetime	               8		1000——9999	                  不受
timestamp	4	               1970-2038	                    受

*/

-- 测试日期型

CREATE TABLE tab_date(
	t1 DATETIME,
	t2 TIMESTAMP

);

INSERT INTO tab_date VALUES(NOW(),NOW());

SELECT * FROM tab_date;


SHOW VARIABLES LIKE 'time_zone';

-- 更改时区
SET time_zone='+9:00';














