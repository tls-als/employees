<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>departmentsList</title>
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

	<!-- ���� -->
	<h1>departments ���̺� ���</h1>
	<%
		//���� ������ ���� ���� ���� ����. 1�������� �ʱ�ȭ
		int currentPage = 1;
		//1�������� ������ ���� ���� ����. 10������ �ʱ�ȭ
		int rowPerPage = 10;
		
		//request�κ��� �Ķ���� ���� null�� �ƴ� �� currentPage���� ����
		if(request.getParameter("currentPage") != null) {
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		
		//�˻��� dept_name(�μ���)�� �޴� ���� ����
		String searchDeptName = "";
		if(request.getParameter("searchDeptName") != null) {
			searchDeptName = request.getParameter("searchDeptName");
		}
		
		// 1. mariadb(sw)����� �� �ְ�
		Class.forName("org.mariadb.jdbc.Driver");	// new Driver();�� ����
		
		// 2. mariadb ����(�ּ�+��Ʈ�ѹ�+db�̸�, db���Ӱ���, db������ȣ)
		Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1004");
		System.out.println(conn+"<-conn");
		
		// 3. conn �ȿ� ����(sql)�� ���� stmt ������ ����
		String sql = "";
		
		//����������
		PreparedStatement stmt =  null;
		//���þ���(��� �μ� ��ȸ)
		if(searchDeptName.equals("")) {
			sql = "SELECT dept_no,dept_name FROM departments LIMIT ?,?";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, (currentPage-1)*rowPerPage);
			stmt.setInt(2, rowPerPage);	
		}
		//�μ� �̸��� �������� ��
		else {
			sql = "SELECT dept_no,dept_name FROM departments WHERE dept_name LIKE ? LIMIT ?,?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, "%"+searchDeptName+"%");
			stmt.setInt(2, (currentPage-1)*rowPerPage);
			stmt.setInt(3, rowPerPage);	
		}
		
		//�׽�Ʈ
		System.out.println(stmt+"<-stmt");
		
		// 4. ����(����)�� ������� ������ �´�
		ResultSet rs = stmt.executeQuery();
		System.out.println(rs+" <-rs");
		
		// 5. ���
		%>
		<!-- ��� -->
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
		<!-- ����¡ �׺���̼�(����,����) -->
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
				<a href="./departmentsList.jsp?currentPage=1&searchDeptName=<%=searchDeptName%>">ó������</a>
				<a href="./departmentsList.jsp?currentPage=<%=currentPage-1%>&searchDeptName=<%=searchDeptName%>">����</a>
			<%	
				}
				if(currentPage < lastPage) {
			%>		
					<a href="./departmentsList.jsp?currentPage=<%=currentPage+1%>&searchDeptName=<%=searchDeptName%>">����</a>
			<%		
				}
				if(currentPage != lastPage) {
			%>		
					<a href="./departmentsList.jsp?currentPage=<%=lastPage%>&searchDeptName=<%=searchDeptName%>">����������</a>
			<%		
				}
			%>
		</div>
		<!-- �μ� �̸� �˻��� -->

		<form method="post" action="./departmentsList.jsp">
			<div>
				�μ���:
				<input type="text" name="searchDeptName" value="<%=searchDeptName%>">
				<button type="submit">�˻�</button>
			</div>
		</form>
</body>
</html>