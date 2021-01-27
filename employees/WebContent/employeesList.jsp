<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Calendar" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>employeesList</title>
</head>
<body>
	<%
		request.setCharacterEncoding("EUC-KR");
	%>
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
	
	<!-- employees 테이블 목록 -->
	<h1>employees 테이블 목록</h1>
	<%
		// 현재 페이지 값을 받을 변수 생성
		int currentPage = 1;
		// request로 보낸 페이지의 파라메터 값을 받음
		if(request.getParameter("currentPage") != null){
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		// 한 페이지에 보일 행의 개수 변수 생성
		int rowPerPage = 10;
		
		//검색할 성별을 받는 변수
		String searchGender = "";
		if(request.getParameter("searchGender") != null) {
			searchGender = request.getParameter("searchGender");
			//searchGender = new String(searchGender.getBytes("8859_1"),"euc-kr");	//한글 깨짐 해결
		}
		System.out.println(searchGender + "<-searchGender");
		
		//검색할 이름을 받는 변수
		String searchName = "";
		if(request.getParameter("searchName") != null) {
			searchName = request.getParameter("searchName");
		}
		System.out.println(searchName + "<-searchGender");
		
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1004");
		String sql = "";
		//동적쿼리 생성
		PreparedStatement stmt = null;
		//아무것도 선택하지 않을 때
		if(searchGender.equals("") && searchName.equals("")) {
			sql = "select emp_no,birth_date,first_name,last_name,gender,hire_date from employees order by emp_no desc limit ?,?";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, (currentPage-1)*rowPerPage);
			stmt.setInt(2, rowPerPage);
		}
		// 성별만 선택했을 때
		else if (!searchGender.equals("") && searchName.equals("")) {
			sql = "select emp_no,birth_date,first_name,last_name,gender,hire_date from employees where gender = ? order by emp_no desc limit ?,?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, searchGender);
			stmt.setInt(2, (currentPage - 1) * rowPerPage);
			stmt.setInt(3, rowPerPage);
		}
		// name만 선택했을 때
		else if (searchGender.equals("") && !searchName.equals("")) {
			sql = "select emp_no,birth_date,first_name,last_name,gender,hire_date from employees where first_name like ? or last_name like ? order by emp_no desc limit ?,?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, "%"+searchName+"%");
			stmt.setString(2, "%"+searchName+"%");
			stmt.setInt(3, (currentPage - 1) * rowPerPage);
			stmt.setInt(4, rowPerPage);
		}
		// 성별과 이름 선택했을 때
		else {
			// &&연산자보다  || 연산자의 우선순위가 낮아 ()로 묶어줘서 출력
			sql = "select emp_no,birth_date,first_name,last_name,gender,hire_date from employees where gender=? and (first_name like ? or last_name like ?) order by emp_no desc limit ?,?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, searchGender);
			stmt.setString(2, "%" + searchName + "%");
			stmt.setString(3, "%" + searchName + "%");
			stmt.setInt(4, (currentPage - 1) * rowPerPage);
			stmt.setInt(5, rowPerPage);
		}

		ResultSet rs = stmt.executeQuery();
	%>
	<table border="1">
		<thead>
			<tr>
				<th>emp_no</th>
				<th>birth_date</th>
				<th>age</th>
				<th>first_name</th>
				<th>last_name</th>
				<th>gender</th>
				<th>hire_date</th>
			</tr>
		</thead>
		<tbody>
			<%
				//현재 날짜 가져오기
				Calendar cal = Calendar.getInstance();
			
				while(rs.next()) {
					//현재 년도 변수에 담기
					int nowYear = cal.get(Calendar.YEAR);
					//생일 날짜 담기
					String birthDate = rs.getString("birth_date");
					//문자열 자르기
					String birthYear = birthDate.substring(0,4);
			%>
				<tr>
					<td><%=rs.getString("emp_no") %></td>
					<td><%=birthDate%></td>
					<td>
						<%=nowYear-Integer.parseInt(birthYear)%>
					</td>
					<td><%=rs.getString("first_name") %></td>
					<td><%=rs.getString("last_name") %></td>
					<td>
					<%
						if(rs.getString("gender").equals("M")) {
					%>
							남자
					<%
						}else {
					%>
							여자
					<%
						}
					%>
					</td>
					<td><%=rs.getString("hire_date") %></td>
				</tr>
			<%
				}
			%>
		</tbody>
	</table>
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
				<a href="./employeesList.jsp?currentPage=1&searchGender=<%=searchGender%>&searchName=<%=searchName%>">처음으로</a>
				<a href="./employeesList.jsp?currentPage=<%=currentPage-1%>&searchGender=<%=searchGender%>&searchName=<%=searchName%>">이전</a>
		<%
			}
			if(currentPage < lastPage) {
		%>
				<a href="./employeesList.jsp?currentPage=<%=currentPage+1%>&searchGender=<%=searchGender%>&searchName=<%=searchName%>">다음</a>
		<%		
			}
			if(currentPage != lastPage) {
		%>		
				<a href="./employeesList.jsp?currentPage=<%=lastPage%>&searchGender=<%=searchGender%>&searchName=<%=searchName%>">마지막으로</a>
		<%		
			}
		%>		
	</div>
	<!-- 검색폼 -->	
	<form method="post" action="./employeesList.jsp">
		<div>
			성별:
			<select name="searchGender">
				<%
					if(searchGender.equals("")) {
				%>
						<option value="" selected="selected">선택안함</option>
				<%		
					}else {
				%>
						<option value="">선택안함</option>
				<%
					}
				%>
				<%
					if(searchGender.equals("M")) {
				%>
						<option value="M" selected="selected">남자</option>
				<%		
					}else {
				%>
						<option value="M">남자</option>
				<%
					}
				%>
				<%
					if(searchGender.equals("F")) {
				%>
						<option value="F" selected="selected">여자</option>
				<%		
					}else {
				%>
						<option value="F">여자</option>
				<%
					}
				%>
			</select>
			이름 :
			<input type="text" name="searchName" value="<%=searchName%>">
			<button type="submit">검색</button>
		</div>
	</form>
</body>
</html>