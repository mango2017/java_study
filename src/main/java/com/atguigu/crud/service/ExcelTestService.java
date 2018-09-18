package com.atguigu.crud.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.atguigu.crud.bean.Projects;
import com.atguigu.crud.dao.ExcelTestMapper;

@Service
public class ExcelTestService {
	@Autowired
	ExcelTestMapper excelTestMapper;
	
	public void insertProjects(Projects projects) {
		excelTestMapper.insertProjects(projects);
	}

	

	public void updateTime(Projects projects) {
		excelTestMapper.updateTime(projects);
		
	}
}
