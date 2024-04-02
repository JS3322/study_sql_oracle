drop table CUSTOM_주문14;

create table CUSTOM_주문14 AS
SELECT A.고객번호, 주문금액, 주문지역코드, B.주문일자
     , 'ASDFFDSAASDFFDSAASDFFDSAASDFFDSAASDFFDSA' C1
     , 'ASDFFDSAASDFFDSAASDFFDSAASDFFDSAASDFFDSA' C2
     , 'ASDFFDSAASDFFDSAASDFFDSAASDFFDSAASDFFDSA' C3
     , 'ASDFFDSAASDFFDSAASDFFDSAASDFFDSAASDFFDSA' C4
     , 'ASDFFDSAASDFFDSAASDFFDSAASDFFDSAASDFFDSA' C5
     , 'ASDFFDSAASDFFDSAASDFFDSAASDFFDSAASDFFDSA' C6
FROM   (select  'C' || lpad(trim(to_char(rownum)), 4, '0')             고객번호
             , round(dbms_random.value(10000, 1000000))                주문금액
             , lpad(to_char(round(dbms_random.value(1, 5))), 2, '0') 주문지역코드
        from dual connect by level <= 1000
       ) A,
       (SELECT  TO_CHAR(TO_DATE('20190901', 'YYYYMMDD') - ROWNUM, 'YYYYMMDD') 주문일자
        FROM DUAL CONNECT BY LEVEL <= 100
       ) B,
       (SELECT ROWNUM R_NUM
        FROM   DUAL
        CONNECT BY LEVEL <= 100
       )
ORDER BY DBMS_RANDOM.RANDOM();





create public synonym CUSTOM_주문14 for system.CUSTOM_주문14;

CREATE INDEX system.IX_CUSTOM_주문14_02 ON system.CUSTOM_주문14(주문지역코드, 주문일자, 주문금액);

COMMIT;



CREATE TABLE system.test_index
(
    numbertest       VARCHAR2(10)
);

insert into system.test_index values (10000);

select * from system.test_index;

select * from system.test_index
where NUMBERTEST < 1000
  and NUMBERTEST < 100;

select * from system.test_index
where trim(NUMBERTEST) < 1000
  and NUMBERTEST < 100;

CREATE TABLE system.test_index_1
(
    numbertest       VARCHAR2(10)
);

insert into system.test_index_1 values ('1000');

select * from system.test_index_1;

select * from system.test_index_1
where NUMBERTEST BETWEEN '800' AND '1100';