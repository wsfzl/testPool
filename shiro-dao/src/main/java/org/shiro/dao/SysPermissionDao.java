package org.shiro.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.shiro.pojo.SysPermission;

public interface SysPermissionDao extends CommonDao<SysPermission, Integer>{

	public List<Integer> getPermissionIdsByRoleId(Integer id);
	
	public void deletePermissionsByRoleId(Integer roleId);
	
	public void addRolePermissions(@Param("roleId") Integer roleId,@Param("perIds") List<Integer> perIds);
}








