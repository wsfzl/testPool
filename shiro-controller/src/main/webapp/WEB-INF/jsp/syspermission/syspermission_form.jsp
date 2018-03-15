<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

	<form action="" id="userForm" method="post">
		<input type="hidden" name="id" />
		<p>
			name : <input type="text" name="name" class="easyui-validatebox" data-options="required:true,missingMessage:'name必须填写'" />
		</p>
		<p>
			排序 : <input type="text" name="sortstring" class="easyui-validatebox"/>
		</p>
		
		<p>
		可用性 : <select name="available" id="available">
			<option value="1">可用</option>
			<option value="0">不可用</option>
		</select>
		</p>
	</form>
</body>
</html>






