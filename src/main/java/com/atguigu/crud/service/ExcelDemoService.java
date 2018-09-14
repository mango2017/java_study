package com.atguigu.crud.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.atguigu.crud.bean.Project;
import com.atguigu.crud.dao.ExcelDemoMapper;

@Service
public class ExcelDemoService {
	@Autowired
	ExcelDemoMapper excelDemoMapper;
	
	public void insertProject(Project project) {
		excelDemoMapper.insertProject(project);
	}
}
