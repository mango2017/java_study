package com.atguigu.crud.controller;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
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

import com.atguigu.crud.bean.Project;
import com.atguigu.crud.service.ExcelDemoService;
import com.atguigu.crud.utils.DateUtils;

@Controller
public class ExcelDemoController {
	@Autowired
	ExcelDemoService excelDemoService;

	@RequestMapping(value = "/excel", method = RequestMethod.POST)
	@ResponseBody
	public void test(@RequestParam("file") MultipartFile pic, HttpServletRequest request) throws IOException {
		List<Project> pList = readXls(pic.getInputStream());
		System.out.println(pList);
		
	}
	public List<Project> readXls(InputStream is) throws IOException {
		//InputStream is = new FileInputStream("D:\\javas\\ssm-crud\\src\\main\\resources\\1.xls");
		
		HSSFWorkbook hssfWorkbook = new HSSFWorkbook(is);
		Project project = null;
		List<Project> list = new ArrayList<Project>();
		HSSFSheet hssfSheet = hssfWorkbook.getSheetAt(0);
		for (int rowNum = 1; rowNum <= hssfSheet.getLastRowNum(); rowNum++) {
			HSSFRow hssfRow = hssfSheet.getRow(rowNum);
			if (hssfRow != null) {
				project = new Project();
				HSSFCell firstPoint = hssfRow.getCell(0);
				HSSFCell secondPoint = hssfRow.getCell(1);
				HSSFCell threePoint = hssfRow.getCell(2);
				HSSFCell startTime = hssfRow.getCell(3);
				HSSFCell endTime = hssfRow.getCell(4);
				System.out.println("看这里"+startTime);
				project.setFirstPoint(getValue(firstPoint));
				project.setSecondPoint(getValue(secondPoint));
				project.setThreePoint(getValue(threePoint));

				// 看这里
				String startTime1 = convertCellToString(startTime);
				String endTime1 = convertCellToString(endTime);
				System.out.println("@@@@@=" + startTime1);

				project.setStartTime(DateUtils.parseDate(startTime1));
				project.setEndTime(DateUtils.parseDate(endTime1));
				System.out.println("========" + project.getStartTime());

				list.add(project);
			}
		}
		//System.out.println(list.toString());
		for (int i = 0; i < list.size(); i++) {
			System.out.print(list.get(i).getFirstPoint());
			System.out.print(list.get(i).getSecondPoint());
			System.out.print(list.get(i).getThreePoint());
			System.out.print(list.get(i).getStartTime());
			System.out.println(list.get(i).getEndTime());
////			// 遍历插入对象
////			// 不知道对不对啊，试试吧
			 excelDemoService.insertProject(list.get(i));
////
		}
//		System.out.println(list);
		return list;

	}

//	public String getValue(HSSFCell hssfCell) {
//		if (hssfCell.getCellType() == hssfCell.CELL_TYPE_BOOLEAN) {
//			return String.valueOf(hssfCell.getBooleanCellValue());
//		} else if (hssfCell.getCellType() == hssfCell.CELL_TYPE_NUMERIC) {
//			return String.valueOf(hssfCell.getNumericCellValue());
//		} else {
//			return String.valueOf(hssfCell.getStringCellValue());
//		}
//	}

	public static String getValue(HSSFCell hssfCell) {
		if (hssfCell.getCellType() == hssfCell.CELL_TYPE_BOOLEAN) {

			return String.valueOf(hssfCell.getBooleanCellValue());
		} else if (hssfCell.getCellType() == hssfCell.CELL_TYPE_NUMERIC) {
//            DecimalFormat df = new DecimalFormat("#####");
//            return String.valueOf(df.format(hssfCell.getNumericCellValue()));

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
				System.out.println("走这里了吗2222");
			} catch (Exception e) {
				System.out.println("走这里了吗1111");
				ans = cell.toString();
			}
			return ans;
		}
		System.out.println("哈哈哈");
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
