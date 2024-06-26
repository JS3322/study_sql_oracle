/* 
다음의 SQL을 같은 Data을 증복해서 읽지 않도록 개선하세요.
필요한 인덱스는 모두 구성되었다는 가정
T_ORDER42의 Primary key : ORDER_NO
*/

--문제1)
SELECT  B.ORDER_NO, B.ORDER_CD,
        ROUND(A.ORDER_AMT_AVG) 평균주문금액, A.ORDER_AMT_SUM 주문합계금액
FROM  (SELECT ORDER_CD
            , AVG(ORDER_AMT) ORDER_AMT_AVG
            , SUM(ORDER_AMT) ORDER_AMT_SUM
       FROM T_ORDER42
       GROUP BY ORDER_CD
      )A,  T_ORDER42 B
WHERE B.ORDER_CD = A.ORDER_CD
ORDER BY ORDER_CD, ORDER_NO
;

--문제2)
SELECT B.ORDER_NO, B.ORDER_CD, B.ORDER_DT, B.ORDER_AMT, B.ORDER_QTY
FROM (SELECT MAX(ORDER_NO) ORDER_NO
      FROM T_ORDER42
      GROUP BY ORDER_CD
     ) A, T_ORDER42 B
WHERE B.ORDER_NO = A.ORDER_NO
ORDER BY ORDER_CD, ORDER_NO
;
