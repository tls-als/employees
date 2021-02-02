<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Calendar" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="EUC-KR">
	<title>employeesList</title>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<%
		request.setCharacterEncoding("EUC-KR");
	%>
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
	
	<!-- employees ���̺� ��� -->
	<div class="container" style="margin-top: 20px">
		<h1>employees ���̺� ���</h1>
		<%
			// ���� ������ ���� ���� ���� ����
			int currentPage = 1;
			// request�� ���� �������� �Ķ���� ���� ����
			if(request.getParameter("currentPage") != null){
				currentPage = Integer.parseInt(request.getParameter("currentPage"));
			}
			// �� �������� ���� ���� ���� ���� ����
			int rowPerPage = 10;
			
			//�˻��� ������ �޴� ����
			String searchGender = "";
			if(request.getParameter("searchGender") != null) {
				searchGender = request.getParameter("searchGender");
				//searchGender = new String(searchGender.getBytes("8859_1"),"euc-kr");	//�ѱ� ���� �ذ�
			}
			System.out.println(searchGender + "<-searchGender");
			
			//�˻��� �̸��� �޴� ����
			String searchName = "";
			if(request.getParameter("searchName") != null) {
				searchName = request.getParameter("searchName");
			}
			System.out.println(searchName + "<-searchGender");
			
			Class.forName("org.mariadb.jdbc.Driver");
			Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1004");
			String sql = "";
			//�������� ����
			PreparedStatement stmt = null;
			//�ƹ��͵� �������� ���� ��
			if(searchGender.equals("") && searchName.equals("")) {
				sql = "select emp_no,birth_date,first_name,last_name,gender,hire_date from employees order by emp_no desc limit ?,?";
				stmt = conn.prepareStatement(sql);
				stmt.setInt(1, (currentPage-1)*rowPerPage);
				stmt.setInt(2, rowPerPage);
			}
			// ������ �������� ��
			else if (!searchGender.equals("") && searchName.equals("")) {
				sql = "select emp_no,birth_date,first_name,last_name,gender,hire_date from employees where gender = ? order by emp_no desc limit ?,?";
				stmt = conn.prepareStatement(sql);
				stmt.setString(1, searchGender);
				stmt.setInt(2, (currentPage - 1) * rowPerPage);
				stmt.setInt(3, rowPerPage);
			}
			// name�� �������� ��
			else if (searchGender.equals("") && !searchName.equals("")) {
				sql = "select emp_no,birth_date,first_name,last_name,gender,hire_date from employees where first_name like ? or last_name like ? order by emp_no desc limit ?,?";
				stmt = conn.prepareStatement(sql);
				stmt.setString(1, "%"+searchName+"%");
				stmt.setString(2, "%"+searchName+"%");
				stmt.setInt(3, (currentPage - 1) * rowPerPage);
				stmt.setInt(4, rowPerPage);
			}
			// ������ �̸� �������� ��
			else {
				// &&�����ں���  || �������� �켱������ ���� ()�� �����༭ ���
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
		<!-- �˻��� -->	
		<form method="post" action="./employeesList.jsp">
			<div class="input-group mb-3">
				���� :
				<select class="form-control col-2" name="searchGender">
					<%
						if(searchGender.equals("")) {
					%>
							<option value="" selected="selected">���þ���</option>
					<%		
						}else {
					%>
							<option value="">���þ���</option>
					<%
						}
					%>
					<%
						if(searchGender.equals("M")) {
					%>
							<option value="M" selected="selected">����</option>
					<%		
						}else {
					%>
							<option value="M">����</option>
					<%
						}
					%>
					<%
						if(searchGender.equals("F")) {
					%>
							<option value="F" selected="selected">����</option>
					<%		
						}else {
					%>
							<option value="F">����</option>
					<%
						}
					%>
				</select>&nbsp;
				�̸� :
				<input class="form-control col-2" type="text" name="searchName" value="<%=searchName%>">
				<button class="btn btn-secondary" type="submit">�˻�</button>
			</div>
		</form>
		<!-- ���̺� -->
		<table class="table table-bordered mt-3">
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
					//���� ��¥ ��������
					Calendar cal = Calendar.getInstance();
				
					while(rs.next()) {
						//���� �⵵ ������ ���
						int nowYear = cal.get(Calendar.YEAR);
						//���� ��¥ ���
						String birthDate = rs.getString("birth_date");
						//���ڿ� �ڸ���
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
								����
						<%
							}else {
						%>
								����
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
		<div style="margin-bottom: 20px;">
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
					<a href="./employeesList.jsp?currentPage=1&searchGender=<%=searchGender%>&searchName=<%=searchName%>">ó������</a>
					<a href="./employeesList.jsp?currentPage=<%=currentPage-1%>&searchGender=<%=searchGender%>&searchName=<%=searchName%>">����</a>
			<%
				}
				if(currentPage < lastPage) {
			%>
					<a href="./employeesList.jsp?currentPage=<%=currentPage+1%>&searchGender=<%=searchGender%>&searchName=<%=searchName%>">����</a>
			<%		
				}
				if(currentPage != lastPage) {
			%>		
					<a href="./employeesList.jsp?currentPage=<%=lastPage%>&searchGender=<%=searchGender%>&searchName=<%=searchName%>">����������</a>
			<%		
				}
			%>		
		</div>
	</div>
</body>
</html>