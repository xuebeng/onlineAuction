<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<base href="<%=basePath%>">

	<title>My JSP 'userManage.jsp' starting page</title>
	<link rel="stylesheet" type="text/css"
		  href="${pageContext.request.contextPath}/manage/jquery-easyui-1.4.4/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css"
		  href="${pageContext.request.contextPath}/manage/jquery-easyui-1.4.4/themes/icon.css">
	<script type="text/javascript"
			src="${pageContext.request.contextPath}/manage/jquery-easyui-1.4.4/jquery.min.js"></script>
	<script type="text/javascript"
			src="${pageContext.request.contextPath}/manage/jquery-easyui-1.4.4/jquery.easyui.min.js"></script>
	<script type="text/javascript"
			src="${pageContext.request.contextPath}/manage/jquery-easyui-1.4.4/locale/easyui-lang-zh_CN.js"></script>
	<script type="text/javascript"
			src="${pageContext.request.contextPath}/manage/js/easyuiExtension.js"></script>

	<script type="text/javascript">
		var url;
		function searchUser() {
			$("#dg").datagrid('load', {
				"name" : $("#name").val(),
				"freeze" : $('#freeze').combobox('getValue')
			});
		}


		function resetValue() {
			$("#userName").val("");
			$("#password").val("");
		}

		function closeUserDialog() {
			$("#dlg").dialog("close");
			resetValue();
		}

		function deleteUser() {
			var selectedRows = $("#dg").datagrid("getSelections");
			if (selectedRows.length == 0) {
				$.messager.alert("系统提示", "请选择要删除的数据！");
				return;
			}
			var strIds = [];
			for ( var i = 0; i < selectedRows.length; i++) {
				strIds.push(selectedRows[i].id);
			}
			var ids = strIds.join(",");
			$.messager.confirm("系统提示", "您确定要删除这<font color=red>"
					+ selectedRows.length + "</font>条数据吗？", function(r) {
				if (r) {
					$.post("${pageContext.request.contextPath}/manage/user/delete", {
								ids : ids
							}, function(result) {
								if (result.success) {
									$.messager.alert("系统提示", "数据已成功删除！");
									$("#dg").datagrid("reload");
								} else {
									$.messager.alert("系统提示", "数据删除失败，请联系系统管理员！");
								}
							}, "json"
					);
				}
			});
		}

		//	function formatBirthday(val,row){
		//		if (val < 2022-08-02){
		//			return '<span style="color:red;">('+val+')</span>';
		//		} else {
		//			return val;
		//		}
		//	}

		var editIndex = undefined;
		function endEditing(){
			if (editIndex == undefined){return true}
			if ($('#dg').datagrid('validateRow', editIndex)){
				$('#dg').datagrid('endEdit', editIndex);
				editIndex = undefined;
				return true;
			} else {
				return false;
			}
		}
		function onClickCell(index, field){
			if (editIndex != index){
				if (endEditing()){
					$('#dg').datagrid('selectRow', index)
							.datagrid('beginEdit', index);
					var ed = $('#dg').datagrid('getEditor', {index:index,field:field});
					if (ed){
						($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
					}
					editIndex = index;
				} else {
					setTimeout(function(){
						$('#dg').datagrid('selectRow', editIndex);
					},0);
				}
			}
		}
		function onEndEdit(index, row){
			var ed = $(this).datagrid('getEditor', {
				index: index,
				field: 'sysUserId'
			});
			row.sysUserId = $(ed.target).combobox('getText');
		}
		function append(){
			if (endEditing()){
				$('#dg').datagrid('appendRow',{status:'P'});
				editIndex = $('#dg').datagrid('getRows').length-1;
				$('#dg').datagrid('selectRow', editIndex)
						.datagrid('beginEdit', editIndex);
			}
		}
		function removeit(){
			if (editIndex == undefined){return}
			$('#dg').datagrid('cancelEdit', editIndex)
					.datagrid('deleteRow', editIndex);
			editIndex = undefined;
		}
		function accept(){
			if (endEditing()){
				$('#dg').datagrid('acceptChanges');
			}
		}
		function reject(){
			$('#dg').datagrid('rejectChanges');
			editIndex = undefined;
		}
		function getChanges(){
			var rows = $('#dg').datagrid('getChanges');
			alert(rows.length+' rows are changed!');
		}
		function onAfterEdit(index, row, changes) {
			var rows = $('#dg').datagrid('getChanges');
			if (rows.length == 1){
				//endEdit该方法触发此事件
				$.post("${pageContext.request.contextPath}/manage/admin/edit", {
						 sysUserId : row.sysUserId,
						 freeze : row.freeze
						}, function(result) {
							if (result.success) {
								$.messager.alert("系统提示", "数据已成功修改！");
								$("#dg").datagrid("reload");
							} else {
								$.messager.alert("系统提示", "数据修改失败！");
							}
						}, "json"
				);
				$.console.info(row);

			}
			editRow = undefined;
		}
	</script>
</head>

<body style="margin: 1px">

<table id="dg" title="用户管理" class="easyui-datagrid" fitColumns="true"
	   pagination="true" rownumbers="true"


	   data-options="
		   		fitColumns:true,
				pagination:true,
				rownumbers:true,
                iconCls: 'icon-edit',
                fit:true,
                singleSelect: true,
                toolbar: '#tb',
                url: '${pageContext.request.contextPath}/manage/admin/adminList',
                method: 'get',
                onClickCell: onClickCell,
                onEndEdit: onEndEdit,
                onAfterEdit:onAfterEdit
            ">
	<%--<thead frozen="true">--%>
	<%--<tr>--%>
	<%--<th field="userId" width="80">用户编号</th>--%>
	<%--</tr>--%>
	<%--</thead>--%>
	<thead>
	<tr>
		<th field="cb" checkbox="true" align="center" ></th>
		<th data-options = "field:'sysUserId',
                    editor:'textbox'
					" align="center">用户Id</th>
		<th data-options = "field:'name'" align="center" width="30">登陆名</th>
		<th data-options = "field:'password'"  align="center" width="30">密码</th>
		<th data-options = "field:'manageEmail'" align="center" width="50">生日</th>
		<th data-options = "field:'freeze', formatter:function(value,row){
                          						  if(row.freeze == 1)
                          						  	return '冻结';
                          						  else
                          						  	return '正常';
                        					},editor:{
                        						type:'combobox',
                        						options:{
                        							valueField:'freeze',
													textField:'chinese',
													method:'get',
													panelHeight:'42.5px',
													url:'/manage/page/freeze.json',
													required:true
                        						}
                        					}" align="center" width="30">状态</th>
	</tr>
	</thead>
</table>
<div id="tb">
	<a href="javascript:append()" class="easyui-linkbutton"
	   iconCls="icon-add" plain="true">添加</a> <a
		href="javascript:onClickCell()" class="easyui-linkbutton"
		iconCls="icon-edit" plain="true">修改</a> <a
		href="javascript:saveUser()" class="easyui-linkbutton"
		iconCls="icon-save" plain="true">保存</a> <a
		href="javascript:deleteUser()" class="easyui-linkbutton"
		iconCls="icon-remove" plain="true">删除</a>
	<div>
		&nbsp;登录名：&nbsp;<input type="text" id="name" size="20" placeholder="可选"
							   onkeydown="if(event.keyCode == 13)searchUser()" />
		&nbsp; 状态：&nbsp;
		<select id="freeze" class="easyui-combobox" name="freeze" size="20"  labelPosition="top">
			<option value="" selected>可选...</option>
			<option value="0">正常</option>
			<option value="1">冻结</option>
		</select>
		<a
				href="javascript:searchUser()" class="easyui-linkbutton"
				iconCls="icon-search" plain="true">查询</a>
	</div>
</div>
</body>
</html>
