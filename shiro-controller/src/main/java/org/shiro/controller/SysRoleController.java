package org.shiro.controller;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.shiro.dao.SysPermissionDao;
import org.shiro.dao.SysRoleDao;
import org.shiro.pojo.SysRole;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/role")
public class SysRoleController {
	@Resource
	private SysRoleDao sysRoleDao;
	@Resource
	private SysPermissionDao sysPermissionDao;
	public void setSysRoleDao(SysRoleDao sysRoleDao) {
		this.sysRoleDao = sysRoleDao;
	}
	@RequestMapping("/all")
	@ResponseBody
	public List<SysRole> all() throws Exception{
		return sysRoleDao.getAll();
	}
	@RequestMapping("roleindex")
	public String roleindex()throws Exception {
		return "sysRole/roleindex";
		
	}
	@RequestMapping("/rolelist")
	@ResponseBody
	public Map<String, Object> rolelist(int page,int rows,@RequestParam(defaultValue="id") String sort,@RequestParam(defaultValue="asc") String order,SysRole condition)throws Exception{
		
		Map<String, Object> map = new HashMap<>();
		
		int start=(page-1) * rows;
		
		List<SysRole> list = sysRoleDao.getListByCondition(start, rows, condition, sort, order);
		
		Integer total = sysRoleDao.getCountByCondition(condition);
		
		map.put("rows", list);
		
		map.put("total", total);
		
		return map;
		
	}
	@RequestMapping(value="/form",method=RequestMethod.GET)
	public String form() throws Exception{
		return "sysRole/sysrole_form";
	}
	@RequestMapping(value="add",method=RequestMethod.POST)
	public Map<String, Object> add(SysRole sysRole) throws Exception{
		Map<String, Object> map = new HashMap<>();
		sysRoleDao.add(sysRole);
		map.put("result", true);
		return map;
		
	}
	@RequestMapping("/batchDelete")
	@ResponseBody
	public Map<String, Object> batchDelete(Integer[] ids) throws Exception {
		Map<String, Object> map = new HashMap<>();
		sysRoleDao.deleteByIds(ids);
		map.put("result", true);
		return map;
	}
	
	@RequestMapping("/view")
	@ResponseBody
	public SysRole view(Integer id) throws Exception {
		return sysRoleDao.getById(id);
	}
	
	@RequestMapping(value="/edit",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> edit(SysRole sysRole) throws Exception{
		Map<String, Object> map = new HashMap<>();
		sysRoleDao.update(sysRole);
		map.put("result", true);
		return map;
	}
	@RequestMapping("/toAssgin")
	public String toAssgin(Integer rid,ModelMap modelMap) throws Exception{
		modelMap.put("roleId", rid);
		return "sysRole/assgin";
	}
	@RequestMapping("/getPermissions")
	@ResponseBody
	public List<Integer> selectPermission(Integer id){
		return sysPermissionDao.getPermissionIdsByRoleId(id);
		
	}
	
	@RequestMapping("/assign")
	@ResponseBody
	public Map<String, Object> assign(Integer roleId,Integer[] ids) throws Exception {
		Map<String, Object> map = new HashMap<>();
		
		sysPermissionDao.deletePermissionsByRoleId(roleId);
		sysPermissionDao.addRolePermissions(roleId, Arrays.asList(ids));
		map.put("result", true);
		return map;
	}

}
