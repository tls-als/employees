<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1004");
	String sql1 = "select max(salary) from salaries";
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	ResultSet rs1 = stmt1.executeQuery();
	
	int beginSalary = 0;	//시작 급여
	int endSalary = 0;		//마지막 급여
	int maxSalary = 0;		//최대 급여
	
	int currentPage = 1;	//현재 페이지
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 10;	//한 페이지에 출력되는 페이지
	int beginPage = (currentPage-1)*rowPerPage;	//시작되는 페이지
	
	//마지막급여 변수에 최대 급여 값 대입
	if(rs1.next()) {
		maxSalary = rs1.getInt("max(salary)");
		endSalary = maxSalary;
	}
	//시작 급여 파라메터
	if
	(request.getParameter("beginSalary") != null) {
		beginSalary = Integer.parseInt(request.getParameter("beginSalary"));
	}
	//마지막 급여 파라메터
	if(request.getParameter("endSalary") != null) {
		endSalary = Integer.parseInt(request.getParameter("endSalary"));
	}
	//급여 사이값 구하는 쿼리
	String sql2 = "select * from salaries where salary between ? and ? limit ?,?";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt2.setInt(1, beginSalary);
	stmt2.setInt(2, endSalary);
	stmt2.setInt(3, beginPage);
	stmt2.setInt(4, rowPerPage);
	ResultSet rs2 = stmt2.executeQuery();
	
	System.out.println(beginSalary + "beginSalary");
	System.out.println(endSalary + "endSalary");
%>
	<h1>salaries 목록</h1>
	<table border="1">
		<tr>
			<th>emp_no</th>
			<th>salary</th>
			<th>from_date</th>
			<th>to_date</th>
		</tr>
		<%
			while(rs2.next()) {
		%>		
				<tr>
					<td><%=rs2.getInt("emp_no")%></td>
					<td><%=rs2.getInt("salary")%></td>
					<td><%=rs2.getString("from_date")%></td>
					<td><%=rs2.getString("to_date")%></td>
				</tr>	
		<%
			}
		%>
	</table>

	<div>
		<%
			String sql3 = "select count(*) from salaries";
			PreparedStatement stmt3 = conn.prepareStatement(sql3);
			ResultSet rs3 = stmt3.executeQuery();

			int totalPage = 0;
			if (rs3.next()) {
				totalPage = rs3.getInt("count(*)");
			}
			int lastPage = totalPage / rowPerPage;
			if (totalPage % rowPerPage != 0) {
				lastPage += 1;
			}

			if (currentPage > 1) {
		%>
				<a href="./salariesListTest.jsp?currentPage=1">처음으로</a> 
				<a href="./salariesListTest.jsp?currentPage=<%=currentPage - 1%>">이전</a>
		<%
			}
			if (currentPage < lastPage) {
		%>
				<a href="./salariesListTest.jsp?currentPage=<%=currentPage + 1%>">다음</a>
				<a href="./salariesListTest.jsp?currentPage=<%=lastPage%>">마지막으로</a>
		<%
			}
			System.out.println(currentPage+"현재페이지");
			System.out.println(lastPage+"마지막페이지");
		%>
	</div>
	<form method="post" action="./salariesListTest.jsp">
		<select name="beginSalary">
			<%
				for(int i=0; i<maxSalary; i=i+10000){
			%>
					<option value="<%=i%>"><%=i%></option>
			<%
				}
			%>
		</select>
		<select name="endSalary">
			<%
				for(int i=maxSalary; i>0; i=i-10000){
			%>
					<option value="<%=i%>"><%=i%></option>
			<%
				}
			%>
		</select>
		<button type="submit">검색</button>
	</form>
</body>
</html>