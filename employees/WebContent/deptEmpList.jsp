<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="EUC-KR">
	<title>deptEmpList</title>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">	
</head>
<body>
	<!-- 메뉴 -->
	<nav class="navbar navbar-expand-sm bg-primary navbar-dark">
		<ul class="navbar-nav">
			<li class="nav-item active">
			  	<a class="nav-link" href="./index.jsp">홈으로</a>
			</li>
			<li class="nav-item">
			  	<a class="nav-link" href="./departmentsList.jsp">departments</a>
			</li>
			<li class="nav-item">
			  	<a class="nav-link" href="./deptEmpList.jsp">dept_emp</a>
			</li>
			<li class="nav-item">
			  	<a class="nav-link" href="./deptManagerList.jsp">dept_manager</a>
			</li>
			<li class="nav-item">
			  	<a class="nav-link" href="./employeesList.jsp">employees</a>
			</li>
			<li class="nav-item">
			  	<a class="nav-link" href="./salariesList.jsp">salaries</a>
			</li>
			<li class="nav-item">
			  	<a class="nav-link" href="./titlesList.jsp">titles</a>
			</li>
		</ul>
	</nav>
	
	<!-- deptEmpList 테이블 목록 -->
	<div class="container" style="margin-top: 20px">
		<h1>deptEmpList 테이블 목록</h1>
		<%
			// 현재 페이지 변수 생성
			int currentPage = 1;
			// request로 보낸 페이지 값 받기
			if(request.getParameter("currentPage") != null) {
				currentPage = Integer.parseInt(request.getParameter("currentPage"));
			}
			// 보여질 행의 수
			int rowPerPage = 10;
			
			
			//재직중이지 않는 사람을 체크하는 변수
			String check = "no";
			if(request.getParameter("check") != null) {
				check = request.getParameter("check");
			}
			
			//부서 번호를 담는 변수
			String deptNo = "";
			if(request.getParameter("deptNo") != null) {
				deptNo = request.getParameter("deptNo");
			}
			
			//Mariadb 사용
			Class.forName("org.mariadb.jdbc.Driver");
			//mariadb 접속
			Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1004");
			//쿼리 실행문
			String sql = "";
			PreparedStatement stmt = null;
			
			//재직,부서 둘다 체크 안한 경우
			if(check.equals("no") && deptNo.equals("")) {
				sql = "SELECT emp_no,dept_no,from_date,to_date FROM dept_emp ORDER BY emp_no desc LIMIT ?, ?";
				stmt = conn.prepareStatement(sql);
				stmt.setInt(1, (currentPage-1)*rowPerPage);
				stmt.setInt(2, rowPerPage);
			}
			//재직만 체크한 경우
			else if(!check.equals("no") && deptNo.equals("")) {
				sql = "SELECT emp_no,dept_no,from_date,to_date FROM dept_emp where to_date='9999-01-01' ORDER BY emp_no desc LIMIT ?, ?";
				stmt = conn.prepareStatement(sql);
				stmt.setInt(1, (currentPage-1)*rowPerPage);
				stmt.setInt(2, rowPerPage);
			}		
			//부서만 체크한 경우
			else if(check.equals("no") && !deptNo.equals("")) {
				sql = "SELECT emp_no,dept_no,from_date,to_date FROM dept_emp where dept_no = ? ORDER BY emp_no desc LIMIT ?, ?";
				stmt = conn.prepareStatement(sql);
				stmt.setString(1, deptNo);
				stmt.setInt(2, (currentPage-1)*rowPerPage);
				stmt.setInt(3, rowPerPage);
			}
			//둘다 체크한 경우
			else {
				sql = "SELECT emp_no,dept_no,from_date,to_date FROM dept_emp where to_date='9999-01-01' and dept_no = ? ORDER BY emp_no desc LIMIT ?, ?";
				stmt = conn.prepareStatement(sql);
				stmt.setString(1, deptNo);
				stmt.setInt(2, (currentPage-1)*rowPerPage);
				stmt.setInt(3, rowPerPage);
			}
			//쿼리 결과 가져오기
			ResultSet rs = stmt.executeQuery();
		%>
		<!-- 검색폼 -->
		<form method="post" action="./deptEmpList.jsp">
			<div>
				<%
					String sqlDeptNo = "select dept_no from departments";
					PreparedStatement stmtDeptNo = conn.prepareStatement(sqlDeptNo);
					ResultSet rsDeptNo = stmtDeptNo.executeQuery();
					
					if(check.equals("no")){
				%>
						<input type="checkbox" name="check" value="yes"> 부서에서 현재 근무 여부
				<%
					}else {
				%>
						<input type="checkbox" name="check" value="yes" checked="checked"> 부서에서 현재 근무 여부
				<%
					}
				%>
			</div>
			<div class="input-group">
				<select class="form-control col-2" name="deptNo">
					<option value="">선택안함</option>
					<%
						while(rsDeptNo.next()) {
							if(deptNo.equals(rsDeptNo.getString("dept_no"))){
					%>
								<option value="<%=rsDeptNo.getString("dept_no")%>" selected="selected"><%=rsDeptNo.getString("dept_no")%></option>
					<%			
							}else {
					%>
								<option value="<%=rsDeptNo.getString("dept_no")%>"><%=rsDeptNo.getString("dept_no")%></option>
					<%				
							}
						}
					%>
				</select>
				<div class="input-group-append">
					<button class="btn btn-secondary" type="submit">검색</button>
				</div>
			</div>
		</form>
		<!-- 테이블로 출력하기 -->
		<table class="table table-bordered mt-3">
			<thead>
				<tr>
					<th>emp_no</th>
					<th>dept_no</th>
					<th>from_date</th>
					<th>to_date</th>
				</tr>
			</thead>
			<tbody>
				<%
					while(rs.next()) {
				%>
					<tr>
						<th><%=rs.getString("emp_no") %></th>
						<th><%=rs.getString("dept_no") %></th>
						<th><%=rs.getString("from_date") %></th>
						<th><%=rs.getString("to_date") %></th>
					</tr>
				<%
					}
				%>
			</tbody>
		</table>
		<!-- 페이징 네비게이션 생성 -->
		<div style="margin-bottom: 20px;">
			<%
				// 쿼리문 생성
				String sql2 = null;
				System.out.println("선택된 부서: "+deptNo);
				System.out.println("체크된 값: "+check);
				// 재직이 체크된 경우
				if(!check.equals("no") && deptNo.equals("")) {
					sql2 = "select count(*) from dept_emp where to_date='9999-01-01'";
				}
				// 부서가 체크된 경우
				else if(check.equals("no") && !deptNo.equals("")) {
					String getNo = request.getParameter("deptNo");
					sql2 = "select count(*) from dept_emp where dept_no='"+getNo+"'";
				}
				// 재직,부서 둘다 체크된 경우
				else if(!check.equals("no") && !deptNo.equals("")) {
					String getNo = request.getParameter("deptNo");
					sql2 = "select count(*) from dept_emp where dept_no='"+getNo+"' AND to_date='9999-01-01'";
				}
				// 둘다 체크가 안 된 경우
				else {
					sql2 = "select count(*) from dept_emp";
				}
				PreparedStatement stmt2 = conn.prepareStatement(sql2);
				ResultSet rs2 = stmt2.executeQuery();
				// 전체 행 변수
				int totalCount = 0;
				if(rs2.next()) {
					totalCount = rs2.getInt("count(*)");
				}
				// 마지막 페이지
				int lastPage = totalCount/rowPerPage;
				if(totalCount%rowPerPage != 0) {
					lastPage += 1;
				}

				if(currentPage == 1 && lastPage != 1) {
			%>
					<a href="./deptEmpList.jsp?currentPage=<%=currentPage+1%>&check=<%=check%>&deptNo=<%=deptNo%>">다음</a>
					<a href="./deptEmpList.jsp?currentPage=<%=lastPage%>&check=<%=check%>&deptNo=<%=deptNo%>">마지막으로</a>
			<%
				}
				if(currentPage > 1) {		
			%>	
					<a href="./deptEmpList.jsp?currentPage=1&check=<%=check%>&deptNo=<%=deptNo%>">처음으로</a>
					<a href="./deptEmpList.jsp?currentPage=<%=currentPage-1%>&check=<%=check%>&deptNo=<%=deptNo%>">이전</a>
			<%	
				}
				if(currentPage != 1 && currentPage < lastPage) {
			%>		
					<a href="./deptEmpList.jsp?currentPage=<%=currentPage+1%>&check=<%=check%>&deptNo=<%=deptNo%>">다음</a>
			<%		
				}
				if(currentPage != 1 && currentPage != lastPage) {
			%>		
					<a href="./deptEmpList.jsp?currentPage=<%=lastPage%>&check=<%=check%>&deptNo=<%=deptNo%>">마지막으로</a>
			<%
				}
			%>
		</div>
	</div>
</body>
</html>