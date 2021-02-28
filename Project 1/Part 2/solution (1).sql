CREATE TABLE query1 AS
SELECT G.name, COUNT(H.genreid) AS moviecount
FROM hasagenre H , genres G
WHERE H.genreid = G.genreid
GROUP BY G.genreid;

CREATE TABLE query2 AS
SELECT G.name, AVG(R.rating) AS rating
FROM ratings R , genres G , movies M, hasagenre H 
WHERE R.movieid = H.movieid AND G.genreid = H.genreid
GROUP BY G.name;

create table query3 as
select title, countofratings
from movies m, (
	select movieid, count(rating) as countofratings 
	from ratings group by movieid having count(rating)>=10) t31
where m.movieid = t31.movieid;

create table query4 as
select m.movieid, m.title
from movies m, hasagenre h, genres g
where m.movieid = h.movieid and h.genreid = g.genreid and g.name = 'Comedy';

CREATE TABLE query5 AS
SELECT M.title, AVG(R.rating) as average
FROM ratings R , genres G , movies M, hasagenre H 
WHERE R.movieid = M.movieid 
GROUP BY M.movieid;


CREATE TABLE query6 AS
select avg(t1.rating) as average
FROM (SELECT G.name, R.rating
	 FROM ratings R, genres G, movies M, hasagenre H
	 WHERE G.genreid = H.genreid AND R.movieid = M.movieid AND H.genreid= 5) t1;

create table query7 as
select avg(r.rating) as average
from movies m, hasagenre h, genres g, ratings r
where m.movieid = h.movieid and h.genreid = g.genreid and r.movieid = m.movieid and g.name = 'Romance' and m.movieid
in (
	select m1.movieid 
	from movies m1, hasagenre h1, genres g1 
	where m1.movieid = h1.movieid and h1.genreid = g1.genreid and g1.name = 'Comedy');

create table query8 as
select avg(r.rating) as average
from movies m, hasagenre h, genres g, ratings r
where m.movieid = h.movieid and h.genreid = g.genreid and r.movieid = m.movieid and g.name = 'Romance' and m.movieid
not in (
	select m1.movieid 
	from movies m1, hasagenre h1, genres g1 
	where m1.movieid = h1.movieid and h1.genreid = g1.genreid and g1.name = 'Comedy');

create table query9 as
select r.movieid, r.rating
from ratings r
where r.userid = :v1;

create table fetchuser as
select r.movieid, r.rating
from ratings r
where r.userid = :v1;

create table t101 as
select movieid, avg(rating) as rating
from ratings group by movieid;

create table movSim as
select tm1.movieid as movieid1, tm2.movieid as movieid2, (1-(abs(tm1.rating - tm2.rating)/5)) as sim
from t101 tm1, t101 tm2
where tm1.movieid != tm2.movieid;

create table pred as
select ms.movieid1 as tmp,
	case sum(ms.sim) when 0.0 
					 then 0.0
					 else sum(ms.sim*f.rating)/sum(ms.sim)
	end
as predScore
from movSim ms, fetchuser f
where ms.movieid2 = f.movieid and ms.movieid1 
not in (
	select movieid from fetchuser)
group by ms.movieid1 order by predScore desc;


create table recommendation as
select title
from movies m, pred p
where m.movieid = p.tmp and p.predScore > 3.9;


drop table fetchuser;
drop table t101;
drop table movSim;
drop table pred;