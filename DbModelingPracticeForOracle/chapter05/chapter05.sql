--[PAGE109][테이블 생성 예]
CREATE TABLE CHAPTER_1(
SABUN VARCHAR2(10) NOT NULL,
NAME VARCHAR2(50) NOT NULL,
AGE VARCHAR2(3),
PHONE VARCHAR2(11),
CONSTRAINT CHAPTER_1_PK PRIMARY KEY(SABUN)
)

TABLESPACE SYSTEM
PCTFREE 10 -- 블록에 데이터들이 증가함에 따라서 블록헤더 등을 제외하고 데이터가 들어가는 공간에 일정량이 채워지면 더이상 채우지 말아야 하는 공간을 의미
PCTUSED 40 -- 재사용되기 위해 필요한 블록의 충진도 값을 설정한다. 디폴트는 60 입력, 삭제가 자주 없는경우 90, 수정작업이 자주 발생하는경우 40
INITRANS 1
MAXTRANS 255
STORAGE(
	INITIAL 64K -- 초기 테이블이 생성될 때 차지하는 크기
	NEXT 1024K -- INITIAL에서 정한 만큼의 공간이 다 사용되었을 때 다음번으로 추가되는 공간의 크기를 의미
	MINEXTENTS 1 -- 세그먼트가 생성될 때 최소한 할당되는 EXTENT의 크기
	MAXEXTENTS UNLIMITED -- 세그먼트가 가질 수 있는 EXTENT의 최대수
	FREELISTS 1 -- INSERT 작업시 미리 사용한 블록을 리스트하고 있다가 할당하는 곳
	FREELIST GROUPS 1
)

--[PAGE112][컬럼 상태 변경 SQL]
ALTER TABLE CHAPTER_1 ADD(JOIN_DAY VARCHAR2(8));
ALTER TABLE CHAPTER_1 COLUMN RENAME PHONE TO HP;
ALTER TABLE CHAPTER_1 MODIFY(AGE NUMBER(3));

--[PAGE113][PRIMARY KEY 제약 조건 지정]
CREATE TABLE CHAPTER_1(
	SABUN VARCHAR2(10) CONSTRAINT CHAPTER_1_PK_SABUN PRIMARY KEY
)

--[PAGE113][NOT NULL 제약 조건 지정]
CREATE TABLE CHAPTER_1(
	SABUN VARCHAR2(10) CONSTRAINT CHAPTER_1_PK_SABUN PRIMARY KEY
	,NAME VARCHAR2(20) CONSTRAINT CHAPTER_1_nn_NAME NOT NULL
)

--[PAGE114][FOREIGN KEY 제약 조건 지정]
CREATE TABLE CHAPTER_1(
	SABUN VARCHAR2(10) CONSTRAINT CHAPTER_1_PK_SABUN PRIMARY KEY
	,NAME VARCHAR2(20) CONSTRAINT CHAPTER_1_nn_NAME NOT NULL
	,PHONE VARCHAR2(11) CONSTRAINT CHAPTER_1_FK_PHONE FOREIGN KEY (PHONE) REFERENCES CHAPTER_2(PHONE)
)

--[PAGE114][DEFAULT 제약 조건 지정]
CREATE TABLE CHAPTER_1(
	SABUN VARCHAR2(10) CONSTRAINT CHAPTER_1_PK_SABUN PRIMARY KEY
	,NAME VARCHAR2(20) CONSTRAINT CHAPTER_1_nn_NAME NOT NULL
	,PHONE VARCHAR2(11) CONSTRAINT CHAPTER_1_FK_PHONE FOREIGN KEY (PHONE) REFERENCES CHAPTER_2(PHONE)
	,PUT_START_DAY DATE DEFAULT SYSDATE
)

--[PAGE115][테이블 제약 조건 확인]
SELECT A.TABLE_NAME
	   ,B.COLUMN_NAME
	   ,A.CONSTRAINT_NAME
	   ,A.CONSTRAINT_TYPE -- P - PRIMARY KEY, U - UNIQUE KEY, F - FOREIGN KEY, C - CHECK OR NOT NULL, V - VIEW
	   ,A.SEARCH_CONDITION
FROM USER_CONSTRAINTS A
	 ,USER_CONS_COLUMNS B
WHERE A.CONSTRAINT_NAME = B.CONSTRAINT_NAME
AND A.TABLE_NAME = 'INSA'
AND A.CONSTRAINT_TYPE ='P';

--[PAGE116][제약 조건 추가]
ALTER TABLE INSA
ADD CONSTRAINT INSA_MOBILE_UK UNIQUE(MOBILE);

--[PAGE116][제약 조건 삭제]
ALTER TABLE INSA
DROP CONSTRAINT INSA_MOBILE_UK;

--[PAGE117][INSA TABLE 생성 예]
CREATE TABLE INSA(
    SABUN VARCHAR2(10)
    ,JOIN_DAY VARCHAR2(8)
    ,RETIRE_DAY VARCHAR2(8)
    ,PUT_YN VARCHAR2(1)
    ,CLASS_GBN_CODE VARCHAR2(3)
    ,NAME VARCHAR2(100)
    ,REG_NO VARCHAR2(13)
    ,ENG_NAME VARCHAR2(100)
    ,PHONE VARCHAR2(25)
    ,HP VARCHAR2(25)
    ,CARRIER VARCHAR2(500)
    ,POS_GBN_CODE VARCHAR2(5)
    ,CMP_REG_NO VARCHAR2(10)
    ,SEX VARCHAR2(10)
    ,YEAR NUMBER
    ,EMAIL VARCHAR2(100)
    ,ADDR1 VARCHAR2(250)
    ,ADDR2 VARCHAR2(250)
    ,MIL_YN VARCHAR2(10)
    ,HOME_PHONE VARCHAR2(25)
    ,JOIN_GBN_CODE VARCHAR2(3)
    ,SALARY NUMBER DEFAULT 0
    ,KOSA_REG_YN VARCHAR2(1)
    ,KOSA_CLASS VARCHAR2(3)
    ,PW VARCHAR2(15)
    ,CONSTRAINT "INSA_PK_SABUN" PRIMARY KEY (SABUN)
)
TABLESPACE USERS
PCTFREE 10
PCTUSED 0
INITRANS 1
MAXTRANS 255
STORAGE(
    INITIAL 64 K
    NEXT 1024 K
    MINEXTENTS 1
    MAXEXTENTS UNLIMITED
)
LOGGING
NOCACHE
MONITORING
NOPARALLEL;

--[PAGE119][제약 조건 지정 방식]
CREATE TABLE INSA(
    SABUN VARCHAR2(10) PRIMARY KEY
)

CREATE TABLE INSA(
    SABUN VARCHAR2(10)
    ,CONSTRAINT "INSA_PK_SABUN" PRIMARY KEY (SABUN)
)

--[PAGE120][제약 조건 지정 방식]
CREATE TABLE INSA_ACAD_ABILITY_1(
    SABUN VARCHAR2(10) NOT NULL
    ,SEQ NUMBER NOT NULL
    ,MAJOR_STUDY_GBN VARCHAR2(100)
    ,GRAT_MONTH VARCHAR2(2)
    ,SCHOOL_NAME VARCHAR2(50)
    ,CONSTRAINT "INSA_ACAD_ABILITY_PK_SEQ" PRIMARY KEY(SEQ)
)
TABLESPACE USERS
PCTFREE 10
PCTUSED 0
INITRANS 1
MAXTRANS 255
STORAGE(
    INITIAL 64 K
    NEXT 1024 K
    MINEXTENTS 1
    MAXEXTENTS UNLIMITED
)
LOGGING
NOCACHE
MONITORING
NOPARALLEL;