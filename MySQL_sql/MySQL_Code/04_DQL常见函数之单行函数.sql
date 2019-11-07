-- 常见函数之单行函数

-- 一、字符函数

-- 1.length 获取参数值的字节个数
SELECT LENGTH('john');
SELECT LENGTH('张三丰hahaha');

SHOW VARIABLES LIKE '%char%'

-- 2.concat 拼接字符串

SELECT CONCAT(last_name,'_',first_name) 姓名 FROM employees;

-- 3.upper、lower 转换大小写
SELECT UPPER('john');
SELECT LOWER('joHn');
-- 将姓变大写，名变小写，然后拼接
SELECT CONCAT(UPPER(last_name),LOWER(first_name))  姓名 FROM employees;

-- 4.substr、substring
-- 注意：索引从1开始
-- 截取从指定索引处后面所有字符
SELECT SUBSTR('李莫愁爱上了陆展元',7) AS 结果;

-- 截取从指定索引处指定字符长度的字符
SELECT SUBSTR('李莫愁爱上了陆展元',1,3) AS 结果;


-- 姓名中首字符大写，其他字符小写然后用_拼接，显示出来

SELECT CONCAT(UPPER(SUBSTR(last_name,1,1)),'_',LOWER(SUBSTR(last_name,2))) AS 结果
FROM employees;

-- 5.instr 返回子串第一次出现的索引，如果找不到返回0

SELECT INSTR('杨不悔爱上了殷六侠','殷六侠') AS 结果;

-- 6.trim 去除两边的空格
SELECT LENGTH(TRIM('    张翠山    ')) AS 结果;

-- 将两边指定的字符去除(去除a)
SELECT TRIM('a' FROM 'aaaaaaaaa张aaaaaaaaaaaa翠山aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa')  AS 结果;

-- 7.lpad 用指定的字符实现左填充指定长度（用*左填充到满5个字符）
-- 如果给定长度小于字符串长度，那么就会截取字符串为给定长度

SELECT LPAD('李四',5,'*') AS 结果;

-- 8.rpad 用指定的字符实现右填充指定长度（用*左填充到满7个字符）

SELECT RPAD('掌上宝',7,'*') AS 结果;


-- 9.replace 替换（会将所有的内容都替换成指定内容）

SELECT REPLACE('周芷若,张无忌爱上了周芷若','周芷若','赵敏') AS 结果;



-- 二、数学函数

-- 1.round 四舍五入
SELECT ROUND(-1.55);
SELECT ROUND(1.567,2);


-- 2.ceil 向上取整,返回>=该参数的最小整数

SELECT CEIL(-1.02);

-- 3.floor 向下取整，返回<=该参数的最大整数
SELECT FLOOR(-9.99);

-- 4.truncate 截断(截断小数点后两位)

SELECT TRUNCATE(1.69999,2);

-- 5.mod取余
/*
mod(a,b) ：  a-a/b*b

mod(-10,-3):-10- (-10)/(-3)*（-3）=-1
*/
SELECT MOD(10,-3);
SELECT 10%3;

-- 6.rand：获取随机数，返回0-1之间的小数
SELECT RAND();


-- 三、日期函数

-- 1.now 返回当前系统日期+时间
SELECT NOW();

-- 2.curdate 返回当前系统日期，不包含时间
SELECT CURDATE();

-- 3.curtime 返回当前时间，不包含日期
SELECT CURTIME();


-- 4.可以获取指定的部分，年、月、日、小时、分钟、秒
SELECT YEAR(NOW()) AS 年;
SELECT YEAR('1998-1-1') AS 年;

SELECT  YEAR(hiredate) AS 年 FROM employees;

SELECT MONTH(NOW()) 月;
SELECT MONTHNAME(NOW()) 月;-- 英文月份


-- 5.str_to_date 将字符通过指定的格式转换成日期

SELECT STR_TO_DATE('1998-3-2','%Y-%c-%d') AS out_put;

-- 查询入职日期为1992--4-3的员工信息
SELECT * FROM employees WHERE hiredate = '1992-4-3';

SELECT * FROM employees WHERE hiredate = STR_TO_DATE('4-3 1992','%c-%d %Y');


-- 6.date_format 将日期转换成字符

SELECT DATE_FORMAT(NOW(),'%y年%m月%d日') AS out_put;

-- 查询有奖金的员工名和入职日期(xx月/xx日 xx年)
SELECT last_name,DATE_FORMAT(hiredate,'%m月/%d日 %y年') 入职日期
FROM employees
WHERE commission_pct IS NOT NULL;

-- 7.datediff 返回两个日期相差的天数
SELECT DATEDIFF(NOW(),'1998-01-01');

-- 8.monthname 以英文形式返回月
SELECT MONTHNAME(NOW());

-- 四、其它函数
SELECT VERSION();-- 查看版本
SELECT DATABASE();-- 查看当前数据库
SELECT USER();-- 查看用户
SELECT PASSWORD('小明')-- 返回该字符串的密码形式
SELECT MD5('yiyi');-- 返回该字符的md5加密形式


-- 五、流程控制函数

-- 总结：如果是等于类型（switch类型）的话case后面需要加内容，如果是if else类型的话case后面不需要加上内容

-- 1.if函数：if else效果

SELECT IF(8<10,'小','大');

SELECT last_name,commission_pct,IF(commission_pct IS NULL,'没有奖金','有奖金') AS 备注 FROM employees;



-- 2.case函数的使用一： switch case 的效果

/*
java中
switch(变量或表达式){
	case 常量1：语句1;break;
	...
	default:语句n;break;


}

mysql中

case 要判断的字段或表达式
when 常量1 then 要显示的值1或语句1;
when 常量2 then 要显示的值2或语句2;
...
else 要显示的值n或语句n;
end
*/

/*案例：查询员工的工资，要求

部门号=30，显示的工资为1.1倍
部门号=40，显示的工资为1.2倍
部门号=50，显示的工资为1.3倍
其他部门，显示的工资为原工资

*/

-- 注意：case前面需要有逗号
SELECT salary AS 原始工资,department_id,
CASE department_id
WHEN 30 THEN salary*1.1
WHEN 40 THEN salary*1.2
WHEN 50 THEN salary*1.3
ELSE salary
END AS 新工资
FROM employees;


-- 3.case 函数的使用二：类似于 多重if

/*
java中：
if(条件1){
	语句1；
}else if(条件2){
	语句2；
}
...
else{
	语句n;
}

mysql中：

case 
when 条件1 then 要显示的值1或语句1
when 条件2 then 要显示的值2或语句2
。。。
else 要显示的值n或语句n
end
*/

/*
案例：查询员工的工资的情况
	如果工资>20000,显示A级别
	如果工资>15000,显示B级别
	如果工资>10000，显示C级别
	否则，显示D级别
*/


SELECT salary,
CASE
WHEN salary >20000 THEN 'A'
WHEN salary >15000 THEN 'B'
WHEN salary >10000 THEN 'C'
ELSE 'D'
END AS 工资等级
FROM employees;


-- 要求：使用case完成下面条件
-- job 			grade
-- AD_PRES		A
-- ST_MAN		B
-- IT_PROG		C

SELECT last_name,job_id AS job,
CASE job_id
WHEN 'AD_PRES' THEN 'A'
WHEN 'ST_MAN' THEN 'B'
WHEN 'IT_PROG' THEN'C'
END AS 'grade'
FROM employees;








