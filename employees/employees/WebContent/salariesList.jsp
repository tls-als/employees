<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>salariesList</title>
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
	
	
	<h1>salariesList 목록</h1>
	
	<!-- 최대 급여 쿼리 -->
	<%
		//현재 페이지 값을 담을 변수 생성
		int currentPage = 1;
		//request로 보낸 페이지 값 받기
		if (request.getParameter("currentPage") != null) {
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		System.out.println(currentPage + "<-currentPage");
		//행의 개수를 담을 변수 생성
		int rowPerPage = 10;
		//시작되는 페이지
		int beginPage = (currentPage - 1) * rowPerPage;

		//mariadb 사용
		Class.forName("org.mariadb.jdbc.Driver");
		//maria 연결
		Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1004");
		// 최소,최대 연봉을 담는 변수
		int minSalary = 0;
		int maxSalary = 0;
		// 연봉 검색 위한 변수
		int beginSalary = 0;
		int endSalary = 0;
		
		//급여 최대값을 조회하는 쿼리
		String sql1 = "select min(salary),max(salary) from salaries";
		PreparedStatement stmt1 = conn.prepareStatement(sql1);
		ResultSet rs1 = stmt1.executeQuery();
		//최소 급여 받기
		if (rs1.next()) {
			minSalary = rs1.getInt("min(salary)");
			maxSalary = rs1.getInt("max(salary)");
			//시작 급여는 검색조건에 따라 변경가능
			beginSalary = minSalary;
			//마지막 급여는 검색조건에 따라 변경가능
			endSalary = maxSalary;
		}
		System.out.println(beginSalary + "<-minSalary");
		System.out.println(endSalary + "<-maxSalary");
		
		//입력받은 시작(최소) 급여 받기
		if (request.getParameter("beginSalary") != null) {
			beginSalary = Integer.parseInt(request.getParameter("beginSalary"));
		}
		//입력받은 마지막(최대) 급여 받기
		if (request.getParameter("endSalary") != null) {
			endSalary = Integer.parseInt(request.getParameter("endSalary"));
		}
	%>
	
	<!-- salariesList 내용(조회) -->
	<%
		//쿼리 실행문 conn에 담기(급여 조회)
		String sql2 = "SELECT emp_no,salary,from_date,to_date FROM salaries WHERE salary BETWEEN ? AND ? LIMIT ?,?";
		PreparedStatement stmt2 = conn.prepareStatement(sql2);
		stmt2.setInt(1, beginSalary);
		stmt2.setInt(2, endSalary);
		stmt2.setInt(3, beginPage);
		stmt2.setInt(4, rowPerPage);
		//쿼리 결과 가져오기
		ResultSet rs2 = stmt2.executeQuery();
		System.out.println(rs2 + "<-rs2");
	%>
	
	<!-- 급여 검색을 위한 폼 -->
	<form method="post" action="./salariesList.jsp">
		최소 급여:
		<select name="beginSalary">
			<%
				int between = 10000;
			
				for(int i=minSalary; i<maxSalary; i=i+10000) {
					if(beginSalary == i) {
			%>
						<option value=<%=i%> selected="selected"><%=i%></option>
			<%
					}else {
			%>	
						<option value=<%=i%>><%=i%></option>
			<%			
					}
				}
			%>
		</select>
		최대 급여:
		<select name="endSalary">
			<%
				for(int i=maxSalary; i>minSalary; i=i-10000) {
					if(endSalary == i) {
			%>
						<option value=<%=i%> selected="selected"><%=i%></option>
			<%
					}else {
			%>	
						<option value=<%=i%>><%=i%></option>
			<%			
					}
				}
			System.out.println(minSalary+"최소급여");
			System.out.println(maxSalary+"최대급여");
			System.out.println(beginSalary+"최소급여");
			System.out.println(endSalary+"최대급여");
			%>
		</select>
		<button type="submit">검색</button>
	</form>
		
	<!-- salariesList 출력하는 폼 -->
	<table border="1">
		<thead>
			<tr>
				<th>emp_no</th>
				<th>salary</th>
				<th>from_date</th>
				<th>to_date</th>
			</tr>
		</thead>
		<tbody>
			<%
				while(rs2.next()) {
			%>
				<tr>
					<td><%=rs2.getString("emp_no")%></td>
					<td><%=rs2.getString("salary")%></td>
					<td><%=rs2.getString("from_date")%></td>
					<td><%=rs2.getString("to_date")%></td>
				</tr>
			<%
				}
			%>
		</tbody>
	</table>
	<!-- 페이징 네비게이션 생성 -->
	<div>
		<%
			//모든 행의 수를 구하는 쿼리문 생성
			String sql3 = "select count(*) from employees";
			PreparedStatement stmt3 = conn.prepareStatement(sql3);
			//쿼리문 실행
			ResultSet rs3 = stmt3.executeQuery();
			//전체 행의 개수를 담는 변수
			int totalCount = 0;
			if(rs3.next()) {
				totalCount = rs3.getInt("count(*)");
			}
			//마지막 페이지를 담는 변수
			int lastPage = totalCount/rowPerPage;
			if(totalCount%rowPerPage != 0) {
				lastPage +=1;
			}
			
			if(currentPage > 1) {
		%>
				<a href="./salariesList.jsp?currentPage=1&beginSalary=<%=beginSalary%>&endSalary=<%=endSalary%>">처음으로</a>
				<a href="./salariesList.jsp?currentPage=<%=currentPage-1%>&beginSalary=<%=beginSalary%>&endSalary=<%=endSalary%>">이전</a>
		<%
			}
			if(currentPage < lastPage) {
		%>
				<a href="./salariesList.jsp?currentPage=<%=currentPage+1%>&beginSalary=<%=beginSalary%>&endSalary=<%=endSalary%>">다음</a>
		<%		
			}
			if(currentPage != lastPage) {
		%>		
				<a href="./salariesList.jsp?currentPage=<%=lastPage%>&beginSalary=<%=beginSalary%>&endSalary=<%=endSalary%>">마지막으로</a>
		<%		
			}
		%>					
	</div>
</body>
</html>