/* 아래 SQL을 OLTP에 최적화 하여 튜닝 하세요.  (인덱스 및 SQL 수정 가능)
   최종 결과 값 : 18건

   T_고객23
      - 총건수               : 2만건
      - 고객성향코드 = '920' : 101건
      - 고객성향코드 종류    : 200종류
      - 인덱스 : PK_T_고객23 (고객번호)

   T_주문23
      - 총 건수: 200만건
      - 아래 조건의 결과 : 10,000건
        O.주문일자 LIKE '201701%' AND O.상품코드 = 'P103'
      - 인덱스 : PK_T_주문23 (주문번호)   */

SELECT C.고객번호, C.고객명, C.C1,
       O.주문번호, O.상품코드, O.주문일자, O.주문수량
FROM T_고객23 C, T_주문23 O
WHERE C.고객성향코드 = '920'
 AND  O.고객번호     = C.고객번호
 AND  O.주문일자     LIKE '201701%'
 AND  O.상품코드     = 'P103';

desc t_고객23;

/*
PLAN_TABLE_OUTPUT
--------------------------------------------------------------
| Id  | Operation          | Name   |A-Rows | Buffers | Reads
--------------------------------------------------------------
|   0 | SELECT STATEMENT   |        |    18 |   11363 |  10793
|*  1 |  HASH JOIN         |        |    18 |   11363 |  10793
|*  2 |   TABLE ACCESS FULL| T_고객2|   108 |     461 |      0
|*  3 |   TABLE ACCESS FULL| T_주문2|  3070 |   10902 |  10793
--------------------------------------------------------------
 */

/*
    답안 :
*/
CREATE INDEX SYSTEM.IX_T_고객23 ON SYSTEM.T_고객23(고객성향코드);
CREATE INDEX SYSTEM.IX_T_주문23 ON SYSTEM.T_주문23(고객번호, 상품코드, 주문일자);

SELECT /*+ ORDERED USE_NL(O) INDEX(C SYSTEM.IX_T_고객23) INDEX(D SYSTEM.IX_T_주문23) */
        C.고객번호, C.고객명, C.C1,
        O.주문번호, O.상품코드, O.주문일자, O.주문수량
FROM SYSTEM.T_고객23 C, SYSTEM.T_주문23 O
WHERE C.고객성향코드 = '920'
 AND  O.고객번호     = C.고객번호
 AND  O.주문일자     LIKE '201701%'
 AND  O.상품코드     = 'P103';


