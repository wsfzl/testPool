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
<%@include file="/common.jsp" %>
<script type="text/javascript">
	$(function(){
		$("#permissionTable").treegrid({
			toolbar:"#tb",
			idField:"id",
			treeField:"text",
			animate:true,
			onLoadSuccess : function(){
				//$(this).treegrid("collapseAll");
			},
			loadFilter : function(data){
				$.each(data,function(){
					this.state = "open";
				});
				return data;
			}
		});
	});
	
	function add_permission(){
		var d = $("<div></div>").appendTo("body");
		d.dialog({
			title : "添加父节点",
			iconCls : "icon-add",
			width:500,
			height:300,
			modal:true,
			href : "permission/form",
			onClose:function(){$(this).dialog("destroy"); },
			buttons:[{
				iconCls:"icon-ok",
				text:"确定",
				handler:function(){
					$("#userForm").form("submit",{
						url : "permission/add",
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

<table id="permissionTable"  title="Permission List"
        data-options="url:'permission/list',fitColumns:true,striped:true,iconCls:'icon-search'">
    <thead>
        <tr>
            <th data-options="field:'text',width:100,sortable:true">Text</th>
            <th data-options="field:'available',width:100,sortable:true">Available</th>
            <th data-options="field:'url',width:50">Url</th>
        </tr>
    </thead>
</table>
<div id="tb">
<a href="javascript:void(0)" class="easyui-linkbutton" onclick="add_permission();" data-options="iconCls:'icon-add',plain:true">添加</a>
<a href="javascript:void(0)" class="easyui-linkbutton" onclick="edit_permission();" data-options="iconCls:'icon-edit',plain:true">修改</a>
<a href="javascript:void(0)" class="easyui-linkbutton" onclick="delete_permission();" data-options="iconCls:'icon-remove',plain:true">删除</a>
<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-undo',plain:true">导出</a>
<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-sum',plain:true">批量导入</a>
</div>
</body>
</html>




