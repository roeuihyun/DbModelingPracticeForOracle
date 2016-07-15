--CHAPTER09
--페이징 처리

--[PAGE374][Total 레코드 수 SELECT]
SELECT COUNT(*) TOTCNT
FROM INSA_BBS
WHERE BBS_CODE = #bbsCode#;

--[PAGE374][게시판 시작 페이지와 CountperPage 입력]
SELECT A.BBS_CODE AS BBS_CODE
	   ,A.BBS_SEQ AS BBS_SEQ
	   ,A.TITLE AS TITLE
	   ,A.CONTENT AS CONTENT
	   ,A.ID AS ID
	   ,A.PW AS PW
	   ,A.BBS_DATE AS BBS_DATE
	   ,A.HIT_CNT AS HIT_CNT
	   ,A.NAME AS NAME
FROM INSA_BBS A
WHERE 1 = 1
AND A.BBS_CODE = #bbsCode#
ORDER BY BBS_SEQ DESC
LIMIT #firstIndex#,#pageUnit#  
;

--CurrentPageNo : 현재 페이지 번호
--RecordCountPerPage : 한 페이지당 게시되는 게시물 건수
--Page Size : 페이지 리스트에 게시되는 페이지 건수
--First, Last RecordIndex : 페이징 SQL의 조건절에 사용되는 시작,마지막 rownum

--대량의 건수처리
--2.1. 페이지별 조회
--[PAGE376][대용량 DB의 페이징 처리_1]
SELECT BBS_SEQ
	   ,TITLE
	   ,NAME
	   ,WRITE_DATE
	   ,HIT_CNT
FROM BOARD
WHERE BBS_SEQ > :T_BBS_SEQ
AND ROWNUM <= 10
AND :SW = 'D'
UNION
SELECT /*+ INDEX_DESC(BOARDBOARD_PK)*/
	   BBS_SEQ
	   ,TITLE
	   ,NAME
	   ,WRITE_DATE
	   ,HIT_CNT
FROM BOARD
WHERE BBS_SEQ < :F_BBS_SEQ
AND ROWNUM <= 10
AND :SW = 'U';

--[PAGE378][대용량 DB의 페이징 처리_2]
SELECT SABUN
	   ,NAME
	   ,HP
	   ,YEARS
	   ,SEX
	   ,CARRIER
	   ,POS_GBN_CODE
	   ,ADDR1||ADDR2
	   ,PUT_YN
FROM INSA_BBS
WHERE SABUN > :T_SABUN
AND ROWNUM < 100;

--화면에서 스크롤이 내려갈 때 마지막 사번을 입력 받아 입력된 사번보다 큰 사번 중 100개의 데이터를 추출하여 화면에서 마지막 데이터에 추가되는 방식이다.