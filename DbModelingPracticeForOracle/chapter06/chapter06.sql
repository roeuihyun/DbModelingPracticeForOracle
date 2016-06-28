--[PAGE166][테이블 별 ROWID 조회]
SELECT ROWID
       ,T1.*
FROM INSA T1;

--[PAGE166][ROWID를 이용한 DML 실행 예제]

--상품마스터 상품 코드 보정작업
UPDATE PRODUCT_MAST A
SET A.CP_CD = 'ZZZZZ'
WHERE ROWID IN (
                SELECT A.ROWID
                FROM PRODUCT_MAST A
                     ,CONT_PROVIDER B
                WHERE A.CP_CD = B.CP_CD(+)
                AND A.CP_GB = B.CP_GB(+)
                AND B.CP_CD = NULL);

--상품 마스터 출판사 보정 작업
UPDATE PRODUCT_MAST A
SET A.CP_CD1 = 'ZZZZZ'
WHERE ROWID IN (
                SELECT A.ROWID
                FROM PRODUCT_MAST A
                     ,CONT_PROVIDER B
                WHERE A.CP_CD1 = B.CP_CD(+)
                AND A.CP_GB1 = B.CP_GB(+)
                AND B.CP_CD = NULL);

--비교값 중의 중복값을 제거한다.
DELETE
FROM RGTMGD
WHERE ROWID IN(
               SELECT A.ROWID
               FROM RGTMGD A
                    ,RGTMGD B
               WHERE A.TEAM_CDOE||A.WRK_CAT||A.REG_NO||SUBSTR(A.MBD_REG_NO,1,7)||'******'
               = B.TEAM_CDOE||B.WRK_CAT||B.REG_NO||SUBSTR(B.MBD_REG_NO,1,7)||'******'
               AND A.ROWID < B.ROWID
               );
               
--[PAGE168][ROWNUM의 조회]
SELECT ROWNUM
       ,SABUN
       ,NAME
       ,ENG_NAME
       ,JOIN_GBN_CODE
FROM INSA T1;

--[PAGE168][ROWNUM과 SORT]
SELECT ROWNUM
       ,SABUN
       ,NAME
       ,ENG_NAME
       ,JOIN_GBN_CODE
FROM INSA T1
ORDER BY NAME;

--[PAGE169][ROWNUM의 사용]
SELECT ROWNUM
       ,SABUN
       ,NAME
       ,ENG_NAME
       ,JOIN_GBN_CODE
FROM INSA T1
WHERE ROWNUM = 1;

--[PAGE169][ROWNUM의 잘못된 예]
SELECT ROWNUM
       ,SABUN
       ,NAME
       ,ENG_NAME
       ,JOIN_GBN_CODE
FROM INSA T1
WHERE ROWNUM > 2;
-- ROWNUM은 추출되는 대상을 가지고 +1씩 증가하는 PSEUDO컬럼이므로 아직 추출하지 못한 값이여서
-- 논리적으로 추출하지 못하는 것이다.

--[PAGE170][ROWNUM의 잘못된 예]
SELECT ROWNUM
       ,SABUN
       ,NAME
       ,ENG_NAME
       ,JOIN_GBN_CODE
FROM INSA T1
WHERE ROWNUM > 1
AND ROWNUM < 100;

--[PAGE170][ROWNUM의 올바른 예]
SELECT ROWNUM
       ,SABUN
       ,NAME
       ,ENG_NAME
       ,JOIN_GBN_CODE
FROM INSA T1
WHERE ROWNUM >= 1
AND ROWNUM < 100;

-- ROWNUM을 사용할 때는 조회 시 1부터 조회되므로 항상 1이 포함되어 있어야 비교할 수 있다는 특성을 잘 알자

--[PAGE171][UNION의 컬럼 유형]
SELECT 20090101 AS SABUN
       ,'이호상' AS NAME
FROM DUAL
UNION
SELECT '20090102' AS SABUN
       ,'홍길동' AS NAME
FROM DUAL;

--[PAGE171][UNION의 컬럼 개수]
SELECT '20090101' AS SABUN
       ,'이호상' AS NAME
       ,'LEE HO SANG' AS ENG_NAME
FROM DUAL
UNION
SELECT '20090102' AS SABUN
       ,'홍길동' AS NAME
FROM DUAL;

--UNION 이나 UNION ALL은 대응되는 집합의 컬럼 유형과 컬럼의 개수가 같아야 에러를 발생 시키지 않는다.

--[PAGE172][UNION의 사용]
SELECT '20090101' AS SABUN
       ,'이호상' AS NAME
FROM DUAL
UNION
SELECT '20090102' AS SABUN
       ,'홍길동' AS NAME
FROM DUAL;

--[PAGE172][UNION의 특성]
SELECT '20090101' AS SABUN
       ,'이호상' AS NAME
FROM DUAL
UNION
SELECT '20090102' AS SABUN
       ,'홍길동' AS NAME
FROM DUAL
UNION
SELECT '20090102' AS SABUN
       ,'김길동' AS NAME
FROM DUAL
UNION
SELECT '20090102' AS SABUN
       ,'홍길동' AS NAME
FROM DUAL
UNION
SELECT '20090102' AS SABUN
       ,'홍길동' AS NAME
FROM DUAL;

--[PAGE173][UNION ALL의 특성]
SELECT '20090101' AS SABUN
       ,'이호상' AS NAME
FROM DUAL
UNION ALL
SELECT '20090102' AS SABUN
       ,'홍길동' AS NAME
FROM DUAL
UNION ALL
SELECT '20090102' AS SABUN
       ,'김길동' AS NAME
FROM DUAL
UNION ALL
SELECT '20090102' AS SABUN
       ,'홍길동' AS NAME
FROM DUAL
UNION ALL
SELECT '20090102' AS SABUN
       ,'홍길동' AS NAME
FROM DUAL;

--[PAGE175][GROUP BY의 사용]
SELECT JOIN_GBN_CODE
       ,COUNT(SABUN)
       ,MAX(NAME)
       ,MIN(ENG_NAME)
       ,COUNT(ENG_NAME)
       ,ROUND(AVG(SALARY))
FROM INSA
GROUP BY JOIN_GBN_CODE;

--[PAGE175][GROUP BY의 사용]
SELECT JOIN_GBN_CODE
       ,COUNT(SABUN)
       ,MAX(NAME)
       ,MIN(ENG_NAME)
       ,COUNT(ENG_NAME)
       ,ROUND(AVG(SALARY))
FROM INSA
GROUP BY JOIN_GBN_CODE
HAVING ROUND(AVG(SALARY)) < 2700;

--[PAGE176][<예제> GROUP BY를 사용하여 합계를 산출하라.]
--[예제 풀이 SQL 과정_1]
SELECT NO
       ,JOIN_GBN_CODE
       ,COUNT(SABUN)
       ,MAX(NAME)
       ,MIN(ENG_NAME)
       ,COUNT(ENG_NAME)
       ,ROUND(AVG(SALARY))
FROM INSA
     ,(SELECT 1 AS NO FROM DUAL UNION
       SELECT 2 AS NO FROM DUAL)
GROUP BY NO, JOIN_GBN_CODE;       

--[예제 풀이 SQL 과정_2]
SELECT DECODE(NO,1,JOIN_GBN_CODE,'합계')
       ,COUNT(SABUN)
       ,MAX(NAME)
       ,MIN(ENG_NAME)
       ,COUNT(ENG_NAME)
       ,ROUND(AVG(SALARY))
FROM INSA
     ,(SELECT 1 AS NO FROM DUAL UNION
       SELECT 2 AS NO FROM DUAL)
GROUP BY DECODE(NO,1,JOIN_GBN_CODE,'합계')
ORDER BY DECODE(NO,1,JOIN_GBN_CODE,'합계');

--[PAGE177][GROUP BY와 SORTING]
SELECT DECODE(NO,1,JOIN_GBN_CODE,'합계')
       ,COUNT(SABUN)
       ,MAX(NAME)
       ,MIN(ENG_NAME)
       ,COUNT(ENG_NAME)
       ,ROUND(AVG(SALARY))
FROM INSA
     ,(SELECT 1 AS NO FROM DUAL UNION
       SELECT 2 AS NO FROM DUAL)
GROUP BY DECODE(NO,1,JOIN_GBN_CODE,'합계');

SELECT DECODE(NO,1,JOIN_GBN_CODE,'합계')
       ,COUNT(SABUN)
       ,MAX(NAME)
       ,MIN(ENG_NAME)
       ,COUNT(ENG_NAME)
       ,ROUND(AVG(SALARY))
FROM INSA
     ,(SELECT 1 AS NO FROM DUAL UNION
       SELECT 2 AS NO FROM DUAL)
GROUP BY DECODE(NO,1,JOIN_GBN_CODE,'합계')
ORDER BY DECODE(NO,1,JOIN_GBN_CODE,'합계');


--[PAGE179][합계를 구함 - GROUP BY와 ROLLUP]
SELECT DECODE(JOIN_GBN_CODE,NULL,'합계',JOIN_GBN_CODE) AS GBN_CODE
       ,COUNT(SABUN)
       ,MAX(NAME)
       ,MIN(ENG_NAME)
       ,COUNT(ENG_NAME)
       ,ROUND(AVG(SALARY))
FROM INSA
GROUP BY ROLLUP(JOIN_GBN_CODE);

--[PAGE179][소계를 구함 - GROUP BY와 ROLLUP]
SELECT DECODE(JOIN_GBN_CODE,NULL,'소계',JOIN_GBN_CODE) AS GBN_CODE
       ,COUNT(SABUN)
       ,MAX(NAME)
       ,MIN(ENG_NAME)
       ,COUNT(ENG_NAME)
       ,ROUND(AVG(SALARY))
FROM INSA
GROUP BY ROLLUP(JOIN_GBN_CODE),SEX;

--[PAGE180][소계와 합계를 구함 - GROUP BY와 ROLLUP]
SELECT DECODE(JOIN_GBN_CODE,NULL,'합계',JOIN_GBN_CODE) AS GBN_CODE
       ,DECODE(SEX,NULL,'소계',SEX) AS SEX
       ,COUNT(SABUN)
       ,MAX(NAME)
       ,MIN(ENG_NAME)
       ,COUNT(ENG_NAME)
       ,ROUND(AVG(SALARY))
FROM INSA
GROUP BY ROLLUP(JOIN_GBN_CODE,SEX);

--[PAGE181][합계를 구함 - GROUP BY와 CUBE]
SELECT DECODE(JOIN_GBN_CODE,NULL,'합계',JOIN_GBN_CODE) AS GBN_CODE
       ,COUNT(SABUN)
       ,MIN(ENG_NAME)
       ,COUNT(ENG_NAME)
       ,ROUND(AVG(SALARY))
FROM INSA
GROUP BY CUBE(JOIN_GBN_CODE)
ORDER BY JOIN_GBN_CODE;

--[PAGE181][소계를 구함 - GROUP BY와 CUBE]
SELECT DECODE(JOIN_GBN_CODE,NULL,'소계',JOIN_GBN_CODE) AS GBN_CODE
       ,SEX
       ,COUNT(SABUN)
       ,MIN(ENG_NAME)
       ,COUNT(ENG_NAME)
       ,ROUND(AVG(SALARY))
FROM INSA
GROUP BY CUBE(JOIN_GBN_CODE),SEX
ORDER BY JOIN_GBN_CODE;

--[PAGE182][소계와 합계를 구함 - GROUP BY와 CUBE]
SELECT DECODE(JOIN_GBN_CODE,NULL,'합계',JOIN_GBN_CODE) AS GBN_CODE
       ,DECODE(SEX,NULL,'소계',SEX) AS SEX
       ,COUNT(SABUN)
       ,MIN(ENG_NAME)
       ,COUNT(ENG_NAME)
       ,ROUND(AVG(SALARY))
FROM INSA
GROUP BY CUBE(JOIN_GBN_CODE,SEX)
ORDER BY JOIN_GBN_CODE;

--[PAGE182][GROUP BY와 GROUPING SET]
SELECT DECODE (JOIN_GBN_CODE,NULL,'합계',JOIN_GBN_CODE) AS GBN_CODE
       ,COUNT(SABUN)
       ,MIN(ENG_NAME)
       ,COUNT(ENG_NAME)
       ,ROUND(AVG(SALARY))
FROM INSA
GROUP BY GROUPING SETS(JOIN_GBN_CODE,());

--[PAGE183][GROUP BY와 GROUPING SET]
SELECT DECODE (JOIN_GBN_CODE,NULL,'소계',JOIN_GBN_CODE) AS GBN_CODE
       ,COUNT(SABUN)
       ,MIN(ENG_NAME)
       ,COUNT(ENG_NAME)
       ,ROUND(AVG(SALARY))
FROM INSA
GROUP BY GROUPING SETS((JOIN_GBN_CODE,SEX),(SEX));

--[PAGE184][GROUP BY와 GROUPING SET]
SELECT DECODE (JOIN_GBN_CODE,NULL,DECODE (SEX,NULL,'소계','합계'),JOIN_GBN_CODE) AS GBN_CODE
       ,SEX
       ,COUNT(SABUN)
       ,MIN(ENG_NAME)
       ,COUNT(ENG_NAME)
       ,ROUND(AVG(SALARY))
FROM INSA
GROUP BY GROUPING SETS((JOIN_GBN_CODE,SEX),(SEX),());

--[PAGE189][NESTED LOOP JOIN SQL문 CTRL + E로 PLAN 확인]
SELECT /*+ ORDERD USE_NL(T T1)*/
       T.SABUN
       ,T.ENG_NAME
       ,T.JOIN_GBN_CODE
       ,T.SALARY
       ,T1.CMP_NAME
       ,T1.CMP_PHONE
       ,T1.CMP_ADDR1
FROM INSA T
     ,INSA_COMPANY T1
WHERE T.CMP_REG_NO = T1.CMP_REG_NO
AND T.SABUN BETWEEN '2012121201' AND '2012123199'
AND T1.CMP_REG_NO = '2222222206';

--[PAGE190][SORT MERGE JOIN문 CTRL + E로 PLAN 확인]
SELECT /*+ USE_MERGE(T,T1)*/
       T.SABUN
       ,T.ENG_NAME
       ,T.JOIN_GBN_CODE
       ,T.SALARY
       ,T1.CMP_NAME
       ,T1.CMP_PHONE
       ,T1.CMP_ADDR1
FROM INSA T
     ,INSA_COMPANY T1
WHERE T.CMP_REG_NO = T1.CMP_REG_NO;

--[PAGE192][HASH JOIN문 CTRL + E로 PLAN 확인]
SELECT /*+USE_HASH(T,T1) */
       T.SABUN
       ,T.ENG_NAME
       ,T.JOIN_GBN_CODE
       ,T.SALARY
       ,T1.CMP_NAME
       ,T1.CMP_PHONE
       ,T1.CMP_ADDR1
FROM INSA T
     ,INSA_COMPANY T1
WHERE T.CMP_REG_NO = T1.CMP_REG_NO;

--[PAGE196][<예제>를 위해 테이블 생성]
CREATE TABLE CHAPTER_2 AS SELECT * FROM CHAPTER_1;

--[PAGE196][<예제> 대학 졸업자들의 평균 나이를 구하시오. 기본 SELECT 쿼리]
SELECT T2.ACAD_ABILITY
       ,AVG(T1.AGE) AS AVG_AGE
FROM CHAPTER_1 T1
     ,CHAPTER_2 T2
WHERE T1.SABUN = T2.SABUN
GROUP BY T2.ACAD_ABILITY
HAVING T2.ACAD_ABILITY = '대졸';

--[PAGE197][<예제> 두 테이블을 이용해 대학 졸업자의 리스트를 추출하여 나이 순서대로 조회하시오 기본 SELECT 쿼리]
SELECT T1.SABUN AS SABUN
       ,T1.NAME AS NAME
       ,T1.AGE
       ,T2.ACAD_ABILITY
       ,T2.MAJOR_STUDY
       ,T2.GRAT_YM
FROM CHAPTER_1 T1
     ,CHAPTER_2 T2
WHERE T1.SABUN = T2.SABUN
AND T2.ACAD_ABILITY = '대졸'
ORDER BY AGE DESC;

--[PAGE198][<예제> 대학 졸업자 중 전공별로 인원과 총 합을 구하시오 기본 SELECT 쿼리]
SELECT T2.ACAD_ABILITY
       ,NVL(T2.MAJOR_STUDY,'-')
       ,COUNT(*) AS TOTAL_COUNT
FROM CHAPTER_1 T1
     ,CHAPTER_2 T2
WHERE T1.SABUN = T2.SABUN
GROUP BY ROLLUP(T2.ACAD_ABILITY,T2.MAJOR_STUDY)
HAVING T2.ACAD_ABILITY = '대졸';

--[PAGE199][<예제> 전체 인원의 평균 나이를 구하고 평균 이하의 인원을 조회하시오. 기본SELECT 쿼리]
-- 방법_1
SELECT AVG(AGE) AS AVG_AGE
FROM TABLE_1;

-- 방법_2
SELECT SABUN
       ,NAME
       ,AGE
FROM TABLE_1
WHERE AGE <= '28';

--[PAGE199][SBUQUERY를 활용한 데이터 조회]
SELECT SABUN
       ,NAME
       ,AGE
FROM TABLE_1
WHERE AGE <= (SELECT AVG(AGE) AS AVG_AGE
              FROM TABLE_1 );
              
              
--[PAGE202][SELECT 문]
SELECT
    DECODE(T2.RECT_REG_NO,NULL,'합계',T2.RECT_REG_NO) AS "채용등록번호"
    ,DECODE(T2.RECT_REG_NO,NULL,'',MAX(T2.PJT_NAME)) AS "프로젝트명"
    ,DECODE(T2.RECT_REG_NO,NULL,'',MAX(T2.PJT_PLACE)) AS "프로젝트장소"
    ,DECODE(T2.RECT_REG_NO,NULL,'',MAX(DECODE(T2.PUT_START_DAY,NULL,'0001/01/01',TO_CHAR(T2.PUT_START_DAY,'YYYY/MM/DD')))) AS "투입시작일"
    ,DECODE(T2.RECT_REG_NO,NULL,'',MAX(DECODE(T2.PUT_END_DAY,NULL,'9999/12/31',TO_CHAR(T2.PUT_END_DAY,'YYYY/MM/DD')))) AS "투입종료일"
    ,DECODE(T2.RECT_REG_NO,NULL,'',
            '총'||COUNT(T2.SABUN)||'명',MAX(T1.NAME)||
            (DECODE(COUNT(T1.SABUN),0,'0명',DECODE(COUNT(T1.SABUN),1,'','외'||(COUNT(T1.SABUN)-1)||'명')))) AS "투입인원수"
FROM INSA T1 --인사 마스터
     ,(SELECT TT1.RECT_REG_NO
              ,TT1.PJT_NAME
              ,TT1.PJT_PLACE
              ,TT1.PUT_START_DAY
              ,TT1.PUT_END_DAY
              ,TT2.SABUN
       FROM INSA_RECT_NOTICE TT1 -- 채용공고
            ,INSA_EMP_PJT TT2 -- 사원별 프로젝트
       WHERE TT1.RECT_REG_NO = TT2.RECT_REG_NO(+)
       AND TT1.PJT_NAME LIKE :IN_PJT_NAME||'%' -- 프로젝트명을 받는다.
       ) T2
WHERE T2.SABUN = T1.SABUN(+)       
GROUP BY ROLLUP(T2.RECT_REG_NO)
ORDER BY T2.RECT_REG_NO;

--[PAGE204][SELECT 문] PARAMETER = :IN_F_PUT_START_DAY = 20130121
SELECT
    T1.CMP_NAME AS "업체명"
    ,T2.NAME AS "성명"
    ,(SELECT CODE_NAME 
      FROM CMM_CODE_DETAIL TT2
      WHERE T2.POS_GBN_CODE = TT2.CODE_NO
      AND CLASS_CODE = 'C03' -- 직위구문코드
      ) AS "직위명"
    ,(SELECT CODE_NAME
      FROM CMM_CODE_DETAIL TT2
      WHERE T2.CLASS_GBN_CODE = TT2.CODE_NO
      AND TT2.CLASS_CODE = 'B01' -- 등급구문코드
      ) AS "등급명"
    ,T4.PJT_NAME AS "프로젝트명"
    ,T3.PUT_START_DAY AS "투입시작일자"
    ,T3.PUT_END_DAY AS "투입종료일자"
    ,T1.SALE_COMPT_NAME AS "영업담당자"
    ,T1.CMP_PHONE AS "업체전화번호"
FROM INSA_COMPANY T1 --업체
     ,INSA T2 --인사마스터
     ,INSA_EMP_PJT T3 --사원별프로젝트
     ,INSA_RECT_NOTICE T4 --채용공고
WHERE 1=1
AND T1.CMP_REG_NO = T2.CMP_REG_NO 
AND T2.SABUN = T3.SABUN
AND T3.RECT_REG_NO = T4.RECT_REG_NO
AND (
     (T3.PUT_START_DAY >= TO_DATE(:IN_F_PUT_START_DAY,'YYYYMMDD') 
      AND T3.PUT_START_DAY < TO_DATE(:IN_F_PUT_START_DAY,'YYYYMMDD')+1)
      OR
     (T3.PUT_END_DAY >= TO_DATE(:IN_F_PUT_START_DAY,'YYYYMMDD') 
      AND T3.PUT_END_DAY < TO_DATE(:IN_F_PUT_START_DAY,'YYYYMMDD')+1)
    )
AND T1.CMP_NAME LIKE :IN_CMP_NAME||'%';

--[PAGE207][<예제> 월별 투입현황을 작성하시오. SELECT문]
SELECT DECODE(CMP_NAME,NULL,'합계',CMP_NAME) AS "업체명"
       ,SUM(
            CASE WHEN :IN_YYYY || '01' BETWEEN TO_CHAR(PUT_START_DAY,'YYYYMM') AND TO_CHAR(PUT_END_DAY,'YYYYMM')
                 THEN 1 
                 ELSE 0
            END
            ) AS MM_01
       ,SUM(
            CASE WHEN :IN_YYYY || '02' BETWEEN TO_CHAR(PUT_START_DAY,'YYYYMM') AND TO_CHAR(PUT_END_DAY,'YYYYMM')
                 THEN 1 
                 ELSE 0
            END
            ) AS MM_02
       ,SUM(
            CASE WHEN :IN_YYYY || '03' BETWEEN TO_CHAR(PUT_START_DAY,'YYYYMM') AND TO_CHAR(PUT_END_DAY,'YYYYMM')
                 THEN 1 
                 ELSE 0
            END
            ) AS MM_03
       ,SUM(
            CASE WHEN :IN_YYYY || '04' BETWEEN TO_CHAR(PUT_START_DAY,'YYYYMM') AND TO_CHAR(PUT_END_DAY,'YYYYMM')
                 THEN 1 
                 ELSE 0
            END
            ) AS MM_04
       ,SUM(
            CASE WHEN :IN_YYYY || '05' BETWEEN TO_CHAR(PUT_START_DAY,'YYYYMM') AND TO_CHAR(PUT_END_DAY,'YYYYMM')
                 THEN 1 
                 ELSE 0
            END
            ) AS MM_05
       ,SUM(
            CASE WHEN :IN_YYYY || '06' BETWEEN TO_CHAR(PUT_START_DAY,'YYYYMM') AND TO_CHAR(PUT_END_DAY,'YYYYMM')
                 THEN 1 
                 ELSE 0
            END
            ) AS MM_06
       ,SUM(
            CASE WHEN :IN_YYYY || '07' BETWEEN TO_CHAR(PUT_START_DAY,'YYYYMM') AND TO_CHAR(PUT_END_DAY,'YYYYMM')
                 THEN 1 
                 ELSE 0
            END
            ) AS MM_07
       ,SUM(
            CASE WHEN :IN_YYYY || '08' BETWEEN TO_CHAR(PUT_START_DAY,'YYYYMM') AND TO_CHAR(PUT_END_DAY,'YYYYMM')
                 THEN 1 
                 ELSE 0
            END
            ) AS MM_08
       ,SUM(
            CASE WHEN :IN_YYYY || '09' BETWEEN TO_CHAR(PUT_START_DAY,'YYYYMM') AND TO_CHAR(PUT_END_DAY,'YYYYMM')
                 THEN 1 
                 ELSE 0
            END
            ) AS MM_09
       ,SUM(
            CASE WHEN :IN_YYYY || '10' BETWEEN TO_CHAR(PUT_START_DAY,'YYYYMM') AND TO_CHAR(PUT_END_DAY,'YYYYMM')
                 THEN 1 
                 ELSE 0
            END
            ) AS MM_10
       ,SUM(
            CASE WHEN :IN_YYYY || '11' BETWEEN TO_CHAR(PUT_START_DAY,'YYYYMM') AND TO_CHAR(PUT_END_DAY,'YYYYMM')
                 THEN 1 
                 ELSE 0
            END
            ) AS MM_11
       ,SUM(
            CASE WHEN :IN_YYYY || '12' BETWEEN TO_CHAR(PUT_START_DAY,'YYYYMM') AND TO_CHAR(PUT_END_DAY,'YYYYMM')
                 THEN 1 
                 ELSE 0
            END
            ) AS MM_12
        ,(
          SUM(
            CASE WHEN :IN_YYYY || '01' BETWEEN TO_CHAR(PUT_START_DAY,'YYYYMM') AND TO_CHAR(PUT_END_DAY,'YYYYMM')
                 THEN 1 
                 ELSE 0
            END
          ) +
          SUM(
            CASE WHEN :IN_YYYY || '02' BETWEEN TO_CHAR(PUT_START_DAY,'YYYYMM') AND TO_CHAR(PUT_END_DAY,'YYYYMM')
                 THEN 1 
                 ELSE 0
            END
          ) +
          SUM(
            CASE WHEN :IN_YYYY || '03' BETWEEN TO_CHAR(PUT_START_DAY,'YYYYMM') AND TO_CHAR(PUT_END_DAY,'YYYYMM')
                 THEN 1 
                 ELSE 0
            END
          ) +
          SUM(
            CASE WHEN :IN_YYYY || '04' BETWEEN TO_CHAR(PUT_START_DAY,'YYYYMM') AND TO_CHAR(PUT_END_DAY,'YYYYMM')
                 THEN 1 
                 ELSE 0
            END
          ) +
          SUM(
            CASE WHEN :IN_YYYY || '05' BETWEEN TO_CHAR(PUT_START_DAY,'YYYYMM') AND TO_CHAR(PUT_END_DAY,'YYYYMM')
                 THEN 1 
                 ELSE 0
            END
          ) +
          SUM(
            CASE WHEN :IN_YYYY || '06' BETWEEN TO_CHAR(PUT_START_DAY,'YYYYMM') AND TO_CHAR(PUT_END_DAY,'YYYYMM')
                 THEN 1 
                 ELSE 0
            END
          ) +
          SUM(
            CASE WHEN :IN_YYYY || '07' BETWEEN TO_CHAR(PUT_START_DAY,'YYYYMM') AND TO_CHAR(PUT_END_DAY,'YYYYMM')
                 THEN 1 
                 ELSE 0
            END
          ) +
          SUM(
            CASE WHEN :IN_YYYY || '08' BETWEEN TO_CHAR(PUT_START_DAY,'YYYYMM') AND TO_CHAR(PUT_END_DAY,'YYYYMM')
                 THEN 1 
                 ELSE 0
            END
          ) +
          SUM(
            CASE WHEN :IN_YYYY || '09' BETWEEN TO_CHAR(PUT_START_DAY,'YYYYMM') AND TO_CHAR(PUT_END_DAY,'YYYYMM')
                 THEN 1 
                 ELSE 0
            END
          ) +
          SUM(
            CASE WHEN :IN_YYYY || '10' BETWEEN TO_CHAR(PUT_START_DAY,'YYYYMM') AND TO_CHAR(PUT_END_DAY,'YYYYMM')
                 THEN 1 
                 ELSE 0
            END
          ) +
          SUM(
            CASE WHEN :IN_YYYY || '11' BETWEEN TO_CHAR(PUT_START_DAY,'YYYYMM') AND TO_CHAR(PUT_END_DAY,'YYYYMM')
                 THEN 1 
                 ELSE 0
            END
          ) +
          SUM(
            CASE WHEN :IN_YYYY || '12' BETWEEN TO_CHAR(PUT_START_DAY,'YYYYMM') AND TO_CHAR(PUT_END_DAY,'YYYYMM')
                 THEN 1 
                 ELSE 0
            END
          ) 
        ) AS TOT
FROM INSA_COMPANY T1 -- 업체
     ,INSA T2 --인사 마스터
     ,INSA_EMP_PJT T3 --사원별프로젝트
WHERE 1 = 1
AND (
     (T3.PUT_START_DAY >= TO_DATE(:IN_YYYY||'0101','YYYYMMDD') 
      AND T3.PUT_START_DAY < TO_DATE(:IN_YYYY||'1231','YYYYMMDD')+1)
      OR
     (T3.PUT_END_DAY >= TO_DATE(:IN_YYYY||'0101','YYYYMMDD') 
      AND T3.PUT_END_DAY < TO_DATE(:IN_YYYY||'1231','YYYYMMDD')+1)
    )
AND T2.SABUN = T3.SABUN
AND T1.CMP_REG_NO = T2.CMP_REG_NO
GROUP BY ROLLUP(T1.CMP_NAME)
ORDER BY T1.CMP_NAME;

--[PAGE210][<예제> 시작일과 종료일을 받아서 중간 단계의 년월일을 추출하시오]
--[두 날짜를 입력 받아 그 사이의 년월일 생성]
SELECT /*+ FULL(T) */
       TO_CHAR(
               (
                (TO_DATE(20130125,'YYYYMMDD')-1) - (-1 * NO)
               ),'YYYYMMDD'
              ) AS SLE_YMD
FROM (
     SELECT ROWNUM AS NO
     FROM A_PGM_AUTH
     ) T
WHERE NO < (SELECT (
                     (TO_DATE(20130130,'YYYYMMDD')+1) - (TO_DATE(20130125,'YYYYMMDD'))
                    ) AS IL_SU
             FROM DUAL 
            );
-- 집합의 개수가 시작일과 종료일의 차이보다 작은 집합으로 추출을 하여 만들어준다.

--[PAGE211][기본적인 INSERT DML]
INSERT INTO CHAPTER_1(SABUN,NAME,AGE,PHONE)
VALUES('20090102','홍길동',15,'01063302151');

--[PAGE212][다중 건의 INSERT]
INSERT INTO CNTTNFHIST(
    SELECT A.REGISTER_SNO
           ,A.REGISTER_GBN
           ,A.ATCL_PRD_SNO
           ,ROWNUM HIST_SEQ
           ,A.HIST_DATE
           ,A.HIST_ITEM_CODE
           ,A.HIST_BEFO
           ,A.HIST_AFFT
           ,A.HIST_MAN_NAME AS HIST_MAN_NAME
           ,A.HIST_MAN_DUTY AS HIST_MAN_DUTY
           ,A.MW_TAKE_NO
           ,'Y' AS USES_YN
           ,SYSDATE AS REGIST_TIME
           ,'88888888' AS REGIST_ID
           ,SYSDATE AS UPDATE_TIME
           ,'88888888' AS REGIST_ID
FROM (
        SELECT X.*
        FROM (
             -- 신규신고
             SELECT A.UPSO_SNO REGISTER_SNO
                    ,'134' REGISTER_GBN
                    ,A.ATCL_PRD_SNO AS ATCL_PRD_SNO
                    ,A.STDT AS HIST_DATE
                    ,'' AS HIST_ITEM_CODE
                    ,'' AS HIST_BEFO
                    ,'신규신고' AS HIST_AFFT
                    ,B.NM AS HIST_MAN_NAME
                    ,B.POSIT AS HIST_MAN_DUTY
                    ,A.MW_TAKE_NO MW_TAKE_NO
             FROM CNTTNFATCL A
                  ,CNTTNCUSER B
             WHERE A.WRKR_ID = B.USR_ID
            ) X ORDER BY 1,3,4,5 ) A
        WHERE NVL(A.HIST_BEFO,'') <> NVL(A.HIST_AFFT,'')
        AND A.ATCL_PRD_SNO < 100000
);

--[PAGE214][새로운 테이블 생성과 동시에 데이터 INSERT]
--방법_1
CREATE TABLE IMSI_TABLE AS 
SELECT T1.SABUN AS SABUN
       ,T1.NAME AS NAME
       ,NVL(T2.ACAD_ABILITY,'-') AS ACAD_ABILITY
       ,NVL(T2.MAJOR_STUDY,'-') AS MAJOR_STUDY
FROM CHAPTER_1 T1
     ,CHAPTER_2 T2
WHERE T1.SABUN = T2.SABUN(+);

--방법_2
CREATE TABLE IMSI_TABLE AS 
(SABUN,NAME,ACAD_ABILITY,MAJOR_STUDY)
SELECT T1.SABUN
       ,T1.NAME
       ,NVL(T2.ACAD_ABILITY,'-')
       ,NVL(T2.MAJOR_STUDY,'-')
FROM CHAPTER_1 T1
     ,CHAPTER_2 T2
WHERE T1.SABUN = T2.SABUN(+);

--[PAGE217][ <예제> 데이터 조회 화면 중 '홍길동'의 나이를 23으로, 핸드폰 번호의 뒷자리를 변경하시오.]
UPDATE TABLE_1
SET AGE = '23'
    ,PHONE='01063307700'
WHERE NAME = '홍길동';

--[PAGE218][ 다중 UPDATE SQL문]
UPDATE PRODUCT_MAST A
SET (A.LINK_CLASS
     ,A.CP_CD
     ,A.CP_CD1) =
    (SELECT B.LINK_CLASS
            ,B.CP_CD
            ,B.CP_CD1
     FROM PRODUCT_MAST_NEW B
     WHERE B.BARCODE = A.BARCODE);

--[PAGE218][ROWID 체크]
SELECT T1.ROWID
FROM INSA T1
WHERE SABUN = '2012010101';

--[PAGE218][ROW ID를 이용한 다중 UPDATE 쿼리]
UPDATE PRODUCT_MAST
SET CP_CD = 'ZZZZZ'
    ,CP_CD1 = 'ZZZZZ'
    .LINK_CLASS = ''
WHERE ROWID IN(
               SELECT A.ROWID
               FROM PRODUCT_MAST A
                    ,PRODUCT_MAST_NEW B
               WHERE A.BARCODE = B.BARCODE(+)
               AND B.BARCODE IS NULL);
               
--[PAGE219][EXISTS를 이용한 다중 UPDATE 쿼리]
UPDATE KFA2003.IFD_GOODS_INGR AA
SET AA. INGR_CODE = (SELECT INGR_CODE_NEW
                     FROM INGR_CODE_2009CONV BB
                     WHERE BB.USE_YN = '2' --삭제
                     AND AA.INGR_CODE =BB.INGR_CODE_OLD)
WHERE EXISTS (SELECT 1
              FROM INGR_CODE_2009CONV BB
              WHERE BB.USE_YN = '2' --삭제
              AND AA.INGR_CODE =BB.INGR_CODE_OLD);

--[PAGE220][<예제> 데이터 조회 화면 중 사번 '20090102'의 정보를 삭제하시오.]
--[기본 DELETE 쿼리와 데이터 조회]
DELETE TABLE_1
WHERE SABUN = '20090102';

--[PAGE221][ROWID를 다중건의 DELETE]
DELETE FROM TNRGTMGD
WHERE ROWID IN (SELECT A.ROWID
                FROM TNRGTMGD A, TNRGTMGD B
                WHERE A.SF_TEAM_CODE 
                || A.WRK_CAT
                || A.MG_REG_NO
                || SUBSTR(A.RGT_MBD_REG_NO,1,7)
                || '******'
                = B.SF_TEAM_CODE 
                || B.WRK_CAT
                || B.MG_REG_NO
                || SUBSTR(B.RGT_MBD_REG_NO,1,7)
                || '******'
                AND A.ROWID < B.ROWID);

--[PAGE232][MERGE 함수를 이용한 데이터 처리 예_1]
MERGE INTO BONUSES D
USING (SELECT EMPLOYEE_ID
              ,SALARY
              ,DEPARTMENT_ID
       FROM EMPLOYEES
       WHERE DEPARTMENT_ID = 80 ) S -- 정보 제공 집합
ON (D.EMPLOYEE_ID = S.EMPLOYEE_ID) -- 연결 고리
WHEN MATCHED THEN 
    UPDATE SET 
    D.BONUS = D.BONUS + S.SALARY * 0.1 --존재시 처리
    WHERE (S.SALARY > 8000)
WHEN NOT MATCHED THEN
    INSERT (D.EMPLOYEE_ID, D.BONUS) --부재시 처리
    VALUES (S.EMPLOYEE_ID, S.SALARY * 0.1);
    
--[PAGE232][MERGE 함수를 이용한 데이터 처리 예_2]
MERGE INTO POR_VOC_LOG_INFO D
USING (SELECT :IN_LOG_YMD, :IN_LOG_EMP_NO LOG_EMP_NO
       FROM DUAL) S
ON (D.LOG_YMD = S.LOG_YMD
    AND D.LOG_EMP_NO = S.LOG_EMP_NO)
WHEN MATCHED THEN
UPDATE SET D.LOG_CNT = D.LOG_CNT + 1
WHEN NOT MATCHED THEN
INSERT (D.LOG_YMD,D.LOG_EMP_NO,D.LOG_CNT)
VALUES (:IN_LOG_YMD, :IN_LOG_EMP_NO, 1);

--[PAGE234][분석 함수의 사용 예]
SELECT SABUN
       ,ENG_NAME
       ,JOIN_GBN_CODE
       ,COUNT(SABUN) OVER(PARTITION BY JOIN_GBN_CODE ORDER BY SABUN) AS COUNT_MEM
FROM INSA;

--[PAGE236][<예제> 정직원 중 연봉이 높은 순서대로 순위를 부여하여 출력하시오.]
SELECT ROWNUM
       ,T1.*
FROM (SELECT SABUN
             ,ENG_NAME
             ,SALARY
             ,JOIN_GBN_CODE
             ,RANK() OVER(PARTITION BY JOIN_GBN_CODE ORDER BY SALARY DESC) AS RANK
             ,DENSE_RANK() OVER(PARTITION BY JOIN_GBN_CODE ORDER BY SALARY DESC) AS DENSE_RANK
             ,ROW_NUMBER() OVER(PARTITION BY JOIN_GBN_CODE ORDER BY SALARY DESC) AS ROW_NUMBER
      FROM INSA       
      ) T1
WHERE JOIN_GBN_CODE = 'RGL'
AND ROWNUM <= 10;

--[PAGE237][<예제> 2013년에 입사한 정직원 중 최근에 입사한 5명을 순서대로 조회하시오.]
--[TOP-N 분석 함수의 사용 예 방법 1]
SELECT T1.*
       ,ROWNUM
FROM (SELECT SABUN
             ,ENG_NAME
             ,NVL(JOIN_DAY,SUBSTR(SABUN,1,8)) AS JOIN_DAY
             ,JOIN_GBN_CODE
      FROM INSA
      WHERE SUBSTR(NVL(JOIN_DAY,SUBSTR(SABUN,1,8)),1,4) = '2013'
      ORDER BY SABUN DESC
      ) T1
WHERE JOIN_GBN_CODE = 'RGL'
AND ROWNUM <= 5;

--[TOP-N 분석 함수의 사용 예 방법 2]
SELECT T1.*
FROM (SELECT SABUN
             ,ENG_NAME
             ,NVL(JOIN_DAY,SUBSTR(SABUN,1,8)) AS JOIN_DAY
             ,JOIN_GBN_CODE
             ,ROW_NUMBER() OVER(PARTITION BY JOIN_GBN_CODE ORDER BY JOIN_DAY DESC) AS "순위"
      FROM INSA
      WHERE SUBSTR(NVL(JOIN_DAY,SUBSTR(SABUN,1,8)),1,4) = '2013'
      ) T1
WHERE JOIN_GBN_CODE = 'RGL'
AND ROWNUM <= 5
ORDER BY "순위" ASC;

--[PAGE239][INDEX 사용으로 RANK 조회]
SELECT ROWNUM
       ,T1.*
FROM (SELECT /*+ INDEX_DESC(INSA INSA_PK)*/
            SABUN
            ,ENG_NAME
            ,NVL(JOIN_DAY,SUBSTR(SABUN,1,8)) AS JOIN_DAY
            ,JOIN_GBN_CODE
      FROM INSA
      WHERE SUBSTR(NVL(JOIN_DAY,SUBSTR(SABUN,1,8)),1,4) = '2013'
      ) T1
WHERE JOIN_GBN_CODE = 'RGL'
AND ROWNUM <= 5;

--[PAGE240][<예제> 프리랜서로 등록된 모든 사원을 급여 기준으로 6등급으로 분류하여 조회하시오.]
SELECT SABUN
       ,ENG_NAME
       ,SALARY
       ,JOIN_GBN_CODE
       ,NTILE(6) OVER(PARTITION BY JOIN_GBN_CODE ORDER BY SALARY DESC) AS NTILE
FROM INSA
WHERE JOIN_GBN_CODE = 'FRE';

--[PAGE241][NTILE 함수의 나머지 값 처리]
SELECT SABUN
       ,ENG_NAME
       ,SALARY
       ,JOIN_GBN_CODE
       ,NTILE(7) OVER(PARTITION BY JOIN_GBN_CODE ORDER BY SALARY DESC) AS NTILE
FROM INSA
WHERE JOIN_GBN_CODE = 'FRE';

-- NTILE 함수는 전체 건수를 조건값으로 받아 어느 한 집단의 데이터를 조회하거나
-- 등급 구분을 하기 위해 사용하기 유용한 함수이다.

--[PAGE242][<예제> 2013년에 입사한 정직원 중 급여그룹을 7개의 그룹으로 구분하고 그 중 급여를 가장 많이 받는 첫 번째 그룹을 조회하시오.]
--[NTILE 분석 함수 사용 예제_2]
SELECT *
FROM  (SELECT SABUN
              ,ENG_NAME
              ,SALARY
              ,JOIN_GBN_CODE
              ,NTILE(7) OVER(PARTITION BY JOIN_GBN_CODE ORDER BY SALARY DESC) AS SAL_G
       FROM INSA
       WHERE SUBSTR(NVL(JOIN_DAY,SUBSTR(SABUN,1,8)),1,4) = '2013'
       )
WHERE JOIN_GBN_CODE = 'RGL'
AND SAL_G = '1';

--CUME_DIST 함수는 그룹값 내에서 기준되는 값의 누적분포를 계산하는 함수이다.
--[PAGE243][<예제> 입사 구분 코드의 각 형태별 연봉 순위를 조회하고 3명씩 추출하여 누적분포를 구하시오.]
--[SALARY의 데이터값으로 누적 분포를 추출]
SELECT *
FROM (SELECT SABUN
             ,ENG_NAME
             ,SALARY
             ,JOIN_GBN_CODE
             ,ROW_NUMBER() OVER(PARTITION BY JOIN_GBN_CODE ORDER BY SALARY DESC) AS ROW_NUMBER
             ,ROUND(CUME_DIST() OVER(PARTITION BY JOIN_GBN_CODE ORDER BY SALARY),3) AS CUME_DIST
      FROM INSA
      ORDER BY JOIN_GBN_CODE DESC)
WHERE ROW_NUMBER <= 3;

--[PAGE245][<예제> 근속 년수가 3년 이상인 직원을 조회하는데 이전 사원의 급여와 합쳐진 금액을 같이 출력하시오.]
--[윈도우 분석 함수 적용 예]
SELECT SABUN
       ,ENG_NAME
       ,SALARY
       ,JOIN_DAY
       ,JOIN_GBN_CODE
       ,SUM(SALARY) OVER(PARTITION BY JOIN_GBN_CODE ORDER BY SABUN ROWS 1 PRECEDING) AS TOTAL_SAL
FROM INSA
WHERE JOIN_DAY < TO_CHAR(ADD_MONTHS(SYSDATE,-36),'YYYYMMDD');

--[PAGE247][<예제> 직원 형태 구분 중 정직원을 조회하는데 월별로 입사 일자가 가장 빠른 사원을 포함하여 조회하시오.]
--[FIRST_VALUE]
SELECT SABUN
       ,ENG_NAME
       ,NVL(JOIN_DAY,SUBSTR(SABUN,1,8)) AS JOIN_DAY
       ,SALARY
       ,FIRST_VALUE(ENG_NAME) OVER(PARTITION BY SUBSTR(JOIN_DAY,1,6) ORDER BY SABUN) AS START_DAY
FROM INSA
WHERE JOIN_GBN_CODE = 'RGL';

--[PAGE248][<예제> 직원 형태 구분 중 정직원의 정보를 조회하고 월별로 입사 일자가 가장 느린 사원을 포함하여 조회하시오.]
--[LAST_VALUE]
SELECT SABUN
       ,ENG_NAME
       ,NVL(JOIN_DAY,SUBSTR(SABUN,1,8)) AS JOIN_DAY
       ,SALARY
       ,LAST_VALUE(ENG_NAME) OVER(PARTITION BY SUBSTR(JOIN_DAY,1,6) ORDER BY SABUN) AS FINAL_DAY
FROM INSA
WHERE JOIN_GBN_CODE = 'RGL';

--[PAGE249]
--[FIRST_VALUE & LAST_VALUE]
SELECT SABUN
       ,ENG_NAME
       ,NVL(JOIN_DAY,SUBSTR(SABUN,1,8)) AS JOIN_DAY
       ,SALARY
       ,FIRST_VALUE(ENG_NAME) OVER(PARTITION BY SUBSTR(JOIN_DAY,1,6) ORDER BY SABUN) AS START_DAY
       ,LAST_VALUE(ENG_NAME) OVER(PARTITION BY SUBSTR(JOIN_DAY,1,6) ORDER BY SABUN ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS FINAL_DAY
FROM INSA
WHERE JOIN_GBN_CODE = 'RGL';

--[PAGE251][<예제> 입사 형태 중 정직원으로 입사한 사원의 정보와 이전, 이후에 입사한 사원을 같이 표시하시오.]
--[LEAD & LAG 분석 함수 사용 SQL]
SELECT SABUN
       ,ENG_NAME
       ,JOIN_DAY
       ,JOIN_GBN_CODE
       ,LEAD(ENG_NAME) OVER(PARTITION BY JOIN_GBN_CODE ORDER BY SABUN) AS NEXT_MEM
       ,LAG(ENG_NAME) OVER(PARTITION BY JOIN_GBN_CODE ORDER BY SABUN) AS PREV_MEM
FROM INSA
WHERE JOIN_GBN_CODE = 'RGL';

--[PAGE252][<예제> 입력되는 사번을 기준으로 이전과 이후에 입사한 직원을 조회하시오.]
--[LEAD & LAG 분석 사용 SQL]
--SQL_1
SELECT SABUN
       ,ENG_NAME
       ,JOIN_DAY
       ,JOIN_GBN_CODE
       ,LEAD(ENG_NAME,1) OVER(PARTITION BY JOIN_GBN_CODE ORDER BY SABUN) AS NEXT_MEM
       ,LAG(ENG_NAME,1) OVER(PARTITION BY JOIN_GBN_CODE ORDER BY SABUN) AS PREV_MEM
FROM INSA
WHERE SABUN = :SABUN;

--SQL_2
SELECT *
FROM (
      SELECT SABUN
             ,ENG_NAME
             ,JOIN_DAY
             ,JOIN_GBN_CODE
             ,LEAD(ENG_NAME,1) OVER(PARTITION BY JOIN_GBN_CODE ORDER BY SABUN) AS NEXT_MEM
             ,LAG(ENG_NAME,1) OVER(PARTITION BY JOIN_GBN_CODE ORDER BY SABUN) AS PREV_MEM
      FROM INSA)
WHERE SABUN = :SABUN;

--[PAGE255][HINT]
-- /*+INDEX*/ INDEX를 순차적으로 SCAN
-- /*+INDEX_DESC(INSA INSA_SAL)*/ INDEX를 역순으로 SCAN
-- /*+INDEX_UNIQUE*/ 값이 UNIQUE한 컬럼에 생성된 UNIQUE INDEX를 통해서 DATA ACCESS
-- /*+INDEX_SS*/ INDEX를 넓게 읽지만 FULL SCAN보다 빠르다.
-- /*+INDEX_SS_ASC*/ INDEX_SS 방식으로 INDEX를 오름차순으로 ACCESS하도록 유도
-- /*+INDEX_SS_DESC*/ INDEX_SS 방식으로 INDEX를 내림차순으로 ACCESS하도록 유도
-- /*+INDEX_FS*/
-- /*+INDEX_FFS*/ NOT NULL 제약이 있어야 사용가능
-- /*+INDEX_EQUAL*/ 인덱스가 여러 개 있을 때 하나의 INDEX만 사용하는 게 아니라 여러개의 INDEX를 동시에 같이 사용해서 더 큰 효과를 보는 작업
-- /*+INDEX_COMBINE*/ INDEX_MERGE와 방법은 같지만 INDEX를 BITMAP INDEX로 변환해서 사이즈를 줄이고 줄인 다음에 작업한다.
--[/*+INDEX_ASC*/ HINT]
SELECT /*+INDEX_ASC*/
       SABUN
       ,ENG_NAME
       ,JOIN_GBN_CODE
       ,SALARY
FROM INSA
WHERE SABUN LIKE '2013%'
AND JOIN_GBN_CODE = 'RGL';

--[PAGE258][/*+INDEX_FFS*/HINT 사용 예]
CREATE INDEX INSA_GBN_SABUN ON INSA(JOIN_GBN_CODE,SABUN);
SELECT /*+INDEX_FFS(INSA INSA_GBN_SABUN)*/
      JOIN_GBN_CODE
      ,COUNT(JOIN_GBN_CODE)
FROM INSA
GROUP BY JOIN_GBN_CODE;

--[PAGE259][JOIN 방법에 의한 힌트]
-- /*+USE_NL*/ JOIN 되는 데이터 양이 적어서 INDEX를 통해 데이터가 ACCESS될 때 유리하다.
-- /*+USE_HASH*/ JOIN 되는 데이터 양이 많아서 FULL TABLE SCAN을 하면서 JOIN될 때 유리하다. 오라클 메모리 JOIN
-- /*+USE_MERGE*/ JOIN 되는 데이터 양이 많아서 FULL TABLE SCAN을 하면서 JOIN될 때 유리하다. 오라클 메모리 JOIN 안하고 내부적으로 정렬 작업이 발생한다.
-- /*+ORDERED*/ FROM절에 기술한 테이블 순서대로 JOIN
-- /*+LEADING*/ HINT 안에 쓴 테이블 명 순서대로 JOIN
--[LEADING HINT 사용 전]
SELECT I.SABUN
       ,I.ENG_NAME
       ,I.JOIN_GBN_CODE
       ,C.CMP_NAME
FROM INSA I, INSA_COMPANY C
WHERE I.CMP_REG_NO = C.CMP_REG_NO
AND I.SABUN = '2012010101'
AND C.CMP_REG_NO = '2222222206';

--[LEADING HINT 사용 후]
SELECT /*+ LEADING(I C)*/
       I.SABUN
       ,I.ENG_NAME
       ,I.JOIN_GBN_CODE
       ,C.CMP_NAME
FROM INSA I, INSA_COMPANY C
WHERE I.CMP_REG_NO = C.CMP_REG_NO
AND I.SABUN = '2012010101'
AND C.CMP_REG_NO = '2222222206';

--[ORDERED HINT 사용]
SELECT /*+ ORDERED */
       I.SABUN
       ,I.ENG_NAME
       ,I.JOIN_GBN_CODE
       ,C.CMP_NAME
FROM INSA I, INSA_COMPANY C
WHERE I.CMP_REG_NO = C.CMP_REG_NO
AND C.CMP_REG_NO = '2222222206'
AND I.SABUN = '2012010101';

--3.3.3 Optimization Goals and Approaches
-- /*+ ALL_ROWS */ 전체 리소스 소비를 최소화 시키기 위한 힌트, 전체 응답 시간이 가장 적은 Plan을 선택
-- /*+ FIRST_ROWS */ WHERE 조건을 만족하는 첫 번째 행을 가장 빠르게 검색하는 실행 계획을 결정
-- /*+ CHOOSE */ Acess되는 테이블에 통계정보의 존재 여부에 따라 옵티마이저로 하여금 Rule-Based Approach 와 Cost-Based Approach 중 하나를 선택할 수 있게 한다.
-- Data Dictionary가 해당 테이블에 대해 통계 정보를 가지고 있다면 Optimizer는 Cost-Based Approach를 선택하고, 그렇지 않다면 Rule-Based Approach를 선택한다.
-- /*+ RULE */ Rule-Based Optimization으로 Plan 작성, 옵티마이저에게 RuleBase 방법으로 쿼리를 수행 하라는 지시

--[/*+ ALL_ROWS */ 힌트 사용]
SELECT /*+ ALL_ROWS */
       SABUN
       ,ENG_NAME
       ,JOIN_GBN_CODE
       ,SALARY
FROM INSA
WHERE SABUN LIKE '2013%'
AND JOIN_GBN_CODE = 'RGL';

--[표6-5] 기타 실행 계획을 조절할 수 있는 힌트
--/*+ USE_CONCAT*/ 조건절에 있는 OR 연산자 조건(또는 IN 연산자 조건)을 별도의 실행 단위로 분리하여 각각의 최적의 엑세스 경로를 수립하여 이를 연결
--/*+ REWRITE(EMP_MV)*/ 어떤 쿼리를 수행하였을 때 옵티마이저는 원래의 테이블을 엑세스하는 방법과 실체뷰를 엑세스 하는 방법 중에서
--유리한 것을 선택하도록 쿼리를 변형 할 수 있다. 이것을 쿼리 재작성이라고 하는데 이러한 과정을 실행하도록 하는 힌트이다.
--/*+ NOREWRITE*/ QUERY_REWRITE_ENABLED 파라미터가 TRUE이더라도 쿼리 재생성을 하지 않도록 유도
--/*+ STAR__TRANSFORMATION*/ 스타 변형 JOIN을 수행하도록 요구
--/*+ FACT*/ 스타 변형 구문에서 해당 테이블이 FACT 테이블로 사용되도록 유도
--/*+ NO_FACT*/ 스타 변형 JOIN에서 팩트 테이블을 지정
--/*+ UNNEST*/ 서브쿼리 블록에 대한 인증성 검사
--/*+ NO_UNNEST*/ 서브쿼리와 메인쿼리를 합쳐 JOIN 형태로 변형
--/*+ APPEND*/ INSERT문에 사용 'DIRECT-PATH' 방식으로 수행 SGA를 거치지 않고 직접 저장공간에 입력
--/*+ CACHE*/ FULL 테이블 스캔 사용 시 테이블에서 읽어온 블록을 버퍼의 LRU 리스트의 MRU쪽에 위치 시킨다.
--/*+ NOCACHE*/ 메모리에 상주
--/*+ CADINALITY(T 9999)*/ 카디날리티의 예상 값을 제시
--/*+ CURSOR_SHARING_EXACT*/ CURSOR_SHARING 파라미터를 EXACT로 지정한 것과 동일
--/*+ DRIVING_SITE*/ 로컬테이블과 원격테이블 JOIN시 힌트로 주어진 테이블을 먼저 처리함
--/*+ DYNAMIC_SAMPLING*/ 통계 정보가 없을 시
--/*+ PUSH_PRED*/ JOIN 조건 컬럼(결합 인덱스의 컬럼)을 뷰 안으로 병합, 결과값에 대한 조인 방식 서술의 강제적 수행을 실행
--/*+ PUSH_SUBQ*/ MERGE 되지 않은 서브쿼리를 최대한 먼저 수행할 수 있도록 실행 계획을 수립
--/*+ QB_NAME*/ 쿼리 블록에 이름을 부여하여 해당 쿼리 블록 외부의 다른 힌트에서 지정한 쿼리 블록을 참조할 수 있도록 하는 힌트
--/*+ REWRITE_ON_ERROR*/ 적합한 실체뷰가 존재하지 않아서 옵티마이저가 쿼리 재생성을 실행할 수 없는 경우
--만약 이 힌트가 지정되어 있으면 ORA-30393 에러를 유발하여 쿼리 수행을 중단시키도록 하는 힌트
--/*+ INLINE*/ WITH절을 WITH절이 아닌 TEMP영역에 담지 않고 서브쿼리로 바꾸겠다는 의미
--/*+ IGNORE_ROW_ON_DUPKEY_INDEX(A.PK_EMP)*/ SINGLE INSERT문에서 사용되고 중복키가 발생하면 중복되지 않은 ROW만 입력할 수 있다.
--/*+ NO_QUERY_TRANSFORMATION*/ 옵티마이저 스스로 SQL을 변경해서 튜닝하는 작업을 하지 못하게 선언

--3.3.4 HINT의 사용
--간단한 SELECT, UPDATE, DELETE SQL 문장에 적용할 수 있다.
--MAIN SQL문이나 서브쿼리에 별도로 힌트 적용 가능하다. 그렇기 때문에 MAINSQL문에 있는 힌트는 첫번째 옵티마이저에만 적용된다.
--옵티마이저가 사용자가 지정한 HINT를 100% 받아들이진 않고, 자체적인 판단으로 사용
--대소문자 구분 없이 사용
--지정 테이블이 ALIAS를 사용한다면,  ALIAS로 힌트 사용해야 한다.
--여러 개의 힌트를 한번에 사용가능
--오라클은 서로 충돌되는 힌트는 실행하지 않는다.