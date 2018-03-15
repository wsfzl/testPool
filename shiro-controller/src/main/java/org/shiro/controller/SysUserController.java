package org.shiro.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.shiro.crypto.hash.Md5Hash;
import org.shiro.dao.SysUserDao;
import org.shiro.pojo.SysUser;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/user")
public class SysUserController {
	
	@Resource
	private SysUserDao sysUserDao;
	

	public void setSysUserDao(SysUserDao sysUserDao) {
		this.sysUserDao = sysUserDao;
	}


	@RequestMapping("/index")
	public String index()throws Exception{
		
		return "sysUser/index";
		
		
	}
	
	@RequestMapping("/list")
	@ResponseBody
	public Map<String, Object> list(int page,int rows,@RequestParam(defaultValue="id") String sort,@RequestParam(defaultValue="asc") String order,SysUser condition)throws Exception{
		
		Map<String, Object> map = new HashMap<>();
		
		int start=(page-1) * rows;
		
		List<SysUser> list = sysUserDao.getListByCondition(start, rows, condition, sort, order);
		
		Integer total = sysUserDao.getCountByCondition(condition);
		
		map.put("rows", list);
		
		map.put("total", total);
		
		return map;
		
	}
	@RequestMapping("/batchDelete")
	@ResponseBody
	public Map<String, Object> batchDelete(Integer[] ids) throws Exception {
		Map<String, Object> map = new HashMap<>();
		sysUserDao.deleteByIds(ids);
		map.put("result", true);
		return map;
	}
	@RequestMapping(value="/form",method=RequestMethod.GET)
	public String form() throws Exception {
		return "sysUser/sysuser_form";
	}
	@RequestMapping(value="/add",method=RequestMethod.POST)
	public Map<String, Object> add(SysUser user,Integer[] roleIds){
		Map<String, Object> map = new HashMap<>();
		Md5Hash hMd5Hash = new Md5Hash(user.getPassword(), user.getSalt());
		user.setPassword(hMd5Hash.toString());
		sysUserDao.add(user);
		sysUserDao.addUserRole(user.getId(), roleIds);
		map.put("result", true);
		
		return map;
		
	}
	
	@RequestMapping(value="/edit",method=RequestMethod.POST)
	public Map<String, Object> edit(SysUser user,Integer[] roleIds){
		Map<String, Object> map = new HashMap<>();
		Md5Hash hMd5Hash = new Md5Hash(user.getPassword(), user.getSalt());
		user.setPassword(hMd5Hash.toString());
		sysUserDao.update(user);
		sysUserDao.addUserRole(user.getId(), roleIds);
		map.put("result", true);
		
		return map;
		
	}
	
	@RequestMapping("/view")
	@ResponseBody
	public SysUser view(Integer id) throws Exception {
		return sysUserDao.getById(id);
	}
}
