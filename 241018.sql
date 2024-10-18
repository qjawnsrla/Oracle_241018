-- 서브 쿼리 : 다른 SQL 쿼리문 내에 포함되는 쿼리문을 말함 
-- 주로 데이터를 필터링하거나 데이터 집계에 사용
-- 서브 쿼리는 SELECT, INSERT, UPDATE, DELETE 문에 모두 사용가능
-- 단일행 서브쿼리 (단 하나의 행으로 결과가 반환) 와 다중행 서브쿼리 (여러행의 결과가 반환)가 있음

-- 특정한 사원이 소속된 부서의 이름을 가져오기
SELECT dname AS "부서이름"
FROM DEPT
WHERE DEPTNO = (
	SELECT DEPTNO 
	FROM EMP
	WHERE ename = "KING"
);

-- 서브쿼리로 'JONES'의 급여보다 높은 급여를 받는 사원 정보 출력
SELECT *
FROM EMP
WHERE sal > (
	SELECT SAL
	FROM EMP
	WHERE ename = 'JONES';
);

-- 자체 조인 (SELF)으로 풀기
SELECT e1.*
FROM emp e1
JOIN emp e2
ON e1.sal > e2.sal
WHERE e2.ename = 'JONES';

-- 서브쿼리는 연산자와 같은 비교 또는 조회 대상의 오른쪽에 놓이며 괄호()로 묶어서 표현
-- 특정한 경우를 제외하고는 ORDER BY 절을 사용할 수 없음
-- 서브쿼리의 SELECT절에 명시한 열은 메인 쿼리의 비교대상과 같은 자료형과 같은 개수로 지정해야함 

SELECT e1.*
FROM emp e1
JOIN emp e2
ON e1.sal > e2.sal
WHERE e2.ename = 'ALLEN';


-- 문제 1 : EMP 테이블의 사원 정보 중에서 사원이름이 ALLEN인 사원의 추가수당보다 많은 사원정보 출력
SELECT *
FROM EMP
WHERE comm > (
	SELECT COMM
	FROM EMP
	WHERE ename = 'ALLEN'
);


-- 문제 2 : JAMES보다 먼저 입사한 사원들의 정보 출력
SELECT e1.*
FROM emp e1
JOIN emp e2
ON e1.hiredate < e2.hiredate
WHERE e2.ename = 'JAMES';

SELECT *
FROM EMP
WHERE HIREDATE < (
	SELECT HIREDATE 
	FROM EMP
	WHERE ename = 'JAMES'
);

-- 문제 : 20번 부서에 속한 사원 중 전체 사원의 평균 급여보다 높은 급여를 받는 사원 정보와 소속부서 조회
-- (사원번호, 이름, 직책, 급여, 부서번호, 부서이름, 부서위치)

SELECT e.empno, e.ename, e.sal, d.deptno, d.dname, d.loc
FROM emp e
JOIN dept D
ON e.DEPTNO  = d.DEPTNO 
WHERE e.deptno = 20
AND e.sal > (
	SELECT avg(sal)
	FROM emp 
);

-- 실행 결과가 여러개인 다중행 서브쿼리
-- IN : 메인 쿼리의 데이터가 서브쿼리의 결과 중 하나라도 일치 데이터가 있다면 true
-- ANT, SOME : 메인 쿼리의 조건식을 만족하는 서브쿼리의 결과가 하나 이상이면 true
-- ALL : 메인 퀄의 조건식을 서브쿼리의 결과 모두가 만족하면 true
-- EXISTS : 서브 쿼리의 결과가 존재하면 (즉, 한개 이상의 행이 결과를 만족하면) true

-- 메인쿼리에서의 급여가 서브쿼리에서의 각 부서의 최대 급여가 같은 사원의 모든정보가 출력
SELECT *
FROM emp
WHERE sal IN(
	SELECT MAX(sal)
	FROM emp
	GROUP BY deptno
);

SELECT empno, ename, sal
FROM emp
WHERE sal > ANY (
	SELECT sal
	FROM emp
	WHERE job = 'SALESMAN'
); 

SELECT empno, ename, sal
FROM emp
WHERE sal = ANY(
	SELECT sal
	FROM emp
	WHERE job = 'SALESMAN'
);

-- 30번 부서 사원들의 급여보다 적은급여를 받는 사원정보 출력
SELECT empno, ename, sal, deptno
FROM emp
WHERE sal < (
	SELECT MIN(sal)
	FROM EMP
	WHERE DEPTNO = 30
);

-- ALL 연산자를 사용해서 동일결과 만들기
SELECT empno, ename, dal, deptno
FROM EMP
WHERE sal < ALL ( 
	SELECT SAL
	FROM EMP
	WHERE deptno = 30
);

-- 직책이 'MANAGER'인 사원보다 많은 급여받는 사원의 사원번호, 이름, 급여 , 부서이름 출력하기
SELECT e.empno, e.ename, e.sal, d.dname
FROM EMP e
JOIN DEPT D
ON e.DEPTNO = d.DEPTNO
WHERE e.SAL > ALL (
	SELECT MAX(sal)
	FROM EMP
	WHERE job = 'MANAGER'
);

-- EXISTS : 서브쿼리의 결과 값이 하나 이상 존재하면 true
SELECT *
FROM EMP
WHERE EXISTS (
	SELECT dname
	FROM DEPT
	WHERE deptno = 40
);

-- 다중열 서브쿼리 : 서브쿼리의 결과 두개 이상의 칼럼으로 반환되어 메인쿼리에 전달하는 쿼리
SELECT empno, ename, sal, deptno
FROM EMP
WHERE (DEPTNO, sal) IN (
	SELECT DEPTNO, SAL
	FROM EMP
	WHERE DEPTNO = 30
);

SELECT *
FROM EMP
WHERE (DEPTNO, sal) IN (
	SELECT DEPTNO, MAX(sal)
	FROM EMP
	GROUP BY DEPTNO
);

-- FROM 절에 사용하는 서브 쿼리 : 인라인뷰라고 하기도 함
-- 테이블 내 데이터 규모가 너무크거나 현재 작업에 불필요한 열이 너무 많아 일부 행과 열만 사용하고자 할 때 유용
SELECT e10.empno, e10.ename, e10.deptno, d.dname, d.loc
FROM (
	SELECT *
	FROM EMP
	WHERE deptno = 10 ) e10
JOIN DEPT d
ON e10.deptno = d.deptno;

-- 먼저 정렬하고 해당 개수만 가져오기 : 급여가 많은 5명에 대한 정보를 보여줘
SELECT ROWNUM, ename, SAL
FROM (
	SELECT *
	FROM EMP
	ORDER BY sal DESC	
)
WHERE ROWNUM <= 5;

-- SELECT 절에 사용하는 서브쿼리 : 단일행 서브쿼리를 스칼라 서브쿼리라고 함
-- SELECT 절에 명시하는 서브쿼리는 반드시 하나의 결과만 반환하도록 작성해야 함
SELECT empno, ename, job, sal, 
	(
	SELECT grade
	FROM SALGRADE
	WHERE e.sal BETWEEN losal AND hisal
	) AS "급여 등급",
	deptno AS "부서 번호",
	(
	SELECT dname
	FROM dept d
	WHERE e.deptno = d.deptno
	) AS "부서이름"
FROM EMP e
ORDER BY "급여 등급";

-- 조인문으로 변경하기 
SELECT e.empno, e.ename, e.job, e.sal, s.grade AS "급여 등급", d.deptno, d.dname
FROM EMP e
JOIN SALGRADE s
ON e.sal BETWEEN s.losal AND s.HISAL 
JOIN dept d
ON e.deptno = d.deptno
ORDER BY "급여 등급";

-- 부서 위치 NEW YORK인 경우에는 본사, 그외에는 분점으로 반환하도록 만들기
SELECT empno, ename, 
	CASE 
		WHEN deptno = (
			SELECT deptno
			FROM dept
			WHERE loc = 'NEW YORK' ) THEN '본사'
		ELSE '분점'
	END AS "소속"
FROM EMP
ORDER BY "소속" DESC;



-- 연습문제 1번 : 전체 사원 중 ALLEN과 같은 직책(JOB)인 사원들의 사원 정보, 부서 정보를 다음과 같이 출력하는 SQL문을 작성하세요. 
-- (직책, 사원번호, 사원이름, 급여, 부서번호, 부서이름)

SELECT e.*, d.*
FROM emp e
JOIN dept d
ON e.deptno = d.deptno
WHERE job = (
	SELECT job
	FROM emp
	WHERE ename = 'ALLEN'
);



-- 연습문제 2번 : 전체 사원의 평균 급여(SAL)보다 높은 급여를 받는 사원들의 사원 정보, 부서 정보, 급여 등급 정보를 출력하는 SQL문을 작성하세요.
-- (단 출력할 때 급여가 많은 순으로 정렬하되 급여가 같을 경우에는 사원 번호를 기준으로 오름차순으로 정렬하세요.)
-- (사원번호, 이름, 입사일, 급여, 급여 등급, 부서이름, 부서위치)

SELECT e.empno AS "사원번호",
	e.ename AS "사원이름",
	e.hiredate AS "입사일",
	e.sal AS "급여",
	s.GRADE AS "급여 등급",
	d.dname AS "부서이름",
	d.loc
FROM emp e
JOIN SALGRADE s 
ON e.SAL BETWEEN s.LOSAL AND s.HISAL
JOIN dept d
ON e.DEPTNO = d.DEPTNO 
WHERE e.sal > (
	SELECT avg(sal)
	FROM emp)
ORDER BY "급여" DESC, "사원번호";



-- 연습문제 3번 : 10번 부서에 근무하는 사원 중 30번 부서에는 존재하지 않는 직책을 가진 사원들의 사원 정보, 부서 정보를 다음과 같이 출력하는 SQL문을 작성하세요.
-- (부서번호, 부서이름, 직책, 부서번호, 부서이름, 부서위치)

SELECT e.empno, e.ename, e.job, d.deptno, d.dname, d.loc
FROM emp e
JOIN dept D
ON e.deptno = d.DEPTNO
WHERE e.DEPTNO = 10
AND job NOT IN(
	SELECT DISTINCT job
	FROM EMP
	WHERE DEPTNO = 30
);



-- 연습문제 4번 : 직책이 SALESMAN인 사람들의 최고 급여보다 높은 급여를 받는 사원들의 사원 정보, 급여 등급 정보를 다음과 같이 출력하는 SQL문을 작성하세요
-- (단 서브쿼리를 활용할 때 다중행 함수를 사용하는 방법과 사용하지 않는 방법을 통해 사원 번호를 기준으로 오름차순으로 정렬하세요.)
-- (사원번호, 사원이름, 급여, 급여 등급)

SELECT e.empno, e.ename, e.sal, s.grade
FROM emp e
JOIN SALGRADE s
ON e.sal BETWEEN s.LOSAL AND s.HISAL 
WHERE e.sal > ALL(
	SELECT MAX(sal)
	FROM EMP
	WHERE job = 'SALESMAN'
)
ORDER BY e.empno;














