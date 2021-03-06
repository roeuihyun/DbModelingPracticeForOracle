DROP FUNCTION GET_CMM_CODE_NAME;

CREATE OR REPLACE FUNCTION       GET_CMM_CODE_NAME (
V_CLASS_CODE IN CMM_CODE_DETAIL.CLASS_CODE%TYPE, 
V_CODE_NO IN CMM_CODE_DETAIL.CODE_NO%TYPE)
RETURN VARCHAR2
IS
V_CMM_CODE_NAME CMM_CODE_DETAIL.CODE_NAME%TYPE;

BEGIN

SELECT CODE_NAME
        INTO  V_CMM_CODE_NAME
         FROM CMM_CODE_DETAIL
        WHERE CODE_NO = V_CODE_NO
           AND CLASS_CODE = V_CLASS_CODE;

RETURN  V_CMM_CODE_NAME;
EXCEPTION
        WHEN NO_DATA_FOUND THEN
               DBMS_OUTPUT.PUT_LINE('해당하는 데이터가 존재하지 않습니다.');
                 RETURN  V_CMM_CODE_NAME;
        WHEN TOO_MANY_ROWS THEN
               DBMS_OUTPUT.PUT_LINE('자료가 2건 이상입니다.');
        WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE('기타 에러입니다.');
END;

/
DROP FUNCTION SAWON_COUNT;

CREATE OR REPLACE FUNCTION SAWON_COUNT (v_GBN_CODE IN VARCHAR2)
RETURN VARCHAR2
IS 
v_m NUMBER;
v_f NUMBER;
v_t NUMBER;
v_ALL VARCHAR2(30);
BEGIN
v_m :=0;
v_f :=0;
v_t :=0;

SELECT COUNT(DECODE(SEX,'M',1)) AS MEN,
       COUNT(DECODE(SEX,'F',1)) AS WOMEN,
       COUNT(SEX) AS TOT  
 INTO v_m, v_f, v_t      
 FROM INSA
WHERE JOIN_GBN_CODE=v_GBN_CODE;

DBMS_OUTPUT.PUT_LINE('남 : '||v_m ||', 여 : '|| v_f ||', 토탈 : '|| v_t);

v_ALL := '남 : '||v_m ||' 여 : '|| v_f ||' 총원 : '|| v_t;
DBMS_OUTPUT.PUT_LINE('v_ALL 에 담겨있는 값은 - '||v_ALL); 
RETURN v_ALL;
END;

/
