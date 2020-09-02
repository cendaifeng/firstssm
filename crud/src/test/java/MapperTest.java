import com.cdf.bean.Department;
import com.cdf.bean.Employee;
import com.cdf.dao.DepartmentMapper;
import com.cdf.dao.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.UUID;

/**
 * 测试 dao 层
 * 使用 @ContextConfiguration 注解自动创建 ioc 容器
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {

    @Autowired
    DepartmentMapper departmentMapper;

    @Autowired
    EmployeeMapper employeeMapper;

    @Autowired
    SqlSession sqlSession;

    @Test
    public void testDepartmentMapper() {

        departmentMapper.insertSelective(new Department(null, "开发部"));

        departmentMapper.insertSelective(new Department(null, "测试部"));

    }

    @Test
    public void testEmployeeMapper() {

//        employeeMapper.insertSelective(new Employee(null, "梁伟涛", "M","liangweitao@stu.jluzh.edu.cn", 1));

        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);

        for (int i = 0; i < 10; i++) {
            String uid = UUID.randomUUID().toString().substring(0, 5) + i;
            mapper.insertSelective(new Employee(null, uid, "M",uid+"@stu.jluzh.edu.cn", 1));
        }
        System.out.println("批量插入完成");
    }

}
