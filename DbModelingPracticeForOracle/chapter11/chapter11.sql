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

--[PAGE402][Sequence 생성 예]
CREATE SEQUENCE INSA_SEQ
INCREMENT BY 3
START WITH 28
MINVALUE 1
MAXVALUE 33
NOCACHE
NOORDER
NOCYCLE;

--[PAGE402][Sequence 사용 예]
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
