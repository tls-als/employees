<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>salariesList</title>
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
	
	
	<h1>salariesList ���</h1>
	
	<!-- �ִ� �޿� ���� -->
	<%
		//���� ������ ���� ���� ���� ����
		int currentPage = 1;
		//request�� ���� ������ �� �ޱ�
		if (request.getParameter("currentPage") != null) {
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		System.out.println(currentPage + "<-currentPage");
		//���� ������ ���� ���� ����
		int rowPerPage = 10;
		//���۵Ǵ� ������
		int beginPage = (currentPage - 1) * rowPerPage;

		//mariadb ���
		Class.forName("org.mariadb.jdbc.Driver");
		//maria ����
		Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1004");
		// �ּ�,�ִ� ������ ��� ����
		int minSalary = 0;
		int maxSalary = 0;
		// ���� �˻� ���� ����
		int beginSalary = 0;
		int endSalary = 0;
		
		//�޿� �ִ밪�� ��ȸ�ϴ� ����
		String sql1 = "select min(salary),max(salary) from salaries";
		PreparedStatement stmt1 = conn.prepareStatement(sql1);
		ResultSet rs1 = stmt1.executeQuery();
		//�ּ� �޿� �ޱ�
		if (rs1.next()) {
			minSalary = rs1.getInt("min(salary)");
			maxSalary = rs1.getInt("max(salary)");
			//���� �޿��� �˻����ǿ� ���� ���氡��
			beginSalary = minSalary;
			//������ �޿��� �˻����ǿ� ���� ���氡��
			endSalary = maxSalary;
		}
		System.out.println(beginSalary + "<-minSalary");
		System.out.println(endSalary + "<-maxSalary");
		
		//�Է¹��� ����(�ּ�) �޿� �ޱ�
		if (request.getParameter("beginSalary") != null) {
			beginSalary = Integer.parseInt(request.getParameter("beginSalary"));
		}
		//�Է¹��� ������(�ִ�) �޿� �ޱ�
		if (request.getParameter("endSalary") != null) {
			endSalary = Integer.parseInt(request.getParameter("endSalary"));
		}
	%>
	
	<!-- salariesList ����(��ȸ) -->
	<%
		//���� ���๮ conn�� ���(�޿� ��ȸ)
		String sql2 = "SELECT emp_no,salary,from_date,to_date FROM salaries WHERE salary BETWEEN ? AND ? LIMIT ?,?";
		PreparedStatement stmt2 = conn.prepareStatement(sql2);
		stmt2.setInt(1, beginSalary);
		stmt2.setInt(2, endSalary);
		stmt2.setInt(3, beginPage);
		stmt2.setInt(4, rowPerPage);
		//���� ��� ��������
		ResultSet rs2 = stmt2.executeQuery();
		System.out.println(rs2 + "<-rs2");
	%>
	
	<!-- �޿� �˻��� ���� �� -->
	<form method="post" action="./salariesList.jsp">
		�ּ� �޿�:
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
		�ִ� �޿�:
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
			System.out.println(minSalary+"�ּұ޿�");
			System.out.println(maxSalary+"�ִ�޿�");
			System.out.println(beginSalary+"�ּұ޿�");
			System.out.println(endSalary+"�ִ�޿�");
			%>
		</select>
		<button type="submit">�˻�</button>
	</form>
		
	<!-- salariesList ����ϴ� �� -->
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
	<!-- ����¡ �׺���̼� ���� -->
	<div>
		<%
			//��� ���� ���� ���ϴ� ������ ����
			String sql3 = "select count(*) from employees";
			PreparedStatement stmt3 = conn.prepareStatement(sql3);
			//������ ����
			ResultSet rs3 = stmt3.executeQuery();
			//��ü ���� ������ ��� ����
			int totalCount = 0;
			if(rs3.next()) {
				totalCount = rs3.getInt("count(*)");
			}
			//������ �������� ��� ����
			int lastPage = totalCount/rowPerPage;
			if(totalCount%rowPerPage != 0) {
				lastPage +=1;
			}
			
			if(currentPage > 1) {
		%>
				<a href="./salariesList.jsp?currentPage=1&beginSalary=<%=beginSalary%>&endSalary=<%=endSalary%>">ó������</a>
				<a href="./salariesList.jsp?currentPage=<%=currentPage-1%>&beginSalary=<%=beginSalary%>&endSalary=<%=endSalary%>">����</a>
		<%
			}
			if(currentPage < lastPage) {
		%>
				<a href="./salariesList.jsp?currentPage=<%=currentPage+1%>&beginSalary=<%=beginSalary%>&endSalary=<%=endSalary%>">����</a>
		<%		
			}
			if(currentPage != lastPage) {
		%>		
				<a href="./salariesList.jsp?currentPage=<%=lastPage%>&beginSalary=<%=beginSalary%>&endSalary=<%=endSalary%>">����������</a>
		<%		
			}
		%>					
	</div>
</body>
</html>