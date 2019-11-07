-- 联合查询

/*
<4> 特点
            1) 要求多条查询语句的查询列数是一致的

            2) 要求多条查询语句的查询的每一列的类型和顺序最好一致
            
            3) union关键字默认去重，如果使用union all 可以包含重复项
*/

CREATE DATABASE test;

-- 引入的案例：查询部门编号>90或邮箱包含a的员工信息

SELECT * FROM employees WHERE email LIKE '%a%' OR department_id>90;;

SELECT * FROM employees  WHERE email LIKE '%a%'
UNION
SELECT * FROM employees  WHERE department_id>90;


-- 案例：查询中国用户中男性的信息以及外国用户中年男性的用户信息

SELECT id,cname FROM t_ca WHERE csex='男'
UNION ALL
SELECT t_id,tname FROM t_ua WHERE tGender='male';


-- ALL关键字可以显示重复的内容：
-- 比如：t_ca与t_ua两个表中中都有一个叫做小明的生，那么在联合的时候会自动去重
-- 只会显示一个，如果加上ALL关键字就可以显示所有内容

