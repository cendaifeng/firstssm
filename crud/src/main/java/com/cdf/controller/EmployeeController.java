package com.cdf.controller;

import com.cdf.bean.Employee;
import com.cdf.bean.Msg;
import com.cdf.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

/**
 * 处理员工增删改查请求
 */
@Controller
public class EmployeeController {

    /**
     * 这里 spring.xml 的组件扫描配置 use-default-filters="true"（默认的）
     * 即使用默认的 Filter 进行扫描，不然会扫描不到
     */
    @Autowired
    EmployeeService employeeService;

    /**
     * 查询员工数据（分页查询）
     * @return 转发到 list 页面
     */
////    @RequestMapping("/emps")
//    @RequestMapping("/list")
//    public String getEmps(@RequestParam(value = "pn", defaultValue = "1")Integer pn,
//                          Model model) {
//
//        // 第二个参数 pageSize: 每页显示的条目数
//        PageHelper.startPage(pn, 5);
//        // startPage 后紧跟的查询就是一个分页查询
//        List<Employee> employeeList = employeeService.getAll();
//        // PageInfo 封装了详细的分页信息，我们将它放入隐含模型
//        // 第二个参数 navigatePages: 分页条显示的页码
//        PageInfo page = new PageInfo<>(employeeList, 6);
//        model.addAttribute("pageInfo", page);
//        return "list";
//    }

    /**
     * 新 查询员工数据（分页查询）
     * @return 返回存有页面信息的 Msg
     */
    @RequestMapping("/emps")
    @ResponseBody
    public Msg getEmpsWithJson(
            @RequestParam(value = "pn", defaultValue = "1")Integer pn) {

        PageHelper.startPage(pn, 5);
        List<Employee> employeeList = employeeService.getAll();
        PageInfo page = new PageInfo<>(employeeList, 6);
        return Msg.success().add("pageInfo", page);
     }

    /**
     * 保存员工数据
     * POST 请求 --> 保存
     * @param employee @Valid 是 Hibernate validation 的校验注解
     * @return
     */
    @RequestMapping(value = "/emps", method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmp(@Valid Employee employee, BindingResult result){

        // 若校验失败，也会像前端校验一样在模态框中显示错误信息
        if (result.hasErrors()) {
            HashMap<String, Object> map = new HashMap<>();
            List<FieldError> errors = result.getFieldErrors();
            for (FieldError fieldError : errors) {
                System.out.println("错误字段："+fieldError.getField());
                System.out.println("错误信息："+fieldError.getDefaultMessage());
                map.put(fieldError.getField(), fieldError.getDefaultMessage());
            }
            return Msg.fail().add("errorFields", map);
        } else {
            employeeService.saveEmp(employee);
            return Msg.success();
        }
    }

    /**
     * 检验用户名是否可用
     * @return
     */
    @RequestMapping(value = "/checkuser", method = RequestMethod.POST)
    @ResponseBody
    public Msg checkUser(@RequestParam("empName") String empName) {

        // 检测是否为合法表达式
        String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
        if (!empName.matches(regx)) {
            return Msg.fail().add("va_msg", "用户名必须为 2-5 位汉字或者 6-16 位英文与数字的组合");
        }
        // 检测数据库中是否已有相同数据
        boolean b = employeeService.checkUser(empName);
        if (b) {
            return Msg.success();
        }
        return Msg.fail().add("va_msg", "用户名已被使用");
    }

    /**
     * 更新员工数据
     * PUT 请求 --> 更新
     * @param employee @Valid 是 Hibernate validation 的校验注解
     * @return
     */
    @RequestMapping(value = "/emps/{empId}", method = RequestMethod.PUT)
    @ResponseBody
    public Msg updateEmp(@Valid Employee employee, BindingResult result){

        System.out.println(employee);

        // 若校验失败，也会像前端校验一样在模态框中显示错误信息
        if (result.hasErrors()) {
            HashMap<String, Object> map = new HashMap<>();
            List<FieldError> errors = result.getFieldErrors();
            for (FieldError fieldError : errors) {
                System.out.println("错误字段："+fieldError.getField());
                System.out.println("错误信息："+fieldError.getDefaultMessage());
                map.put(fieldError.getField(), fieldError.getDefaultMessage());
            }
            return Msg.fail().add("errorFields", map);
        } else {
            employee.setEmpName(null);
            employeeService.updateEmp(employee);
            return Msg.success();
        }
    }

    /**
     * 删除员工
     * DELETE 请求 --> 删除
     * @param ids 可支持单个或多条目同时删除，格式为 "id1-id2-id3"...
     * @return
     */
    @RequestMapping(value = "/emps/{ids}", method = RequestMethod.DELETE)
    @ResponseBody
    public Msg deleteEmp(@PathVariable("ids") String ids){
        if (ids.contains("-")) {
            String[] idArray = ids.split("-");

            ArrayList<Integer> list = new ArrayList<>();
            for (String id : idArray) {
                list.add( Integer.valueOf(id) );
            }
            employeeService.deleteBatch(list);
            System.out.println("delete "+list);
        } else {
            employeeService.deleteEmp(ids);
        }
        return Msg.success();
    }
}
