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
INSERT INTO CHK_ROW (SEQ_NO, TIME_IN, SABUN, ENG_NAME, COL_NAME, O_DATA, N_DATA)
VALUES
(
  (SELECT /*+ INDEX_DESC(CHK_ROW CHK_ROW_PK)*/
        DECODE(MAX(SEQ_NO),NULL,1,MAX(SEQ_NO+1))
  FROM CHK_ROW),
  SYSDATE
  ,:OLD.SABUN
  ,:OLD.ENG_NAME
  ,'SALARY'
  ,:OLD.SALARY
  ,:NEW.SALARY
);
DBMS_OUTPUT.PUT_LINE(:OLD.ENG_NAME || '님의 급여 정보가 변경되었습니다.');
DBMS_OUTPUT.PUT_LINE('수정 전 금액' || :OLD.SALARY);
DBMS_OUTPUT.PUT_LINE('수정 후 금액' || :NEW.SALARY);
END;
/

--[PAGE295][CHK_ROW_UDP 트리거 동작을 위한 UPDATE 실행문]
UPDATE INSA
SET SALARY = 3550
WHERE ROWID IN (SELECT ROWID
                FROM INSA
                WHERE JOIN_DAY LIKE '2002%'
                AND JOIN_GBN_CODE = 'RGL');

--[PAGE296][트리거 삭제 기본형식]
DROP TRIGGER 트리거명
ALTER TRIGGER 트리거명 [ENABLE /DISABLE]

--3.2. 트리거 사용 시 주의사항
--[PAGE297][트리거의 상태를 점검하는 SQL]
SELECT A.OWNER
       ,A.TRIGGER_NAME
       ,B.STATUS
FROM ALL_TRIGGERS A
     ,ALL_OBJECTS B
WHERE A.TRIGGER_NAME = B.OBJECT_NAME
AND A.OWNER = 'INSA'
AND TRIGGER_NAME = 'CHK_ROW_UDP';

--[PAGE298][CHK_ROW 테이블 조회]
SELECT *
FROM CHK_ROW;

--[PAGE298][INSA 테이블 컬럼변경]
ALTER TABLE INSA RENAME COLUMN SALARY TO SALARY_IMSI;

--위와같이 DDL로 인해 테이블 컬럼 변경 혹은 컬럼 추가가 되면 STATUS가 INVALID로 변경된다.

--[PAGE299][CHK_ROW_UDP 트리거 'DISABLE']
ALTER TRIGGER CHK_ROW_UDP DISABLE

--[PAGE299][INSA 테이블 UPDATE 실행]
UPDATE INSA
SET SALARY_IMSI = 99999999
WHERE SABUN = '210040101'

--[PAGE300][CHK_ROW 테이블의 조회]
SELECT *
FROM CHK_ROW;

--4. 함수(FUNCTION)
--4.1. 사용자 함수
--[PAGE301][함수 생성 기본형식]
CREATE OR REPLACE FUNCTION 함수명 (PARAMETER1 DATATYPE,...N)
RETURN DATATYPE
IS
-변수 선언 부-;
BEGIN
-처리내용(PL/SQL BLOCK)-;
RETURN;
END;

--CREATE OR REPLACE FUNCTION : 새롭게 함수를 생성하거나 기존에 작성된 함수를 수정
--함수명 : 생성할 함수의 이름을 정한다.
--PARAMETER : 함수의 파라미터로 입력되는 변수명과 데이터 타입을 명시한다.
--변수 선언 부 : 내부에서 사용할 변수를 명시한다.
--BEGIN
--처리내용 : 함수가 수행할 내용을 명시한 부분
--RETURN : 함수가 반환할 값을 명시한다.
--END

--<예제> 공통 코드 관리에서 마스터 코드와 상세코드를 입력 받아 해당하는 코드명을 출력하는 함수를 작성하시오.
--[PAGE302][FUNCTION 생성 예제]
CREATE OR REPLACE FUNCTION LEEOK.GET_CMM_CODE_NAME(
V_CLASS_CODE IN CMM_CODE_DETAIL.CLASS_CODE%TYPE,
V_CODE_NO IN CMM_CODE_DETAIL.CODE_NO%TYPE)
RETURN VARCHAR2
IS
V_CMM_CODE_NAME CMM_CODE_DETAIL.CODE_NAME%TYPE

BEGIN

SELECT CODE_NAME
INTO V_CMM_CODE_NAME
FROM CMM_CODE_DETAIL
WHERE CODE_NO = V_CODE_NO
AND CLASS_CODE = V_CLASS_CODE;

RETURN V_CMM_CODE_NAME;
EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('입력한 코드는 없습니다.');
        RETURN V_CMM_CODE_NAME; 
      WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('자료가 두건 이상입니다.');
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('기타 에러입니다.');
END;

--[PAGE303][FUNCTION 사용 예제]
SELECT GET_CMM_CODE_NAME('H01','A06') AS 응시결과
FROM DUAL;

--[PAGE304][EXCEPTION 처리]
SELECT GET_CMM_CODE_NAME('H01','A09') AS 응시결과
FROM DUAL;

--<예제> 직원 구분 코드를 입력 받아 해당하는 그룹별 남,녀 인원수와 총합을 조회하는 함수를 만드시오.
--[PAGE304][FUNCTION 사용의 예]
CREATE OR REPLACE FUNCTION SAWON_COUNT
(V_GBN_CODE INSA.JOIN_GBN_CODE%TYPE)
RETURN VARCHAR2
IS

V_M NUMBER;
V_F NUMBER;
V_T NUMBER;
V_ALL VARCHAR2(30);

BEGIN

V_M := 0;
V_F := 0;
V_T := 0;

SELECT COUNT(DECODE(SEX,'M',1)) AS MEN
       ,COUNT(DECODE(SEX,'F',1)) AS WOMEN
       ,COUNT(SEX) AS TOT
INTO V_M, V_F, V_T
FROM INSA
WHERE JOIN_GBN_CODE = V_GBN_CODE;
DBMS_OUTPUT.PUT_LINE('남:'||V_M||' 여:'||V_F||' 토탈:'||V_T);
V_ALL :='남:'||V_M||' 여:'||V_F||' 토탈:'||V_T;
DBMS_OUTPUT.PUT_LINE('V_ALL에 담겨져 잇는 값은 : ' || V_ALL);
RETURN V_ALL;
END;

--[PAGE306][SAWON COUNT 함수 실행]
SELECT SAWON_COUNT('RGL') AS 인원구성
FROM DUAL;

--4.1.1. 사용자 정의 함수 사용시 주의사항
--복잡한 계산식이나 어려운 로직을 포함하는 경우 함수로 정의하여 사용
--사용자 정의 함수에서 대량의 데이터를 조회하여 결과값을 리턴하는 방법은 사용하지 말자
--오라클 내장 함수와 사용자 정의 함수는 속도의 차이가 많이 나므로 내장함수의 모든 기능을 숙지하고 내장함수를 많이 사용하는것이 좋다.
--테이블의 JOIN 으로 가능한 것을 함수로 만들어 사용하지 말자.
--주로 SELECT 절에 사용을 하고 WHERE 절에 사용하는것을 자제하자.

--4.2. 오라클 내장 함수
--4.2.1. 숫자형 함수
--[PAGE307][ABS 함수 사용 예] ABS 함수는 절대값을 뽑아 내는 함수이다.
SELECT ABS(-27)
FROM DUAL;

--[PAGE307][SIGN 함수 사용 예] SIGN 함수는 양수는 1 음수는 -1 0은 0으로 리턴한다.
SELECT SIGN(-10), SIGN(44), SIGN(0)
FROM DUAL;

--[PAGE308][ROUND 함수 사용 예] ROUND 함수는 숫자를 지정한 자리에서 반올림 처리하는 함수이다.
SELECT ROUND(125.198,2)
FROM DUAL;

--[PAGE308][TRUNC 함수 사용 예] TRUNC 함수는 숫자를 지정한 자리에서 절삭 처리하는 함수이다.
SELECT TRUNC(125.198,2)
FROM DUAL;

--[PAGE308][MOD 함수 사용 예] MOD 함수는 좌측에 있는 값을 우측에 있는 값으로 나눈 나머지를 반환하는 함수이다.
SELECT MOD(15,4)
FROM DUAL;

--[PAGE308][POWER 함수 사용 예] POWER 함수는 거듭제곱을 구하는 함수이다.
SELECT POWER(4,2)
FROM DUAL;

--[PAGE308][SQRT 함수 사용 예] SQRT 함수는 제곱근을 구하는 함수이다.
SELECT SQRT(9)
FROM DUAL;

--[PAGE309][CHR 함수 사용 예] CHR 함수는 ASCII 코드 값에 해당하는 문자를 확인하는 함수이다.
SELECT CHR(88)
FROM DUAL;

--[PAGE309][TO_NUMBER 함수 사용 예] TO_NUMBER 함수는 문자열로 입력된 숫자를 숫자 타입으로 변환한다.
SELECT TO_NUMBER('508')
FROM DUAL;

--4.2.2. 문자형 함수
--[PAGE309][LOWER 함수 사용 예] LOWER 함수는 대소문자가 혼합되어 있거나 대문자인 문자열을 소문자로 변환한다.
SELECT LOWER('KING')
FROM DUAL;

--[PAGE309][CONCAT 함수 사용 예] CONCAT 함수는 두 문자열을 연결하여 결과를 반환하는 함수로 CONCAT 대신에 '||'표시로도 대체할 수 있다.
SELECT CONCAT('KO','REA')
FROM DUAL;

--[PAGE310][LTRIM 함수 사용 예] LTRIM 함수는 넘어온 파라미터 값 CHAR 에서 SET의 의 값을 왼쪽에서 제거한 값을 반환하는 함수이다.
SELECT LTRIM('##2013년','#')
FROM DUAL;

--[PAGE310][RTRIM 함수 사용 예] RTRIM 함수는 넘어온 파라미터 값 CHAR 에서 SET의 의 값을 오른쪽에서 제거한 값을 반환하는 함수이다.
SELECT RTRIM('##2013년','년')
FROM DUAL;

--[PAGE310][INITCAP 함수 사용 예] INITCAP 함수는 첫 문자를 대문자로 바꾸고 나머지는 소문자로 변환하는 함수이다.
SELECT INITCAP('KOREA') AS NATION
FROM DUAL;

--[PAGE310][SUBSTR 함수 사용 예] SUBSTR 함수는 CHAR에서 POSITION 위치부터 LENGTH 길이까지 문자열을 잘라내서 반환하는 함수이다.
SELECT SUBSTR('KOREA',1,3) AS NATION
FROM DUAL;

--[PAGE311][LPAD 함수 사용 예] LPAD 함수는 가운데 길이만큼 왼쪽으로 늘려서 반환하는 함수이다.
SELECT LPAD('KOREA',7,$)
FROM DUAL;

--[PAGE311][RPAD 함수 사용 예] RPAD 함수는 가운데 길이만큼 오른쪽으로 늘려서 반환하는 함수이다.
SELECT RPAD('KOREA',7,$)
FROM DUAL;

--[PAGE311][REPLACE 함수 사용 예] REPLACE 함수는 입력한 문자열을 검색하여 변환 하여 반환해주는 함수이다.
SELECT REPLACE('KOREA','A','AN')
FROM DUAL;

--[PAGE311][ASCII 함수 사용 예] ASCII 함수는 입력한 CHAR를 아스키 코드값으로 변환하는 함수이다.
SELECT ASCII('K')
FROM DUAL;

--[PAGE312][LENGTH 함수 사용 예] LENGTH 함수는 입력한 CHAR의 문자열 길이를 반환하는 함수이다.
SELECT LENGTH('DRAGON')
FROM DUAL;

--[PAGE312][TO_CHAR 함수 사용 예] TO_CHAR 함수는 숫자나 문자값을 지정한 형식의 VARCHAR2문자열로 변환하는 함수이다.
SELECT TO_CHAR(SYSDATE,'YY-MM-DD-DY') AS DAY
FROM DUAL;

--[PAGE312][숫자 타입의 데이터 형 변환] 숫자 타입의 데이터를 문자 데이터로 변환할 때 사용된다.
SELECT TO_CHAR(SALARY,'$99,999')
FROM DUAL;

--[PAGE312][INSTR 함수 사용 예] INSTR FULL CHAR에서 찾고자 하는 CHAR의 위치를 찾아내 주는 함수이다.
SELECT INSTR('ABCDABBBCD','B','3','2') AS SEARCH_B
FROM DUAL;

--4.2.3. 날짜형 함수
--[PAGE314][SYSDATE 사용 예] SYSDATE 파라미터값이 없고 현재 날짜와 시간을 반환하는 함수이다.
SELECT SYSDATE
FROM DUAL;

--[PAGE314][LAST_DAY 함수 사용 예] LAST_DAY 해당하는 월의 마지막 날짜를 반환하는 함수이다.
SELECT LAST_DAY(TO_DATE('20130214','YYYYMMDD'))
FROM DUAL;

--[PAGE314][MONTHS_BETWEEN 함수 사용 예] MONTHS_BETWEEN DATE1과 DATE2 사이의 달수를 반환하는 함수이다.
SELECT MONTHS_BETWEEN(TO_DATE('20130201','YYYYMMDD')
                      ,TO_DATE('20130101','YYYYMMDD')) MONTH
FROM DUAL;

--[PAGE315][TO_DATE 함수 사용 예] TO_DATE 문자 타입의 날짜 형식을 표현식에 따라 결과값을 반환하는 함수이다.
SELECT TO_DATE('20130214','YYYYMMDD')
FROM DUAL;

--[PAGE315][ADD_MONTH 함수 사용 예] ADD_MONTH 임의의 날짜에 지정한 개월수를 더해서 결과값을 반환하는 함수이다.
SELECT ADD_MONTH(TO_DATE('20130214','YYYYMMDD'),3)
FROM DUAL;

--[PAGE315][NEXT_DAY 함수 사용 예] NEXT_DAY 임의의 날짜에 지정한 개월수를 더해서 결과값을 반환하는 함수이다.
SELECT NEXT_DAY(TO_DATE('20130214','YYYYMMDD'),3)
FROM DUAL;

--4.2.4. 그 외 함수
--[PAGE316][NVL 함수 사용 예] NVL 컬럼에 값이 담겨져 있으면 담겨있는 값을 사용하고 NULL이면 대체값을 사용한다.
SELECT ROWNUM, T1.*
FROM (
      SELECT SABUN, ENG_NAME, ZIP, NVL(ZIP,'UNKNOWN') AS ZIPCODE
      FROM INSA
      WHERE JOIN_GBN_CODE = 'RGL'
      ) T1
WHERE ROWNUM <= 10;

--[PAGE317][DECODE 함수 사용 예] DECODE 함수는 컬럼값에 따라 원하는 값을 선택적으로 사용할 수 있다.
SELECT ROWNUM, T1.*
FROM (
      SELECT SABUN, ENG_NAME, JOIN_GBN_CODE
             ,DECODE(JOIN_GBN_CODE,'RGL','정직원','CMP','업체직원','CNT','계약직원','프리랜서') AS "직원형태"
      FROM INSA
      WHERE JOIN_GBN_CODE = 'RGL'
      ) T1
WHERE ROWNUM <= 10;

--[PAGE318][CASE 함수 사용 예] CASE 함수는 자바의 SWITCH문이나 IF~ELSE 문과 비슷한 표현 방법이다.
SELECT ROWNUM, T1.*
FROM (
      SELECT SABUN, ENG_NAME, SEX
             ,CASE SEX WHEN 'M' THEN '남'
                      WHEN 'F' THEN '여'
                      ELSE '모름'
             END AS 성별
      FROM INSA
      )T1
WHERE ROWNUM <= 7;

--5. 기타 Object
--5.1. VIEW
--[PAGE320][VIEW 생성 예]
CREATE VIEW V_INSA
      AS SELECT SABUN,NAME,ENG_NAME,CMP_REG_NO,JOIN_GBN_CODE
      FROM INSA
      WHERE JOIN_GBN_CODE = 'RGL';

SELECT SABUN,NAME,ENG_NAME,CMP_REG_NO,JOIN_GBN_CODE
FROM V_INSA;

--[PAGE321][두개 이상 테이블로 VIEW 생성 예제]
CREATE VIEW CP_INSA
AS 
SELECT I.SABUN, I.ENG_NAME, C.CMP_NAME, C.CMP_ZIP ZIPCODE, C.CMP_ADDR1 ADDR
FROM INSA I, INSA_COMPANY C
WHERE I.CMP_REG_NO = C.CMP_REG_NO(+);

SELECT * FROM CP_INSA;

--[PAGE322][기존 생성 VIEW 확인]
SELECT * FROM USER_VIEWS;

--[PAGE322][V_INSA VIEW를 이용한 INSERT]
INSERT INTO V_INSA(SABUN,NAME,ENG_NAME,JOIN_GBN_CODE)
VALUES('2013022803','박준형','JUNE','RGL');

--[PAGE323][V_INSA VIEW를 이용한 UPDATE]
UPDATE V_INSA SET
CMP_REG_NO = '2222222206'
WHERE SABUN = '2013022803';

--[PAGE323][V_INSA VIEW를 이용한 DELETE]
DELETE CP_INSA
WHERE SABUN = '2012010124';

--[PAGE324][VIEW 삭제]
DROP VIEW V_INSA;

--5.1.1. VIEW 사용시 주의사항
--조회시 복잡하게 추출해야 될 항목들을 VIEW로 만들어 사용자에게 편의성을 제공할 필요가 있을 시 사용한다.
--사용자는 조회하지 말아야 할 테이블이나 컬럼 등이 있을 때 VIEW로 따로 만들어서 만들어진 VIEW에 권한을 주어 조회할 수 있도록 할 때 사용한다.
--사용자들이 튜닝 하기 어려운 SQL 일때 미리 만들어서 제공한다.
--VIEW는 튜닝을 하였어도 원본 SQL과 합쳐지면서 PLAN을 새로 만들기 때문에 VIEW 생성 시 VIEW 문장이 다른 SQL과 결합되더라도
--수행계획이 바뀌지 않게 힌트나 GROUP BY등을 넣어 주어서 최대한 PLAN의 변동을 막을 수 있도록 생성하여 제공해야 된다.

--5.2. DATA DICTIONARY VIEW
--DICTIONARY VIEW에 따른 분류
--USER_ 사용자가 소유하고 있는 OBJECT와 관련된 모든 정보
--ALL_ 사용자가 접근 가능하게 허락된 OBJECT와 관련된 모든 정보
--DBA_ DBA권한을 가지고 있는 사용자가 접근할 수 있는 모든 정보
--V$_ 서버의 성능, 시스템 관련정보,메모리,락 등의 정보

--[PAGE327][DICTIONARY VIEW를 이용한 LOCK의 조회]
SELECT A.SID, A.SERIAL#
FROM V$SESSION A, V$LOCK B, DBA_OBJECTS C
WHERE A.SID = B.SID
AND B.ID1 = C.OBJECT_ID
AND B.TYPE = 'TM'
AND C.OBJECT_NAME = 'CMM_CODE_DETAIL';

--위의 SQL로 테이블 락을 조회하고 락이 발생된 세션을 다음 명령으로 삭제한다.
ALTER SYSTEM KILL SESSION 'SID번호,SERIAL#';