package com.atguigu.crud.controller;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.forwardedUrl;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale.Category;

import javax.sound.midi.MidiDevice.Info;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.atguigu.crud.bean.Project;
import com.atguigu.crud.service.ExcelDemoService;

@Controller
public class ExcelDemoController {
	
	@Autowired
	ExcelDemoService excelDemoService;
	
	
	@RequestMapping(value="/excel",method=RequestMethod.GET)
	@ResponseBody
	public List<Project> readXls() throws IOException {
		InputStream is = new FileInputStream("D:\\javas\\ssm-crud\\src\\main\\resources\\1.xls");
		HSSFWorkbook hssfWorkbook = new HSSFWorkbook(is);
		Project project  = null;
		List<Project> list = new ArrayList<Project>();
		//System.out.println(hssfWorkbook);
		HSSFSheet hssfSheet = hssfWorkbook.getSheetAt(0);
		for(int rowNum=1;rowNum<=hssfSheet.getLastRowNum();rowNum++) {
			HSSFRow hssfRow = hssfSheet.getRow(rowNum);
			if(hssfRow != null) {
				project  = new Project();
				HSSFCell firstPoint = hssfRow.getCell(0);
				HSSFCell secondPoint = hssfRow.getCell(1);
				HSSFCell threePoint = hssfRow.getCell(2);
				HSSFCell startTime = hssfRow.getCell(3);
				HSSFCell endTime = hssfRow.getCell(4);
				project.setFirstPoint(getValue(firstPoint));
				project.setSecondPoint(getValue(secondPoint));
				project.setThreePoint(getValue(threePoint));
				project.setStartTime(getValue(startTime));
				project.setEndTime(getValue(endTime));
				list.add(project);
				
			}
		}
		for( int i = 0 ; i < list.size() ; i++) {//内部不锁定，效率最高，但在多线程要考虑并发操作的问题。
//		    System.out.print(list.get(i).getFirstPoint());
//		    System.out.print(list.get(i).getSecondPoint());
//		    System.out.print(list.get(i).getThreePoint());
//		    System.out.print(list.get(i).getStartTime());
//		    System.out.println(list.get(i).getEndTime());
			//遍历插入对象
			//不知道对不对啊，试试吧
			excelDemoService.insertProject(list.get(i));
			
		}
//		System.out.println("@@@@@@@@@@@@@@@@@="+list);
		return null;	
	}
	
	public String getValue(HSSFCell hssfCell) {
        if (hssfCell.getCellType() == hssfCell.CELL_TYPE_BOOLEAN) {
 
            return String.valueOf(hssfCell.getBooleanCellValue());
        } else if (hssfCell.getCellType() == hssfCell.CELL_TYPE_NUMERIC) {
 
            return String.valueOf(hssfCell.getNumericCellValue());
        } else {
 
            return String.valueOf(hssfCell.getStringCellValue());
        }
    }

}
