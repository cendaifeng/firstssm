import com.cdf.bean.Employee;
import com.github.pagehelper.PageInfo;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.List;

/**
 * 测试crud请求
 */
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {"file:C:\\Users\\Administrator\\IdeaProjects\\firstSSM\\crud\\web\\WEB-INF\\springmvc-servlet.xml", "classpath:applicationContext.xml"})
public class MvcTest {

    // 传入 springmvc 的 ioc
    @Autowired
    WebApplicationContext context;
    // 虚拟 mvc 请求
    MockMvc mockMvc;

    @Before
    public void initMockMvc() {
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    @Test
    public void testPage() throws Exception {
        // 模拟请求，拿到返回值
        MvcResult result = mockMvc.perform(
                MockMvcRequestBuilders.get("/emps").param("pn", "6")).andReturn();
        // 请求成功后，请求域中会有 pageInfo
        MockHttpServletRequest request = result.getRequest();
        PageInfo pageInfo = (PageInfo) request.getAttribute("pageInfo");

        System.out.println("getPageNum(): " + pageInfo.getPageNum() + "\n"
                + "getPages(): " + pageInfo.getPages() + "\n"
                + "getTotal(): " + pageInfo.getTotal());
        System.out.println("导航码：");
        int[] nums = pageInfo.getNavigatepageNums();
        for (int i : nums) {
            System.out.print("  "+i);
        }
        System.out.println();

        // 获取员工数据
        List<Employee> list = pageInfo.getList();
        for (Employee employee : list) {
            System.out.println("ID: "+employee.getEmpId()+" ==> Name: "+employee.getEmpName());
            System.out.println(employee);
        }

    }

}
