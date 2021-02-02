<%@page import="org.mariadb.jdbc.internal.com.read.dao.Results"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="EUC-KR">
	<title>titlesList</title>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<!-- �޴� -->
	<nav class="navbar navbar-expand-sm bg-primary navbar-dark">
		<ul class="navbar-nav">
			<li class="nav-item active">
			  	<a class="nav-link" href="./index.jsp">Ȩ����</a>
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
	
	<!-- salariesList ���� -->
	<div class="container" style="margin-top: 20px">
		<h1>titlesList ���</h1>
		<%
			//���� ������ ���� ���� ���� ����
			int currentPage = 1;
			 //���� ������ ���� ���� ����
			int rowPerPage = 10;
			//request�� ���� ������ �� �ޱ�
			if(request.getParameter("currentPage") != null) {
				currentPage = Integer.parseInt(request.getParameter("currentPage"));
			}
			//maria ���
			Class.forName("org.mariadb.jdbc.Driver");
			//maria ����
			Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1004");
			//���� ���๮
			String sql = "SELECT emp_no,title,from_date,to_date FROM titles ORDER BY emp_no ASC LIMIT ?, ?";
			PreparedStatement stmt = conn.prepareStatement(sql);
			stmt.setInt(1, (currentPage-1)*rowPerPage);
			stmt.setInt(2, rowPerPage);
			//���� ���
			ResultSet rs = stmt.executeQuery();
		%>
		
		<table class="table table-bordered mt-3">
			<thead>
				<tr>
					<th>emp_no</th>
					<th>title</th>
					<th>from_date</th>
					<th>to_date</th>
				</tr>
			</thead>
			<tbody>
				<%
					while(rs.next()) {
				%>
					<tr>
						<td><%=rs.getString("emp_no")%></td>
						<td><%=rs.getString("title")%></td>
						<td><%=rs.getString("from_date")%></td>
						<td><%=rs.getString("to_date")%></td>
					</tr>
				<%
					}
				%>
			</tbody>
		</table>
		<div>
			<%
				//1������������ ó������,���� ��Ÿ���� ����
				if(currentPage > 1) {
			%>
					<a href="./titlesList.jsp?currentPage=1">ó������</a>
					<a href="./titlesList.jsp?currentPage=<%=currentPage-1%>">����</a>
			<%
				}
				//��ü ���� ������ ���ϴ� ������ ����
				String sql2 = "select count(*) from titles";
				PreparedStatement stmt2 = conn.prepareStatement(sql2);
				ResultSet rs2 = stmt2.executeQuery();
				// ��ü ���� ������ ��� ����(���� ���� ��츦 ����)
				int totalCount = 0;
				if(rs2.next()) {
					totalCount = rs2.getInt("count(*)");
				}
				//������ �������� ��� ���� ����
				int lastPage = totalCount/rowPerPage;
				//�� ���� ����%�� ������ ��(10��) �������� ���� ���
				if(totalCount%rowPerPage != 0) {
					lastPage += 1;
				}
				if(currentPage < lastPage) {
			%>
					<a href="./titlesList.jsp?currentPage=<%=currentPage+1%>">����</a>	
			<%
				}
				if(currentPage != lastPage) {
			%>
					<a href="./titlesList.jsp?currentPage=<%=lastPage%>">����������</a>
			<%		
				}
			%>		
		</div>
	</div>
</body>
</html>