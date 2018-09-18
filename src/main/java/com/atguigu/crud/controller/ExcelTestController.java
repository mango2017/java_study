package com.atguigu.crud.controller;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.javassist.expr.NewArray;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.DateUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.atguigu.crud.bean.Projects;
import com.atguigu.crud.service.ExcelTestService;
import com.atguigu.crud.utils.DateUtils;

@Controller
public class ExcelTestController {
	@Autowired
	ExcelTestService excelTestService;

//	@RequestMapping(value = "/test", method = RequestMethod.POST)
//	@ResponseBody
//	public void test(@RequestParam("file") MultipartFile pic, HttpServletRequest request) throws IOException {
//		List<Projects> pList = readXls(pic.getInputStream());
//		System.out.println(pList);
//		
//	}

	@RequestMapping(value = "/exceltest", method = RequestMethod.GET)
	public void readXls() throws IOException {
		InputStream is = new FileInputStream("D:\\javas\\ssm-crud\\src\\main\\resources\\1.xls");
		HSSFWorkbook hssfWorkbook = new HSSFWorkbook(is);
		Projects projects1 = null;
		Projects projects2 = null;
		Projects projects3 = null;
		Projects projects = null;
		int firsrt_parentid = 0;// 2级的父id
		int second_parentid = 0;// 3级的父id

		List<Projects> list = new ArrayList<Projects>();
		HSSFSheet hssfSheet = hssfWorkbook.getSheetAt(0);
		for (int rowNum = 1; rowNum <= hssfSheet.getLastRowNum(); rowNum++) {
			HSSFRow hssfRow = hssfSheet.getRow(rowNum);
			if (hssfRow != null) {
				projects1 = new Projects();
				projects2 = new Projects();
				projects3 = new Projects();
				projects = new Projects();

				HSSFCell firstPoint = hssfRow.getCell(0) != null ? hssfRow.getCell(0) : null;
				HSSFCell secondPoint = hssfRow.getCell(1) != null ? hssfRow.getCell(1) : null;
				HSSFCell threePoint = hssfRow.getCell(2) != null ? hssfRow.getCell(2) : null;
				HSSFCell startTime = hssfRow.getCell(3) != null ? hssfRow.getCell(3) : null;
				HSSFCell endTime = hssfRow.getCell(4) != null ? hssfRow.getCell(4) : null;
				String startTime1 = convertCellToString(startTime);
				String endTime1 = convertCellToString(endTime);
				// 一级节点
				if (firstPoint != null) {
					projects1.setProjectName(getValue(firstPoint));
					projects1.setLevel(1); // 1级别
					projects1.setParentId(0); // 父id
				}
				if (startTime1 != null) {
					projects1.setStartTime(DateUtils.parseDate(startTime1));
				}
				if (endTime1 != null) {
					projects1.setEndTime(DateUtils.parseDate(endTime1));
				}
				// 插入一级节点，返回插入id
				if (firstPoint != null) {
					excelTestService.insertProjects(projects1);
					firsrt_parentid = projects1.getId();// 返回二级父id
					System.out.println(firsrt_parentid);
				}

				// 二级节点
				if (secondPoint != null) {
					projects2.setProjectName(getValue(secondPoint));
					projects2.setLevel(2);// 2级别
					projects2.setParentId(firsrt_parentid);// 父id
				}
				if (startTime1 != null) {
					projects2.setStartTime(DateUtils.parseDate(startTime1));
				}

				if (endTime1 != null) {
					projects2.setEndTime(DateUtils.parseDate(endTime1));
				}
				if (secondPoint != null) {
					excelTestService.insertProjects(projects2);
					second_parentid = projects2.getId();// 返回三级父id
				}

				// 三级节点
				if (threePoint != null) {
					projects3.setProjectName(getValue(threePoint));
					projects3.setLevel(3);
					projects3.setParentId(second_parentid);
				}

				if (startTime1 != null) {
					projects3.setStartTime(DateUtils.parseDate(startTime1));
				}

				if (endTime1 != null) {
					projects3.setEndTime(DateUtils.parseDate(endTime1));
				}

				if (threePoint != null) {
					excelTestService.insertProjects(projects3);
				}
				// 当 一级节点 和二级节点为空的时候，最后截止时间赋值给二级节点
				if (firstPoint == null && secondPoint == null) {
					projects.setEndTime(DateUtils.parseDate(endTime1));
					projects.setId(second_parentid);
					excelTestService.updateTime(projects);
					projects.setEndTime(DateUtils.parseDate(endTime1));
					projects.setId(firsrt_parentid);
					excelTestService.updateTime(projects);
				}

			}

		}

	}

	public static String getValue(HSSFCell hssfCell) {
		if (hssfCell.getCellType() == hssfCell.CELL_TYPE_BOOLEAN) {
			return String.valueOf(hssfCell.getBooleanCellValue());
		} else if (hssfCell.getCellType() == hssfCell.CELL_TYPE_NUMERIC) {
			return String.valueOf(hssfCell.getNumericCellValue());
		} else {
			return String.valueOf(hssfCell.getStringCellValue());
		}
	}

	public static String convertCellToString(HSSFCell cell) {
		// 如果为null会抛出异常，应当返回空字符串
		if (cell == null)
			return "";

		// POI对单元格日期处理很弱，没有针对的类型，日期类型取出来的也是一个double值，所以同样作为数值类型
		// 解决日期2006/11/02格式读入后出错的问题，POI读取后变成“02-十一月-2006”格式
		if (cell.toString().contains("-") && checkDate(cell.toString())) {
			String ans = "";
			try {
				ans = new SimpleDateFormat("yyyy/MM/dd").format(cell.getDateCellValue());

			} catch (Exception e) {

				ans = cell.toString();
			}
			return ans;
		}

		cell.setCellType(CellType.STRING);
		return cell.getStringCellValue();
	}

	private static boolean checkDate(String str) {
		String[] dataArr = str.split("-");
		try {
			if (dataArr.length == 3) {
				int x = Integer.parseInt(dataArr[0]);
				String y = dataArr[1];
				int z = Integer.parseInt(dataArr[2]);
				if (x > 0 && x < 32 && z > 0 && z < 10000 && y.endsWith("月")) {
					return true;
				}
			}
		} catch (Exception e) {
			return false;
		}
		return false;
	}

}
