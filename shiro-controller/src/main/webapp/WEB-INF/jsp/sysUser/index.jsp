<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<base href="<%=basePath%>">
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="easyui/jquery.min.js"></script>
<script type="text/javascript" src="easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="easyui/locale/easyui-lang-zh_CN.js"></script>
<link rel="stylesheet" type="text/css" href="easyui/themes/material/easyui.css"/>
<link rel="stylesheet" type="text/css" href="easyui/themes/icon.css"/>
<script type="text/javascript">
	
$(function(){
	$("#userTable").datagrid({
		pagination : true,
		toolbar : "#tb",
		idField : "id"
	});
})

	//删除选中的用户
	function delete_user(){
		//1. 获取选中的数据，如果没有选中，则提示必须选中数据
		var selRows = $("#userTable").datagrid("getSelections");
		if(selRows.length == 0){
			$.messager.alert("提示","请选择要删除的数据行！","warning");
			return;
		}
		//2. 提示是否删除？是
		$.messager.confirm("提示","确定要删除选中的数据吗？",function(r){
			if(r){
				//3. 发送异步请求，带选中行的编号
				//拼接删除条件
				var postData = "";
				$.each(selRows,function(i){
					postData += "ids="+this.id;
					if(i < selRows.length - 1){
						postData += "&";
					}
				});
				$.post("user/batchDelete",postData,function(data){
					if(data.result == true){
						//4. 删除成功后，刷新表格 reload
						$("#userTable").datagrid("reload");
					}
				});
			}
		});
	}


	function roleFormatter(value,row,index) {
		if(value.length==0){
			return "-";
		}
		var str="";
		for(var i = 0;i<value.length;i++){
			str += value[i].name+" ";	
		}
		return str;
	}
	function setCondition(){
		var postData = {username : $("#username").val()};
		var ids = $("#roles").combobox("getValues");
		for(var i = 0; i < ids.length ; i++){
			postData["sysRoles["+i+"].id"] = ids[i];
		}
		
		$("#userTable").datagrid("reload",postData);
	}
	function add_user(){
		var d = $("<div></div>").appendTo("body");
		d.dialog({
			title : "添加用户",
			iconCls : "icon-add",
			width:500,
			height:300,
			modal:true,
			href : "user/form",
			onClose:function(){$(this).dialog("destroy"); },
			buttons:[{
				iconCls:"icon-ok",
				text:"确定",
				handler:function(){
					$("#userForm").form("submit",{
						url : "user/add",
						success : function(data){
							d.dialog("close");
							$("#userTable").datagrid("reload");
						}
					});
				}
			},{
				iconCls:"icon-cancel",
				text:"取消",
				handler:function(){
					d.dialog("close");
				}
			}]
		});
	}
	
	function edit_user(){
		var row = $("#userTable").datagrid("getSelected");
		if(row==null){
			return;
		}
		var d = $("<div></div>").appendTo("body");
		d.dialog({
			title : "编辑用户",
			iconCls : "icon-add",
			width:500,
			height:300,
			modal:true,
			href : "user/form",
			onClose:function(){$(this).dialog("destroy"); },
			onLoad:function(){
				//发异步
				$.post("user/view",{id:row.id},function(data){
					$("#userForm").form("load",data);
					var roles = new Array();
					$.each(data.sysRoles,function(){
						roles.push(this.id);
					});
					$("#roles_form").combobox("setValues",roles)
					});
				},
			buttons:[{
				iconCls:"icon-ok",
				text:"确定",
				handler:function(){
					$("#userForm").form("submit",{
						url : "user/edit",
						success : function(data){ 
							d.dialog("close");
							$("#userTable").datagrid("reload");
						}
					});
				}
			},{
				iconCls:"icon-cancel",
				text:"取消",
				handler:function(){
					d.dialog("close");
				}
			}]
		});
	}
	
	
</script>
</head>
<body>
	 <div class="easyui-panel" title="设置查询条件" style="padding:15px 10px;">
	username : <input type="text" name="" id="username" />
	roles : 
	<input id="roles" class="easyui-combobox" name="dept"
    		data-options="valueField:'id',textField:'name',url:'role/all',panelHeight:'auto',panelMaxHeight:250,multiple:true">
	<a id="btn" href="javascript:void(0)" onclick="setCondition();" class="easyui-linkbutton" data-options="iconCls:'icon-search'">Search</a>
	<a id="btn" href="javascript:void(0)" onclick="resetCondition()" class="easyui-linkbutton" data-options="iconCls:'icon-undo'">Reset</a>
</div>
	
	<table id="userTable" class="easyui-datagrid" title="用户管理系统" style="width:100%;"
            data-options="singleSelect:true,collapsible:true,pagination:true,pageList:[5,10,20,30,40,50],striped:true,fitColumns:true,url:'user/list'">
        <thead>
            <tr>
            	<th data-options="field:'tyu',checkbox:true"></th>
                <th data-options="field:'id',width:30,sortable:true,order:'desc'">编号</th>
                <th data-options="field:'username',width:100,sortable:true">用户名称</th>
                <th data-options="field:'password',width:80,align:'right'">用户密码</th>
                <th data-options="field:'salt',width:80,align:'right'">颜值</th>
                <th data-options="field:'sysRoles',width:80,formatter:roleFormatter,align:'right'">权限</th>
                
            </tr>
        </thead>
    </table>
	
<div id="tb">
<a href="role/roleindex" class="easyui-linkbutton" onclick="add_user();" data-options="iconCls:'icon-add',plain:true">角色管理</a>
<a href="javascript:void(0)" class="easyui-linkbutton" onclick="add_user();" data-options="iconCls:'icon-add',plain:true">添加</a>
<a href="javascript:void(0)" class="easyui-linkbutton" onclick="edit_user();" data-options="iconCls:'icon-edit',plain:true">修改</a>
<a href="javascript:void(0)" class="easyui-linkbutton" onclick="delete_user();" data-options="iconCls:'icon-remove',plain:true">删除</a>
<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-undo',plain:true">导出</a>
<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-sum',plain:true">批量导入</a>
</div>
</body>
</html>




