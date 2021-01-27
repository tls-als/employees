<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>departmentsList</title>
</head>
<body>
	<!-- 메뉴 -->
	<div>
		<table border="1">
			<tr>
				<td><a href="./index.jsp">홈으로</a></td>
				<td><a href="./departmentsList.jsp">departments 테이블 목록</a></td>
				<td><a href="./deptEmpList.jsp">dept_emp 테이블 목록</a></td>
				<td><a href="./deptManagerList.jsp">dept_manager</a></td>
				<td><a href="./employeesList.jsp">employees</a></td>
				<td><a href="./salariesList.jsp">salaries</a></td>
				<td><a href="./titlesList.jsp">titles</a></td>
			</tr>
		</table>
	</div>

	<!-- 내용 -->
	<h1>departments 테이블 목록</h1>
	<%
		//현재 페이지 값을 담은 변수 생성. 1페이지로 초기화
		int currentPage = 1;
		//1페이지에 보여질 행의 변수 생성. 10행으로 초기화
		int rowPerPage = 10;
		
		//request로부터 파라메터 값이 null이 아닐 때 currentPage값을 받음
		if(request.getParameter("currentPage") != null) {
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		
		//검색할 dept_name(부서명)을 받는 변수 생성
		String searchDeptName = "";
		if(request.getParameter("searchDeptName") != null) {
			searchDeptName = request.getParameter("searchDeptName");
		}
		
		// 1. mariadb(sw)사용할 수 있게
		Class.forName("org.mariadb.jdbc.Driver");	// new Driver();와 같다
		
		// 2. mariadb 접속(주소+포트넘버+db이름, db접속계정, db계정암호)
		Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1004");
		System.out.println(conn+"<-conn");
		
		// 3. conn 안에 쿼리(sql)를 만들어서 stmt 변수에 저장
		String sql = "";
		
		//동적쿼리문
		PreparedStatement stmt =  null;
		//선택안함(모든 부서 조회)
		if(searchDeptName.equals("")) {
			sql = "SELECT dept_no,dept_name FROM departments LIMIT ?,?";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, (currentPage-1)*rowPerPage);
			stmt.setInt(2, rowPerPage);	
		}
		//부서 이름을 선택했을 때
		else {
			sql = "SELECT dept_no,dept_name FROM departments WHERE dept_name LIKE ? LIMIT ?,?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, "%"+searchDeptName+"%");
			stmt.setInt(2, (currentPage-1)*rowPerPage);
			stmt.setInt(3, rowPerPage);	
		}
		
		//테스트
		System.out.println(stmt+"<-stmt");
		
		// 4. 쿼리(실행)의 결과물을 가지고 온다
		ResultSet rs = stmt.executeQuery();
		System.out.println(rs+" <-rs");
		
		// 5. 출력
		%>
		<!-- 출력 -->
		<table border="1">
			<thead>
				<tr>
					<th>dept_no</th>
					<th>dept_name</th>
				</tr>
			</thead>
			<tbody>
				<%
					while(rs.next()) {
				%>
						<tr>
							<td><%=rs.getString("dept_no")%></td>
							<td><%=rs.getString("dept_name")%></td>
						</tr>					
				<%
					}
				%>
			</tbody>
		</table>
		<!-- 페이징 네비게이션(이전,다음) -->
		<div>
			<%
				//쿼리문 생성
				String sql2 = "select count(*) from employees";
				PreparedStatement stmt2 = conn.prepareStatement(sql2);
				ResultSet rs2 = stmt2.executeQuery();
				//전체 행 변수
				int totalCount = 0;
				if(rs2.next()) {
					totalCount = rs2.getInt("count(*)");
				}
				//마지막 페이지
				int lastPage = totalCount/rowPerPage;
				if(totalCount%rowPerPage != 0) {
					lastPage += 1;
				}
				if(currentPage > 1) {
			%>
				<a href="./departmentsList.jsp?currentPage=1&searchDeptName=<%=searchDeptName%>">처음으로</a>
				<a href="./departmentsList.jsp?currentPage=<%=currentPage-1%>&searchDeptName=<%=searchDeptName%>">이전</a>
			<%	
				}
				if(currentPage < lastPage) {
			%>		
					<a href="./departmentsList.jsp?currentPage=<%=currentPage+1%>&searchDeptName=<%=searchDeptName%>">다음</a>
			<%		
				}
				if(currentPage != lastPage) {
			%>		
					<a href="./departmentsList.jsp?currentPage=<%=lastPage%>&searchDeptName=<%=searchDeptName%>">마지막으로</a>
			<%		
				}
			%>
		</div>
		<!-- 부서 이름 검색폼 -->

		<form method="post" action="./departmentsList.jsp">
			<div>
				부서명:
				<input type="text" name="searchDeptName" value="<%=searchDeptName%>">
				<button type="submit">검색</button>
			</div>
		</form>
</body>
</html>