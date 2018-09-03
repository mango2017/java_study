package com.atguigu.crud.test;

import java.util.UUID;

import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.atguigu.crud.bean.Department;
import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.dao.DepartmentMapper;
import com.atguigu.crud.dao.EmployeeMapper;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations= {"classpath:applicationContext.xml"})
public class MapperTest  {
	/**
	 * 
	 * ����
	 * @param args
	 */
	@Autowired
	private DepartmentMapper departmentMapper;
	
	@Autowired
	private EmployeeMapper employeeMapper;
	
	@Autowired
	SqlSession sqlSession;
	
	@Test
	public void testCRUD() {
//		System.out.println(1);
		//1.����springioc����
//		ApplicationContext ioc = new ClassPathXmlApplicationContext("applicationContext.xml");
//		//�������л�ȡmapper
//		DepartmentMapper bean = ioc.getBean(DepartmentMapper.class);
//		System.out.println(departmentMapper);
		departmentMapper.insertSelective(new Department(null, "���۲�s"));
		departmentMapper.insertSelective(new Department(null, "��Ӫ��s"));
//		
		//��������
//		EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
//		for(int i=0;i<20;i++) {
//			String uid = UUID.randomUUID().toString().substring(0, 5) + i;
//			mapper.insertSelective(new Employee(null,uid,"M","123@qq.com",1));
//		}
//		System.out.println("������ɲ���");
		
	}

}
