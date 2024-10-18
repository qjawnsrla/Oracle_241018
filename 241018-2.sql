-- DML (Date Manipulation Language) : insert(입력), update(수정), delete(삭제) 

-- 연습용테이블 생성하기

CREATE TABLE DEPT_TEMP
AS SELECT * FROM dept;

SELECT * FROM DEPT_TEMP;



-- 테이블에 데이터를 추가하는 insert문
-- 1번쩨 방법 : insert into 테이블명(컬럼명...) values(데이터...)

INSERT INTO DEPT_temp(deptno, dname, loc) VALUES (50, 'DATABASE', 'SEOUL');

-- 2번째 방법 : insert into values(데이터...) - 칼럼명 없이 입력 가능 
INSERT INTO DEPT_TEMP VALUES (60, 'BACKEND', 'BUSAN'); 

-- 3번째 방법 : 입력할 칼러명, 데이터 만 입력하면 입력된 데이터만 들어가고 입력하지 않은 나머지 자리에는 NULL값으로 채워짐
INSERT INTO DEPT_TEMP(deptno) VALUES(70);

-- INSERT INTO DEPT_TEMP(dname, loc) VALUES ('APP', 'DAEGU'); 는 원래는 Primary Key값이 없으므로 에러가 발생한

-- INSERT INTO DEPT_TEMP VALUES () -- 로 쓰면 데이터를 명확하게 다 넣어줘야하므로 에러발생


INSERT INTO DEPT values(40, 'BACKEND', 'BUSAN');

DELETE FROM dept
WHERE loc = 'BUSAN';

SELECT * FROM dept;


DELETE FROM DEPT_TEMP
--WHERE dname = 'APP'
WHERE deptno = 70;

INSERT INTO dept_temp VALUES (70, '웹개발', '');

SELECT * FROM DEPT_TEMP;


CREATE TABLE EMP_TEMP
AS SELECT *
FROM EMP
WHERE 1 != 1;

SELECT * FROM EMP_TEMP;

INSERT INTO emp_temp (empno, ename, job, mgr, hiredate, sal , comm, deptno)
	VALUES (9001, '나영석', 'PD', NULL, '2020/01/01', 9900, 1000, 50);

INSERT INTO emp_temp (empno, ename, job, mgr, hiredate, sal , comm, deptno)
	VALUES (9002, '강호동', 'MC', NULL, TO_DATE('2020/01/01', 'YYYY/MM/DD'), 8000, 1000, 60);

INSERT INTO emp_temp (empno, ename, job, mgr, hiredate, sal , comm, deptno)
	VALUES (9003, '서장훈', 'MC', NULL, SYSDATE, 9000, 1000, 70);


SELECT * FROM DEPT_TEMP;

INSERT INTO dept_temp(deptno, dname, loc) values(80, 'FRONTEND', 'SUWON');
ROLLBACK;

UPDATE DEPT_TEMP 
	SET dname = 'WEB-PROGRAM',
		loc = 'SUWON'
	WHERE deptno = 70;
	
COMMIT;

DELETE FROM DEPT_TEMP
	WHERE loc = 'SUWON';