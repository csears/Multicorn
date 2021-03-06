CREATE EXTENSION multicorn;
CREATE server multicorn_srv foreign data wrapper multicorn options (
    wrapper 'multicorn.testfdw.TestForeignDataWrapper'
);
CREATE user mapping for postgres server multicorn_srv options (usermapping 'test');

CREATE foreign table testmulticorn (
    test1 character varying,
    test2 character varying
) server multicorn_srv options (
    option1 'option1'
);

-- Test "normal" usage
select * from testmulticorn;

-- Test quals
select * from testmulticorn where test1 like '%0';
select * from testmulticorn where test1 ilike '%0';


-- Test columns
select test2 from testmulticorn;

-- Test subquery plan
select test1, (select max(substr(test1, 9, 1))::int from testmulticorn t2 where substr(t2.test1, 7, 1)::int = substr(t1.test1, 7, 1)::int)
from testmulticorn t1;

select test1, (select max(substr(test1, 9, 1))::int from testmulticorn t2 where t2.test1 = t1.test1)
from testmulticorn t1;

select * from testmulticorn where test1 is null;

select * from testmulticorn where test1 is not null;

select * from testmulticorn where 'grou' > test1;

select * from testmulticorn where test1 < ANY(ARRAY['grou', 'MACHIN']);

DROP EXTENSION multicorn cascade;
