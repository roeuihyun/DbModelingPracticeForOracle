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

--[PAGE356][함수 사용 INDEX 생성 전 확인 SQL]
SELECT /*+ INDEX_DESC(INSA INSA_SAL)*/
		SABUN, ENG_NAME, JOIN_GBN_CODE, SALARY
FROM INSA
WHERE TO_CHAR(SALARY) LIKE '30%'
AND JOIN_GBN_CODE = 'RGL';

--[PAGE356][함수 사용 INDEX 생성]
CREATE INDEX INSA_SAL_F
ON INSA(TO_CHAR(SALARY));

--[PAGE356][함수 사용 INDEX 생성 전 확인 SQL]
SELECT /*+ INDEX_DESC(INSA INSA_SAL)*/
		SABUN, ENG_NAME, JOIN_GBN_CODE, SALARY
FROM INSA
WHERE TO_CHAR(SALARY) LIKE '30%'
AND JOIN_GBN_CODE = 'RGL';

--실행 계획이 달라진다. TABLE FULL SCAN -> INDEX ROWID 사용으로 변경

--3. 물리적 구조에 따른 분류
--3.1. B*TREE INDEX
--3.1.1. 설명
--명칭 : 인덱스를 생성할 때 일반적으로 가장 많이 사용하는 인덱스이며 binary search index의 약자이고 물리적 구조가 좌우 대칭 구조를 이루고 있어 Balance-tree INDEX라고도 한다.
--구조 : 나무구조처럼 Rock Block, Branch Block, Leaf Block으로 나뉘어져 찾아갈 수 있는 구조로 생성되며 Leaf Block에서는 서로의 정보를 연결하는 Double Linked List 정보를 가지고 있다.
--[PAGE358][기본형식]
CREATE [UNIQUE] IDNEX [SCHEMA.]인덱스명
ON [SCHEMA.]테이블명(컬럼[ASC|DESC][,컬럼[ASC|DESC]...])
[TABLESPACE 테이블 스페이스명]
[PCTREE 값]
[INITRANS 숫자]
[MAXTRANS 숫자]
[STORAGE 절]
[LOGGIN|NOLOGGING]
[NOSORT]
[REVERSE];
--찾아가는 Leaf Block의 깊이가 동일하여 검색시간이 동일하다.
--Leaf Block에는 물리적으로 테이블 레코드의 ROWID를 가지고 레코드를 직접 엑세스 할 수 있다.
--NULL값의 저보는 인덱스 정보를 만들지 앟는다. 결합인덱스일 때는 구성 컬럼이 모두 NULL값일 때 인덱스 정보로 저장하지 않는다.
--Cardinality(집합원의 개수)가 다시 말해 분포도가 좋은 컬럼에 인덱스를 생성할 때 유리하다.

--3.1.3. B*TREE INDEX의 구조 설명
--B*TREE 인덱스는 위에서 보는 바와 같이 나무의 가지같은 구조로 Root, Brach, Leaf Block으로 구성되어 있으며 마지막 Leaf Block에는 인덱스 컬럼의 값과 실제 물리적 테이블을 찾아갈 수 있는 ROWID로 구성이 되어있다.
--[PAGE360][ROWID의 구성]
--DATABASE SEGMENT 정보 + TABLE SPACE의 DATA FILE정보 + DATA BLOCK 정보 + ROW NUMBER

--[PAGE360][구조설명]
--(1)Root Block 
--블록 헤드와 실제 인덱스 값의 범위를 알 수 있는 정보와 Branch Block을 찾아갈 수 있는 블럭 정보를 가지고 있다.
--인덱스 검색 시 제일 먼저 검색하며 인덱스 대상 상수값을 가지고 블럭에 있는 인덱스 값의 범위와 비교하여 해당되는 Brach Block의 물리적 주소값을 찾는다.
--레코드가 없는 테이블에 인덱스를 생성하면 값이 없는 Root Block이 먼저 생성된다.

--(2)Branch Block 
--블록 헤드와 실제 인덱스 값의 범위를 알 수 있는 정보와 Leaf Block을 찾아갈 수 있는 블록 정보를 가지고 있다.
--인덱스 검색 시 Root Block을 경유하여 검색되며 Branch Block을 찾은 후 인덱스 대상 상수값을 가지고 블록에 있는 인덱스 값의 범위와 비교하여 다음 블록의 물리적 주소를 가지고 다음 블록을 찾아간다.
--인덱스 검색 시 Leaf Block을 찾을 때까지 위의 과정을 반복하여 수행한다.

--(3)Leaf Block
--블록 헤드와 실제 인덱스 값을 가지고 있으며 테이블 레코드를 찾아 갈수 있는 ROWID값을 가지고 있다.
--인덱스 검색 시 Leaf Block에 도달을 하면 블록을 순차적으로 검색하여 인덱스 대상 상수값과 같으면 찾아갈 ROWID값을 가지고 직접 해당 레코드를 검색하게 된다.

--(4)Double Linked list
--Leaf Block에는 이전 블록 번호와 다음 블록 번호를 가지고 있어 순차적으로 또는 역방향으로도 검색할 수 있도록 되어 있다.
--Leaf Block은 항상 인덱스 키값으로 정렬되어 있기 때문에 Link 정보를 가지고 블록들을 읽으면서 필요한 데이터를 검색할 수 있다.