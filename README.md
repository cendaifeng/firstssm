# 第一个 Spring-SpringMVC-Mybatis 项目记录

基本功能点有：

- 分页
- 数据校验
  + jquery前端校验+JSR303后端校验
- ajax
- Rest风格的URI，即使用HTTP协议请求方式的动词，来表示对资源的操作

技术点：

- 基础框架-ssm（SpringMVC+Spring+MyBatis）
- 数据库-MySQL
- 前端框架-bootstrap
- 项目依赖管理-Maven
- 分页-pagehelper
- 逆向工程-MyBatis Generator





## 环境配置部分

### Maven settings.xml

```xml
<!-- 配置 JDK 编译版本 -->
<profile>     
    <id>JDK-1.8</id>       
    <activation>       
        <activeByDefault>true</activeByDefault>       
        <jdk>1.8</jdk>       
    </activation>       
    <properties>       
        <maven.compiler.source>1.8</maven.compiler.source>       
        <maven.compiler.target>1.8</maven.compiler.target>       
        <maven.compiler.compilerVersion>1.8</maven.compiler.compilerVersion>       
    </properties>       
</profile>
```

```xml
<!-- 设置镜像仓库 -->
<!-- 阿里云仓库 -->
<mirror>
    <id>alimaven</id>
    <mirrorOf>central</mirrorOf>
    <name>aliyun maven</name>
    <url>https://maven.aliyun.com/repository/central</url>
</mirror>

<!-- 中央仓库1 -->
<mirror>
    <id>repo1</id>
    <mirrorOf>central</mirrorOf>
    <url>http://repo1.maven.org/maven2/</url>
</mirror>

<!-- 中央仓库2 -->
<mirror>
    <id>repo2</id>
    <mirrorOf>central</mirrorOf>
    <url>http://repo2.maven.org/maven2/</url>
</mirror>
```

### 引入 jar 包

注意，在 tomcat 中本身就包含了 servlet ，所以在引入时会加上 ``<scope>provided</scope>`` 以防止冲突；mysql 驱动版本需要与系统 mysql 数据库版本匹配，否则易出现*时区*错误。

```xml
<dependencies>
        <!-- SpringMVC, Spring -->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-webmvc</artifactId>
            <version>5.2.7.RELEASE</version>
        </dependency>
        <!-- Spring整合jdbc -->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-jdbc</artifactId>
            <version>5.2.7.RELEASE</version>
        </dependency>
        <!-- spring-test -->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-test</artifactId>
            <version>5.2.7.RELEASE</version>
        </dependency>
        <!-- https://mvnrepository.com/artifact/org.aspectj/aspectjrt -->
        <dependency>
            <groupId>org.aspectj</groupId>
            <artifactId>aspectjrt</artifactId>
            <version>1.9.5</version>
        </dependency>
        <!-- https://mvnrepository.com/artifact/org.aspectj/aspectjweaver -->
        <dependency>
            <groupId>org.aspectj</groupId>
            <artifactId>aspectjweaver</artifactId>
            <version>1.9.5</version>
        </dependency>
        
        <!-- MyBatis -->
        <dependency>
            <groupId>org.mybatis</groupId>
            <artifactId>mybatis</artifactId>
            <version>3.5.5</version>
        </dependency>
        <!-- MyBatis整合Spring -->
        <dependency>
            <groupId>org.mybatis</groupId>
            <artifactId>mybatis-spring</artifactId>
            <version>2.0.5</version>
        </dependency>
        <!-- mybatis-generator -->
        <dependency>
            <groupId>org.mybatis.generator</groupId>
            <artifactId>mybatis-generator-core</artifactId>
            <version>1.4.0</version>
        </dependency>
        <!-- Druid -->
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>druid</artifactId>
            <version>1.1.20</version>
        </dependency>
        <!-- Mysql驱动 -->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>5.1.47</version>
        </dependency>

        <!-- jstl/jstl -->
        <dependency>
            <groupId>jstl</groupId>
            <artifactId>jstl</artifactId>
            <version>1.2</version>
        </dependency>
        <!-- javax.servlet-api -->
        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>javax.servlet-api</artifactId>
            <version>4.0.1</version>
            <scope>provided</scope>
        </dependency>
        <!-- javax.servlet.jsp-api -->
        <dependency>
            <groupId>javax.servlet.jsp</groupId>
            <artifactId>javax.servlet.jsp-api</artifactId>
            <version>2.3.3</version>
            <scope>provided</scope>
        </dependency>
        <!-- junit -->
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.12</version>
            <scope>test</scope>
        </dependency>
        
    </dependencies>
```

### 导入 BootStrap 

在 web 目录下导入 BootStrap 和 Jquery 的静态资源

![image-20200817221657219](https://github.com/cendaifeng/firstssm/blob/master/assets/image-20200817221657219.png)

在 index.jsp 页面引入

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>$Title$</title>
    <!-- Bootstrap 核心 CSS 文件 -->
    <link href="static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) -->
    <script src="static/js/jquery-1.12.4.min.js"></script>
    <!-- Bootstrap 核心 JavaScript 文件 -->
    <script src="static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
  </head>
  <body>
  $END$
  </body>
</html>
```

### 编写 SSM 整合配置文件

- web.xml
- springmvc-servlet.xml
- applicationContext.xml
- mybatis-config.xml

``` xml
<!-- web.xml -->

<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
         http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">

    <!--  字节码过滤器  -->
    <filter>
        <filter-name>CharacterEncodingFilter</filter-name>
        <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
        <init-param>
            <param-name>encoding</param-name>
            <param-value>UTF-8</param-value>
        </init-param>
        <init-param>
            <param-name>forceRequestEncoding</param-name>
            <param-value>true</param-value>
        </init-param>
        <init-param>
            <param-name>forceResponseEncoding</param-name>
            <param-value>true</param-value>
        </init-param>
    </filter>
    <filter-mapping>
        <filter-name>CharacterEncodingFilter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>

    <!--  启动 Spring 容器  -->
    <context-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>classpath:applicationContext.xml</param-value>
    </context-param>

    <listener>
        <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
    </listener>

    <!-- SpringMVC 的前端控制器 -->
    <!-- 拦截所有请求 -->
    <servlet>
        <servlet-name>springmvc</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
        <init-param>
            <param-name>contextConfigLocation</param-name>
            <param-value>WEB-INF/springmvc-servlet.xml</param-value>
        </init-param>
        <load-on-startup>1</load-on-startup>
    </servlet>
    <servlet-mapping>
        <servlet-name>springmvc</servlet-name>
        <url-pattern>/</url-pattern>
    </servlet-mapping>

    <!--  使用 Rest 风格的URI  -->
    <filter>
        <filter-name>HiddenHttpMethodFilter</filter-name>
        <filter-class>org.springframework.web.filter.HiddenHttpMethodFilter</filter-class>
    </filter>
    <filter-mapping>
        <filter-name>HiddenHttpMethodFilter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>

</web-app>
```

```xml
<!-- springmvc-servlet.xml -->

<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/context
         https://www.springframework.org/schema/context/spring-context.xsd
          http://www.springframework.org/schema/mvc
           https://www.springframework.org/schema/mvc/spring-mvc.xsd">

    <!--  配置组件扫描，只扫描控制器  -->
    <context:component-scan base-package="com.cdf" use-default-filters="false">
        <context:include-filter type="annotation" expression="org.springframework.stereotype.Controller"/>
    </context:component-scan>
    
    <!--  配置视图解析器  -->
    <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
        <property name="prefix" value="/WEB-INF/views/"></property>
        <property name="suffix" value=".jsp"></property>
    </bean>

    <!--  将 springmvc 不能处理的请求交给 Tomcat  -->
    <mvc:default-servlet-handler/>
    <!--  JSR303 校验，快捷 Ajax 映射动态请求  -->
    <mvc:annotation-driven/>

</beans>
```

```xml
<!-- applicationContext.xml -->

<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context" xmlns:tx="http://www.springframework.org/schema/tx"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/context https://www.springframework.org/schema/context/spring-context.xsd http://www.springframework.org/schema/tx http://www.springframework.org/schema/tx/spring-tx.xsd http://www.springframework.org/schema/aop https://www.springframework.org/schema/aop/spring-aop.xsd">

    <!--  配置组件扫描，不扫描控制器  -->
    <context:component-scan base-package="com.cdf" >
        <context:exclude-filter type="annotation" expression="org.springframework.stereotype.Controller"/>
    </context:component-scan>

    <!--  数据源  -->
    <!--  引入外部文件  -->
    <context:property-placeholder location="classpath:dbconfig.properties"/>
    <bean id="druidDataSource" class="com.alibaba.druid.pool.DruidDataSource" init-method="init" destroy-method="close">
        <property name="driverClassName" value="${jdbc_driverClassName}" />
        <property name="url" value="${jdbc_url}" />
        <property name="username" value="${jdbc_user}" />
        <property name="password" value="${jdbc_password}" />
    </bean>

    <!-- 配置与MyBatis的整合-->
    <bean id="sqlSessionFactoryBean" class="org.mybatis.spring.SqlSessionFactoryBean">
        <property name="dataSource" ref="druidDataSource"/>
        <property name="configLocation" value="classpath:mybatis-config.xml"/>
        <property name="mapperLocations" value="classpath:mapper/*.xml"/>
    </bean>

    <!-- 配置扫描器，将 mybais 接口的实现加入到 ioc 容器 -->
    <bean id="mapperScannerConfigurer" class="org.mybatis.spring.mapper.MapperScannerConfigurer">
        <property name="basePackage" value="com.cdf.dao"/>
    </bean>
    
    <!--  配置一个可以批量插入的 sqlSession  -->
    <bean id="sqlSessionTemplate" class="org.mybatis.spring.SqlSessionTemplate">
        <constructor-arg name="sqlSessionFactory" ref="sqlSessionFactoryBean"></constructor-arg>
        <constructor-arg name="executorType" value="BATCH"></constructor-arg>
    </bean>

    <!--  事务控制配置  -->
    <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <property name="dataSource" ref="druidDataSource"/>
    </bean>

    <!-- 配置事务增强 -->
    <tx:advice id="txAdvice" transaction-manager="transactionManager">
        <tx:attributes>
            <tx:method name="*" propagation="REQUIRED" read-only="false"/>
            <tx:method name="get" propagation="SUPPORTS" read-only="true"/>
        </tx:attributes>
    </tx:advice>

    <aop:config>
        <aop:pointcut id="txPonintcut" expression="execution(* com.cdf.service..*(..))"/>
        <aop:advisor advice-ref="txAdvice" pointcut-ref="txPonintcut"/>
    </aop:config>

</beans>
```

```xml
<!-- mybatis-config.xml -->

<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <settings>
        <setting name="mapUnderscoreToCamelCase" value="true"/>
    </settings>
    <typeAliases>
        <package name="com.cdf.bean"/>
    </typeAliases>

<!--  mappers 已在 Spring 中配置，无需在此配置  -->
<!--    <environments default="development">-->
<!--        <environment id="development">-->
<!--            <transactionManager type="JDBC"/>-->
<!--            <dataSource type="POOLED">-->
<!--                <property name="driver" value="com.mysql.jdbc.Driver" />-->
<!--                <property name="url" value="jdbc:mysql://localhost:3306/ssm_crud" />-->
<!--                <property name="username" value="root" />-->
<!--                <property name="password" value="abc123" />-->
<!--            </dataSource>-->
<!--        </environment>-->
<!--    </environments>-->
<!--    <mappers>-->
<!--        <mapper resource="mapper/DepartmentMapper.xml"/>-->
<!--        <mapper resource="mapper/EmployeeMapper.xml"/>-->
<!--    </mappers>-->

</configuration>
```

### 配置 MyBatis 生成器

注意，MBG.xml 和 MBGTest.java 中的地址都要求写*绝对路径*。

```xml
<!-- MBG.xml -->

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE generatorConfiguration
        PUBLIC "-//mybatis.org//DTD MyBatis Generator Configuration 1.0//EN"
        "http://mybatis.org/dtd/mybatis-generator-config_1_0.dtd">

<generatorConfiguration>
    <context id="MySQLTables" targetRuntime="MyBatis3">
        <commentGenerator>
            <!-- 去除自动生成的注释 -->
            <property name="suppressAllComments" value="true"/>
        </commentGenerator>
        <!-- 配置数据库连接信息 -->
        <jdbcConnection driverClass="com.mysql.cj.jdbc.Driver"
                        connectionURL="jdbc:mysql://localhost:3306/ssm_crud?useUnicode=true&amp;characeterEncoding=utf-8&amp;serverTimezone=UTC"
                        userId="root"
                        password="abc123">
        </jdbcConnection>

        <javaTypeResolver >
            <property name="forceBigDecimals" value="false" />
        </javaTypeResolver>
        <!-- 指定 JavaBean 生成的位置 -->
        <javaModelGenerator targetPackage="com.cdf.bean" targetProject="C:\Users\Administrator\IdeaProjects\firstSSM\crud\src\main\java">
            <property name="enableSubPackages" value="true" />
            <property name="trimStrings" value="true" />
            <!-- 是否对modal添加构造函数 -->
            <property name="constructorBased" value="true"/>
        </javaModelGenerator>
        <!-- 指定 sql 映射文件生成的位置 -->
        <sqlMapGenerator targetPackage="mapper"  targetProject="C:\Users\Administrator\IdeaProjects\firstSSM\crud\src\main\resources">
            <property name="enableSubPackages" value="true" />
        </sqlMapGenerator>
        <!-- 指定 dao 接口生成的位置 -->
        <javaClientGenerator type="XMLMAPPER" targetPackage="com.cdf.dao"  targetProject="C:\Users\Administrator\IdeaProjects\firstSSM\crud\src\main\java">
            <property name="enableSubPackages" value="true" />
        </javaClientGenerator>

        <!-- 指定每个表的生成策略 -->
        <table tableName="employee" domainObjectName="Employee" ></table>
        <table tableName="department" domainObjectName="Department"
               enableCountByExample="false" enableUpdateByExample="false"
               enableDeleteByExample="false" enableSelectByExample="true"
               selectByExampleQueryId="false">
                <!-- 禁用掉一些从句语句 -->
        </table>

    </context>
</generatorConfiguration>
```

运行该类 mybatisGenerator 就会自动生成 JavaBean，Mapper 和 sql 映射文件

```java
/* MBGTest.java */

public class MBGTest {

    public static void main(String[] args) throws Exception {
        List<String> warnings = new ArrayList<String>();
        boolean overwrite = true;
        File configFile = new File("C:\\Users\\Administrator\\IdeaProjects\\firstSSM\\crud\\mbGenerator.xml");
        ConfigurationParser cp = new ConfigurationParser(warnings);
        Configuration config = cp.parseConfiguration(configFile);
        DefaultShellCallback callback = new DefaultShellCallback(overwrite);
        MyBatisGenerator myBatisGenerator = new MyBatisGenerator(config, callback, warnings);
        myBatisGenerator.generate(null);
    }
}
```

此时的项目文件结构为：

![image-20200818163940317](https://github.com/cendaifeng/firstssm/blob/master/assets/image-20200818163940317.png)

### 根据实际情况补充 dao 接口（Mapper 类）和映射文件 mappe.xml

查询 Employee 时，我们希望将部门名称等信息一并查出以展示，从而减少二次查询的时间开销。

```java
/* EmployeeMapper.java */

    // 新增的结果包含部门的查询方法
    List<Employee> selectByExampleWithDept(EmployeeExample example);

    Employee selectByPrimaryKeyWithDept(Integer empId);
```

Employee 类中增加  ``private Department department;`` 字段。

```xml
<!-- EmployeeMapper.xml -->

  <!-- ... -->
  <!-- 新增带部门字段的结果集映射 -->
  <resultMap id="WithDeptResultMap" type="com.cdf.bean.Employee">
    <constructor>
      <idArg column="emp_id" javaType="java.lang.Integer" jdbcType="INTEGER" />
      <arg column="emp_name" javaType="java.lang.String" jdbcType="VARCHAR" />
      <arg column="gender" javaType="java.lang.String" jdbcType="CHAR" />
      <arg column="email" javaType="java.lang.String" jdbcType="VARCHAR" />
      <arg column="d_id" javaType="java.lang.Integer" jdbcType="INTEGER" />
    </constructor>
    <!--  指定联合查询出的部门字段的封装  -->
    <association property="department" javaType="com.cdf.bean.Department" >
      <id column="dept_id" property="deptId"/>
      <result column="dept_name" property="deptName"/>
    </association>
  </resultMap>

  <!-- 新增带部门的 Column 列表 -->
  <sql id="WithDept_Column_List">
    e.emp_id, e.emp_name, e.gender, e.email, e.d_id, d.dept_id, d.dept_name
  </sql>

  <!--  List<Employee> selectByExampleWithDept(EmployeeExample example);-->
  <select id="selectByExampleWithDept" resultMap="WithDeptResultMap" >
    select
    <if test="distinct">
      distinct
    </if>
    <include refid="WithDept_Column_List" />
    <!-- 改写成联合查询语句 -->
    from employee e left join department d on e.d_id = d.dept_id
    <if test="_parameter != null">
      <include refid="Example_Where_Clause" />
    </if>
    <if test="orderByClause != null">
      order by ${orderByClause}
    </if>
  </select>
  <!--  Employee selectByPrimaryKeyWithDept(Integer empId);-->
  <select id="selectByPrimaryKeyWithDept" resultMap="WithDeptResultMap">
    select
    <include refid="WithDept_Column_List" />
    <!-- 改写成联合查询语句 -->
    from employee e left join department d on e.d_id = d.dept_id
    where emp_id = #{empId,jdbcType=INTEGER}
  </select>
```

### 测试

```java
/**
 * 测试 dao 层与基本环境配置
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

        for (int i = 0; i < 1000; i++) {
            String uid = UUID.randomUUID().toString().substring(0, 5) + i;
            mapper.insertSelective(new Employee(null, uid, "M",uid+"@stu.jluzh.edu.cn", 1));
        }
        System.out.println("批量插入完成");
    }

}
```

查询数据库，结果如下：

![image-20200819162533049](https://github.com/cendaifeng/firstssm/blob/master/assets/image-20200819162533049.png)

完美！至此，环境配置完成。



## 编写查询功能

### 编写 MVC 测试

在上一章，我们测试了 Spring 和 MyBatis 的整合，但由于没有涉及到请求转发，所有没有 SpringMVC 的参与。这一章，我们首先来编写一个真正的 SSM 整合的测试，加入了分页模块方便后面页面的编写。

引入 pagehelper 的 Maven 依赖

```xml
<!-- https://mvnrepository.com/artifact/com.github.pagehelper/pagehelper -->
<dependency>
    <groupId>com.github.pagehelper</groupId>
    <artifactId>pagehelper</artifactId>
    <version>5.1.11</version>
</dependency>
```

在 mybatis 中配置插件

```xml
<!-- mybatis-config.xml -->
    <!-- ... -->
    <plugins>
        <plugin interceptor="com.github.pagehelper.PageInterceptor"></plugin>
    </plugins>
```

编写 EmployeeController 控制器来处理 ``/emps`` 的请求

```java
/* EmployeeController.java */

package com.cdf.controller;

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
    @RequestMapping("/emps")
    public String getEmps(@RequestParam(value = "pn", defaultValue = "1")Integer pn,
                          Model model) {
		// 第二个参数 pageSize: 每页显示的条目数
        PageHelper.startPage(pn, 5);
        // startPage 后紧跟的查询就是一个分页查询
        List<Employee> employeeList = employeeService.getAll();
        // PageInfo 封装了详细的分页信息，我们将它放入隐含模型
        // 第二个参数 navigatePages: 分页条显示的页码
        PageInfo page = new PageInfo<>(employeeList, 6);
        model.addAttribute("pageInfo", page);
        return "list";
    }
}
```

页面转发到 list.jsp ，此时隐含模型 pageInfo 中已经保存了详细的分页信息。

编写 EmployeeService 来处理业务逻辑，与数据库做交互，这里自动装配的 EmployeeMapper （接口）已由 MaBatis 进行了实现

```java
/* EmployeeService.java */

package com.cdf.service;

@Service
public class EmployeeService {

    @Autowired
    EmployeeMapper employeeMapper;

    /**
     * 查询所有员工
     * @return 员工列表
     */
    public List<Employee> getAll() {
        return employeeMapper.selectByExampleWithDept(null);
    }

}
```

使用 Spring 的 MockMvc 来测试 SSM 功能的运作（没有动用 Tomcat，所以 web.xml 不被涉及在内）

```java
/* MvcTest.java */

/**
 * 测试 springmvc 请求转发及分页模块
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
        // 请求成功后，请求域中会有 pageInfo（在 Controller 中我们放入的）
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
        }

    }

}
```

![image-20200819163616793](https://github.com/cendaifeng/firstssm/blob/master/assets/image-20200819163616793.png)

测试成功！

### 编写 list.jsp 页面

#### 写入样式

首先，我们在 index.jsp 上直接发送 ``/emps`` 请求，由 Controller 拦截，再转发给 list.jsp 。

![image-20200819192907969](https://github.com/cendaifeng/firstssm/blob/master/assets/image-20200819192907969.png)

不以 '/' 开始的**相对路径**，以当前资源的路径为基准，易出错；以 '/' 开始的相对路径，以服务器的路径为标准，会从 web 文件夹（在地址上体现为工程名）开始。所以如果直接写 ``href="/static/bootstrap...`` 则会因为找不到名为 static 的工程而丢失样式。

我们采用以 '/' 开始的相对路径，在该工程下 ``ContextPath`` 为 ``/crud`` 。

jsp 解析后 css 的地址会变为 ``/crud/static/bootstrap-3.3.7-dist/css/bootstrap.min.css`` 

```jsp
<%-- list.jsp --%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<% pageContext.setAttribute("APP_PATH", request.getContextPath()); %>
<html>
<head>
    <title>list of Emps</title>
        <%-- Bootstrap 核心 CSS 文件 --%>
        <link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
        <%-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) --%>
        <script src="${APP_PATH}/static/js/jquery-1.12.4.min.js"></script>
        <%-- Bootstrap 核心 JavaScript 文件 --%>
        <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js" ></script>
</head>
<body>
    <%-- 搭建显示页面 --%>
    <div class="container">
        <%-- 标题 --%>
        <div class="row">
            <div class="col-md-12">
                <h1>员工信息列表</h1>
            </div>
        </div>
        <%-- 按钮 --%>
        <div class="row">
            <%-- 一行总共 12 个单位，这里的 div 占 4 个单位，向右偏移 8 个单位 --%>
            <div class="col-md-4 col-md-offset-8">
                <button type="button" class="btn btn-primary">新增</button>
                <button type="button" class="btn btn-danger">删除</button>
            </div>
        </div>
        <%-- 显示表格数据 --%>
        <div class="row">
            <%-- table-hover 鼠标经过高亮 table-striped 条纹样式 --%>
            <table class="table table-hover table-striped">
                <tr>
                    <th>ID</th>
                    <th>姓名</th>
                    <th>性别</th>
                    <th>邮箱</th>
                    <th>部门</th>
                    <th>操作</th>
                </tr>
                <tr>
                    <th>1</th>
                    <th>梁伟涛</th>
                    <th>18</th>
                    <th>liangweitao@stu.jluzh.edu.cn</th>
                    <th>开发部</th>
                    <th>
                        <button type="button" class="btn btn-primary btn-sm">
                            <span class="glyphicon glyphicon-th-list" aria-hidden="true"></span>
                            编辑
                        </button>
                        <button type="button" class="btn btn-danger btn-sm">
                            <span class="glyphicon glyphicon-remove" aria-hidden="true"></span>
                            删除
                        </button>
                    </th>
                </tr>
            </table>
        </div>
        <%-- 显示分页信息 --%>
        <div class="row">
            <%-- 分页文字信息 --%>
            <div class="col-md-5">
                当前记录
            </div>
            <%-- 分页条 --%>
            <div class="col-md-7">
                <nav aria-label="Page navigation">
                    <ul class="pagination">
                        <li>
                            <a href="#">首页</a>
                        </li>
                        <li>
                            <a href="#" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                        <li><a href="#">1</a></li>
                        <li><a href="#">2</a></li>
                        <li><a href="#">3</a></li>
                        <li><a href="#">4</a></li>
                        <li><a href="#">5</a></li>
                        <li>
                            <a href="#" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                        <li>
                            <a href="#">末页</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>

    </div>

</body>
</html>
```

![image-20200819170434214](https://github.com/cendaifeng/firstssm/blob/master/assets/image-20200819170434214-1598965471564.png)

好家伙，真漂亮！

#### 填充数据

在 Controller 中由 springmvc 传入的隐含模型 pageInfo 会在请求域中。在 EL 表达式中，${requestScope.get("pageInfo")} 与 ${pageInfo} 含义相同。

在数据遍历和页码信息判断时，需要用到 jstl 标签库，我们将它引入： ``<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>`` 

![image-20200819182824954](https://github.com/cendaifeng/firstssm/blob/master/assets/image-20200819182824954-1598965471565.png)

在 table 中，用 ``c:forEach`` 标签遍历 pageInfo.list 取出每个员工的信息写入表内：

```jsp
<%-- list.jsp --%>

    <%-- ... --%>
	<%-- 显示表格数据 --%>
    <div class="row">
        <%-- table-hover 鼠标经过高亮 table-striped 条纹样式 --%>
        <table class="table table-hover table-striped">
            <tr>
                <th>ID</th>
                <th>姓名</th>
                <th>性别</th>
                <th>邮箱</th>
                <th>部门</th>
                <th>操作</th>
            </tr>
            <c:forEach items="${pageInfo.list}" var="emp">
                <tr>
                    <th>${emp.empId}</th>
                    <th>${emp.empName}</th>
                    <th>${emp.gender=="M"?"男":"女"}</th>
                    <th>${emp.email}</th>
                    <th>${emp.department.deptName}</th>
                    <th>
                        <button type="button" class="btn btn-primary btn-sm">
                            <span class="glyphicon glyphicon-th-list" aria-hidden="true"></span>编辑
                        </button>
                        <button type="button" class="btn btn-danger btn-sm">
                            <span class="glyphicon glyphicon-remove" aria-hidden="true"></span>删除
                        </button>
                    </th>
                </tr>
            </c:forEach>
        </table>
    </div>
```

下一步，取出分页文字信息、制作分页条

使用 ``c:if`` 标签，例如 ``<c:if test="${page_num == pageInfo.pageNum}">`` 判断该页码块是否为当前页面页码块，如果是则高亮显示。

```jsp
<%-- list.jsp --%>

    <%-- ... --%>
	<%-- 显示分页信息 --%>
    <div class="row">
        <%-- 分页文字信息 --%>
        <div class="col-md-5">
            <h4>当前页码: 第 ${pageInfo.pageNum} 页 <small>总 ${pageInfo.pages} 页 共 ${pageInfo.total} 记录</small></h4>
        </div>
        <%-- 分页条 --%>
        <div class="col-md-7">
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <li>
                        <a href="${APP_PATH}/emps?pn=1">首页</a>
                    </li>
                    <li>
                        <c:if test="${pageInfo.hasPreviousPage}">
                            <a href="${APP_PATH}/emps?pn=${pageInfo.pageNum-1}" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </c:if>
                    </li>
                    <c:forEach items="${pageInfo.navigatepageNums}" var="page_num">
                        <c:if test="${page_num == pageInfo.pageNum}">
                            <li class="active"><a href="#">${page_num}</a></li>
                        </c:if>
                        <c:if test="${page_num != pageInfo.pageNum}">
                            <li ><a href="${APP_PATH}/emps?pn=${page_num}">${page_num}</a></li>
                        </c:if>
                    </c:forEach>
                    <li>
                        <c:if test="${pageInfo.hasNextPage}">
                            <a href="${APP_PATH}/emps?pn=${pageInfo.pageNum+1}" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </c:if>
                    </li>
                    <li>
                        <a href="${APP_PATH}/emps?pn=${pageInfo.pages}">末页</a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
```

提示：若出现 ``javax.el.PropertyNotFoundException: 类型[com.cdf.bean.Employee]上找不到属性[department]`` 错误。请为 Employee 类中添加 ``getDepartment()`` （及 ``setDepartment()`` ）方法。

![image-20200819184130060](https://github.com/cendaifeng/firstssm/blob/master/assets/image-20200819184130060.png)

大功告成！

### 返回分页的 json 数据

如果我们的网站不止支持 *B-S 模型*，还可以支持客户端（如 Android 端、Mac 端）的访问，那我们的分页数据就得舍弃前面的方式，转而以 json 数据的形式返回。

#### index.jsp 页面直接发送 AJax 请求进行员工数据的查询

引入 jackson-databind 的 Maven 依赖

```xml
<!-- https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-databind -->
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.11.0</version>
</dependency>
```

@ResponesBody 注解（需要 Jackson 包）可以将返回的 PageInfo 转换成 json 数据放在响应体里。

```java
/* EmployeeController.java */    

	/* ... */  
    @RequestMapping("/emps")
    @ResponseBody
    public PageInfo getEmpsWithJson(
            @RequestParam(value = "pn", defaultValue = "1")Integer pn) {

        PageHelper.startPage(pn, 5);
        List<Employee> employeeList = employeeService.getAll();
        PageInfo page = new PageInfo<>(employeeList, 6);
        return page;
    }
```

发送请求之后，会返回 json 数据：

![image-20200819195844663](https://github.com/cendaifeng/firstssm/blob/master/assets/image-20200819195844663.png)

由于在返回信息里，我们除了分页数据还想添加*状态码和提示信息* 。我们就需要新建一个 Msg 类，将分页信息也一并放入，在 Controller 中返回

```java
/* Msg.java */

/**
 * 通用的返回 json 的类
 */
public class Msg {

    // 状态码
    private int code;
    // 提示信息
    private String msg;
    // 用户要返回给浏览器的数据
    private Map<String, Object> extend = new HashMap<>();

    public static Msg success() {
        Msg result = new Msg();
        result.setCode(100);
        result.setMsg("处理成功");
        return result;
    }

    public static Msg fail() {
        Msg result = new Msg();
        result.setCode(200);
        result.setMsg("处理失败");
        return result;
    }

    public Msg() {
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Map<String, Object> getExtend() {
        return extend;
    }

    public void setExtend(Map<String, Object> extend) {
        this.extend = extend;
    }

    public Msg add(String key, Object value) {
        this.getExtend().put(key, value);
        return this;
    }
}
```

```java
/* EmployeeController.java */

	/* ... */ 
    @RequestMapping("/emps")
    @ResponseBody
    public Msg getEmpsWithJson(
            @RequestParam(value = "pn", defaultValue = "1")Integer pn) {

        PageHelper.startPage(pn, 5);
        List<Employee> employeeList = employeeService.getAll();
        PageInfo page = new PageInfo<>(employeeList, 6);
        return Msg.success().add("pageInfo", page);
     }
```

这里用到了***链式编程***的方式来构建 Msg 对象，无论是 ``success()`` 还是 ``add()`` 方法返回的都是 Msg ，很好的简化了代码的编写。

将 list.jsp 中用 EL 表达式解析的请求域的数据重新用 JavaScript 来改写

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<% pageContext.setAttribute("APP_PATH", request.getContextPath()); %>
<html>
<head>
    <title>list of Emps</title>
    <%-- Bootstrap 核心 CSS 文件 --%>
    <link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <%-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) --%>
    <script src="${APP_PATH}/static/js/jquery-1.12.4.min.js"></script>
    <%-- Bootstrap 核心 JavaScript 文件 --%>
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js" ></script>
</head>
<body>
<%-- 搭建显示页面 --%>
<div class="container">
    <%-- 标题 --%>
    <div class="row">
        <div class="col-md-12">
            <h1>员工信息列表</h1>
        </div>
    </div>
    <%-- 按钮 --%>
    <div class="row">
        <%-- 一行总共 12 个单位，这里的 div 占 4 个单位，向右偏移 8 个单位 --%>
        <div class="col-md-4 col-md-offset-8">
            <button type="button" class="btn btn-primary">新增</button>
            <button type="button" class="btn btn-danger">删除</button>
        </div>
    </div>
    <%-- 显示表格数据 --%>
    <div class="row">
        <%-- table-hover 鼠标经过高亮 table-striped 条纹样式 --%>
        <table class="table table-hover table-striped" id="emps_table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>姓名</th>
                    <th>性别</th>
                    <th>邮箱</th>
                    <th>部门</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>

            </tbody>
        </table>
    </div>
    <%-- 显示分页信息 --%>
    <div class="row">
        <%-- 分页文字信息 --%>
        <div class="col-md-5" id="page_info_area">

        </div>
        <%-- 分页条 --%>
        <div class="col-md-7">
            <nav aria-label="Page navigation" id="page_nav_area">

            </nav>
        </div>

    </div>

</div>
<script type="application/javascript">

    var totalRecord,currentPage, pagesCount, itemPerPage;
    //页面加载完成以后，直接去发送ajax请求,要到分页数据
    $(function (){
        to_page(1);
    });

    function to_page(pn) {
        $.ajax({
            url:"${APP_PATH}/emps",
            data:"pn="+pn,
            type:"get",
            success:function (result) {
                // 解析显示员工信息
                build_emps_table(result);
                // 解析显示分页信息
                build_page_info(result);
                // 解析显示导航条
                build_page_nav(result);
            }
        });
    }

    function build_emps_table(result) {
        $("#emps_table tbody").empty();
        var emps = result.extend.pageInfo.list;
        $.each(emps, function (index, item) {
            var empIdTd = $("<th></th>").append(item.empId);
            var empNameTd = $("<th></th>").append(item.empName);
            var genderTd = $("<th></th>").append(item.gender=="M"?"男":"女");
            var emailTd = $("<th></th>").append(item.email);
            var deptNameTd = $("<th></th>").append(item.department.deptName);
            var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm")
                .append($("<span></span>")).addClass("glyphicon glyphicon-th-list").append(" <b>编辑</b>");
            var deleteBtn = $("<button></button>").addClass("btn btn-danger btn-sm")
                .append($("<span></span>")).addClass("glyphicon glyphicon-remove").append(" <b>删除</b>");
            var btnTd = $("<th></th>").append(editBtn).append("  ").append(deleteBtn);
            $("<tr></tr>").append(empIdTd)
                .append(empNameTd)
                .append(genderTd)
                .append(emailTd)
                .append(deptNameTd)
                .append(btnTd)
                    .appendTo("#emps_table tbody");
        });
    }

    function build_page_info(result) {
        $("#page_info_area").empty();
        $("#page_info_area").append("<h4>当前页码: 第 "
            +result.extend.pageInfo.pageNum +" 页 <small>总 "
            +result.extend.pageInfo.pages+" 页 共 "
            +result.extend.pageInfo.total +" 记录</small></h4>")
        totalRecord = result.extend.pageInfo.total;
        currentPage = result.extend.pageInfo.pageNum;
        pagesCount = result.extend.pageInfo.pages;
        itemPerPage = result.extend.pageInfo.pageSize;
    }

    function build_page_nav(result){
        $("#page_nav_area").empty();
        var ul = $("<ul></ul>").addClass("pagination");

        //构建元素
        var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
        var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
        if(result.extend.pageInfo.hasPreviousPage == false){
            firstPageLi.addClass("disabled");
            prePageLi.addClass("disabled");
        }else{
            //为元素添加点击翻页的事件
            firstPageLi.click(function(){
                to_page(1);
            });
            prePageLi.click(function(){
                to_page(result.extend.pageInfo.pageNum -1);
            });
        }


        var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
        var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
        if(result.extend.pageInfo.hasNextPage == false){
            nextPageLi.addClass("disabled");
            lastPageLi.addClass("disabled");
        }else{
            nextPageLi.click(function(){
                to_page(result.extend.pageInfo.pageNum +1);
            });
            lastPageLi.click(function(){
                to_page(result.extend.pageInfo.pages);
            });
        }


        //添加首页和前一页的提示
        ul.append(firstPageLi).append(prePageLi);
        //遍历给ul中添加页码提示
        $.each(result.extend.pageInfo.navigatepageNums,function(index,item){

            var numLi = $("<li></li>").append($("<a></a>").append(item));
            if(result.extend.pageInfo.pageNum == item){
                numLi.addClass("active");
            }
            numLi.click(function(){
                to_page(item);
            });
            ul.append(numLi);
        });
        //添加下一页和末页的提示
        ul.append(nextPageLi).append(lastPageLi);

        //把ul加入到nav
        var navEle = $("<nav></nav>").append(ul);
        navEle.appendTo("#page_nav_area");
    }

</script>
</body>
</html>
```

![image-20200819215739591](https://github.com/cendaifeng/firstssm/blob/master/assets/image-20200819215739591.png)

渲染成功，就是感觉没有原生 html 来的漂亮。

这是 SpringMVC 从接收到请求到响应返回的大体流程


![image-20200818002158769](https://github.com/cendaifeng/firstssm/blob/master/assets/image-20200818002158769.png)



## 编写新增功能

流程：点击“新增”按钮 --> 弹出新增对话框 --> 去数据库查询部门列表并显示 --> 校验用户输入的数据 --> 完成保存

### 添加模态框和相应点击事件

在 **Bootstrap**  官网上找到模态框模版，添加到 index.jsp 任意位置。

需要更改诸如 ``id`` , ``name`` , 以及 ``label值`` 等信息

```jsp
<%-- index.jsp --%>    

<%-- ... --%>
<!-- 员工添加的模态框 -->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">员工添加</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal">
                    <div class="form-group">
                        <label for="empName_add_input" class="col-sm-2 control-label">Emp Name</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="EmpName">
                            <span class="help-block">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="email_input" class="col-sm-2 control-label">Email</label>
                        <div class="col-sm-10">
                            <input type="email" name="email" class="form-control" id="email_input" placeholder="Email@xxx.com">
                            <span class="help-block">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender_input1" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender_input2" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Department Name</label>
                        <div class="col-sm-4">
                            <select class="form-control" name="dId">
                                <%-- <option>1</option> --%>
                            </select>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">Save</button>
            </div>
        </div>
    </div>
</div>
```

在“新增”按钮中，增加 ``id`` 属性 ``emp_add_modal_btn`` 

```jsp
<%-- index.jsp --%>    

	<%-- ... --%>
	<div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button type="button" class="btn btn-primary" id="emp_add_modal_btn">新增</button>
            <button type="button" class="btn btn-danger">删除</button>
        </div>
    </div>
```

为该按钮添加点击事件，以唤出模态框  

```html
<%-- index.jsp --%>    

  <script>
    <%-- ... --%>
    // 点击新增按钮弹出模态框
    $("#emp_add_modal_btn").click(function () {
        // 表单重置
        reset_form("#empAddModal form");
        // 发送 ajax 请求，查出部门信息，显示在下拉列表中
        getDepts();
        // 弹出
        $("#empAddModal").modal({
            // 设置点击背景模态框不会消失
            backdrop:"static"
        });
    });
  </script>  
```

### 从数据库获取部门信息

添加员工的模态框的表单中，有一个下拉列表，需要显示所有部门的名字以供用户选择；所以我们不能只是将当前的部门直接写死在 html 页面中，而是需要去数据库中查询有关信息，这样可以增加*拓展性*和*可维护性*。

新增 ``getDepts()`` 函数

```jsp
<%-- index.jsp --%>    

  <script>
    <%-- ... --%>
    function getDepts() {
        $.ajax({
            url:"${APP_PATH}/depts",
            type:"GET",
            success:function (result) {
                // console.log(result)
                // 清空下拉列表
                $("select").empty();
                // 显示部门信息在下拉列表中
                $.each(result.extend.depts, function (){
                   var optionEle = $("<option></option>").append(this.deptName).attr("value", this.deptId);
                   optionEle.appendTo("#empAddModal select")
                });
            }
        })
    }
  </script>  
```

这里的 **``this``** 就是遍历出来的每一个 **``“item”``** 。

接下来，要写相对应的**后端**代码了。

```java
/* DepartmentController.java */

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
```

```java
/* DepartmentService.java */

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
```

![image-20200822190050868](https://github.com/cendaifeng/firstssm/blob/master/assets/image-20200822190050868.png)

### 将表单填写数据提交给服务器

同样，这里我们给“保存”按钮添加点击事件

```jsp
<%-- index.jsp --%>    

  <script>
		var totalRecord, currentPage, pagesCount, itemPerPage;
     <%-- build_page_info(result) --%>
		totalRecord = result.extend.pageInfo.total;
        currentPage = result.extend.pageInfo.pageNum;
        pagesCount = result.extend.pageInfo.pages;
        itemPerPage = result.extend.pageInfo.pageSize;
    <%-- ... --%>
    // 点击保存按钮，将填写的数据提交给服务器
    $("#emp_save_btn").click(function () {
        // 数据格式
        if (!validate_add_form()){ return false; }
        // 发送 ajax 请求保存员工
        $.ajax({
            url:"${APP_PATH}/emps",
            type:"POST",
            // 将 form 表单中的数据序列化为一个 Employee 对象
            data:$("#empAddModal form").serialize(),
            success:function (result){
                // 关闭框框
                $("#empAddModal").modal('hide');
                // 跳转到最后一页
                if (totalRecord%itemPerPage != 0) {
                    to_page(pagesCount);
                } else {
                    to_page(pagesCount+1);
                }
            }
        });
    });
  </script>
```

totalRecord, pagesCount, itemPerPage 为此前定义的全局变量，在这里用于检测在增加新纪录前，分页的总页数一共有多少页了，从而在添加记录后跳转到正确的页码。

#### ***JQuery 前端校验***

在点击保存按钮后，发送 ajax 请求前，需要执行 ``validate_add_form()`` 来使用 ***JQuery 前端校验***，校验输入的用户名和邮箱格式是否符合标准

```jsp
<%-- index.jsp --%>    

  <script>
    <%-- ... --%>
    function validate_add_form() {
        var empName = $("#empName_add_input").val();
        var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
        var email = $("#email_input").val();
        var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        var ifName = false;
        var ifEmail = false;
        // 检验用户名
        if (!regName.test(empName)) {
            // alert("用户名必须为 2-5 位汉字或者 6-16 位英文与数字的组合");
            show_validate_msg("#empName_add_input","error","用户名必须为 2-5 位汉字或者 6-16 位英文与数字的组合");
        } else {
            show_validate_msg("#empName_add_input","success","");
            ifName = true;
        }
        // 检验邮箱
        if (!regEmail.test(email)) {
            // alert("电子邮箱格式不正确");
            show_validate_msg("#email_input","error","电子邮箱格式不正确");
        } else {
            show_validate_msg("#email_input","success","");
            ifEmail = true;
        }

        if (ifName && ifEmail == true) {
            return true;
        } else {
            return false;
        }
    }
      
    //显示校验结果的提示信息
    function show_validate_msg(ele,status,msg){
        //清除当前元素的校验状态
        $(ele).parent().removeClass("has-success has-error");
        $(ele).next("span").text("");
        
        // 改变表单输入框的样式
        if("success" == status){
            $(ele).parent().addClass("has-success");
        }else if("error" == status){
            $(ele).parent().addClass("has-error");
        }
        // 改变输入框下的提示信息
        $(ele).next("span").text(msg);
    }
  </script>
```

唤出模态框之前我们需要清空表单样式及内容，一来是美观不凌乱；二是防止因为表单状态未改变引起的重复数据意外提交。

```jsp
<%-- index.jsp --%>    

  <script>
    <%-- ... --%>
    // 清空表单样式及内容
    function reset_form(ele){
        $(ele)[0].reset();
        //清空表单样式
        $(ele).find("*").removeClass("has-error has-success");
        $(ele).find(".help-block").text("");
    }
  </script>
```

输入错误格式，点击保存，效果如下：

![image-20200822184722371](https://github.com/cendaifeng/firstssm/blob/master/assets/image-20200822184722371.png)

**编写后端代码**

```java
/* EmployeeController.java */

    /**
     * 保存员工数据
     * POST 请求 --> 保存
     * @return
     */
    @RequestMapping(value = "/emps", method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmp(Employee employee){

        employeeService.saveEmp(employee);
        return Msg.success();
    }
```

```java
/* EmployeeService.java */

    /**
     * 员工保存
     */
    public void saveEmp(Employee employee) {
        employeeMapper.insertSelective(employee);
    }
```

#### 检查用户名是否已经被使用

在“用户名”输入栏的输入改变后，我们希望有一个检验机制可以检测到输入的用户名是否已经被使用过。

在模态框弹出后，点击保存按钮之前，加入 ``.change()`` 事件，发送 ajax 请求进行检验

```jsp
<%-- index.jsp --%>

  <script>
    <%-- $("#emp_add_modal_btn").click() --%>
    <%-- ... --%>
    // 校验用户名是否可用
    $("#empName_add_input").change(function (){
        // 发送 ajax 请求校验
        var empName = this.value;
        $.ajax({
            url:"${APP_PATH}/checkuser",
            data:"empName="+empName,
            type:"POST",
            success:function (result) {
                if (result.code == 100) {
                    show_validate_msg("#empName_add_input", "success", "用户名可用");
                    $("#emp_save_btn").attr("ajax-validate", "success");
                } else {
                    show_validate_msg("#empName_add_input", "error", result.extend.va_msg);
                    $("#emp_save_btn").attr("ajax-validate", "error");
                }
            }
        });
    });
      
    // 点击保存按钮，将填写的数据提交给服务器
    $("#emp_save_btn").click(function () {
        // 数据格式校验
        if (!validate_add_form()){ return false; }
        // ajax 验证用户名
        if ($(this).attr("ajax-validate")=="error") {
            return false;
        }
    <%-- ... --%>
  </script>
```

**编写后端代码**

值得一提的是，用户名格式的检验也可以写在这里。

```java
/* EmployeeController.java */

    /**
     * 检验用户名是否可用
     * @return
     */
    @RequestMapping(value = "/checkuser", method = RequestMethod.POST)
    @ResponseBody
    public Msg checkUser(@RequestParam("empName") String empName) {

        // 检测是否为合法表达式
        // String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
        // if (!empName.matches(regx)) {
        //     return Msg.fail().add("va_msg", "用户名必须为 2-5 位汉字或者 6-16 位英文与数字的组合");
        // }
        // 检测数据库中是否已有相同数据
        boolean b = employeeService.checkUser(empName);
        if (b) {
            return Msg.success();
        }
        return Msg.fail().add("va_msg", "用户名已被使用");
    }
```

```java
/* EmployeeService.java */

    /**
     * 检查用户名是否可用
     * 检测数据库中是否已有相同数据
     * @return true 可用 false 不可用
     */
    public boolean checkUser(String empName) {
        EmployeeExample example = new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
        criteria.andEmpNameEqualTo(empName);
        long count = employeeMapper.countByExample(example);
        return count == 0;
    }
```

![image-20200822201627893](https://github.com/cendaifeng/firstssm/blob/master/assets/image-20200822201627893.png)

别高兴太早！要知道前端的代码是可以随便越过的，要保证数据安全，我们必须编写后端检验 (JSR303)

### ***后端校验 (JSR303)***

引入 hibernate-validator 的 Maven 依赖

```xml
<!-- https://mvnrepository.com/artifact/org.hibernate/hibernate-validator -->
<dependency>
    <groupId>org.hibernate</groupId>
    <artifactId>hibernate-validator</artifactId>
    <version>6.1.5.Final</version>
</dependency>
```

改进 EmployeeController ，增加基于 org.springframework.validation 和 Hibernate validation 的校验

```java
/* EmployeeController.java */

    /**
     * 保存员工数据
     * POST 请求 --> 保存
     * @param employee @Valid 是 Hibernate validation 的校验注解
     * @return
     */
    @RequestMapping(value = "/emps", method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmp(@Valid Employee employee, BindingResult result){

        // 若校验失败，我们也会像前端校验一样在模态框中显示错误信息
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
```

在 Bean 中添加*校验注解*

```java
/* Employee.java */

public class Employee {
    private Integer empId;

    @Pattern(regexp = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})",
        message = "用户名必须为 2-5 位汉字或者 6-16 位英文与数字的组合")
    private String empName;

    private String gender;

    @NotBlank
    @Email(message = "邮箱格式不正确")
    private String email;
    /* ... */
```

改写前端代码，请求成功后**接收后端的 BindingResult** ，若 result 中的 code 属性不为 100 则响应错误信息

```jsp
<%-- index.jsp --%>    

  <script>
    <%-- ... --%>
    // 点击保存按钮，将填写的数据提交给服务器
    $("#emp_save_btn").click(function () {
        // 数据格式校验
        if (!validate_add_form()){ return false; }
        // ajax 验证用户名
        if ($(this).attr("ajax-validate")=="error") {
            return false;
        }
        // 发送 ajax 请求保存员工
        $.ajax({
            url:"${APP_PATH}/emps",
            type:"POST",
            // 将 form 表单中的数据序列化为一个 Employee 对象
            data:$("#empAddModal form").serialize(),
            success:function (result){
                if (result.code == 100) {
                    // 关闭框框
                    $("#empAddModal").modal('hide');
                    // 跳转到最后一页
                    if (totalRecord%itemPerPage != 0) {
                        to_page(pagesCount);
                    } else {
                        to_page(pagesCount+1);
                    }
                } else {
                    // console.log(result);
                    // 显示失败信息
                    // 如果不是未定义
                    if (undefined != result.extend.errorFields.empName) {
                        show_validate_msg("#empName_add_input", "error", "用户名必须为 2-5 位汉字或者 6-16 位英文与数字的组合");
                    }
                    if (undefined != result.extend.errorFields.email) {
                        show_validate_msg("#email_input", "error", "电子邮箱格式不正确");
                    }
                }
            }
        });
    });
  </script>
```

<< ========================= 手 动 分 割 ================================= >>

写到这里不得不说一个更新完 Maven porn.xml 后一定要注意的动作——**手动导包**！（由于疏忽这个错误我竟然排了一天）

这里我介绍 IDEA 的操作。更新完 Maven 之后，它只会帮你把 jar 包放在 External Libraries 里，更多时候我们需要手动将包放在**输出路径的 lib** 下（out/artfacts/xxx_war_exploded/WEB-INF/lib）

具体操作如下：

![image-20200822221149410](https://github.com/cendaifeng/firstssm/blob/master/assets/image-20200822221149410.png)

*File*下的***项目结构*** ==> ***Artifacts*** 选中当前模块的 ***lib 目录*** ==> 添加库文件，添加所有

<< ========================= 手 动 分 割 ================================= >>

还有一点，就是用户名重复的验证如果被跳过了，在我们这次的代码里是不会检测到的，所以在数据库那里我们可以设置**唯一性**属性来阻止错误数据的输入。当然如果非要检验也很容易，我们只需要在 ``saveEmp()`` 中加入 ``employeeService.checkUser(empName)`` 即可，不过这样在每次保存的时候就会多一次查询，没有必要，所以请相信我们的用户哈哈哈哈哈，把最终的检查留个数据库。

回到前端，我们将保存按钮点击事件里的**数据格式校验代码**注释掉，以越过前端检验后端校验是否工作

![image-20200822222045038](https://github.com/cendaifeng/firstssm/blob/master/assets/image-20200822222045038.png)

![image-20200822222209993](https://github.com/cendaifeng/firstssm/blob/master/assets/image-20200822222209993.png)

如果 ``console.log(result);`` 

![image-20200822224937637](https://github.com/cendaifeng/firstssm/blob/master/assets/image-20200822224937637.png)

Server 控制台

![image-20200822222233458](https://github.com/cendaifeng/firstssm/blob/master/assets/image-20200822222233458.png)

校验依然正常！新增功能编写完成！



## 编写修改功能

修改功能与新增功能的流程类似；点击“修改”按钮 --> 弹出修改对话框 --> 去数据库查询部门列表并显示 --> 回显表单数据 --> 校验用户输入的数据 --> 完成更新

唯二需要注意的点是：回显数据，如何**获取**到所选员工项的信息；点击更新后向服务器**发起请求**的细节。

### 添加模态框和相应点击事件

我们也更改了诸如 ``id`` , ``name`` , 以及 ``label值`` 等属性，以便 js 函数配合。因为用户名不修改，所有我们应把输入栏改为不可修改的静态文本样式 ``<p class="form-control-static" id="empName_update_static"><!-- EmpName to display --></p>`` 

```jsp
<%-- index.jsp --%>    

<%-- ... --%>
<!-- 员工修改的模态框 -->
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel_02">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel_02">员工修改</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Emp Name</label>
                        <div class="col-sm-10">
                            <%-- 静态文本样式 --%>
                            <p class="form-control-static" id="empName_update_static"><!-- EmpName to display --></p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="email_update_input" class="col-sm-2 control-label">Email</label>
                        <div class="col-sm-10">
                            <input type="email" name="email" class="form-control" id="email_update_input" placeholder="Email@xxx.com">
                            <span class="help-block"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender_update_input1" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender_update_input2" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Department Name</label>
                        <div class="col-sm-4">
                            <select class="form-control" name="dId">
                                <%-- <option>1</option> --%>
                            </select>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">Update</button>
            </div>
        </div>
    </div>
</div>
```

在员工信息表格的 ``$("<button></button>")`` 中添加 ``class`` 属性 ``edit_btn`` 

```jsp
  <script>
	function build_emps_table(result) {
        $("#emps_table tbody").empty();
        var emps = result.extend.pageInfo.list;
        $.each(emps, function () {
            var empIdTd = $("<th></th>").append(this.empId);
            var empNameTd = $("<th></th>").append(this.empName);
            var genderTd = $("<th></th>").append(this.gender=="M"?"男":"女");
            var emailTd = $("<th></th>").append(this.email);
            var deptNameTd = $("<th></th>").append(this.department.deptName);
            var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                .append($("<span></span>")).addClass("glyphicon glyphicon-th-list").append(" <b>编辑</b>");
  </script>      
```

为该按钮添加点击事件，以唤出模态框 

```jsp
  <script>
    <%-- ... --%>
    // 为编辑按钮绑定上单击事件
    // 在全局文档中找到 .edit_btn 属性
    $(document).on("click", ".edit_btn", function () {
        // alert("click");
        // 弹出
        $("#empUpdateModal").modal({
            backdrop:"static"
        });
    });
  </script>  
```

同样，我们需要在下拉列表中显示部门名。我们已经写过从数据库获取部门信息的函数 ``getDepts()`` 了，我们现在要做的是重构它。向里面传入jQuery对象的索引。

```jsp
  <script>
	function getDepts(ele) {
        $.ajax({
            url:"${APP_PATH}/depts",
            type:"GET",
            async:false,
            success:function (result) {
                // console.log(result)
                // 清空下拉列表
                $("select").empty();
                // 显示部门信息在下拉列表中
                $.each(result.extend.depts, function (){
                   var optionEle = $("<option></option>").append(this.deptName).attr("value", this.deptId);
                   optionEle.appendTo(ele)
                });
            }
        })
    }

    $(document).on("click", ".edit_btn", function () {
        // alert("click");
        // 发送 ajax 请求，查出部门信息，显示在下拉列表中
        getDepts("#empUpdateModal select");
        // 弹出
        $("#empUpdateModal").modal({
            backdrop:"static"
        });
    });
  </script>
```

接下来是在弹出的模态框表单中回显所选员工的信息，有两种方式可以获取到该信息：一是获取预先在 `` $("#emp_update_btn")`` 中存储的属性 ``empid`` ，通过 ajax 请求，用其值到数据库中查询出该员工完整的信息，再 ``"appendTo"`` 到表单中。

二是在构建单元格的时候，即 ``build_emps_table(result)`` 时，为每个编辑按钮添加 ``data`` ，将当前员工的所有信息都放入 ``data`` 中，后用 ``$(ele).data("fieldname")`` 取出。

**注意**：如果要使用第一种方法，有可能会导致编辑框的员工*原部门信息*显示错误。因为查询员工信息的方法和显示部门名字的方法都属于 **ajax （异步）方法**，它们将没有顺序限制地**并发运行**，一旦员工信息数据先于部门名字信息被返回，下拉列表将只会显示默认项。解决方法，可以在查询部门的方法 ``getDepts()`` 中，**加入同步**，即 ``async:false,`` 。**更新：后来多次测试后发现，就算是第二种方法，也需要加入同步！**

我们选用第二种方法，这样可以节省一次查询和与后端的交互。

```jsp
  <script>

    function build_emps_table(result) {
        $("#emps_table tbody").empty();
        var emps = result.extend.pageInfo.list;
        $.each(emps, function () {
            var empIdTd = $("<th></th>").append(this.empId);
            var empNameTd = $("<th></th>").append(this.empName);
            var genderTd = $("<th></th>").append(this.gender=="M"?"男":"女");
            var emailTd = $("<th></th>").append(this.email);
            var deptNameTd = $("<th></th>").append(this.department.deptName);
            var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                .append($("<span></span>")).addClass("glyphicon glyphicon-th-list").append(" <b>编辑</b>");

            // 给编辑按钮添加data
            editBtn.data({"empid":this.empId, "empname":this.empName, "gender":this.gender, "email":this.email, "department":this.department});

    <%-- ... --%>
    // 为编辑按钮绑定上单击事件
    $(document).on("click", ".edit_btn", function () {
        // alert("click");
        // 清空表单样式
        reset_form("#empUpdateModal form");
        // 发送 ajax 请求，查出部门信息，显示在下拉列表中
        getDepts("#empUpdateModal select");
        // 获取员工信息并显示
        displayEmp(this);
        // 将员工的id传递给模态框的更新按钮
        var empid = $(this).data("empid");
        $("#emp_update_btn").attr("update_id", empid);
        // 弹出
        $("#empUpdateModal").modal({
            backdrop:"static"
        });
    });

    function displayEmp(ele) {
        $("#empName_update_static").text($(ele).data("empname"));
        $("#email_update_input").val($(ele).data("email"));
        $("#empUpdateModal input[name=gender]").val([$(ele).data("gender")]);
        $("#empUpdateModal select").val([$(ele).data("department").deptId]);
    }

  </script>  
```

为了下一步更新工作的请求提交，我们还将 ``empid`` 传递给了模态框右下角的更新按钮。

这里再介绍一下 ``.data()`` 的使用，首先就是我们需要导入**最新版本**的 JQuery.js 包。

这个函数可以在 DOM 对象中 ``data域`` 中存储一定的数据，存的时候使用 ``element.data("key", value)`` 或者 ``element.data({"key1": value1})`` ；取的时候使用 ``element.data("key")``。（该 “key” 最好为全小写）

还有一个相近的函数，一般用来储存“值”是**字符串**的数据，``element.attr("key", value)`` ；``element.data("key")``

这两组函数之间有一定的关联，当我们的 ``"data"`` 中存的值是**字符串**，或者需要将其值当做字符串取出，就可以用 ``element.attr("data-datakey")`` 。需要注意的是，如果我们用 ``ele.attr("data-somethings", "va")`` 来存，``ele.data("somethings")`` 是取不出来的。

### 给更新按钮绑定 ajax 请求以将数据提交给服务器

与”新增“的保存按钮如出一辙，只是 ajax 的参数有所不同：Rest 风格 url 和 data 的请求方式。

```jsp
  <script>
      
    // 点击更新按钮，将填写的数据提交给服务器
    $("#emp_update_btn").click(function () {
        // 将更新按钮中的 empid 信息取出
        let empid = $(this).attr("update_id");
        // 发送 ajax 请求保存员工
        $.ajax({
            // Rest 风格的 url
            url:"${APP_PATH}/emps/"+empid,
            type:"POST",
            // 将 form 表单中的数据序列化为一个 Employee 对象
            // 这里用的是原始的的 "_method" 参数标注 PUT 请求
            data:$("#empUpdateModal form").serialize()+"&_method=PUT",
            success:function (result){
                if (result.code == 100) {
                    // 关闭框框
                    $("#empUpdateModal").modal('hide');
                    // 跳转到当前页
                    to_page(currentPage);
                } else {
                    // console.log(result);
                    // 显示失败信息
                    // 如果不是未定义
                    if (undefined != result.extend.errorFields.email) {
                        show_validate_msg("#email_input", "error", "电子邮箱格式不正确");
                    }
                }
            }
        });
    });
      
  </script>  
```

```java
/* EmployeeController.java */   

	/**
     * 更新员工数据
     * PUT 请求 --> 更新
     * @param employee @Valid 是 Hibernate validation 的校验注解
     * @return
     */
    @RequestMapping(value = "/emps/{id}", method = RequestMethod.PUT)
    @ResponseBody
    public Msg updateEmp(@Valid Employee employee, BindingResult result, @PathVariable Integer id){

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
            employeeService.updateEmp(employee);
            return Msg.success();
        }
    }

/* EmployeService.java */

    /**
     * 员工更新
     */
    public void updateEmp(Employee employee) {
        employeeMapper.updateByPrimaryKeySelective(employee);
    }
```

这里就要提到本功能第二个要注意的点了，点击更新后向服务器**发起请求**的细节。

如果用 **ajax 直接发送 PUT 请求**，Tomcat (本版本9.0.37) 将不会把数据封装到 map 中（只有 POST 请求它才会封装）。这样一来，SpringMVC 在封装 POJO 对象的时候，在请求域中将无法取出数据，如 request.getParamter("empName")

![image-20200830174258940](https://github.com/cendaifeng/firstssm/blob/master/assets/image-20200830174258940.png)

取出来的 POJO 没有任何信息：

![image-20200830160604813](https://github.com/cendaifeng/firstssm/blob/master/assets/image-20200830160604813.png)

解决方案是，在 web.xml 中配置 HttpPutFormContentFilter 过滤器

```xml
<filter>
	<filter-name>HttpPutFormContentFilter</filter-name>
    <filter-class>org.springframework.web.filter.HttpPutFormContentFilter</filter-class>
</filter>
<filter-mapping>
	<filter-name>HttpPutFormContentFilter</filter-name>
	<url-pattern>/*</url-pattern>
</filter-mapping>
```



而**最简单的方式**为， ajax *请求类型*为 POST，在 *data* 中 加上 ``"&_method=PUT"`` 。

更改后我们再发送请求，结果如下，其他数据正常，而 *ID* 和 *员工名* 为空

![image-20200831090500569](https://github.com/cendaifeng/firstssm/blob/master/assets/image-20200831090500569.png)

![image-20200831004404410](https://github.com/cendaifeng/firstssm/blob/master/assets/image-20200831004404410.png)

这是由于 *ID* 本身就不属于表单信息；员工名在表单中为静态固定文本，没有被取出来，我们的 Service 层是有选择的更新，所以也不需要员工名的数据。

我们只需要将 ***PathVariable*** （路径参数）的值写成和 POJO 字段名相同，即可被自动封装。

```java
@RequestMapping(value = "/emps/{empId}", method = RequestMethod.PUT)
@ResponseBody
public Msg updateEmp(@Valid Employee employee, BindingResult result){
```

![image-20200831092922599](https://github.com/cendaifeng/firstssm/blob/master/assets/image-20200831092922599.png)

更新成功，且邮箱格式验证正常！



## 编写删除功能

删除功能我们会做两种，一种是每行末尾的按钮负责单个员工的删除，一种是位于右上角的批量删除。

### 添加单个删除点击事件


在员工删除按钮添加 ``class`` 属性 ``delete_btn`` ，并将 ``empId`` 保存在 ``attr`` 中

```jsp
  <script> 
    function build_emps_table(result) {
        <!-- ... -->
        var deleteBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
            .append($("<span></span>")).addClass("glyphicon glyphicon-remove").append(" <b>删除</b>");

        // 给删除按钮添加自定义属性
        deleteBtn.attr("del_id", this.empId);
  </script>      
```

为该按钮添加点击事件，以发送 ajax 请求

```jsp
  <script>
    // 为每行的删除按钮绑定上单击事件
    // 创建按钮时动态绑定
    $(document).on("click", ".delete_btn", function () {
        // 弹出确认删除框
        let empName = $(this).parents("tr").find("th:eq(1)").text();
        if (confirm("确认删除『"+empName+"』吗！")) {
            // 将自定义属性 del_id 取出
            let empid = $(this).attr("del_id");
            // 发送 ajax 请求删除员工
            $.ajax({
                url:"${APP_PATH}/emps/"+empid,
                type:"POST",
                data:"_method=DELETE",
                success:function (result) {
                    alert(result.msg);
                    to_page(currentPage);
                }
            });
        }
    });
  </script>  
```

这里用于确认提示的员工名，我们用了一种新的方式取出，找到**当前按钮对象**的**父元素** ``tr`` 的第二个 ``th`` 标签中的文本。

### 后端代码编写

Controller 端我们将单个和多个员工的删除功能和并在一起；到了 Service 端就把它们一分为二。

```java
/* EmployeeController.java */   

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
            System.out.println(list);
        } else {
            employeeService.deleteEmp(ids);
        }
        return Msg.success();
    }

/* EmployeService.java */

    /**
     * 员工删除
     * @param id
     */
    public void deleteEmp(String id) {
        employeeMapper.deleteByPrimaryKey(Integer.valueOf(id));
    }

    /**
     * 多个员工删除
     * @param idList
     */
    public void deleteBatch(List<Integer> idList) {
        EmployeeExample example = new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
        // delete from employee where emp_id in ...
        criteria.andEmpIdIn(idList);
        employeeMapper.deleteByExample(example);
    }
```

到这里单个员工删除的功能就完成了，接下来我们来编写批量删除的功能。

设想是这样的，点击右上角的删除按钮每行员工信息的前面就会出现一个选项框，点选后再此点击删除键则删除。

### 添加批量删除点击事件

为批量删除按钮添加 id ``emp_delete_bat_btn`` 

```jsp
<%-- 按钮 --%>
<div class="row">
    <div class="col-md-4 col-md-offset-8">
        <button type="button" class="btn btn-primary" id="emp_add_modal_btn">新增</button>
        <button type="button" class="btn btn-danger" id="emp_delete_bat_btn">删除</button>
    </div>
</div>
```

在每一行的行首加入选项框，用属性 ``hidden="true"`` ，将其**先隐藏起来**，后在点击事件中将该属性删除。

```jsp
<thead>
    <tr>
        <th>
            <input type='checkbox' id="check_all" hidden="true"/>
        </th>
        <th>ID</th>
        <th>姓名</th>
        <th>性别</th>
        <th>邮箱</th>
        <th>部门</th>
        <th>操作</th>
    </tr>
</thead>
<!-- ... -->
<script>
    function build_emps_table(result) {
        $("#emps_table tbody").empty();
        var emps = result.extend.pageInfo.list;
        $.each(emps, function() {
            var checkbox_item = $("<th></th>").append("<input type='checkbox' class='check_item' hidden='true'/>");
			<!-- ... -->
            var btnTd = $("<th></th>").append(editBtn).append("  ").append(deleteBtn);
            $("<tr></tr>")
                .append(checkbox_item)
                .append(empIdTd)
                .append(empNameTd)
                .append(genderTd)
                .append(emailTd)
                .append(deptNameTd)
                .append(btnTd)
                    .appendTo("#emps_table tbody");
        });
    }
</script>
```

![image-20200901203100305](https://github.com/cendaifeng/firstssm/blob/master/assets/image-20200901203100305.png)

点击批量删除按钮显示隐藏的选项框

```jsp
<script>
	$("#emp_delete_bat_btn").click(function () {
        // 显示隐藏的选项框
        display_checkbox();
        // 将删除改为确认
        let bat_btn = document.getElementById("emp_delete_bat_btn");
        bat_btn.innerHTML = "确认";
        // 再次点击该按钮
        if (bat_btn.hasAttribute("conf")) {
            // 发送 ajax 请求删除员工
			<!-- ... -->
            // 跳过函数末行的属性标记设置
            return;
        }

        // 第一次点击该按钮
        bat_btn.setAttribute("conf", "true");
    });
</script>
```

显示隐藏的选项框

```jsp
<script>
    // 全选功能
    $("#check_all").click(function () {
        // 对于原生 dom，attr 获取自定义的值，prop 获取 dom 原生属性的值
        $(".check_item").prop("checked", $("#check_all").prop("checked"));
    });

    // check_item 关联 check_all
    $(document).on("click", ".check_item", function() {
        let flag = $(".check_item:checked").length ==  $(".check_item").length;
        $("#check_all").prop("checked", flag);
    });
</script>
```

全选功能：将 check_item 和 check_all 互相关联

```jsp
<script>
    // 全选功能
    $("#check_all").click(function () {
        // 对于原生 dom，attr 获取自定义的值，prop 获取 dom 原生属性的值
        $(".check_item").prop("checked", $("#check_all").prop("checked"));
    });

    // check_item 关联 check_all
    $(document).on("click", ".check_item", function() {
        let flag = $(".check_item:checked").length ==  $(".check_item").length;
        $("#check_all").prop("checked", flag);
    });
</script>
```

![image-20200901203223241](https://github.com/cendaifeng/firstssm/blob/master/assets/image-20200901203223241.png)

### 再次点击批量删除发送 ajax 请求

由于我们在点击事件的末行设置了**标识当前按钮状态（删除或确认）的属性 ``conf`` **，所以在第二次点击（已变为确认的）删除按钮时，会触发新的功能，即获取被选择的项并发送 ajax 请求。

在上节我们已经写好了处理多个员工删除请求的后端代码，所以这里我们只关心前端的逻辑。

首先在跳转页面时，我们希望选项框以及批量删除按钮都处于原始状态。我们将 ``clear_checkbox()`` 放在 ``to_page()`` 中

```jsp
<script>
    function to_page(pn) {
		<!-- ... -->
        clear_checkbox();
    }
    <!-- ... -->
        
    // 还原选项框功能（跳转页面时会调用）
    function clear_checkbox() {
        let bat_btn = document.getElementById("emp_delete_bat_btn");
        let checkbox_top = document.getElementById("check_all");

        // 仅对全选选项框进行隐藏，单项选项框由于是动态变更的，所以只在页面刷新时隐藏
        if (!checkbox_top.hasAttribute("hidden")) {
            checkbox_top.setAttribute("hidden", "true");
        }
        // 重置为删除
        bat_btn.innerHTML = "删除";
        // 移除按钮已点击的属性标记
        if (bat_btn.hasAttribute("conf")) {
            bat_btn.removeAttribute("conf");
        }
        // 清空选项框
        $("#check_all").prop("checked", false);
        $(".check_item").prop("checked", false);
    }
</script>
```

在发送请求前，我们需要获取到的两个数据是：被选中员工的名字放到确认提示框中；被选中员工的 ID 作为请求的路径变量。

如何取出被选中的员工信息呢？遍历 ``$(".check_item:checked")`` 对象；它们的**父元素** ``tr`` 的第二个 ``th`` 标签中的文本是 ID，第三个 ``th`` 标签中的文本是员工名。后将之拼串。

```jsp
<script>
    /* 多个员工删除 */
    $("#emp_delete_bat_btn").click(function () {
        // 显示隐藏的选项框
        display_checkbox();
        // 将删除改为确认
        let bat_btn = document.getElementById("emp_delete_bat_btn");
        bat_btn.innerHTML = "确认";
        // 再次点击该按钮
        if (bat_btn.hasAttribute("conf")) {
            // 获取员工名和 ID 信息
            let empNames = "", delIds = "";
            $.each($(".check_item:checked"), function () {
                let empName = $(this).parents("tr").find("th:eq(2)").text();
                empNames = empNames + empName + ",";
                let delId = $(this).parents("tr").find("th:eq(1)").text();
                delIds = delIds + delId + "-";
            });
            empNames = empNames.substring(0,empNames.length-1);
            delIds = delIds.substring(0,delIds.length-1);

            // 弹出确认删除框
            if ($(".check_item:checked").length < 1) {
                alert("未选择员工！")
                return;
            }
            if (confirm("确认删除『"+empNames+"』吗！")) {
                // 发送 ajax 请求删除员工
                $.ajax({
                    url:"${APP_PATH}/emps/"+delIds,
                    type:"POST",
                    data:"_method=DELETE",
                    success:function (result) {
                        alert(result.msg);
                    }
                });
            }
            // 刷新页面以还原选项框
            to_page(currentPage);
            // 跳过函数末行的属性标记设置
            return;
        }

        // 第一次点击该按钮
        bat_btn.setAttribute("conf", "true");
    });
</script>
```

需要注意的是，无论请求成不成功，我们都将**刷新页面以还原选项框**，并且 ``return`` 退出函数来阻止末行的状态属性的设置。

![image-20200901204850599](https://github.com/cendaifeng/firstssm/blob/master/assets/image-20200901204850599.png)

![image-20200901204956264](https://github.com/cendaifeng/firstssm/blob/master/assets/image-20200901204956264.png)

删除成功，且选项框还原！

​		***==结束撒花==***

