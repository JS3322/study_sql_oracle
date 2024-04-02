DROP INDEX SYSTEM.IX_T_고객23 ;
DROP INDEX SYSTEM.IX_T_주문23 ;

CREATE INDEX SYSTEM.IX_T_고객23 ON SYSTEM.T_고객23(고객성향코드);
CREATE INDEX SYSTEM.IX_T_주문23 ON SYSTEM.T_주문23(고객번호, 상품코드, 주문일자);

EXECUTE DBMS_STATS.GATHER_TABLE_STATS('SYSTEM', 'T_고객23');
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('SYSTEM', 'T_주문23');

ALTER SESSION SET STATISTICS_LEVEL=ALL;

SELECT /*+ ORDERED USE_NL(O) INDEX(C SYSTEM.IX_T_고객23) INDEX(D SYSTEM.IX_T_주문23) */
       C.고객번호, C.고객명, C.C1
     , O.주문번호, O.상품코드, O.주문일자, O.주문수량
FROM SYSTEM.T_고객23 C, SYSTEM.T_주문23 O
WHERE C.고객성향코드 = '920'
 AND  O.고객번호     = C.고객번호
 AND  O.주문일자     LIKE '201701%'
 AND  O.상품코드     = 'P103';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST -ROWS'));

 /*
---------------------------------------------------------------------------------------------------------------
| Id  | Operation                     | Name       | Starts | E-Rows | A-Rows |   A-Time   | Buffers | Reads  |
---------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |            |      1 |        |     15 |00:00:00.07 |     356 |    426 |
|   1 |  NESTED LOOPS                 |            |      1 |        |     15 |00:00:00.07 |     356 |    426 |
|   2 |   NESTED LOOPS                |            |      1 |    121 |     15 |00:00:00.07 |     341 |    411 |
|   3 |    TABLE ACCESS BY INDEX ROWID| T_고객23   |      1 |    114 |    114 |00:00:00.03 |     109 |    244 |
|*  4 |     INDEX RANGE SCAN          | IX_고객23_0|      1 |    114 |    114 |00:00:00.01 |       3 |      2 |
|*  5 |    INDEX RANGE SCAN           | IX_주문23_0|    114 |      1 |     15 |00:00:00.04 |     232 |    167 |
|   6 |   TABLE ACCESS BY INDEX ROWID | T_주문23   |     15 |      1 |     15 |00:00:00.01 |      15 |     15 |
---------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   4 - access("C"."고객성향코드"='920')
   5 - access("O"."고객번호"="C"."고객번호" AND "O"."상품코드"='P103' AND "O"."주문일자" LIKE '201701%')
       filter("O"."주문일자" LIKE '201701%')
 */