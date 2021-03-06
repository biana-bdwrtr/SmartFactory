<%@page import="java.util.List"%>
<%@page import="com.youandi.vo.ItemMasterVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Item Master</title>
<style>
table {
	border-collapse: collapse;
}
th {
	background-color: ivory;
}
td {
	text-align: center;
}
</style>
</head>
<body>
	<div align="center">
		<h2>Item Masterπ</h2>
		
		<table border="1" style="width: 80%;">
			<tr>
				<th width="12%">νλ²</th>
				<th width="22%">νλͺ</th>
				<th width="4%">νμ</th>
				<th width="6%">μ°½κ³ </th>
				<th width="4%">λ¨μ</th>
				<th width="4%">λ¨κ°</th>
				<th width="8%">κ·κ²©</th>
				<th width="8%">μ΅μ λ°μ£Όμλ</th>
				<th width="8%">κ³ μ  λ°μ£Όμλ</th>
				<th width="8%">μ΅λ λ°μ£Όμλ</th>
				<th width="8%">μμ±μΌ</th>
				<th width="8%">μμ±μ</th>
			</tr>
			<c:forEach items="${ list }" var="item">
			<tr>
				<td>${ item.ITEMCODE }</td>
				<td>${ item.ITEMNAME }</td>
				<td>${ item.ITEMTYPE }</td>
				<td>${ item.WHCODE }</td>
				<td>${ item.BASEUNIT }</td>
				<td>${ item.UNITCOST }</td>
				<td>${ item.ITEMSPEC }</td>
				<td>${ item.MINORDERQTY }</td>
				<td>${ item.ORDERQTY }</td>
				<td>${ item.MAXORDERQTY }</td>
				<td>${ item.MAKEDATE }</td>
				<td>${ item.MAKER }</td>
			</tr>
			</c:forEach>
			
		</table>
	</div>
</body>
</html>