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
	
	<!-- deptEmpList ���̺� ��� -->
	<div class="container" style="margin-top: 20px">
		<h1>deptEmpList ���̺� ���</h1>
		<%
			// ���� ������ ���� ����
			int currentPage = 1;
			// request�� ���� ������ �� �ޱ�
			if(request.getParameter("currentPage") != null) {
				currentPage = Integer.parseInt(request.getParameter("currentPage"));
			}
			// ������ ���� ��
			int rowPerPage = 10;
			
			
			//���������� �ʴ� ����� üũ�ϴ� ����
			String check = "no";
			if(request.getParameter("check") != null) {
				check = request.getParameter("check");
			}
			
			//�μ� ��ȣ�� ��� ����
			String deptNo = "";
			if(request.getParameter("deptNo") != null) {
				deptNo = request.getParameter("deptNo");
			}
			
			//Mariadb ���
			Class.forName("org.mariadb.jdbc.Driver");
			//mariadb ����
			Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1004");
			//���� ���๮
			String sql = "";
			PreparedStatement stmt = null;
			
			//����,�μ� �Ѵ� üũ ���� ���
			if(check.equals("no") && deptNo.equals("")) {
				sql = "SELECT emp_no,dept_no,from_date,to_date FROM dept_emp ORDER BY emp_no desc LIMIT ?, ?";
				stmt = conn.prepareStatement(sql);
				stmt.setInt(1, (currentPage-1)*rowPerPage);
				stmt.setInt(2, rowPerPage);
			}
			//������ üũ�� ���
			else if(!check.equals("no") && deptNo.equals("")) {
				sql = "SELECT emp_no,dept_no,from_date,to_date FROM dept_emp where to_date='9999-01-01' ORDER BY emp_no desc LIMIT ?, ?";
				stmt = conn.prepareStatement(sql);
				stmt.setInt(1, (currentPage-1)*rowPerPage);
				stmt.setInt(2, rowPerPage);
			}		
			//�μ��� üũ�� ���
			else if(check.equals("no") && !deptNo.equals("")) {
				sql = "SELECT emp_no,dept_no,from_date,to_date FROM dept_emp where dept_no = ? ORDER BY emp_no desc LIMIT ?, ?";
				stmt = conn.prepareStatement(sql);
				stmt.setString(1, deptNo);
				stmt.setInt(2, (currentPage-1)*rowPerPage);
				stmt.setInt(3, rowPerPage);
			}
			//�Ѵ� üũ�� ���
			else {
				sql = "SELECT emp_no,dept_no,from_date,to_date FROM dept_emp where to_date='9999-01-01' and dept_no = ? ORDER BY emp_no desc LIMIT ?, ?";
				stmt = conn.prepareStatement(sql);
				stmt.setString(1, deptNo);
				stmt.setInt(2, (currentPage-1)*rowPerPage);
				stmt.setInt(3, rowPerPage);
			}
			//���� ��� ��������
			ResultSet rs = stmt.executeQuery();
		%>
		<!-- �˻��� -->
		<form method="post" action="./deptEmpList.jsp">
			<div>
				<%
					String sqlDeptNo = "select dept_no from departments";
					PreparedStatement stmtDeptNo = conn.prepareStatement(sqlDeptNo);
					ResultSet rsDeptNo = stmtDeptNo.executeQuery();
					
					if(check.equals("no")){
				%>
						<input type="checkbox" name="check" value="yes"> �μ����� ���� �ٹ� ����
				<%
					}else {
				%>
						<input type="checkbox" name="check" value="yes" checked="checked"> �μ����� ���� �ٹ� ����
				<%
					}
				%>
			</div>
			<div class="input-group">
				<select class="form-control col-2" name="deptNo">
					<option value="">���þ���</option>
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
					<button class="btn btn-secondary" type="submit">�˻�</button>
				</div>
			</div>
		</form>
		<!-- ���̺�� ����ϱ� -->
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
		<!-- ����¡ �׺���̼� ���� -->
		<div style="margin-bottom: 20px;">
			<%
				// ������ ����
				String sql2 = null;
				System.out.println("���õ� �μ�: "+deptNo);
				System.out.println("üũ�� ��: "+check);
				// ������ üũ�� ���
				if(!check.equals("no") && deptNo.equals("")) {
					sql2 = "select count(*) from dept_emp where to_date='9999-01-01'";
				}
				// �μ��� üũ�� ���
				else if(check.equals("no") && !deptNo.equals("")) {
					String getNo = request.getParameter("deptNo");
					sql2 = "select count(*) from dept_emp where dept_no='"+getNo+"'";
				}
				// ����,�μ� �Ѵ� üũ�� ���
				else if(!check.equals("no") && !deptNo.equals("")) {
					String getNo = request.getParameter("deptNo");
					sql2 = "select count(*) from dept_emp where dept_no='"+getNo+"' AND to_date='9999-01-01'";
				}
				// �Ѵ� üũ�� �� �� ���
				else {
					sql2 = "select count(*) from dept_emp";
				}
				PreparedStatement stmt2 = conn.prepareStatement(sql2);
				ResultSet rs2 = stmt2.executeQuery();
				// ��ü �� ����
				int totalCount = 0;
				if(rs2.next()) {
					totalCount = rs2.getInt("count(*)");
				}
				// ������ ������
				int lastPage = totalCount/rowPerPage;
				if(totalCount%rowPerPage != 0) {
					lastPage += 1;
				}

				if(currentPage == 1 && lastPage != 1) {
			%>
					<a href="./deptEmpList.jsp?currentPage=<%=currentPage+1%>&check=<%=check%>&deptNo=<%=deptNo%>">����</a>
					<a href="./deptEmpList.jsp?currentPage=<%=lastPage%>&check=<%=check%>&deptNo=<%=deptNo%>">����������</a>
			<%
				}
				if(currentPage > 1) {		
			%>	
					<a href="./deptEmpList.jsp?currentPage=1&check=<%=check%>&deptNo=<%=deptNo%>">ó������</a>
					<a href="./deptEmpList.jsp?currentPage=<%=currentPage-1%>&check=<%=check%>&deptNo=<%=deptNo%>">����</a>
			<%	
				}
				if(currentPage != 1 && currentPage < lastPage) {
			%>		
					<a href="./deptEmpList.jsp?currentPage=<%=currentPage+1%>&check=<%=check%>&deptNo=<%=deptNo%>">����</a>
			<%		
				}
				if(currentPage != 1 && currentPage != lastPage) {
			%>		
					<a href="./deptEmpList.jsp?currentPage=<%=lastPage%>&check=<%=check%>&deptNo=<%=deptNo%>">����������</a>
			<%
				}
			%>
		</div>
	</div>
</body>
</html>