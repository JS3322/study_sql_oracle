DROP   TABLE SYSTEM.T_고객23;
CREATE TABLE SYSTEM.T_고객23
  (고객번호      VARCHAR2(7),
   고객명        VARCHAR2(50),
   고객성향코드  VARCHAR2(3),
   C1            VARCHAR2(30),
   C2            VARCHAR2(30),
   C3            VARCHAR2(30),
   C4            VARCHAR2(30),
   C5            VARCHAR2(30),
   CONSTRAINT PK_T_고객23 PRIMARY KEY (고객번호)
  );

CREATE PUBLIC SYNONYM T_고객23 FOR SYSTEM.T_고객23;

INSERT /*+ APPEND */ INTO T_고객23
SELECT LPAD(TO_CHAR(ROWNUM), 7, '0')                                    고객번호
     , RPAD(TO_CHAR(ROUND(DBMS_RANDOM.VALUE(1, 65000))), 10, '0')       고객명
     , LPAD(TO_CHAR(ROUND(DBMS_RANDOM.VALUE(1, 200))) || '0', 3, '0')   고객성향코드
     , 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'                                     C1
     , 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'                                     C2
     , 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'                                     C3
     , 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'                                     C4
     , 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'                                     C5
FROM DUAL
CONNECT BY LEVEL <= 20000
ORDER BY DBMS_RANDOM.RANDOM();;

COMMIT;

DROP   TABLE SYSTEM.T_DATE23;
CREATE TABLE SYSTEM.T_DATE23 AS
SELECT TO_CHAR(TO_DATE('20170101', 'YYYYMMDD') + LEVEL, 'YYYYMMDD') WORK_DATE
FROM DUAL
CONNECT BY LEVEL <= 100
ORDER BY DBMS_RANDOM.RANDOM();

CREATE PUBLIC SYNONYM T_DATE23 FOR SYSTEM.T_DATE23;

DROP TABLE  SYSTEM.T_주문23 ;
CREATE TABLE SYSTEM.T_주문23 AS
SELECT  'O' || LPAD(TO_CHAR(ROWNUM), 7, '0')                                    주문번호
      ,  C.고객번호
      , 'P' || LPAD(TO_CHAR(ROUND(DBMS_RANDOM.VALUE(1, 200))) || '0', 3, '0')   상품코드
      ,  D.WORK_DATE                                                            주문일자
      , ROUND(DBMS_RANDOM.VALUE(1, 3))                                          주문수량
FROM T_고객23 C, T_DATE23 D
ORDER BY DBMS_RANDOM.RANDOM();;

CREATE PUBLIC SYNONYM T_주문23 FOR SYSTEM.T_주문23;

ALTER TABLE SYSTEM.T_주문23
ADD CONSTRAINT PK_T_주문23 PRIMARY KEY(주문번호)
;

EXECUTE DBMS_STATS.GATHER_TABLE_STATS('SYSTEM', 'T_고객23');
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('SYSTEM', 'T_주문23');

COMMIT;