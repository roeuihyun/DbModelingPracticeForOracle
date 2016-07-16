--CHAPTER14
--이력 관리
--변경되는 이력들을 관리하는 여러가지 방법을 알아보고 장단점을 확인하여 보자

--1.1. 이력관리 대상 테이블과 분리해 이력 테이블 생성(모든 컬럼 포함)
--이력 대상 테이블과 이력 테이블을 분리하면서 관련 컬럼을 모두 이력 테이블에 포함하여 히스토리를 남겨두는 형태의 이력관리다.
--이런 방식은 변하지 않는 항목들이 중복되어 히스토리에 남아 있게 되므로 데이터 측면에서 효율적인 관리가 아니라고 말할 수 있다.
--그러나 필요에 따라서는 이렇게 이력 관리를 해야할 경우가 종종 발생을 한다.

--1.1.1. 적용 시 고려사항
--아주 중요한 데이터 관리 요건이 있으나 변경대상 컬럼을 정하지 못할 때
--이력 대상 테이블들의 릴레이션이 있을 때 이력 테이블 설계에 신중히 대처
--변경 시 모든 컬럼을 체크하고 한개라도 변경된 컬럼이 있으면 모든 컬럼의 이력을 생성
--이력을 관리해야 될 이력 대상들이 적을수록 시스템의 부하나 유지보수 측면에서 유리하다.
--테이블 전체를 이력으로 발생시키는 경우는 아주 특별한 경우에만 해야 한다.

--1.1.3. 대상 테이블의 모든 컬럼들을 이력 테이블에 담아두고 관리하는 방법의 장점
--이력관리될 테이블의 모든 컬럼을 대상으로 하기 때문에 관리 항목에 신경쓸 필요성이 없기 때문에 분석, 설계 공수가 단축
--이력발생 시 모든 컬럼을 대상으로 하므로 코딩 시 에러율이 작아진다.
--따로 이력을 조회하는 화면을 개발하지 않고 이력을 조회하는 화면을 따로 두지 않을 수 있다.
--이력 조회 화면이 따로 없으면 코딩 시 생산성이 증가됨

--1.1.4. 대상 테이블의 모든 컬럼들을 이력 테이블에 담아두고 관리하는 방법의 단점
--한개의 항목만 수정되어도 전체항목의 이력을 발생해야 하므로 데이터 측면에서 보면 변경되지 않아야 할 항목까지 여러 레코드에 들어가서 중복이 발생한다.
--수정 업무 코딩 시 화면 항목들의 변경 유무 사항을 체크를 해야하므로 에러율 발생이 높다.
--수정 후 저장 시 꼭 체크를 해야함
--조회
--모든 항목을 대상으로 이력을 조회할 시 조회자가 변경된 항목을 구분하기가 힘들다.

--1.2. 이력관리 대상 테이블과 분리해 이력 테이블 생성(변경관리 대상 컬럼만 포함)
--이력을 관리할 대상 컬럼을 구분할 수 있을때
--이력 대상 테이블의 릴레이션이 있을 때 이력 테이블 설계에 신중히 대처
--변경 시 이력 관리 대상 컬럼을 체크하고 한 개라도 변경된 컬럼이 있으면 변경 대상 컬럼의 모든 항목의 이력을 생성
--사용되는 전체컬럼들이 이력 테이블에 기록되지 않고 이력 관리가 필요한 컬럼들만 추출하여 이력 테이블을 만들기 때문에
--상대적으로 이력 건수가 많아 질 수록 메모리를 차지하는 용량을 줄일 수 있고 필요한 컬럼만 관리되므로 중복이나 변경 이력에 대한 가독성이 좋다.

--1.2.2. 장점
--이력 관리될 테이블의 선택된 컬럼을 대상으로 하기 때문에 관리 항목을 선택만 하면 되기 때문에 분석, 설계 공수가 단축된다.
--조회
--이력을 조회하는 화면을 따로 두지 않을 수 있다.
--이력 조회 화면이 따로 없으면 코딩 시 생산성이 증가됨.

--1.2.3. 단점
--변경 대상인 항목 중 한개의 항목만 수정되어 전체 항목의 이력을 발생해야 하므로 데이터 측면에서 보면 변경되지 않는 항목까지
--여러 레코드에 들어가서 중복이 발생한다.
--수정 업무 코딩 시 화면 항목들의 변경 유무 사항을 체크를 해야 하므로 에러율 발생이 높다.
--수정 후 저장 시 꼭 체크를 해야함

--트리거를 사용하여 보통 이력을 남기는데 테이블 구조가 변경될 경우 트리가가 DISABLE되므로 주의해야 한다.

--2. 자기 참조 이력
--자기 참조 이력을 자기 자신의 테이블에 가지고 가는 구조로 이력 테이블을 따로 가지고 가지 않는 구조이다.
--자신의 테이블에 이력이 발생되면 이력을 같이 저장시키는 구조
--이력 일련 번호가 가장 크거나 종료 일시가 가장 클 때 최종 데이터라고 볼 수 있다.
--이력 대상 테이블들의 릴레이션이 있을 때 이력 테이블 설계에 신중히 대처.
--변경 시 모든 컬럼을 체크하고 한 개라도 변경된 컬럼이 있으면 모든 컬럼의 이력을 생성.

--이력 발생 개발
--이런 유형의 이력 발생 모델은 전사적으로 적용되는 형태여서 주로 공통팀에서 이력을 발생시키는 모듈을 만들어서 사용할 수 
--있도록 하는 경우가 많이 있다.
--이력 조회
--이력 조회가 필요 시 업무별로 화면을 정의하고 자기 자신의 테이블에서 이력을 조회할 수 있도록 개발을 해야한다.
--장점
--이력 테이블이 따로 존재하지 않아서 테이블의 개수가 늘어나지 않는다.
--분석, 설계 시 전체컬럼을 대상으로 이력을 발생하므로 관리항목 선정에 대하여 고민 할 필요가 없엇 공수가 절약된다.
--단점
--한 개의 테이블에 이력이 같이 존재하여서 현 시점의 데이터를 추출 할 때 이력이 들어 있는 저장 장소까지 읽어야 하기 때문에 비효율적이다.

--2.1. 오라클 블럭의 구조
--ORACLE은 논리적인 구조로 Block -> Extend -> Segment -> Tablespace -> Database 로 확장 된다는 것을 알 수 있다.
--Extend : 데이터 블럭의 연속된 형태로 구성되며, 세그먼트의 저장 단위로 사용한다.
--테이블이나 인덱스를 생성할 때 STORAGE OPTION으로 설정할 수 있다.
--Segment : 데이터를 저장하기 위해 할당하는 확장 영역이며 테이블 세그먼트, 인덱스 세그먼트,
--롤백 세그먼트, 언두 세그먼트,템프러리먼트 등이 있다. 하나 이상의 Extend로 구성된다.
--Tablespace : 물리적 파일이 1개 이상으로 구성되며 시스템 테이블 스페이스와 사용자가 생성하는 테이블 스페이스가 있다.
--1개 이상의 Segment로 구성됨.
--Database : 테이블 스페이스의 집합체라고 할 수 있다.

--보통 이 오라클 블럭의 구조 및 크기 설정은 init.ora file을 확인해 보면 된다.
--일반적으로 이 크기는 8kbyte로 구성되어 있으며 이 크기는 영문자 8000자 한글 4000자 정도가 들어가는 구조이다.

--PCTFREE : 데이터 저장 공간이 insert에 의해 증가될 때 어느 공간만큼 증가하면 모두 채우지 말고 비워두라는 뜻이다.
--Update시 사용하기 위한 공간.
--PCTUSED : 블럭 안의 레코드가 삭제되면 점점 빈 공간이 생기는데 PCTUSED 지정선까지 삭제되면 이 블럭에 다시
--insert 할 수 있게 하라는 설정. 블럭의 재사용을 의미한다.

--PCTFREE 설정을 잘못하게 되는 경우엔 데이터의 클러스트링(Clustering)이 아주 나빠지게 되는 것이다.
--이것은 수행 속도에 엄청난 결과를 발생 시킨다.

--이력일련번호에 마지막번호를 현 시점의 채무자로 발생을 시키는 경우
--인덱스를 생성하여도 소용이 없다. 채무자별 이력일련번호가 가장 큰 레코드를 가져와야 하므로 모든 레코드를
--비교하는 방법밖에 없다.
--현 시점의 채무자는 종료 일시에 '99999999'를 넣어서 처리하였을 경우
--종료 일시에 인덱스를 만들어야 현 시점의 채무자를 가져올 수 있다.
--이력일련번호에 현 시점의 채무자를 최초의 번호로 부여하고 이력은 일련 번호가 증가된다.
--현 시점의 채무자는 이력 일련번호 0을 유지하며(이력은 insert, 현 시점의 채무자는 update)이력 일련번호에 인덱스를
--만들어서 현 시점의 채무자를 가져올 수 있다. 이방법은 모든 채무자를 가져올 때는 좋은 방법이 아닐 수 있다.

--2.1.2 단점 2
--나중에 SQL 튜닝에 대하여 손을 쓸 수 있는 방법이 없다.
--위에서 설명한 바와 같이 이력과 현 시점의 데이터가 같이 존재하고 또 한개의 테이블이 아니라 모든 테이블이
--이런 방식으로 설계되어 있다면 더 심각하다.
--테이블의 Join이 이루어지면서 테이블 별로 현시점의 데이터만을 추출 해야 하므로 엄청난 자원과 시간이 시스템적으로 소요된다.
--이는 근본적으로 손을 쓸 수 있는 방법을 넘어서 버린다.

--3. 변경된 이력만 관리
--모든 테이블의 변경된 컬럼만을 대상으로 하고 있으므로 변경된 자료만 이력으로 생성하며 
--업무별로 변경 이력 테이블을 따로 두어 사용할 수 있다.

--변경된 컬럼 데이터만을 관리
--테이블별 컬럼 정보를 가지고 이력을 발생시킨다.
--여러테이블의 변경자료를 같이 가지고 잇는구조이다.
--변경 전후의 데이터를 모두 가지고 있다.

--3.1.1. 장점
--변경 이력을 관리해야 될 대상을 시간과 구조에 상관없이 선택할 수 있다.
--위의 방식으로 설계를 해두면 개발 도중이나 개발 후 유지보수 중에서도 변경 대상이나 텡블이나 컬럼들이 바뀌어도 
--설계의 변경없이 처리된다는 것이 가장 큰 장점이라고 말할 수 있다.
--변경 이력 때문에 분석,설계자가 이력관리 모델링이나 테이블에 신경쓰찌 않아도 되며 단지 이력을 관리해야 될 대상이나 항목만을 정의하면 된다.
--변경 이력을 업무 공통으로 적용하기 때문에 개발자들이 공통모듈을 사용하면 되므로 공수가 절약된다.
--이력관리의 엔티티를 분리해서 데이터베이스 관리가 효율적이다.
--조회
--변경된 시점과 변경된 항목들이 화면으로 조회되므로 업무 효율이 높다.
--공통 조회 화면 한개의 개발만으로도 사용 가능하므로 개발 효율성이 높다.

--3.1.2. 단점
--한개의 레코드의 수정이 일어나더라도 변경이력을 변경된 개수만큼의 레코드가 발생하기 때문에 레코드의 수가 늘어난다.
--이력 테이블을 모든 업무에서 사용하므로 관리나 백업에 주의해야 한다.