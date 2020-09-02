package com.cdf.controller;

import com.cdf.bean.Department;
import com.cdf.bean.Msg;
import com.cdf.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * 处理和部门有关的请求
 */
@Controller
public class DepartmentController {

    @Autowired
    DepartmentService departmentService;

    /**
     * 查询部门信息
     * @return 以 Msg 形式返回给页面
     */
    @RequestMapping("/depts")
    @ResponseBody
    public Msg getDepts() {

        List<Department> all = (List<Department>) departmentService.getAll();
        return Msg.success().add("depts", all);
    }
}
