--CHAPTER11
--채번
--채번은 순번으로 PK를 생성하거나 특정 컬럼값을 정해줄 때 사용한다.

--1.DB Sequence
--오라클 객체 중 한 가지인 Sequence는 문자형이나 데이트 타입의 값이 아닌 숫자로 UNIQUE한, 즉 PK값으로 사용하기 위한 목적으로 만든다.
--Sequence는 테이블에 종속적이지 않고 별도로 Sequence Object를 만들고 사용자가 요청한 이벤트 발생과 동시에 채번이 발생하고 번호가 저장된다.

--[PAGE402][Sequence 생성 기본 형식]
CREATE SEQUENCE 시퀀스 이름
INCREMENT BY N
START WITH N
MINVALUE | NOMINVALUE
MAXVALUE | NOMAXVALUE
CACHE | NOCACHE
ORDER | NOORDER
CYCLE | NOCYCLE;

--INCREMENT BY : 시퀀스가 증가되는 값을 정수 N으로 지정.
--START WITH : 시퀀스의 최초 시작값 지정.
--MINVALUE : 시퀀스가 감소할 때 생성 가능한 최솟값 지정. 최소값 = 1
--NOMINVALUE : 시퀀스가 감소할 때 최소값을 지정하지 않는다. 
--MAXVALUE : 시퀀스가 증가할 때 생성 가능한 최대값 지정 최대값. 10^27
--NOMAXVALUE : 시퀀스가 증가할 때 끝나는 최대값을 지정하지 않는다.
--CACHE | NOCACHE : 오라클 서버가 미리 지정하고 메모리에 유지할 값의 수. 디폴트 20

--[PAGE403][Sequence 생성 예]
CREATE SEQUENCE INSA_SEQ
INCREMENT BY 3
START WITH 28
MINVALUE 1
MAXVALUE 33
NOCACHE
NOORDER
NOCYCLE;

--[PAGE403][Sequence 사용 예]
INSERT INTO INSA(SABUN, NAME, ENG_NAME, HP, JOIN_GBN_CODE)
VALUES(INSA_SEQ.NEXTVAL, '홍길동', 'HONG', '010-1234-5678','RGL');
INSERT INTO INSA(SABUN, NAME, ENG_NAME, HP, JOIN_GBN_CODE)
VALUES(INSA_SEQ.NEXTVAL, '이순신', 'LEGEND', '010-1234-1234','RGL');
SELECT ROWNUM
	   ,T1.*
FROM (SELECT SABUN
			 ,NAME
			 ,ENG_NAME
			 ,HP
			 ,JOIN_GBN_CODE
	  FROM INSA
	  WHERE JOIN_GBN_CODE = 'RGL'
	  ORDER BY SABUN DESC) T1
WHERE ROWNUM <= 2;

--[PAGE405][Sequence 사용 예]
CREATE TABLE INSA_1(
	SEQ_NO NUMBER CONSTRAINT TEST_SEQ_NN NOT NULL,
	SABUN VARCHAR2(10),
	JOIN_DAY DATE,
	CONSTRAINT INSA1_PK PRIMARY KEY (SABUN)
);

CREATE SEQUENCE INSA_SEQ1
MINVALUE 1
MAXVALUE 10
INCREMENT BY 2
START WITH 2
CYCLE;

INSERT INTO TEST_SEQ VALUES (INSA_SEQ1.NEXTVAL, :SABUN, SYSDATE);

--1.1. SEQUENCE 수정
--[PAGE406][Sequence 수정 기본 형식]
ALTER SEQUENCE SEQUENCE_NAME
수정값;

--[PAGE406][INSA_SEQ 수정]
ALTER SEQUENCE INSA_SEQ
INCREMENT BY 2
MAXVALUE 9999999999;

--[PAGE406][INSA_SEQ 수정 후 적용]
INSERT INTO INSA
(SABUN, NAME, ENG_NAME, HP, JOIN_GBN_CODE)
VALUES
(INSA_SEQ.NEXTVAL, '박준형', 'LIM', '010-1111-2222','RGL');

--만약 시작값을 수정해야 한다면 SEQUENCE를 삭제하고 처음부터 다시 생성하고 적용해야 한다.
--처음 설정 때부터 충분히 고려해서 SEQUENCE를 만들어야 한다.

--1.2. SEQUENCE 삭제
--[PAGE407][Sequence 삭제]
DROP SEQUENCE SEQUENCE_NAME;
DROP SEQUENCE INSA_SEQ;

--1.3. SEQUENCE 확인
--[PAGE407][Sequence 확인]
SELECT *
FROM USER_SEQUENCES;

--시퀀스의 경우 중간에 건너뛰는 번호가 존재하면 안된다고 하면 사용하기 힘든 방법이다.

--2. 채번 테이블 사용
--채번 테이블 사용은 해당하는 테이블의 PK값을 숫자 형식으로 증가하여 중복이 발생하지 않고 여러 테이블의 발번을
--하나의 테이블로 관리하는 방법이다.

--2.1. 채번 테이블의 생성
--[PAGE408][채번 테이블 생성]
CREATE TABLE NUMSEQ(
	TAB_NO VARCHAR2(10) PRIMARY KEY,
	SEQ NUMBER
);

--먼저 채번 테이블을 생성한다. 2개의 컬럼으로 채번 테이블을 구성하는데 TAB_NO컬럼은 채번 테이블의 PK 컬럼으로서
--각각의 채번 대상 테이블을 구분하는 역할을 한다. SEQ 컬럼은 각 테이블의 MAX 값을 담아두는 컬럼으로 NUNMBER 이다.

--[PAGE409][채번 대상 테이블 생성]
CREATE TABLE TEST_1(
	NO VARCHAR2(10) PRIMARY KEY
);

--[PAGE409][채번 테이블 초기화]
INSERT INTO NUMSEQ VALUES('TEST_1',0);

--2.2. 채번 테이블의 사용
--[PAGE409][채번 대상 테이블 INSERT]
INSERT INTO TEST_1(NO)
VALUES((SELECT SEQ + 1 
		FROM NUMSEQ
		WHERE TAB_NO = 'TEST_1'));

--[PAGE410][채번 테이블 UPDATE]
UPDATE NUMSEQ SET 
SEQ = SEQ + 1;

--[PAGE410][채번 테이블 UPDATE]
--TAB01_INSA TABLE 
CREATE TABLE TAB01_INSA(
	SABUN VARCHAR2(10) PRIMARY KEY,
	NAME VARCHAR2(100),
	JOIN_DAY VARCHAR2(8),
	JOIN_GBN_CODE VARCHAR2(3)
);

--TAB05_PRODUCT TABLE
CREATE TABLE TAB05_PRODUCT(
	P_NO VARCHAR2(15) PRIMARY KEY,
	P_CODE VARCHAR2(3),
	P_COLOR VARCHAR2(4),
	P_NAME VARCHAR2(10),
	P_PROD_D VARCHAR2(8)
);

--[PAGE411][NUMSEQ 채번 테이블 초기화]
INSERT INTO NUMSEQ
VALUES('TAB01',(SELECT TO_CHAR(SYSDATE,'YYYYMMDD')||'00' FROM DUAL));
INSERT INTO NUMSEQ VALUES('TAB05',0);

--[PAGE411][두개 테이블 데이터 입력]
INSERT INTO TAB01_INSA(SABUN, NAME, JOIN_DAY, JOIN_GBN_CODE)
VALUES((SELECT DECODE(SUBSTR(MAX(SEQ),1,8)
			   ,TO_CHAR(SYSDATE,'YYYYMMDD')
			   ,MAX(SEQ)+1
			   ,TO_CHAR(SYSDATE,'YYYYMMDD')||'01' )
		FROM NUMSEQ
		WHERE TAB_NO = 'TAB01'
		AND SEQ < TO_CHAR(SYSDATE,'YYYYMMDD')||'99'),
	   :NAME, TO_CHAR(SYSDATE,'YYYYMMDD'), :JOIN_GBN_CODE);

INSERT INTO TAB05_PRODUCT(P_NO, P_CODE, P_COLOR, P_NAME, P_PROD_D)
VALUES((SELECT :CODE||:COLOR||:P_KIND||(SELECT SEQ + 1
										FROM NUMSEQ
										WHERE TAB_NO = 'TAB05')
		FROM DUAL),
	  :P_CODE, :P_COLOR, :P_NAME, :TO_CHAR(SYSDATE,'YYYYMMDD'));

--[PAGE412][채번 대상 테이블의 채번 값을 채번 테이블에 갱신]
UPDATE NUMSEQ SET 
SEQ = ((SELECT DECODE(SUBSTR(MAX(SEQ),1,8)
			   ,TO_CHAR(SYSDATE,'YYYYMMDD')
			   ,MAX(SEQ)+1
			   ,TO_CHAR(SYSDATE,'YYYYMMDD')||'01')
		FROM NUMSEQ
		WHERE SEQ < TO_CHAR(SYSDATE,'YYYYMMDD')||'99'))
WHERE TAB_NO = 'TAB01';

UPDATE NUMSEQ SET
SEQ = SEQ + 1
WHERE TAB_NO = 'TAB05';

--[PAGE412][각 테이블의 데이터 확인]
SELECT * FROM NUMSEQ;
SELECT * FROM TAB01_INSA;
SELECT * FROM TAB05_PRODUCT;

--2.3. 채번 테이블 사용시 문제점
--채번 테이블은 트랜젝션단위로 사용을 잘 해야지 중복에러를 발생시키지 않고 사용할 수 있다.

--3. INDEX 사용
--UNIQUE INDEX를 이용한 채번 방법

--3.1. INDEX를 이용한 채번
--INDEX를이용한 채번은 OBJECT를 사용하지 않고 자신의 테이블을 사용한다.
--[PAGE416][채번 테이블 생성]
CREATE TABLE COUNT_TAB(
	NO_COL VARCHAR2(3) CONSTRAINT COUNT_TAB PRIMARY KEY
);

--[PAGE416][PK를 이용한 채번]
INSERT INTO COUNT_TAB(NO_COL) 
VALUES ((SELECT /*+ INDEX_DESC(COUNT_TAB COUNT_TAB_PK)*/
				DECODE(MAX(NO_COL),NULL,0,MAX(NO_COL) + 1)
		FROM COUNT_TAB
		WHERE ROWNUM = 1));
--위의 SQL문은 NO_COL 컬럼을 역순으로 정렬하여 DECODE 함수를 이용해 가장 큰 값을 기준으로 처음값이 0에서부터 1씩
--증가하도록 작성된 SQL문장이다.

--[PAGE417][INSA 테이블 SABUN 생성 예]
SELECT /*+ INDEX_DESC(INSA INSA_PK)*/
	   DECODE(SUBSTR(MAX(SABUN),1,8)
	   		 ,TO_CHAR(SYSDATE,'YYYYMMDD')
	   		 ,MAX(SABUN) + 1
	   		 ,TO_CHAR(SYSDATE,'YYYYMMDD')||'01') AS SABUN
FROM INSA
WHERE SABUN < TO_CHAR(SYSDATE,'YYYYMMDD')||'99'
AND ROWNUM = 1;

--[PAGE419][INDEX를 이용한 채번 생성]
INSERT INTO INSA(SABUN, JOIN_DAY, NAME, ENG_NAME, SEX, HP, JOIN_GBN_CODE)
SELECT /*+ INDEX_DESC(INSA INSA_PK)*/
	   DECODE(SUBSTR(MAX(SABUN),1,8)
	   ,TO_CHAR(SYSDATE,'YYYYMMDD')
	   ,MAX(SABUN) + 1
	   ,TO_CHAR(SYSDATE,'YYYYMMDD')||'01') AS SABUN
	   ,TO_CHAR(SYSDATE,'YYYYMMDD')
	   ,:IN_NAME
	   ,:IN_ENG_NAME
	   ,:IN_SEX
	   ,:IN_HP
	   ,:IN_JOIN_GBN_CODE
FROM INSA
WHERE SABUN < TO_CHAR(SYSDATE,'YYYYMMDD')||'99'
AND ROWNUM = 1;