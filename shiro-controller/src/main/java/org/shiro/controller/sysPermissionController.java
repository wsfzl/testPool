package org.shiro.controller;

import java.util.List;

import javax.annotation.Resource;

import org.shiro.dao.SysPermissionDao;
import org.shiro.pojo.SysPermission;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/permission")
public class sysPermissionController {
	@Resource
	private SysPermissionDao sysPermissionDao;

	public void setSysPermissionDao(SysPermissionDao sysPermissionDao) {
		this.sysPermissionDao = sysPermissionDao;
	}
	
	@RequestMapping("/index")
	public String index()throws Exception{
		return "syspermission/index";	
	}
	@RequestMapping("/list")
	@ResponseBody
	public List<SysPermission> list() throws Exception{
		return sysPermissionDao.getAll();
	}
	@RequestMapping("/form")
	public String form() throws Exception {
		return "syspermission/syspermission_form";
	}
}
