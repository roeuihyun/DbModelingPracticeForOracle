--CHAPTER08
--1. 인덱스 (INDEX)
--인덱스는 책에서 '목차 + 페이지 번호'와 같이 컬럼값 + ROWID 형태로 데이터를 빠르게 ACCESS 하기 위해 사용한다.

--1.1. 인덱스의 기초
--[PAGE344][테이블의 조회]
SELECT * FROM INSA
WHERE SALARY >= 3000;

--[PAGE344][인덱스 생성]
CREATE INDEX INSA.INSA_SAL
ON INSA.INSA(SALARY);

--[PAGE344][인덱스 생성 후 조회]
SELECT /*+ INDEX(INSA INSA_SAL)*/
      *
FROM INSA
WHERE SALARY >= 3000;

--테이블 데이터의 양이 적거나 10% 이상 범위에 있는 데이터를 INDEX를 통해 찾는것은 INDEX 정보를 먼저 검색하고 검색 된
--INDEX가 가리키는 데이터를 조회하기 때문에 오히려 FULL SCAN이 빠르다.

--1.2. INDEX 생성
--인덱스를 생성하는 방법은 두가지 있는데 하나는 테이블 생성시 UNIQUE 제약 조건을 정의하면 자동적으로 UNIQUE INDEX 생성
--두번째 방법은 사용자가 직접 아래의 CREATE INDEX 문장을 통해 인덱스를 생성하는 방법이다.

--[PAGE346][PK 제약조건 UNIQUE INDEX 생성 예]
ALTER TABLE INSA.INSA ADD
(
  CONSTRAINT INSA_PK
  PRIMARY KEY (SABUN)
);

--[PAGE346][UNIQUE INDEX 사용 예]
SELECT SABUN, ENG_NAME, HP, JOIN_GBN_CODE, SALARY
FROM INSA
WHERE SABUN = '2013022601';

--[PAGE347][INDEX 생성과 사용 예]
CREATE INDEX 인덱스명
ON 테이블명 (컬럼...N);

CREATE INDEX INSA_HP
ON INSA(HP);

--[PAGE347][INDEX CONFIRM]
SELECT INDEX_NAME , TABLE_NAME, UNIQUENESS
FROM USER_INDEXES --유저의 생성된 인덱스를 볼 수 있는 딕셔너리 테이블
WHERE TABLE_NAME = 'INSA';

--2. 인덱스의 종류
--2.1. UNIQUE INDEX
--고유 인덱스라고도 하며 PK, UK 제약 조건이 걸린 컬럼에 대해 오라클이 자동으로 생성할 수도 있고 사용자가 직접 생성 가능.
--[PAGE349][테이블 생성]
CREATE TABLE INSA_TE_IN(
SABUN VARCHAR2(10) CONSTRAINT INSA_TE_IN_PK PRIMARY KEY,
HO VARCHAR2(13)
);

--[PAGE349][INDEX 확인]
SELECT INDEX_NAME , INDEX_TYPE, TABLE_OWNER, TABLE_NAME, UNIQUENESS
FROM USER_INDEXES --유저의 생성된 인덱스를 볼 수 있는 딕셔너리 테이블
WHERE TABLE_NAME = 'INSA_TE_IN';

--2.2. NONUNIQUE INDEX
--비고유 인덱스라고도 하며 중복되는 데이터를 갖는 컬럼에 대해서 사용자가 직접 생성하는 인덱스이다.
--사용자가 ACCESS 하는 시간을 향상시키기 위해 필요한 INDEX를 직접 생성해서 사용하는 경우이다.

--[PAGE349][NONUNIQUE INDEX 생성]
CREATE INDEX INSA_SAL
ON INSA(SALARY);

--[PAGE349][INDEX 확인]
SELECT INDEX_NAME , INDEX_TYPE, TABLE_OWNER, TABLE_NAME, UNIQUENESS
FROM USER_INDEXES --유저의 생성된 인덱스를 볼 수 있는 딕셔너리 테이블
WHERE TABLE_NAME = 'INSA';

--2.3.1. SINGLE COLUMN INDEX
--물리적 테이블에 존재하는 한 개의 컬럼으로 인덱스를 생성하는 형태를 말하며 단일 인덱스라고 한다.

--2.3.2. COMPOSITE INDEX
--결합 인덱스라고도 하며 2개 이상의 싱글 컬럼이 하나의 인덱스로 결합된 INDEX를 의미한다.
--조회 조건이 항상 결합하여 조회하는 컬럼들을 위주로 결합하여 생성하는것이 일반적이다.
--[PAGE353][COMPOSITE INDEX 생성]
CREATE INDEX INSA_GBN_SABUN
ON INSA(JOIN_GBN_CODE,SABUN);

--[PAGE353][INDEX 확인]
SELECT INDEX_NAME , INDEX_TYPE, TABLE_OWNER, TABLE_NAME, UNIQUENESS
FROM USER_INDEXES --유저의 생성된 인덱스를 볼 수 있는 딕셔너리 테이블
WHERE TABLE_NAME = 'INSA';

--[PAGE354][COMPOSITE INDEX의 조회]
SELECT SABUN, NAME, SALARY, JOIN_GBN_CODE
FROM INSA
WHERE SABUN LIKE '2013%'
AND JOIN_GBN_CODE = 'RGL';

--2.4. 함수 사용 INDEX
--인덱스가 적용된 컬럼을 가공하게 되면 OPTIMIZER는 인덱스를 사용하지 못하게 된다.
--인덱스 컬럼의 가공이 필요할 때인덱스를 만들 때부터 함수를 적용시킬 수 있는데 이렇게 만들어진 INDEX를
--함수사용 INDEX라고 한다.