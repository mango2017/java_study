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
				<button type="button" class="btn btn-danger" id="emp_delete_all">删除</button>
				<button type="button" class="btn btn-success" id="open_excel">打开工作簿</button>
			</div>
		</div>
		
		<form name="dateupload" method="post" enctype="multipart/form-data" action="${APP_PATH}/test" >
        	<input type="file" name="file"  >
        	<input type="submit" value="上传" />
		</form>


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
										id="empName_add_input" placeholder=""> <span
										class="help-block"></span>
								</div>
							</div>
							<div class="form-group">
								<label class="col-sm-2 control-label">email</label>
								<div class="col-sm-10">
									<input type="text" name="email" class="form-control"
										id="email_add_input" placeholder=""> <span
										class="help-block"></span>
								</div>
							</div>
							<div class="form-group">
								<label class="col-sm-2 control-label">gender</label>
								<div class="col-sm-10">
									<label class="radio-inline"> <input type="radio"
										checked="checked" name="gender" id="gender_add_input"
										value="M"> 男
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


		<!-- 员工修改模态框 -->
		<div class="modal fade" id="empUpdateModal" tabindex="-1"
			role="dialog" aria-labelledby="myModalLabel">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h4 class="modal-title">员工编辑</h4>
					</div>
					<div class="modal-body">
						<form class="form-horizontal">
							<div class="form-group">
								<label class="col-sm-2 control-label">empName</label>
								<div class="col-sm-10">
									<p class="form-control-static" id="empName_update_static"></p>
									<span class="help-block"></span>
								</div>
							</div>
							<div class="form-group">
								<label class="col-sm-2 control-label">email</label>
								<div class="col-sm-10">
									<input type="text" name="email" class="form-control"
										id="email_update_input" placeholder=""> <span
										class="help-block"></span>
								</div>
							</div>
							<div class="form-group">
								<label class="col-sm-2 control-label">gender</label>
								<div class="col-sm-10">
									<label class="radio-inline"> <input type="radio"
										name="gender" id="gender_update_input" value="M"> 男
									</label> <label class="radio-inline"> <input type="radio"
										name="gender" id="gender_update_input" value="F"> 女
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
						<button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
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
							<th><input type="checkbox" id="check_all"/></th>
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
		var totalRecord, currentPage;
		$(function() {
			//去首页
			to_page(1);
			$("#emp_add_modal_btn").click(function() {
				//模态框弹出之前，清空表单数据（表单重置）
				//$("#empAddModal form")[0].reset();
				reset_form("#empAddModal form");

				//发送ajax请求，查出部门信息，显示在下拉列表中
				getDepts("#empAddModal select");
				$("#empAddModal").modal({
					backdrop : 'static'
				});
			});

		});

		//表单重置方法
		function reset_form(ele) {
			$(ele)[0].reset();//重置表单内容
			//清空表单样式
			$(ele).find("*").removeClass("has-error has-success");
			$(ele).find(".help-block").text("");
		}

		//查出所有的部门信息，并显示在下拉列表中
		function getDepts(ele) {
			//清空下拉列表中的值
			$(ele).empty();
			$.ajax({
				url : "${APP_PATH}/depts",
				type : "GET",
				success : function(result) {
					$.each(result.extend.depts, function() {
						var optionEle = $("<option></option>").append(
								this.deptName).attr("value", this.deptId);
						optionEle.appendTo(ele);
					});
				}
			});
		}
		

		function build_emps_table(result) {
			//清空table表格
			$("#emps_table tbody").empty();
			var emps = result.extend.pageInfo.list;
			$.each(emps, function(index, item) {
				var checkBoxTd = $("<td></td>").append("<input type='checkbox' class='check_item' />");
				//alert(item.empName);
				var empIdTd = $("<td></td>").append(item.empId); //在td标签内部插入  如果不想在标签内部请使用after
				var empNameTd = $("<td></td>").append(item.empName);
				var genderTd = $("<td></td>").append(
						item.gender == 'M' ? '男' : '女');
				var emailTd = $("<td></td>").append(item.email);
				var deptNameTd = $("<td></td>")
						.append(item.department.deptName);
				var editBtn = $("<button></button>").addClass(
						"btn btn-primary btn-sm edit_btn").append(
						$("<span></span>").addClass(
								"glyphicon glyphicon-pencil")).append("编辑");
				//为编辑按钮添加一个自定义的属性，来表示当前员工id
				editBtn.attr("edit-id", item.empId);
				var deleteBtn = $("<button></button>").addClass(
						"btn btn-danger btn-sm delete_btn").append(
						$("<span></span>").addClass(
								"glyphicon glyphicon-trash ")).append("删除");
				deleteBtn.attr("delete-id", item.empId);
				var btnTd = $("<td></td>").append(editBtn).append(" ").append(
						deleteBtn);

				$("<tr></tr>").append(checkBoxTd).append(empIdTd).append(empNameTd).append(
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
			currentPage = result.extend.pageInfo.pageNum;

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
		$("#empName_add_input").change(
				function() {
					//发送ajax请求校验用户名是否可用
					var empName = this.value;
					$.ajax({
						url : "${APP_PATH}/checkuser",
						data : "empName=" + empName,
						type : "POST",
						success : function(result) {
							console.log(result);
							if (result.code == 100) {//成功
								show_validate_msg("#empName_add_input",
										"success", "用户名可用");
								$("#emp_save_btn").attr("ajax-va", "success");
							} else { //失败
								show_validate_msg("#empName_add_input",
										"error", result.extend.va_msg);
								$("#emp_save_btn").attr("ajax-va", "error");
							}
						}
					});
				});

		//点击保存，保存员工
		$("#emp_save_btn")
				.click(
						function() {
							//1.模态框中填写的表单数据提交给服务器进行保存
							//先对要提交给服务器的数据进行验证
							if (!validate_add_form()) {
								return false;
							}
							//判断之前的ajax用户名校验是否成功，如果成功
							if ($(this).attr("ajax-va") == "error") {
								return false;
							}

							//2.发送ajax请求保存员工
							$
									.ajax({
										url : "${APP_PATH}/emp",
										type : "POST",
										data : $("#empAddModal form")
												.serialize(),
										success : function(result) {
											if (result.code == 100) {
												//alert(result.msg);
												//员工保存成功
												//关闭模态框
												$("#empAddModal").modal('hide');
												//来到最后一页，显示刚才保存的数据
												to_page(totalRecord);
											} else {
												//显示失败信息
												if (undefined != result.extend.errorFields.email) {
													//显示邮箱错误信息
													show_validate_msg(
															"#email_add_input",
															"error",
															result.extend.errorFields.email);
												}
												if (undefined != result.extend.errorFields.empName) {
													//员工名字错误信息
													show_validate_msg(
															"#empName_add_input",
															"error",
															result.extend.errorFields.empName);
												}
											}
										}
									});
						});

		//校验数据方法
		function validate_add_form() {
			//1.拿到要校验的数据，使用正则表达式
			var empName = $("#empName_add_input").val();
			var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
			if (!regName.test(empName)) {
				show_validate_msg("#empName_add_input", "error",
						"用户名必须是2-5位中文或6-16位英文和数字的组合");
				return false;
			} else {
				show_validate_msg("#empName_add_input", "success", "");
				/* $("#empName_add_input").parent().addClass("has-success");
				$("#empName_add_input").next().text(""); */
			}
			//校验邮箱
			var email = $("#email_add_input").val();
			var regEmail = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
			if (!regEmail.test(email)) {
				show_validate_msg("#email_add_input", "error", "邮箱格式不正确");
				/* $("#email_add_input").parent().addClass("has-error");
				$("#email_add_input").next().text("邮箱格式不正确"); */
				return false;
			} else {
				show_validate_msg("#email_add_input", "success", "");
				/* $("#email_add_input").parent().addClass("has-success");
				$("#email_add_input").next().text(""); */
			}
			return true;
		}

		//
		function show_validate_msg(ele, status, msg) {
			//清除当前元素的校验状态
			$(ele).parent().removeClass("has-success has-error");
			$(ele).next("span").text("");
			if ("success" == status) {
				$(ele).parent().addClass("has-success");
				$(ele).next("span").text(msg);
			} else if ("error" == status) {
				$(ele).parent().addClass("has-error");
				$(ele).next("span").text(msg);

			}
		}

		//触发编辑按钮
		//我们是按钮创建之前就绑定了click 所以绑定不上
		//1.可以创建按钮的同时绑定事件
		//2.绑定单击事件 live jquery新版本没有live方法了，用on方法替代
		$(document).on("click", ".edit_btn", function() {
			//查出部门信息，并显示部门列表
			getEmp($(this).attr("edit-id"));
			//把员工的id传递给模态框更新按钮
			$("#emp_update_btn").attr("edit-id", $(this).attr("edit-id"));
			//查出部门信息，并显示部门列表
			getDepts("#empUpdateModal select");
			$("#empUpdateModal").modal({
				backdrop : 'static'
			});
		});
		//获取员工信息
		function getEmp(id) {
			$.ajax({
				url : "${APP_PATH}/emp/" + id,
				type : "GET",
				success : function(result) {
					var empData = result.extend.emp;
					$("#empName_update_static").text(empData.empName);//员工名
					$("#email_update_input").val(empData.email);//邮箱
					$("#empUpdateModal input[name=gender]").val(
							[ empData.gender ]);
					$("#empUpdateModal select").val([ empData.dId ]);
				}
			});
		}

		//点击更新，更新员工信息
		$("#emp_update_btn").click(function() {
			//1,校验邮箱信息
			var email = $("#email_update_input").val();
			var regEmail = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
			if (!regEmail.test(email)) {
				show_validate_msg("#email_add_input", "error", "邮箱格式不正确");
				/* $("#email_add_input").parent().addClass("has-error");
				$("#email_add_input").next().text("邮箱格式不正确"); */
				return false;
			} else {
				show_validate_msg("#email_add_input", "success", "");
				/* $("#email_add_input").parent().addClass("has-success");
				$("#email_add_input").next().text(""); */
			}
			$.ajax({
				url : "${APP_PATH}/empsave/" + $(this).attr("edit-id"),
				type : "PUT",
				data : $("#empUpdateModal form").serialize(),
				success : function(result) {
					//alert(result.msg);
					//1.关闭模态框
					$("#empUpdateModal").modal("hide");
					//2.回到本页面
					to_page(currentPage);
				}
			});

		});

		//删除一条员工数据
		$(document).on("click", ".delete_btn", function() {
			//弹出是否删除对话框
			var empName = $(this).parents("tr").find("td:eq(2)").text();
			var empId = $(this).attr("delete-id")
			if (confirm("确认删除【" + empName + "】吗？")) {
				$.ajax({
					url : "${APP_PATH}/emp/" + empId,
					type : "DELETE",
					success : function(result) {
						alert(result.msg);
						to_page(currentPage);
					}
				});
			}
		});
		
		//全选 & 全不选
		$("#check_all").click(function(){
			//attr获取checked是undefined
			//我们这些dom原生的属性，应该使用prop attr获取自定义属性
			$(".check_item").prop("checked",$(this).prop("checked"));
		});
		
		
		$(document).on("click",".check_item",function(){
			//判断当前选中的元素是否5个
			var flag = $(".check_item:checked").length == $(".check_item").length;
			$("#check_all").prop("checked",flag);
			
		});
		
		//点击全部删除,批量删除
		$("#emp_delete_all").click(function(){
			var empNames = "";
			var del_idstr ="";
			 $.each($(".check_item:checked"),function(){
				 empNames += $(this).parents("tr").find("td:eq(2)").text()+",";
				 //组装id字符串
				 del_idstr += $(this).parents("tr").find("td:eq(1)").text()+"-";
			 });
			 empNames = empNames.substring(0,empNames.length-1);
			 del_idstr = del_idstr.substring(0,del_idstr.length-1);
			  if(confirm("确认删除【"+empNames+"】吗？")){
				 //发送ajax请求
				  $.ajax({
						url : "${APP_PATH}/emp/" + del_idstr,
						type : "DELETE",
						success : function(result) {
							alert(result.msg);
							to_page(currentPage);
						}
					});
			 } 
		});
		
		//打开现有工作簿
		$("#open_excel").click(function(){
			 $.ajax({
					url : "${APP_PATH}/excel/",
					type : "GET",
					success : function(result) {
						alert(result);
					}
				});
		});
		
	</script>

</body>
</html>