package com.atguigu.crud.controller;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.mybatis.generator.codegen.ibatis2.dao.templates.GenericCIDAOTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.bean.Msg;
import com.atguigu.crud.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

@Controller
public class EmployeeController {
	@Autowired
	EmployeeService employeeService;
	
	
	
	//保存员工信息
	/**
	 * 
	 * 员工保存
	 * 1 支持JSR303校验
	 * 2 导入hibernate-validator
	 *
	 * @param employee
	 * @return
	 */
	@RequestMapping(value="/emp",method=RequestMethod.POST)
	@ResponseBody
	public Msg saveEmp(@Valid Employee employee,BindingResult result) {
		if(result.hasErrors()) {
			//校验失败，应该返回失败，在模态框中显示校验失败的信息
			Map<String, Object> map=new HashMap<String, Object>();
			List<FieldError> errors = result.getFieldErrors();
			for(FieldError fieldError:errors) {
				System.out.println("错误的字段名"+fieldError.getField());
				System.out.println("错误的信息"+fieldError.getDefaultMessage());
				map.put(fieldError.getField(),fieldError.getDefaultMessage());
			}
			return Msg.fail().add("errorFields",map);
		}else {
			employeeService.saveEmp(employee);
			return Msg.success();
		}
	}
	
	
//	@RequestMapping("/emps")
	public String getEmps(@RequestParam(value="pn",defaultValue="1")Integer pn,Model model) {
//		System.out.println(1);
		//这不是一个分页查询
		//引入PageHelper分页插件
		//在查询之前只需要调用，传入页码，以及每页的大小
		PageHelper.startPage(pn,5);
		//startPage后面紧跟的这个查询就是一个分页查询
		List<Employee> emps=employeeService.getAll();
		System.out.println(emps.toString());
		//使用pageInfo包装查询后的结果，只需要将pageInfo交给页面就行了
		//封装了详细的分页信息，包括有我们查询出来的数据，传入连续显示的页数
		PageInfo page = new PageInfo(emps,5);
//		System.out.println(page);
		model.addAttribute("info", page);
		return "list";
	}
	
	
	//以json的形式返回对象
	@RequestMapping("/emps")
	@ResponseBody
	public Msg getEmpsWithJson(@RequestParam(value="pn",defaultValue="1")Integer pn) {
		PageHelper.startPage(pn,6);
		//startPage后面紧跟的这个查询就是一个分页查询
		List<Employee> emps=employeeService.getAll();
		System.out.println(emps.toString());
		//使用pageInfo包装查询后的结果，只需要将pageInfo交给页面就行了
		//封装了详细的分页信息，包括有我们查询出来的数据，传入连续显示的页数
		PageInfo page = new PageInfo(emps,5);
		return Msg.success().add("pageInfo",page);
	}
	
	//校验用户名是否可用
	@RequestMapping("/checkuser")
	@ResponseBody
	public Msg checkuser(@RequestParam("empName")String empName) {
		//先判断用户名是否是合法的表达式
		String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";//java里正则表达式没有/.../
		if(!empName.matches(regx)) {
			return Msg.fail().add("va_msg","用户名必须是6-16位英文和数字的组合或2-5位中文(后台验证)");
		}
		//数据库用户名重复校验
		boolean b = employeeService.checkuser(empName);
		if(b) {
			return Msg.success();
		}else{
			return Msg.fail().add("va_msg","用户名不可用");
		}
	}
	
	
	
	//编辑，查询员工信息
	@RequestMapping(value="/emp/{id}",method=RequestMethod.GET)
	@ResponseBody
	public Msg getEmp(@PathVariable("id")Integer id) {
		Employee employee = employeeService.getEmp(id);
		return Msg.success().add("emp", employee);
	}
	
	//我们要能支持直接发送put之类的请求，还要封装请求踢中的数据
	//配置上HttpPutFormContentFilter
	//它的作用，将请求体重的数据解析包装成一个map，request被重新包装，request.getParameter()被重写，就会从自己封装的map中取数据
	//保存更新的员工数据
	@RequestMapping(value="/empsave/{empId}",method=RequestMethod.PUT)
	@ResponseBody
	public Msg saveEmp(Employee employee) {
		System.out.println("员工信息===="+employee.getEmpId());
		employeeService.updateEmp(employee);
		return Msg.success();
	}
	
	
	
	
	
	
	
	
	@RequestMapping("/test")
	public void getTest() {
		System.out.println("hello jssssava");
	}
}
