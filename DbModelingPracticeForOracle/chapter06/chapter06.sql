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