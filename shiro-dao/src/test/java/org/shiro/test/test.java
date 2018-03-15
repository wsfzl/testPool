package org.shiro.test;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.junit.After;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.shiro.dao.SysPermissionDao;
import org.shiro.dao.SysRoleDao;
import org.shiro.dao.SysUserDao;
import org.shiro.pojo.SysPermission;
import org.shiro.pojo.SysRole;
import org.shiro.pojo.SysUser;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:applicationContext-mybatis.xml")
public class test {


	@Resource
	private SysUserDao sysUserDao;
	@Resource
	private SysRoleDao sysRoleDao;
	@Resource
	private SysPermissionDao sysPermissionDao;
	
	

	public void setSysRoleDao(SysRoleDao sysRoleDao) {
		this.sysRoleDao = sysRoleDao;
	}



	public void setSysUserDao(SysUserDao sysUserDao) {
		this.sysUserDao = sysUserDao;
	}



	@Test
	public void test() {
//		SysUser condition = new SysUser();
		
//		List<SysRole> sysRoles = new ArrayList<>();
//		SysRole sysRole = new SysRole();
//		sysRole.setId(2);
//		sysRoles.add(sysRole);
//		condition.setSysRoles(sysRoles);
//		List<SysUser> list = sysUserDao.getListByCondition(0, 5, condition, "id", "asc");
//		for (SysUser sysUser : list) {
//			System.out.println(sysUser.getUsername());
//		}
//		SysRole condition=new SysRole();
//		SysRole sysRoles = new SysRole();
//		
//		condition.setName("后勤");
//		List<SysRole> list = sysRoleDao.getListByCondition(0, 5, condition, "id", "asc");
//		for (SysRole sysRole : list) {
//			System.out.println(sysRole.getName());
//		}
		int roleId = 2;
		List<Integer> list= sysPermissionDao.getPermissionIdsByRoleId(roleId);

for (Integer integer : list) {
	System.out.println(integer);
}
		
	}

}
