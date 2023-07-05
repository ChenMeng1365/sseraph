
-- SQL EXAMPLE

-- 1.1 查询同时存在" 01 "课程和" 02 "课程的情况
-- 翻译成大白话：意思是选择01和02课程的学生学号以及分数
SELECT a.sid,a.score,b.score
FROM (SELECT *
FROM sc
WHERE cid = '01') AS a,
(SELECT *
FROM sc
WHERE cid = '02') AS b
WHERE a.sid = b.sid

-- 法二
SELECT s1.sid, s1.score, s2.score
FROM sc s1
LEFT JOIN sc s2
ON s1.sid = s2.sid
WHERE s1.cid = '01' AND s2.cid = '02'


-- 1.2 查询存在" 01 "课程但可能不存在" 02 "课程的情况(不存在时显示为 null )
/* 大白话:哪些同学选了01课程，但是可能没有选02课程
显示为null用left join 处理*/
SELECT *
FROM (SELECT *
FROM sc
WHERE cid = '01') AS a
LEFT JOIN(SELECT *
FROM sc
WHERE cid = '02') AS b
ON a.sid = b.sid 


-- 1.3 查询不存在" 01 "课程但存在" 02 "课程的情况
/*题目看似语言平实，实际上会产生歧义 
此处我理解成选了02课程但是没有选01课程的学生*/

-- 首先找出哪些人选了01课程
SELECT sid
FROM sc
WHERE cid = '01';

-- 以上这些学号排除再外
SELECT *
FROM sc
WHERE sid NOT IN 
(SELECT sid
FROM sc
WHERE cid = '01')
AND cid = '02';

-- 另外一种思路，有人认为可以不存在01课程，但是除了01之外的其他课程都得呈现
SELECT s1.*
FROM sc s1
JOIN sc s2
ON s1.sid = s2.sid
WHERE s1.sid NOT IN 
(SELECT sid
FROM sc s
WHERE s.cid = '01')
AND s2.cid = '02';


-- 2.查询平均成绩大于等于 60 分的同学的学生编号和学生姓名和平均成绩
-- 按学号分组，查询出每个学生的平均成绩
SELECT sid，AVG（score)
FROM sc
GROUP BY sid
HAVING AVG(score) >= 60

-- 查找平均成绩大于等于60的学生相关信息
SELECT t1.*,s.sname
FROM student s
RIGHT JOIN 
(SELECT sid,avg(score)
FROM sc
GROUP BY sid
HAVING  AVG(score) >= 60)t1
ON s.sid = t1.sid

-- 法二
SELECT s1.sid, s1.sname, avg(s2.score) as 平均成绩
FROM student s1
JOIN sc s2
ON s1.sid = s2.sid
GROUP BY s1.sid
HAVING avg(s2.score) >= 60


-- 3. 查询在 SC 表存在成绩的学生信息
 -- 首先查找出成绩表中存在的学生学号
SELECT DISTINCT sid
FROM sc
WHERE  score is not NULL

-- 根据上述查找出的学号，结合学生表，得出学生所有信息
SELECT *
FROM student
WHERE sid IN
(SELECT DISTINCT sid
FROM sc
WHERE  score is not NULL)


-- 4. 查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩(没成绩的显示为 null )
-- 大白话：学生编号和学生姓名在学生表中，选课总数用count在成绩表中，总成绩也在成绩表中,实际将两张表联结即可
SELECT student.sid,sname, COUNT(cid) as 选课总数, SUM(score) as 总成绩
FROM student
LEFT JOIN sc -- 因为需要显示没有成绩的，所以要用左联结
ON student.sid = sc.sid
GROUP BY sid


-- 4.1 查有成绩的学生信息
-- 首先查找出那些有成绩的学生学号
SELECT sid
FROM sc
WHERE scor is not NULL

-- 根据以上学号，结合学生表查找出所有相关信息
SELECT *
FROM student
WHERE sid  IN 
(SELECT sid
FROM sc
WHERE score is not NULL)  


-- 5. 查询「李」姓老师的数量 
SELECT COUNT(tname) 
FROM teacher
WHERE tname LIKE '李%'


-- 6. 查询学过「张三」老师授课的同学的信息
-- 首先根据教师表得出张三老师的教师编号
SELECT tid
FROM teacher
WHERE tname = '张三'

-- 根据张三老师的教师编号，结合课程表找出张三老师所授课程的课程编号
SELECT cid
FROM course
WHERE tid =
(SELECT tid
FROM teacher
WHERE tname = '张三')

-- 根据上述得出的课程编号得出那些上过张三老师课的学生编号
SELECT sid
FROM sc
WHERE cid =
(SELECT cid
FROM course
WHERE tid =
(SELECT tid
FROM teacher
WHERE tname = '张三'))

-- 再根据学生学号，结合学生表找出所有学生的信息
SELECT *
FROM student
WHERE sid IN
(SELECT sid
FROM sc
WHERE cid =
(SELECT cid
FROM course
WHERE tid =
(SELECT tid
FROM teacher
WHERE tname = '张三')))


-- 我习惯性拆解思路，一张一张表写，可能会非常麻烦，如下的写法效率很高
select distinct s.*
from student s
inner join sc sc on s.SId=sc.SId
inner join course c on sc.CId=c.CId
inner join teacher t on c.TId=t.TId
where t.Tname='张三'


-- 7. 查询没有学全所有课程的同学的信息
-- 首先根据课程表计算出所有课程的数量
SELECT count(cid)
FROM course

-- 结合成绩表，按照学号分组，只要选修的课程数量小于上述子查询，得出学号
SELECT sid
FROM sc
GROUP BY sid
HAVING count(cid) <
(SELECT count(cid)
FROM course)

-- 根据上述得出的学生学号，结合学生表，得出所有学生信息
SELECT *
FROM student
WHERE sid IN 
(SELECT sid
FROM sc
GROUP BY sid
HAVING count(cid) <
(SELECT count(cid)
FROM course))

-- 这道题目我看到别人写出的答案，把学号9-13号的同学的信息也加进去了，我觉得没必要，如果觉得应该这么做的人可以在评论区写答案，下面也有小部分题目也出现了类似情况，把其他学号加进去


-- 8. 查询至少有一门课与学号为" 01 "的同学所学相同的同学的信息
SELECT DISTINCT s.*,s.sid
FROM student s, sc s2
WHERE cid IN
(SELECT cid
FROM sc
WHERE sid = '01')
AND s.sid = s2.sid
AND s2.sid <> '01'


-- 9. 查询和" 01 "号的同学学习的课程完全相同的其他同学的信息
-- 首先查找出01同学学习的课程
SELECT cid
FROM sc
WHERE sid ='01'

-- 哪些学生学习的课程和01号同学相似
SELECT DISTINCT sid
FROM sc
WHERE cid IN
(SELECT cid
FROM sc
WHERE sid ='01')
AND sid <> '01'
GROUP BY sid -- 这里一定要按学号分组，否则查询结果只会返回第一个符合条件的学号
HAVING COUNT(cid) >=3

-- 根据上述查询的学号，结合学生表，找到相关信息
SELECT student.*
FROM student
WHERE sid IN
(SELECT DISTINCT sid
FROM sc
WHERE cid IN
(SELECT cid
FROM sc
WHERE sid ='01')
AND sid <> '01'
GROUP BY sid 
HAVING COUNT(cid) >=3

-- 法二
-- 有时需要几张表的信息时可以同时卸载FROM 子句中
SELECT DISTINCT s2.*
FROM sc s1, student s2,
(SELECT cid
FROM sc
WHERE sid ='01')r
WHERE s1.sid = s2.sid
AND s1.cid = r.cid
AND s2.sid <> '01'
GROUP BY s2.sid
HAVING COUNT(s1.cid) >2


-- 10. 查询没学过"张三"老师讲授的任一门课程的学生姓名
-- 首先查询出张三老师所授课程的教师号 
SELECT tid
FROM teacher
WHERE tname = '张三'

-- 结合课程表，根据上述教师号找到相应的课程号
SELECT cid
FROM course
WHERE tid =
(SELECT tid
FROM teacher
WHERE tname = '张三')

-- 结合成绩表，查询哪些学生上过张三老师的课
SELECT  sid
FROM sc
WHERE cid  IN 
(SELECT cid
FROM course
WHERE tid =
(SELECT tid
FROM teacher
WHERE tname = '张三'))-- 换个思维，因为找没上过的人学号，结果会把学号和课程号当成一条记录来判断

-- 查找有哪些学号没有在上述子查询中出现
SELECT DISTINCT sid
FROM sc
WHERE sid not in 
(SELECT  sid
FROM sc
WHERE cid  IN 
(SELECT cid
FROM course
WHERE tid =
(SELECT tid
FROM teacher
WHERE tname = '张三')))

-- 最后根据上述查询学号找到相应的学生姓名
SELECT sname
FROM student
WHERE sid IN
(SELECT DISTINCT sid
FROM sc
WHERE sid not in 
(SELECT  sid
FROM sc
WHERE cid  IN 
(SELECT cid
FROM course
WHERE tid =
(SELECT tid
FROM teacher
WHERE tname = '张三'))))


-- 11. 查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩
-- 查询两门以上不及格的同学学号及其平均成绩
SELECT sid,avg(score) as avg_score
FROM sc
WHERE score <60
GROUP BY sid
HAVING COUNT(cid) >= 2

-- 根据上述查询的学号，结合学生表得出相关姓名
SELECT s.sid,sname,t1.avg_score
FROM student s
RIGHT JOIN
(SELECT sc.sid,avg(score) as avg_score
FROM sc
WHERE score <60
GROUP BY sc.sid
HAVING COUNT(sc.cid) >= 2)t1
ON s.sid = t1.sid  


-- 12. 检索" 01 "课程分数小于 60，按分数降序排列的学生信息
-- 找出01课程分数小于60的学生学号
SELECT sid,score
FROM sc
WHERE cid ='01'
AND score <60

-- 根据上述查询出的学号，结合学生表找到相关信息
SELECT *,score
FROM student s
RIGHT JOIN
(SELECT sid,score
FROM sc
WHERE cid ='01'
AND score <60)t1
ON s.sid = t1.sid
ORDER BY score DESC

-- 法二 非常精炼的做法
select student.*
from student,sc
where sc.CId ='01'
and   sc.score<60
and   student.SId=sc.SId


-- 13. 按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩
--  首先按照学号分类，查询每个学生的平均成绩
SELECT sid, AVG(score) as 平均成绩
FROM sc
GROUP BY sid
ORDER BY AVG(score) DESC

-- 再添加学生的每门课程的成绩
SELECT sc.sid, sc.cid, sc.score,t1.平均成绩
FROM sc
LEFT JOIN 
(SELECT sid, AVG(score) as 平均成绩
FROM sc
GROUP BY sid)t1
ON sc.sid = t1.sid
ORDER BY t1.平均成绩 DESC


-- 12. 检索" 01 "课程分数小于 60，按分数降序排列的学生信息
-- 找出01课程分数小于60的学生学号
SELECT sid,score
FROM sc
WHERE cid ='01'
AND score <60

-- 根据上述查询出的学号，结合学生表找到相关信息
SELECT *,score
FROM student s
RIGHT JOIN
(SELECT sid,score
FROM sc
WHERE cid ='01'
AND score <60)t1
ON s.sid = t1.sid
ORDER BY score DESC

-- 法二 非常精炼的做法
select student.*
from student,sc
where sc.CId ='01'
and   sc.score<60
and   student.SId=sc.SId


-- 13. 按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩
--  首先按照学号分类，查询每个学生的平均成绩
SELECT sid, AVG(score) as 平均成绩
FROM sc
GROUP BY sid
ORDER BY AVG(score) DESC

-- 再添加学生的每门课程的成绩
SELECT sc.sid, sc.cid, sc.score,t1.平均成绩
FROM sc
LEFT JOIN 
(SELECT sid, AVG(score) as 平均成绩
FROM sc
GROUP BY sid)t1
ON sc.sid = t1.sid
ORDER BY t1.平均成绩 DESC


-- 14、查询没学过"张三"老师讲授的任一门课程的学生姓名
-- 根据教师表，查询张三老师的教师编号
SELECT tid
FROM teacher
WHERE tname = '张三'

-- 结合课程表，查询张三老师的课程编号
SELECT cid
FROM course
WHERE tid =
(SELECT tid
FROM teacher
WHERE tname = '张三')

-- 结合成绩表，查询上过张三老师课程的学生学号
SELECT sid
FROM sc
WHERE cid =
(SELECT cid
FROM course
WHERE tid =
(SELECT tid
FROM teacher
WHERE tname = '张三'))

-- 根据上述学号结果，查询没上过张三老师课程的学生学号
SELECT DISTINCT sid
FROM sc 
WHERE sid NOT IN 
(SELECT sid
FROM sc
WHERE cid =
(SELECT cid
FROM course
WHERE tid =
(SELECT tid
FROM teacher
WHERE tname = '张三')))

-- 结合学生表，查询上述学号的学生姓名
SELECT sname
FROM student
WHERE sid =
(SELECT DISTINCT sid
FROM sc 
WHERE sid NOT IN 
(SELECT sid
FROM sc
WHERE cid =
(SELECT cid
FROM course
WHERE tid =
(SELECT tid
FROM teacher
WHERE tname = '张三'))))


-- 14查询各科成绩最高分、最低分和平均分，要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列
SELECT sc.cid,course.cname,COUNT(DISTINCT sc.SId) 课程人数,
       AVG(sc.score) 平均分,
       MAX(sc.score) 最高分,
       MIN(sc.score) 最低分,
COUNT(CASE
        WHEN sc.score >= 60 THEN 1
        ELSE NULL
    END) / COUNT(DISTINCT sc.SId) 及格率,
    COUNT(CASE
        WHEN sc.score >= 70 AND sc.score < 80 THEN 1
        ELSE NULL
    END) / COUNT(DISTINCT sc.SId) 中等率,
    COUNT(CASE
        WHEN sc.score >= 80 AND sc.score < 90 THEN 1
        ELSE NULL
    END) / COUNT(DISTINCT sc.SId) 优良率,
    COUNT(CASE
        WHEN sc.score >= 90 AND sc.score <=100 THEN 1
        ELSE NULL
    END) / COUNT(DISTINCT sc.SId) 优秀率
FROM course
JOIN sc
ON course.cid = sc.cid
GROUP BY sc.cid
ORDER BY 课程人数  DESC, sc.cid;


-- 15 按各科成绩进行排序，并显示排名， Score 重复时保留名次空缺
-- 这题有点难度，首先一方面涉及到组内排名的问题
SELECT s1.cid, s1.sid, s1.score, count(s2.score) + 1 as 排名
FROM sc s1
LEFT JOIN sc s2
ON  s1.cid = s2.cid AND s1.score < s2.score
GROUP BY s1.cid,s1.sid, s1.score
ORDER BY s1.cid, count(s2.score) + 1 ASC;

-- 按各科成绩进行排序，并显示排名， Score 重复时合并名次
-- 此题比上一问难度增加，参考了其他人的答案
SELECT  sc.SId, sc.CId, sc.score, tp.ranks
FROM sc
LEFT JOIN 
(SELECT SId, CId,
(SELECT COUNT(DISTINCT sc2.score) + 1
FROM sc sc2
WHERE sc1.CId = sc2.CId
AND sc2.score > sc1.score) ranks
FROM sc sc1) tp 
ON sc.SId = tp.SId AND sc.CId = tp.CId
ORDER BY sc.CId , ranks;

-- 查询学生的总成绩，并进行排名，总分重复时保留名次空缺
SELECT a.*, @rank := @rank + 1 as rank_no
FROM 
(SELECT sid, sum(score) AS 总成绩
FROM sc
GROUP BY sid
ORDER BY sum(score) DESC)a,
(SELECT @rank := 0) b;

-- 法二
set @rank=0;
SELECT a.*, @rank := @rank + 1 as rank_no
FROM 
(SELECT sid, sum(score) AS 总成绩
FROM sc
GROUP BY sid
ORDER BY sum(score) DESC)a;


-- 查询学生的总成绩，并进行排名，总分重复时，相同值序号相同

SET @rank := 0 ,@rowtotal := NULL;
SELECT a.*,
       CASE WHEN @rowtotal = a.sumscore THEN @rank
            WHEN @rowtotal := a.sumscore THEN @rank := @rank + 1
       END AS rank_no
FROM 
(select sc.SId, sum(score) as sumscore
from sc
GROUP BY sc.SId 
ORDER BY sum(score) desc)a;


-- 17 统计各科成绩各分数段人数：课程编号，课程名称，[100-85]，[85-70]，[70-60]，[60-0] 及所占百分比
SELECT c.cname,t1.*
FROM course c
JOIN
(SELECT cid, 
       SUM(CASE WHEN score BETWEEN 85 AND 100 THEN 1 ELSE 0 END) as '85-100',
       ROUND(SUM(CASE WHEN score BETWEEN 85 AND 100 THEN 1 ELSE 0 END)/count(score),2) as '[85-100]占比',
       SUM(CASE WHEN score BETWEEN 70 AND 84 THEN 1 ELSE 0 END) as '70-84',
       ROUND(SUM(CASE WHEN score BETWEEN 70 AND 84 THEN 1 ELSE 0 END)/count(score),2) as '[70-84]占比',
       SUM(CASE WHEN score BETWEEN 60 AND 69 THEN 1 ELSE 0 END) as '60-69',
       ROUND(SUM(CASE WHEN score BETWEEN 60 AND 69 THEN 1 ELSE 0 END)/count(score),2) as '[60-69]占比',
       SUM(CASE WHEN score BETWEEN 0 AND 59 THEN 1 ELSE 0 END) as '0-59',
       ROUND(SUM(CASE WHEN score BETWEEN 0 AND 59 THEN 1 ELSE 0 END)/count(score),2) as '[0-59]占比'
FROM sc
GROUP BY cid)t1
ON  c.cid = t1.cid;


-- 18.查询各科成绩前三名的记录
-- 首先查询出有哪些组
SELECT cid, max(score) AS 最大值
FROM sc
GROUP BY cid;

-- 查询结果显示有三门课程
-- 接着使用order by 子句按成绩降序排序（DESC) ，然后用limit子句返回排名前三的学生学号
SELECT *
FROM sc
WHERE cid = '01'
ORDER BY score DESC
LIMIT 3;

-- 以此类推，其他两门课程也这么做，用union进行联结
(SELECT *  FROM sc  WHERE cid = '01'  ORDER BY score DESC  LIMIT 3)
union all
(SELECT *  FROM sc  WHERE cid = '02'  ORDER BY score DESC  LIMIT 3)
union all
(SELECT *  FROM sc  WHERE cid = '03'  ORDER BY score DESC  LIMIT 3);

-- 以上方法比较繁琐，并且万一如果有多个分组结果，用起来会非常麻烦，下面推荐一个简单高效做法，运用关联子查询
SELECT *
FROM sc 
WHERE (SELECT COUNT(*) 
FROM sc a
WHERE sc.cid = a.cid AND sc.score < a.score )<3
ORDER BY cid ASC, sc.score DESC;


-- 19.查询每门课程被选修的学生数
SELECT cid, count(score) as 学生人数
FROM sc
GROUP BY cid；


-- 20.查询出只选修两门课程的学生学号和姓名
SELECT sid, sname
FROM student
WHERE sid IN
(SELECT sid
FROM sc
GROUP BY sid
HAVING COUNT(cid) =2);


-- 21.查询男生、女生人数
SELECT ssex,count(sid) as 人数
FROM student
GROUP BY ssex;


-- 22.查询名字中含有「风」字的学生信息
SELECT *
FROM student
WHERE sname LIKE '%风%';


-- 23.查询同名学生名单，并统计同名人数
SELECT sname,count(sname)
FROM student
GROUP BY sname
HAVING count(sname) >= 2;


-- 24.查询 1990 年出生的学生名单
SELECT *
FROM student
WHERE sage BETWEEN '1990-01-01' AND '1990-12-31';

-- 法二
SELECT *
FROM student
WHERE EXTRACT(year FROM sage) = '1990'  
-- EXTRACT函数——截取日期元素，只能用在mysql和postgresql中
EXTRACT(日期元素 FROM 日期）


-- 25.查询每门课程的平均成绩，结果按平均成绩降序排列，平均成绩相同时，按课程编号升序排列
SELECT cid, avg(score) as avg_sc
FROM sc
GROUP BY cid
ORDER BY avg_sc DESC, cid ASC;


-- 26.查询平均成绩大于等于 85 的所有学生的学号、姓名和平均成绩
SELECT s1.sid,sname,t1.平均成绩
FROM student s1
JOIN 
(SELECT sid,avg(score) as 平均成绩
FROM sc 
GROUP BY sid
HAVING avg(score) >= 85)t1
ON s1.sid = t1.sid;

-- 法二
SELECT s1.sid, sname, avg(score) as 平均成绩
FROM sc s1,
     student s2
WHERE s1.sid = s2.sid
GROUP BY s1.sid
HAVING avg(score) >=85;


-- 27.查询课程名称为「数学」，且分数低于 60 的学生姓名和分数
SELECT sname,t1.score
FROM student s1
JOIN
(SELECT sid,score
FROM sc
WHERE cid =
(SELECT cid
FROM course 
WHERE cname = '数学')
AND score < 60)t1
ON s1.sid = t1.sid

-- 法二
SELECT c.cname, s1.sname, s2.score
FROM course c,
     student s1,
     sc s2
WHERE c.cid = s2.cid
     AND s1.sid = s2.sid 
     AND c.cname = '数学'
     AND s2.score < 60;
-- 以上这个方法，就是把所有的条件罗列在WHERE 子句中 ，其实感觉这样做好像也很简单……


-- 28.查询所有学生的课程及分数情况（存在学生没成绩，没选课的情况
SELECT s1.*,s2.cid,s2.score
FROM student s1
LEFT JOIN sc s2
ON s1.sid = s2.sid


-- 29.查询任何一门课程成绩在 70 分以上的姓名、课程名称和分数
SELECT sname, cname, score
FROM student s1,
     course c,
     sc s2
WHERE s1.sid = s2.sid
     AND c.cid = s2.cid
     AND score >70


-- 30.查询存在不及格的课程
SELECT t1.cid,cname, t1.score
FROM course c
JOIN 
(SELECT cid,score
FROM sc
WHERE score <60)t1
ON c.cid = t1.cid


-- 31.查询课程编号为 01 且课程成绩在 80 分及以上的学生的学号和姓名
SELECT sid,sname
FROM student
WHERE sid IN
(SELECT sid
FROM sc
WHERE score >= 80
      AND cid ='01')

-- 32.求每门课程的学生人数
SELECT cid, count(sid) AS 学生人数
FROM sc
GROUP BY cid


-- 33. 成绩不重复，查询选修「张三」老师所授课程的学生中，成绩最高的学生信息及其成绩
SELECT DISTINCT s.*,t1.最高分
FROM student s
JOIN 
(SELECT sid,max(score) as 最高分
FROM sc
WHERE cid =
(SELECT cid
FROM course
WHERE tid =
(SELECT tid
FROM teacher
WHERE tname = '张三')))t1
ON s.sid = t1.sid


-- 34.成绩有重复的情况下，查询选修「张三」老师所授课程的学生中，成绩最高的学生信息及其成绩
SELECT  s.*,t1.最高分
FROM student s
JOIN 
(SELECT sid,max(score) as 最高分
FROM sc
WHERE cid =
(SELECT cid
FROM course
WHERE tid =
(SELECT tid
FROM teacher
WHERE tname = '张三')))t1
ON s.sid = t1.sid


-- 35.查询不同课程成绩相同的学生的学生编号、课程编号、学生成绩
SELECT s1.sid, s1.cid, s1.score
FROM sc s1
JOIN sc s2
ON s1.sid = s2.sid AND s1.cid <> s2.cid AND s1.score = s2.score
GROUP BY s1.sid, s1.cid 


-- 36.查询每门功成绩最好的前两名
SELECT  a.CId, a.SId, a.score
FROM sc a
LEFT JOIN sc b 
ON  a.CId = b.CId 
    AND a.score < b.score
GROUP BY a.CId , a.SId
HAVING COUNT(a.CId) < 2
ORDER BY CId , score DESC


-- 37.统计每门课程的学生选修人数（超过 5 人的课程才统计）
SELECT  cid,count(sid)
FROM sc
GROUP BY cid
HAVING count(sid) >5


-- 38.检索至少选修两门课程的学生学号
SELECT sid,COUNT(cid)
FROM sc
GROUP BY sid
HAVING COUNT(cid) >=2


-- 39.查询选修了全部课程的学生信息
SELECT *
FROM student
WHERE sid IN
(SELECT sid
FROM sc
GROUP BY sid 
HAVING count(cid) =
(SELECT count(cid)
FROM course))


-- 40-41.查询各学生的年龄，只按年份来算
SELECT sid, sname, ssex, extract(year from CURRENT_DATE) - extract(year from sage) as age
from student
SELECT current_date; 可以获得当前日期， 日期合适是yyyy--mm--dd


-- 42.查询本周过生日的学生
SELECT sid 
FROM  student
WHERE WEEKOFYEAR(current_date) = WEEKOFYEAR(sage)
-- 关于mysql中weekofyear相关函数的解释，以下链接中有解释
-- https://blog.csdn.net/csdn_0_001/article/details/79502366


--43. 查询下周过生日的学生
SELECT sid 
FROM  student
WHERE WEEKOFYEAR(current_date) + 1 = WEEKOFYEAR(sage)


-- 44.查询本月过生日的学生
SELECT *
from student
WHERE extract(month from CURRENT_DATE) = extract(month from sage) 

-- 法二
SELECT *
FROM student
WHERE MONTH(Sage) = MONTH(current_date);


-- 45.查询下月过生日的学生
SELECT *
from student
WHERE extract(month from CURRENT_DATE) + 1 = extract(month from sage) 

