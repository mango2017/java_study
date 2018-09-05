<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>员工列表</title>
<%
	pageContext.setAttribute("APP_PATH", request.getContextPath());
%>
<script type="text/javascript" src="${APP_PATH}/static/js/jquery.min.js"></script>
<script type="text/javascript"
	src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<link rel="stylesheet"
	href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<!-- 标题 -->
		<div class="row">
			<div class="col-md-12">
				<h1>SSM-CRUD</h1>
			</div>
		</div>

		<!-- 按钮 -->
		<div class="row">
			<div class="col-md-4 col-md-offset-8">
				<button type="button" class="btn btn-primary" id="emp_add_modal_btn">新增</button>
				<button type="button" class="btn btn-danger">删除</button>
			</div>
		</div>


		<!-- 员工添加模态框 -->
		<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog"
			aria-labelledby="myModalLabel">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h4 class="modal-title" id="myModalLabel">员工添加</h4>
					</div>
					<div class="modal-body">
						<form class="form-horizontal">
							<div class="form-group">
								<label class="col-sm-2 control-label">empName</label>
								<div class="col-sm-10">
									<input type="text" name="empName" class="form-control"
										id="empName_add_input" placeholder="">
										<span class="help-block"></span>
								</div>
							</div>
							<div class="form-group">
								<label class="col-sm-2 control-label">email</label>
								<div class="col-sm-10">
									<input type="text" name="email" class="form-control"
										id="email_add_input" placeholder="">
										<span class="help-block"></span>
								</div>
							</div>
							<div class="form-group">
								<label class="col-sm-2 control-label">gender</label>
								<div class="col-sm-10">
									<label class="radio-inline"> <input type="radio" checked="checked"
										name="gender" id="gender_add_input" value="M"> 男
									</label> <label class="radio-inline"> <input type="radio"
										name="gender" id="gender_add_input" value="F"> 女
									</label>
								</div>
							</div>

							<div class="form-group">
								<label class="col-sm-2 control-label">deptName</label>
								<div class="col-sm-4">
									<select class="form-control" name="dId">
										
									</select>
								</div>
							</div>
						</form>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
						<button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
					</div>
				</div>
			</div>
		</div>










		<!-- 显示表格数据 -->
		<div class="row">
			<div class="col-md-12">
				<table class="table table-hover" id="emps_table">
					<thead>
						<tr>
							<th>ID</th>
							<th>empName</th>
							<th>gender</th>
							<th>email</th>
							<th>deptName</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>

					</tbody>

				</table>
			</div>
		</div>







		<div class="row">
			<!-- 分页文字信息 -->
			<div class="col-md-6" id="page_info_area"></div>

			<!-- 分页条信息 -->
			<div class="col-md-6" id="page_nav_area">
				<%-- <nav aria-label="Page navigation">
					<ul class="pagination">
						<li><a href="${APP_PATH}/emps?pn=1">首页</a></li>
						<c:if test="">
							<li><a href="${APP_PATH}/emps?pn=" aria-label="Previous">
									<span aria-hidden="true">&laquo;</span>
							</a></li>
						</c:if>

						<c:forEach items="" var="page_Num">
							<c:if test="">
								<li class="active"><a href="#"></a></li>
							</c:if>

							<c:if test="">
								<li><a href="${APP_PATH}/emps?pn="></a></li>
							</c:if>

						</c:forEach>
						<c:if test="">
							<li><a href="${APP_PATH}/emps?pn=" aria-label="Next"> <span
									aria-hidden="true">&raquo;</span>
							</a></li>
						</c:if>
						<li><a href="${APP_PATH}/emps?pn=">末页</a></li>
					</ul>
				</nav> --%>
			</div>


		</div>
	</div>

	<script>
	var totalRecord;
		$(function() {
			//去首页
			to_page(1);
			$("#emp_add_modal_btn").click(function() {
				//模态框弹出之前，清空表单数据（表单重置）
				//$("#empAddModal form")[0].reset();
				reset_form("#empAddModal form");
				
				
				//发送ajax请求，查出部门信息，显示在下拉列表中
				getDepts();
				$("#empAddModal").modal({
					backdrop : 'static'
				});
			});

		});
		
		//表单重置方法
		function reset_form(ele){
			$(ele)[0].reset();//重置表单内容
			//清空表单样式
			$(ele).find("*").removeClass("has-error has-success");
			$(ele).find(".help-block").text("");
		}
		
		//查出所有的部门信息，并显示在下拉列表中
		function getDepts(){
			$.ajax({
				url:"${APP_PATH}/depts",
				type:"GET",
				success:function(result){
					$.each(result.extend.depts,function(){
						var optionEle = $("<option></option>").append(this.deptName).attr("value",this.deptId);
						optionEle.appendTo("#empAddModal select");
					});
				}
			});
		}
		
		
		

		function build_emps_table(result) {
			//清空table表格
			$("#emps_table tbody").empty();
			var emps = result.extend.pageInfo.list;
			$.each(emps, function(index, item) {
				//alert(item.empName);
				var empIdTd = $("<td></td>").append(item.empId); //在td标签内部插入  如果不想在标签内部请使用after
				var empNameTd = $("<td></td>").append(item.empName);
				var genderTd = $("<td></td>").append(
						item.gender == 'M' ? '男' : '女');
				var emailTd = $("<td></td>").append(item.email);
				var deptNameTd = $("<td></td>")
						.append(item.department.deptName);
				var editBtn = $("<button></button>").addClass(
						"btn btn-primary btn-sm").append(
						$("<span></span>").addClass(
								"glyphicon glyphicon-pencil")).append("编辑");
				var deleteBtn = $("<button></button>").addClass(
						"btn btn-danger btn-sm").append(
						$("<span></span>")
								.addClass("glyphicon glyphicon-trash")).append(
						"删除");
				var btnTd = $("<td></td>").append(editBtn).append(" ").append(
						deleteBtn);
				$("<tr></tr>").append(empIdTd).append(empNameTd).append(
						genderTd).append(emailTd).append(deptNameTd).append(
						btnTd).appendTo("#emps_table tbody");
			});
		}

		function build_page_info(result) {
			//清空
			$("#page_info_area").empty();
			$("#page_info_area").append(
					"当前" + result.extend.pageInfo.pageNum + "页，总"
							+ result.extend.pageInfo.pages + "页，总"
							+ result.extend.pageInfo.total + "条记录");
			totalRecord = result.extend.pageInfo.total;
			
		}

		function build_page_nav(result) {
			//page_nav_area
			$("#page_nav_area").empty();
			var ul = $("<ul></ul>").addClass("pagination");
			//构建元素
			var firstPageLi = $("<li></li>").append(
					$("<a></a>").append("首页").attr("href", "#"));
			var prePageLi = $("<li></li>").append(
					$("<a></a>").append("&laquo;"));
			if (result.extend.pageInfo.hasPreviousPage == false) {
				firstPageLi.addClass("disabled");
				prePageLi.addClass("disabled");
			}
			//为元素添加点击翻页的事件
			firstPageLi.click(function() {
				to_page(1);
			});
			//前一页
			prePageLi.click(function() {
				to_page(result.extend.pageInfo.pageNum - 1);
			});

			var nextPageLi = $("<li></li>").append(
					$("<a></a>").append("&raquo;"));
			var lastPageLi = $("<li></li>").append(
					$("<a></a>").append("末页").attr("href", "#"));

			if (result.extend.pageInfo.hasNextPage == false) {
				nextPageLi.addClass("disabled");
				lastPageLi.addClass("disabled");
			}
			nextPageLi.click(function() {
				to_page(result.extend.pageInfo.pageNum + 1);
			});

			lastPageLi.click(function() {
				to_page(result.extend.pageInfo.pages);
			});

			//首页和前一页
			ul.append(firstPageLi).append(prePageLi);
			$.each(result.extend.pageInfo.navigatepageNums, function(index,
					item) {
				var numLi = $("<li></li>").append($("<a></a>").append(item));
				//如果当前页面等于正在遍历的页码
				if (result.extend.pageInfo.pageNum == item) {
					numLi.addClass("active");
				}
				numLi.click(function() {
					to_page(item);
				});
				ul.append(numLi);
			});
			//下一页和末页
			ul.append(nextPageLi).append(lastPageLi);
			//把ul加入到nav
			var navEle = $("<nav></nav>").append(ul);
			navEle.appendTo("#page_nav_area");
		}

		function to_page(pn) {
			$.ajax({
				url : "${APP_PATH}/emps",
				data : "pn=" + pn,
				type : "GET",
				success : function(result) {
					//console.log(result);
					//1.解析并显示员工数据
					build_emps_table(result);
					//2.解析并显示分页信息
					build_page_info(result);

					build_page_nav(result);

				}
			});
		}
		
		//校验用户名是否可用
		$("#empName_add_input").change(function(){
			//发送ajax请求校验用户名是否可用
			var empName = this.value;
			$.ajax({
				url:"${APP_PATH}/checkuser",
				data:"empName="+empName,
				type:"POST",
				success:function(result){
					console.log(result);
					if(result.code==100){//成功
						show_validate_msg("#empName_add_input","success","用户名可用");
						$("#emp_save_btn").attr("ajax-va","success");
					}else{ //失败
						show_validate_msg("#empName_add_input","error",result.extend.va_msg);
						$("#emp_save_btn").attr("ajax-va","error");
					}
				}
			});
		});
		
		
		//点击保存，保存员工
		$("#emp_save_btn").click(function(){
			//1.模态框中填写的表单数据提交给服务器进行保存
			//先对要提交给服务器的数据进行验证
			if(!validate_add_form()){
				return false;
			}
			//判断之前的ajax用户名校验是否成功，如果成功
			if($(this).attr("ajax-va")=="error"){
				return false;
			}
			
			//2.发送ajax请求保存员工
			 $.ajax({
				url : "${APP_PATH}/emp",
				type : "POST",
				data:$("#empAddModal form").serialize(),
				success : function(result) {
					//alert(result.msg);
					//员工保存成功
					//关闭模态框
					$("#empAddModal").modal('hide');
					//来到最后一页，显示刚才保存的数据
					to_page(totalRecord);
					
				}
			}); 
		});
		
		//校验数据方法
		function validate_add_form(){
			//1.拿到要校验的数据，使用正则表达式
			var empName = $("#empName_add_input").val();
			var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
			if(!regName.test(empName)){
				show_validate_msg("#empName_add_input","error","用户名可以是2-5位中文或6-16位英文和数字的组合");
				return false;
			}else{
				show_validate_msg("#empName_add_input","success","");
				/* $("#empName_add_input").parent().addClass("has-success");
				$("#empName_add_input").next().text(""); */
			}
			//校验邮箱
			var email = $("#email_add_input").val();
			var regEmail = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
			if(!regEmail.test(email)){
				show_validate_msg("#email_add_input","error","邮箱格式不正确");
				/* $("#email_add_input").parent().addClass("has-error");
				$("#email_add_input").next().text("邮箱格式不正确"); */
				return false;
			}else{
				show_validate_msg("#email_add_input","success","");
				/* $("#email_add_input").parent().addClass("has-success");
				$("#email_add_input").next().text(""); */
			}
			return true;
		}
		
		//
		function show_validate_msg(ele,status,msg){
			//清除当前元素的校验状态
			$(ele).parent().removeClass("has-success has-error");
			$(ele).next("span").text("");
			if("success"==status){
				$(ele).parent().addClass("has-success");
				$(ele).next("span").text(msg);
			}else if("error"==status){
				$(ele).parent().addClass("has-error");
				$(ele).next("span").text(msg);
				
			}
		}
		
	</script>

</body>
</html>