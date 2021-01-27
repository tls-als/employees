<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>deptManagerList</title>
</head>
<body>
	<!-- �޴� -->
	<div>
		<table border="1">
			<tr>
				<td><a href="./index.jsp">Ȩ����</a></td>
				<td><a href="./departmentsList.jsp">departments ���̺� ���</a></td>
				<td><a href="./deptEmpList.jsp">dept_emp ���̺� ���</a></td>
				<td><a href="./deptManagerList.jsp">dept_manager</a></td>
				<td><a href="./employeesList.jsp">employees</a></td>
				<td><a href="./salariesList.jsp">salaries</a></td>
				<td><a href="./titlesList.jsp">titles</a></td>
			</tr>
		</table>
	</div>
	
	<!-- deptManagerList ���� -->
	<h1>deptManagerList ���</h1>
	<%
		//���� ������ ���� ����
		int currentPage = 1;
		//���� ���� ���� ����
		int rowPerPage = 10;
		//request�� ���� ������ �� �ޱ�
		if(request.getParameter("currentPage") != null) {
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		//maria DB ���
		Class.forName("org.mariadb.jdbc.Driver");
		//maria DB ����
		Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1004");
		//���� ���๮
		String sql = "SELECT dept_no,emp_no,from_date,to_date FROM dept_manager ORDER BY dept_no DESC LIMIT ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, (currentPage-1)*rowPerPage);
		stmt.setInt(2, rowPerPage);
		//��� ��������
		ResultSet rs = stmt.executeQuery();
	%>
	<table border="1">
		<thead>
			<tr>
				<th>dept_no</th>
				<th>emp_no</th>
				<th>from_date</th>
				<th>to_date</th>
			</tr>
		</thead>
		<tbody>
			<%
				while(rs.next()) {
			%>
				<tr>
					<td><%=rs.getString("dept_no")%></td>
					<td><%=rs.getString("emp_no")%></td>
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
			//������ ����
			String sql2 = "select count(*) from employees";
			PreparedStatement stmt2 = conn.prepareStatement(sql2);
			ResultSet rs2 = stmt2.executeQuery();
			//��ü �� ����
			int totalCount = 0;
			if(rs2.next()) {
				totalCount = rs2.getInt("count(*)");
			}
			//������ ������
			int lastPage = totalCount/rowPerPage;
			if(totalCount%rowPerPage != 0) {
				lastPage += 1;
			}
			if(currentPage > 1) {
		%>	
				<a href="./deptManagerList.jsp?currentPage=1">ó������</a>
				<a href="./deptManagerList.jsp?currentPage=<%=currentPage-1%>">����</a>
		<%	
			}
			if(currentPage < lastPage) {
		%>		
				<a href="./deptManagerList.jsp?currentPage=<%=currentPage+1%>">����</a>
		<%		
			}
			if(currentPage != lastPage) {
		%>		
				<a href="./deptManagerList.jsp?currentPage=<%=lastPage%>">����������</a>
		<%		
			}
		%>
				
	</div>
</body>
</html>