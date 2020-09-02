package com.cdf.service;

import com.cdf.bean.Department;
import com.cdf.dao.DepartmentMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.Collection;

@Controller
public class DepartmentService {

    @Autowired
    private DepartmentMapper departmentMapper;

    /**
     * 查询所有部门
     * @return 部门列表
     */
    public Collection<Department> getAll() {
        return departmentMapper.selectByExample(null);
    }
}
