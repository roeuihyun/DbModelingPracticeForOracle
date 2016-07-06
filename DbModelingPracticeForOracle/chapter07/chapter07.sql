--CHAPTER07
--DB OBJECT

--1.1. CHAR 
--1.1.1. 특성
--타입 : 문자열
--최대길이 : 2000 BYTE
--설명 : 고정 길이기 때문에 홍길동을 입력하면 홍길동 뒤에 94 BYTE만큼 SPACE가 채워진다.
--[PAGE265][CHAR의 길이를 체크]
SELECT DT_CHAR, RTRIM(DT_CHAR) FROM DATA_TYPE
UNION ALL
SELECT TO_CHAR(LENGTHB(DT_CHAR)), TO_CHAR(LENGTHB(RTRIM(DT_CHAR))) FROM DATA_TYPE;


--1.2. VARCHAR 
--1.2.1. 특성
--타입 : 문자열
--최대길이 : 4000 BYTE
--설명 : 가변 길이기 때문에 홍길동을 입력하면 홍길동만 입력되어 6 BYTE만 차지하게된다.
--[PAGE266][VARCHAR2의 길이를 체크]
SELECT DT_VARCHAR2, TRIM(DT_VARCHAR2) FROM DATA_TYPE
UNION ALL
SELECT TO_CHAR(LENGTHB(DT_VARCHAR2)), TO_CHAR(LENGTHB(TRIM(DT_VARCHAR2))) FROM DATA_TYPE;

--[PAGE267][같은 타입(CHAR)의 조인]
SELECT T1.DT_SEQ
       ,T1.DT_CHAR
       ,T1.DT_VARCHAR2
       ,T1.DT_NUMBER_1
       ,T1.DT_NUMBER_2
       ,T1.DT_DATE
FROM DATA_TYPE T1
     ,DATA_TYPE T2
WHERE T1.DT_SEQ = T2.DT_SEQ
AND T1.DT_CHAR = T2.DT_CHAR;

--[PAGE268][다른 타입(CHAR)의 조인]
SELECT T1.DT_SEQ
       ,T1.DT_CHAR
       ,T1.DT_VARCHAR2
       ,T1.DT_NUMBER_1
       ,T1.DT_NUMBER_2
       ,T1.DT_DATE
FROM DATA_TYPE T1
     ,DATA_TYPE T2
WHERE T1.DT_SEQ = T2.DT_SEQ
AND T1.DT_CHAR = T2.DT_VARCHAR2;

--1.3. NUMBER
--1.3.1. 특성
--타입 : 숫자
--최대길이 : 10^-38 ~ 10^38 /  21 BYTE
--설명 : NUMBER(정밀도, 배율)
--정밀도 : 소수점 좌,우의 숫자의 길이를 포함한 전체 자리수
--배율 : 소수점 이하의 자리수

--[PAGE270][NUMBER의 길이 체크]
UPDATE DATA_TYPE 
SET DT_NUMBER_1 = 123456789012345678901234567890.12345678901234567890123456789
    ,DT_NUMBER_2 =1234567.99
WHERE DT_SEQ = '01';

UPDATE DATA_TYPE 
SET DT_NUMBER_1 = -123456789012345678901234567890.12345678901234567890123456789
    ,DT_NUMBER_2 = -1234567.99
WHERE DT_SEQ = '02';

SELECT DT_SEQ
       ,DT_CHAR
       ,DT_VARCHAR2
       ,DT_NUMBER_1
       ,VSIZE(DT_NUMBER_1)||' BYTE' AS "크기"
       ,DT_NUMBER_2
FROM DATA_TYPE;

--1.4. DATE
--1.4.1. 특성
--타입 : 날짜
--최대길이 : BC 4712년 1월 1일 ~ 9999년 12월 32일 / 7 BYTE
--설명 : DATE형은 숫자로 구성되어 있기 때문에 SYSDATE -7같은 연산이 가능하다. 그러나 DATE -DATE는 사용할 수 없다.

--[PAGE271][DATE 타입 조회]
SELECT VSIZE(DT_DATE)||' BYTE' AS "크기"
       ,TO_CHAR(DT_DATE,'YYYY/MM/DD') AS "년월일"
       ,TO_CHAR(DT_DATE,'YYYY/MM/DD HH24:MI:SS') AS "년월일시분초"
       ,DT_DATE
       ,SYSDATE - 7
FROM DATA_TYPE;

--1.4.2. LAST_DAY(DATE) 함수  해당 월의 마지막 일자를 리턴한다.
--[PAGE272][LAST_DAY 함수 사용]
SELECT LAST_DAY(SYSDATE)
FROM DUAL;

--1.4.3. TO_CHAR(DATE,['FORMAT']) 함수 FORMAT에 맞게 문자열 형식으로 리턴한다.
--[PAGE272][TO_CHAR 함수 사용]
SELECT TO_CHAR(SYSDATE,'YYYY/MM/DD HH24:MI:SS')
FROM DUAL;

--1.4.4. TO_DATE(CHAR,['FORMAT']) 함수 FORMAT에 맞게 DATE 형식으로 리턴한다.
--[PAGE272][TO_DATE 함수 사용]
SELECT TO_DATE('20100503 09:59:25','YYYYMMDD HH24:MI:SS')
FROM DUAL;

--1.4.5. ADD_MONTHS(DATE,NUMBER) 함수 숫자 값만큼 월을 더하여 리턴한다.
--[PAGE273][TO_DATE 함수 사용]
SELECT ADD_MONTHS(SYSDATE, 1)
FROM DUAL;

--1.4.6 MONTHS_BETWEEN(DATE,DATE) 함수 두 일자의 개월 차이를 리턴한다.
--[PAGE273][MONTHS_BETWEEN 함수 사용]
SELECT MONTHS_BETWEEN(SYSDATE, SYSDATE - 30)
FROM DUAL;

--1.4.7 NEXT_DAY(DATE,NUMBER) 함수 DATE 날짜 후 해당하는 요일 (1=일요일 ~ 7=토요일)을 DATE형으로 반환한다.
--[PAGE274][NEXT_DAY 함수 사용]
SELECT NEXT_DAY(SYSDATE, 7)
FROM DUAL;

--1.5. TIMESTAMP
--1.5.1 특성
--타입 : 날짜
--최대길이 : 년,월,일,시,분,초 MILLISECOND(9) 까지 / 7 BYTE ~ 11 BYTE
--설명 : MILLISECOND 시간을 구하기 위해서는 TIMESTAMP 형식을 사용하여 밀리초의 정밀도는 0~9까지 올 수 있으며 디폴트는 6이다.
--[PAGE274][TIMESTAMP 타입 조회]
SELECT T1.DT_SEQ
       ,TO_CHAR(T1.DT_TIMESTAMP,'YYYYMMDD HH24:MI:SS:FF') AS EX1
       ,TO_CHAR(T1.DT_TIMESTAMP,'YYYYMMDDHH24MISSFF3') AS EX2
       ,VSIZE(T1.DT_TIMESTAMP)||' BYTE' AS BYTE
       ,T1.DT_DATE
FROM DATA_TYPE T1;

--1.6. 기타 데이터 타입
--1.6.1 특성
--타입 : 날짜
--최대길이 : 년,월,일,시,분,초 MILLISECOND(9) 까지 / 7 BYTE ~ 11 BYTE
--설명 : MILLISECOND 시간을 구하기 위해서는 TIMESTAMP 형식을 사용하여 밀리초의 정밀도는 0~9까지 올 수 있으며 디폴트는 6이다.
--형태     타입           최대길이   설명
--LONG     문자열         2GB        가변 길이
--RAW      바이트 문자열  2GB        가변 길이
--LONG RAW 이진 문자열    2GB        오라클에 의해서 변환될 수 없는 데이터 저장
--BLOB     이진 데이터    4GB        구조화되지 않는 데이터
--CLOB     문자 데이터    4GB        구조화되지 않는 데이터
--NCLOB    문자 데이터    4GB        다국적 언어 지원
--BFILE    이진 데이터    4GB        데이터베이스 외부에 데이터를 저장함


--2. 프로시저(PROCEDURE)
--2.1. 프로시저 일반
--[PAGE277][프로시저 생성 예제]
CREATE OR REPLACE PROCEDURE SALARY_INC(V_SABUN IN VARCHAR2)
IS
BEGIN
      UPDATE INSA
      SET SALARY = SALARY * 1.03
      WHERE SABUN = V_SABUN;
COMMIT;
EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('REGISTER IS FAILED');
      ROLLBACK;
END;
--실행
EXEC SALARY_INC('2013032104');

--<예제> 새로 입사한 사원의 정보를 입력하는 프로시저를 만드는데 사원 번호는 등록 날짜를 기준으로 UNIQUE한 번호를 
--자동 부여하고 이름과 입사일, 직원 구분 코드는 입력 받는다.
--(직원 구분 코드 : 정직원 - RGL/ 계약직 -CNT/ 프리랜서 - FRE)
--[PAGE278][프로시저 생성 예제]
CREATE OR REPLACE PROCEDURE IN_SA(V_NAME IN VARCHAR2, V_RGL IN VARCHAR2)
IS
V_SABUN INSA.SABUN %TYPE;
BEGIN
INSERT INTO INSA(SABUN, NAME, JOIN_GBN_CODE, JOIN_DAY)
VALUES( 
        (SELECT /*+ INDEX_DESC(INSA INSA_PK)*/
         DECODE(SUBSTR(SABUN,1,8)
         ,TO_CHAR(SYSDATE,'YYYYMMDD')
         ,SABUN + 1
         ,TO_CHAR(SYSDATE,'YYYYMMDD')||'01'
         FROM INSA
         WHERE SABUN < TO_CHAR(SYSDATE,'YYYYMMDD')||'99'
         AND ROWNUM = 1),
         V_NAME, V_RGL, TO_CHAR(SYSDATE,'YYYYMMDD'))
      );
COMMIT;
EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('FAIL!');
      ROLLBACK;
END;
--[PAGE279][프로시저 실행]
EXEC IN_SA('김민기','RGL');

SELECT SABUN
       ,NAME
       ,JOIN_GBN_CODE
       ,JOIN_DAY
FROM INSA
ORDER BY SABUN DESC; 

--<예제>사번을 입력 받아 직원의 이름과 직급 그리고 입사일로부터 근무한 월 수를 확인하시오
--[PAGE280][OUT 변수를 이용하는 프로시저 생성]
CREATE OR REPLACE PROCEDURE workPm
(V_SABUN IN INSA.SABUN%TYPE,
V_NAME OUT INSA.ENG_NAME %TYPE,
V_CDNAME OUT CMM_CODE_DETAIL.CODE_NAME%TYPE,
V_M OUT INSA.JOIN_DAY%TYPE)
IS
BEGIN

SELECT T1.ENG_NAME
       ,T2.CODE_NAME
       ,ROUND(MONTHS_BETWEEN(SYSDATE,TO_DATE(JOIN_DAY,'YYYYMMDD'))) AS MON_WORK
INTO V_NAME, V_CDNAME, V_M
FROM INSA T1, CMM_CODE_DETAIL T2
WHERE T1.POS_GBN_CODE = T2.CODE_NO
AND T1.SABUN = V_SABUN;

DBMS_OUTPUT.PUT_LINE(V_NAME||'--'||V_CDNAME||'--'||V_M);

EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('조회하려는 사번이 존재하지 않음!');

END workPm;

--[PAGE281][익명 블록 PL/SQL 생성]
DECLARE
V_NAME INSA.ENG_NAME%TYPE;
V_CDNAME CMM_CODE_DETAIL.CODE_NAME%TYPE;
V_M INSA.JOIN_DAY%TYPE;
BEGIN

workPm('2012010119',V_NAME, V_CDNAME, V_M);
DBMS_OUTPUT.PUT_LINE('이름: '||V_NAME||' 직급: '||V_CDNAME||' 근무월수: '||V_M||' 개월');

END;

--[PAGE282][프로시저 확인]
SELECT *
FROM USER_PROCEDURES;

--[PAGE282][생성된 PL/SQL 객체 내용 조회]
SELECT *
FROM USER_SOURCE;

--[PAGE283][프로시저 삭제]
DROP PROCEDURE 프로시저명;


--3. 트리거(TRIGGER)
--3.1. 트리거 일반
--3.1.1. 트리거 사용목적
--데이터베이스 테이블 생성하는 과정에서 참조 무결성과 데이터 무결성 등의 복잡한 제약 조건을 생성하는 경우
--데이터베이스 테이블의 데이터에 생기는 작업의 감시, 보완
--데이터베이스 테이블에 생기는 변화에 따라 다른 프로그램을 실행하는 경우
--불필요한 트랜잭션을 금지하기 위해
--컬럼의 값을 자동으로 생성되도록 하는 경우
--복잡한 뷰를 생성하는 경우

--[PAGE291][트리거의 기본 형식]
CREATE TRIGGER 트리거명
BEFORE | AFTER INSTERT | DELETE | UPDATE (OF 컬럼...N)
ON 테이블명
FOR EACH ROW
WHEN :OLD OR :NEW.COLUMN..
BEGIN
  트리거의 내용
END;

--3.1.2. 트리거 사용 예제
--[PAGE292][트리거 생성 예]
CREATE OR REPLACE TRIGGER CHK_TRIG
BEFORE UPDATE
ON INSA
BEGIN
DBMS_OUTPUT.PUT_LINE('요청하신 작업이 처리 되었습니다.');
END;

--[PAGE292][트리거 실행 예]
UPDATE INSA SET SALARY = 2800 WHERE SABUN = '20130111103';

--[PAGE293][UPDATE 이벤트 결과 확인]
SELECT SABUN
       ,SALARY
FROM INSA
WHERE SABUN = '2013011103';

--[PAGE293][CHK_ROW 백업 테이블 생성]
CREATE TABLE CHK_ROW(
SEQ_NO NUMBER,          -- 백업 순번
TIME_IN DATE,           -- 백업 시간
SABUN VARCHAR2(10),     -- 백업 대상 사번
ENG_NAME VARCHAR2(20),  -- 백업 대상 이름
COL_NAME VARCHAR2(10),  -- 변경된 항목
O_DATA VARCHAR2(10),    -- 변경 전 데이터
N_DATA VARCHAR2(10)     -- 변경 후 데이터
);

--[PAGE294][CHK_ROW_UDP 트리거 생성]
CREATE OR REPLACE TRIGGER CHK_ROW_UDP
BEFORE UPDATE OF SALARY
ON INSA
FOR EACH ROW
BEGIN
