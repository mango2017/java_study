package com.atguigu.crud.controller;

import java.io.File;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.fileupload.FileItem;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.method.annotation.ResponseBodyEmitterReturnValueHandler;

@Controller
public class FileDemoController {
	 @RequestMapping(value="/files")
    public void files(@RequestParam("file") MultipartFile pic, HttpServletRequest request) throws Exception {
		 	String path = request.getSession().getServletContext().getRealPath("./upload");
		 	String filename = pic.getOriginalFilename();
		 	System.out.println(pic.getInputStream());
//		 	File dir = new File(path, filename);
//		 	System.out.println(dir);
//		 	if(!dir.exists()) {
//		 		System.out.println("创建目录吗");
//		 		dir.mkdirs();
//		 	}
//		 	pic.transferTo(dir);
//		 	System.out.println(1);
		 
    }
}
