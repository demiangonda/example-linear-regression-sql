-- Linear Regression
create table bt(
x1 float,
x2 float
);

insert into bt values (1.00,1.00);
insert into bt values (2.00,2.00);
insert into bt values (3.00,1.30);
insert into bt values (4.00,3.75);
insert into bt values (5.00,2.25);

create table regline(
mx1 float,
mx2 float,
sx1 float,
sx2 float,
r float,
a float,
b float
);

create table prediction(
x1 float,
x2 float,
x2d float,
x2mx2d float,
x2mx2dpow2 float
);

select * from bt;

--regression line
insert into regline (mx1, mx2, sx1, sx2, r, a, b)
select 
c.mx1, c.mx2, c.sx1, c.sx2, c.r,
c.mx2 - c.r*(c.sx2/c.sx1)*c.mx1 as a,
c.r*(c.sx2/c.sx1) as  b
from
(
select
avg(a.mx1) as mx1, avg(a.mx2) as mx2, avg(a.sx1) as sx1, avg(a.sx2) as sx2,
sum( ((b.x1-a.mx1)/a.sx1) * ((b.x2-a.mx2)/a.sx2) ) / (COUNT(*)-1) as r --Pearsons r
from (
select 
AVG(x1) as mx1,
AVG(x2) as mx2,
STDEV(x1) as sx1,
STDEV(x2) as sx2 
from bt
) a
cross join bt b
) c;

select * from regline;

select
b.x1,
b.x2,
reg.b * b.x1 + reg.a as x2d,
b.x2 - (reg.b * b.x1 + reg.a) as x2mx2d,
(b.x2 - (reg.b * b.x1 + reg.a))*
(b.x2 - (reg.b * b.x1 + reg.a)) as x2mx2dpow2
from
bt b 
cross join 
regline reg;

drop table bt;
drop table regline;
drop table prediction;