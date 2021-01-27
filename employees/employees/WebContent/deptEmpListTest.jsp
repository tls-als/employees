<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>dept_emp 목록</h1>
	<%
		int currentPage = 1;	//currentPage가 넘어오지 않으면
		if(request.getParameter("currentPage") != null) {
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		String ck = "no";	//현재 재직 아닌 사람은 보지 않겠다
		if(request.getParameter("ck") != null) {
			ck = request.getParameter("ck");
		}
		System.out.println(ck);
		
		String deptNo = "";
		if(request.getParameter("deptNo") != null) {
			deptNo = request.getParameter("deptNo");
		}
		System.out.println(deptNo);
		
		int rowPerPage = 10;
		int beginRow = (currentPage-1)*rowPerPage;
		
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1004");
		String sql1 = "";
		
		if(ck.equals("no") && (deptNo.equals(""))) {
			sql1 = "select emp_no,dept_no,from_date,to_date from dept_emp limit ?,?";
		} else if(ck.equals("no") && (deptNo.equals(""))) {
			sql1 = "select emp_no,dept_no,from_date,to_date from dept_emp where to_date='9999-01-01' limit ?,?";
		} else if(ck.equals("yes") && (deptNo.equals(""))) {
			sql1 = "select emp_no,dept_no,from_date,to_date from dept_emp where to_date='9999-01-01' limit ?,?";
		}else {
			sql1 = "select emp_no,dept_no,from_date,to_date from dept_emp where to_date='9999-01-01' limit ?,?";
		}
		
		PreparedStatement stmt1 = conn.prepareStatement(sql1);
		stmt1.setInt(1, beginRow);
		stmt1.setInt(2, rowPerPage);
		ResultSet rs1 = stmt1.executeQuery();
		
		String sql2 = "select dept_no from departments";
		PreparedStatement stmt2 = conn.prepareStatement(sql2);
		ResultSet rs2 = stmt2.executeQuery();
	%>
	<form method="post" action="./deptEmpListTest.jsp">
		<%
			if(ck.equals("no")) {
		%>		
				<input type="checkbox" name="ck" value="yes">현재 부서에 근무중
		<%		
			}else {
		%>		
				<input type="checkbox" name="ck" value="yes" checked="checked">현재 부서에 근무중
		<%
			}
		%>
	
		
		<select name="deptNo">
			<option value="">선택안함</option>
			<%
					while(rs2.next()) {
						if(deptNo.equals(rs2.getString("dept_no"))) {
			%>	
							<option value="<%=rs2.getString("dept_no")%>" selected="selected"><%=rs2.getString("dept_no")%></option>	
			<%		
					}else {
			%>	
					<option value="<%=rs2.getString("dept_no")%>"><%=rs2.getString("dept_no")%></option>	
			<%
					}
				}
			%>
		</select>
		<button type="submit">검색</button>
	</form>
	
	<table border="1">
		<tr>
			<th>emp_no</th>
			<th>dept_no</th>
			<th>from_date</th>
			<th>to_date</th>
		</tr>
		<%
			while(rs1.next()) {
		%>
				<tr>
					<td><%=rs1.getInt("emp_no")%></td>
					<td><%=rs1.getString("dept_no")%></td>
					<td><%=rs1.getString("from_date")%></td>
					<td><%=rs1.getString("to_date")%></td>
				</tr>
		<%
			}
		%>
	</table>
</body>
</html>