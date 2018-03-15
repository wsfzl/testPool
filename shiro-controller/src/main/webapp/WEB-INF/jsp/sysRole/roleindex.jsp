<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'MyJsp.jsp' starting page</title>
    <%@include file="/common.jsp" %>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">

<script type="text/javascript">

function avaFomatter(value,row,index){
	
	if(value ==1){
		return "可用";
	}
	return "不可用";
	
}
function opFormatter(value,row,index){
	return "<a href='javascript:void(0)' title='分配权限' onclick='assignPermission("+row.id+");' class='op'><img src='easyui/themes/icons/large_chart.png' width='16'/></a>";
}
function assignPermission(roleId){
	$("#userTable").datagrid("clearSelections");
	var d = $("<div></div>").appendTo("body");
	d.dialog({
		title:"分配权限",
		width:250,
		height:350,
		href:"role/toAssgin?rid="+roleId,
		modal:true,
		onClose:function(){$(this).dialog("destroy");},
		buttons:[{
			iconCls:"icon-ok",
			text:"确定",
			handler:function(){
				//获取选中的节点：checked indeterminate
				var nodes = $("#assignTree").tree("getChecked","checked");
				var half_nodes = $("#assignTree").tree("getChecked","indeterminate");
				$.merge(nodes,half_nodes);
				//获取选中节点的编号，权限编号
				var postData = "";
				for(var i = 0; i<nodes.length;i++){
					postData += "ids="+nodes[i].id + "&";
				}
				postData += "roleId="+roleId;
				//发送异步请求，带 角色编号、一组权限编号
				$.post("role/assign",postData,function(data){
					$.messager.show({
						title:'提示',
						msg:'授权成功！重新登录后生效！',
						timeout:2000,
						showType:'slide'
					});
					d.dialog("close");
					//弹框提示！
				});
				
			}
		},{
			iconCls:"icon-cancel",
			text:"取消",
			handler:function(){
				 d.dialog("close");
			}
		}]
	})
}

$(function(){
	$("#userTable").datagrid({
		pagination : true,
		toolbar : "#tb",
		idField : "id",
		onLoadSuccess:function(){
			$("a.op").tooltip({
				position: 'right'
			});
		}
		
	});
})
function add_role(){
		var d = $("<div></div>").appendTo("body");
		d.dialog({
			title : "添加用户",
			iconCls : "icon-add",
			width:500,
			height:300,
			modal:true,
			href : "role/form",
			onClose:function(){$(this).dialog("destroy"); },
			buttons:[{
				iconCls:"icon-ok",
				text:"确定",
				handler:function(){
					$("#userForm").form("submit",{
						url : "role/add",
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
//删除选中的用户
function delete_role(){
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
			$.post("role/batchDelete",postData,function(data){
				if(data.result == true){
					//4. 删除成功后，刷新表格 reload
					$("#userTable").datagrid("reload");
				}
			});
		}
	});
}
function edit_role(){
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
		href : "role/form",
		onClose:function(){$(this).dialog("destroy"); },
		onLoad:function(){
			//发异步
			$.post("role/view",{id:row.id},function(data){
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
					url : "role/edit",
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

	<a id="btn" href="javascript:void(0)" onclick="setCondition();" class="easyui-linkbutton" data-options="iconCls:'icon-search'">Search</a>
	<a id="btn" href="javascript:void(0)" onclick="resetCondition()" class="easyui-linkbutton" data-options="iconCls:'icon-undo'">Reset</a>
</div>
	
	<table id="userTable" class="easyui-datagrid" title="角色管理系统" style="width:100%;"
            data-options="singleSelect:true,collapsible:true,pagination:true,pageList:[5,10,20,30,40,50],striped:true,fitColumns:true,url:'role/rolelist'">
        <thead>
            <tr>
            	<th data-options="field:'tyu',checkbox:true"></th>
                <th data-options="field:'id',width:30,sortable:true,order:'desc'">编号</th>
                <th data-options="field:'name',width:30,order:'desc'">name</th>
                <th data-options="field:'available',width:30,order:'desc',formatter:avaFomatter">可用性</th>
  				 <th data-options="field:'world',width:50,formatter:opFormatter">操作</th>
                
            </tr>
        </thead>
    </table>
	
<div id="tb">
<a href="user/index" class="easyui-linkbutton" onclick="" data-options="iconCls:'icon-add',plain:true">用户管理</a>
<a href="javascript:void(0)" class="easyui-linkbutton" onclick="add_role();" data-options="iconCls:'icon-add',plain:true">添加</a>
<a href="javascript:void(0)" class="easyui-linkbutton" onclick="edit_role();" data-options="iconCls:'icon-edit',plain:true">修改</a>
<a href="javascript:void(0)" class="easyui-linkbutton" onclick="delete_role();" data-options="iconCls:'icon-remove',plain:true">删除</a>
<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-undo',plain:true">导出</a>
<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-sum',plain:true">批量导入</a>
</div>
  </body>
</html>
