package com.bjpowernode.crm.workbench.web.controller;


import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.settings.service.impl.UserServiceImpl;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.PrintJson;
import com.bjpowernode.crm.utils.ServiceFactory;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.service.*;
import com.bjpowernode.crm.workbench.service.CustomerService;
import com.bjpowernode.crm.workbench.service.CustomerService;
import com.bjpowernode.crm.workbench.service.impl.*;
import com.bjpowernode.crm.workbench.service.impl.CustomerServiceImpl;
import com.bjpowernode.crm.workbench.service.impl.CustomerServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CustomerController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        

        System.out.println("进入到客户控制器");
        String path = request.getServletPath();

        if ("/workbench/customer/getUserList.do".equals(path)){
            getUserList(request,response);
        }else if ("/workbench/customer/save.do".equals(path)){
            save(request,response);
        }else if ("/workbench/customer/pageList.do".equals(path)){
            pageList(request,response);
        }else if ("/workbench/customer/detail.do".equals(path)){
            detail(request,response);
        }else if ("/workbench/customer/getRemarkListByCid.do".equals(path)){
            getRemarkListByCid(request,response);
        }else if ("/workbench/customer/getContactsListByCid.do".equals(path)){
            getContactsListByCid(request,response);
        }else if ("/workbench/customer/deleteContacts.do".equals(path)){
            deleteContacts(request,response);
        }else if ("/workbench/customer/addContacts.do".equals(path)){
            addContacts(request,response);
        }else if ("/workbench/customer/deleteRemark.do".equals(path)){
            deleteRemark(request,response);
        }else if ("/workbench/customer/delete.do".equals(path)){
            delete(request,response);
        }else if ("/workbench/customer/deleteInDetail.do".equals(path)){
            deleteInDetail(request,response);
        }else if ("/workbench/customer/saveRemark.do".equals(path)){
            saveRemark(request,response);
        }else if ("/workbench/customer/updateRemark.do".equals(path)){
            updateRemark(request,response);
        }else if ("/workbench/customer/bundTran.do".equals(path)){
            bundTran(request,response);
        }else if ("/workbench/customer/deleteTran.do".equals(path)){
            deleteTran(request,response);
        }else if ("/workbench/customer/update.do".equals(path)){
            update(request,response);
        }else if ("/workbench/customer/getUserListAndCustomer.do".equals(path)){
            getUserListAndCustomer(request,response);
        }else if ("/workbench/customer/getCustomerName.do".equals(path)){
            getCustomerName(request,response);
        }else if ("/workbench/customer/getTranListByCustomerId.do".equals(path)){
            getTranListByCustomerId(request,response);
        }

    }

    private void deleteTran(HttpServletRequest request, HttpServletResponse response) {
        String tranId = request.getParameter("transactionId");
        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean flag = ts.deleteById(tranId);
        PrintJson.printJsonFlag(response,flag);
    }

    private void deleteInDetail(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到删除市场活动信息的操作");
        String id = request.getParameter("customerId");
        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        boolean flag = cs.deleteInDetail(id);
        PrintJson.printJsonFlag(response,flag);
    }


    private void getTranListByCustomerId(HttpServletRequest request, HttpServletResponse response) {
        String customerId = request.getParameter("customerId");
        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        List<Tran> tranList = cs.getTranListByCustomerId(customerId);
        Map<String, String> pMap = (Map<String, String>) request.getServletContext().getAttribute("pMap");
        for (Tran t : tranList) {
            String stage = t.getStage();
            String possibility = pMap.get(stage);
            t.setPossibility(possibility);
        }
        PrintJson.printJsonObj(response,tranList);
    }

    private void bundTran(HttpServletRequest request, HttpServletResponse response) {
        String id = UUIDUtil.getUUID();
        String customerId = request.getParameter("customerId");
        String customerName = request.getParameter("customerName");
        String owner = request.getParameter("owner");
        String money = request.getParameter("money");
        String name = request.getParameter("name");
        String expectedDate = request.getParameter("expectedDate");

        String contactsName = request.getParameter("contactsName");
        String contactsId = request.getParameter("contactsId");
//      若contactsId为空 contactsName不管之前存不存在一样的，都会新建联系人（存在姓名一样的人）
        String stage = request.getParameter("stage");
        String type = request.getParameter("type");
        String source = request.getParameter("source");
        String activityId = request.getParameter("activityId");
        String createBy = ((User) request.getSession().getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSysTime();
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");

        Tran t = new Tran();
        t.setId(id);
        t.setOwner(owner);
        t.setMoney(money);
        t.setName(name);
        t.setExpectedDate(expectedDate);
        t.setStage(stage);
        t.setType(type);
        t.setSource(source);
        t.setActivityId(activityId);
        t.setCustomerId(customerId);
        t.setContactsId(contactsId);
        t.setCreateBy(createBy);
        t.setCreateTime(createTime);
        t.setDescription(description);
        t.setContactSummary(contactSummary);
        t.setNextContactTime(nextContactTime);
        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean flag = ts.save(t, customerName,contactsName);
//        关联联系人和交易也在ts.save里处理了
        PrintJson.printJsonFlag(response, flag);
    }

    private void addContacts(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到线索模块-解除关联市场活动操作");
        ContactsService contactsServices = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());

        String contactsId = UUIDUtil.getUUID();
        String owner = request.getParameter("owner");
        String source = request.getParameter("source");
        String customerName = request.getParameter("customerName");
        String fullname = request.getParameter("fullname");
        String appellation = request.getParameter("appellation");
        String email = request.getParameter("email");
        String mphone = request.getParameter("mphone");
        String job = request.getParameter("mphone");
        String birth = request.getParameter("birth");
        String createBy = ((User) request.getSession().getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSysTime();
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");
        String address = request.getParameter("address");

        Contacts contacts = new Contacts();
        contacts.setId(contactsId);
        contacts.setOwner(owner);
        contacts.setSource(source);
        contacts.setFullname(fullname);
        contacts.setAppellation(appellation);
        contacts.setEmail(email);
        contacts.setMphone(mphone);
        contacts.setJob(job);
        contacts.setBirth(birth);
        contacts.setCreateBy(createBy);
        contacts.setCreateTime(createTime);
        contacts.setDescription(description);
        contacts.setContactSummary(contactSummary);
        contacts.setNextContactTime(nextContactTime);
        contacts.setAddress(address);
        boolean flag = contactsServices.save(contacts,customerName);
//       建立联系的操作在ContactsServices的save里就行了，不需要在Customer里再建立一次

        PrintJson.printJsonFlag(response,flag);
    }

    private void deleteContacts(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到线索模块-解除关联市场活动操作");
        String customerId = request.getParameter("customerId");
        String contactsId = request.getParameter("contactsId");
        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        boolean flag = cs.deleteContacts(customerId,contactsId);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getContactsListByCid(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到根据市场id，取得备注信息列表");
        String customerId = request.getParameter("customerId");
        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        List<Contacts> crList = cs.getContactsListByCid(customerId);
        PrintJson.printJsonObj(response,crList);
    }

    private void getCustomerName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("取得 客户名称列表（按照客户名进行模糊查询）");
        String name = request.getParameter("name");
        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        List<Customer> cList = cs.getCustomerName(name);
        PrintJson.printJsonObj(response, cList);
    }

    private void update(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行线索的修改操作");
        String id = request.getParameter("id");
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String description = request.getParameter("description");
        String website = request.getParameter("website");
        String address = request.getParameter("address");
        String nextContactTime = request.getParameter("nextContactTime");
        String contactSummary = request.getParameter("contactSummary");
        //修改时间：当前系统时间
        System.out.println(id);
        String editTime = DateTimeUtil.getSysTime();
        //修改人：当前登录用户
        String editBy = ((User)request.getSession().getAttribute("user")).getName();

        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        Customer c = new Customer();
        c.setId(id);
        c.setAddress(address);
        c.setContactSummary(contactSummary);
        c.setNextContactTime(nextContactTime);
        c.setEditBy(editBy);
        c.setDescription(description);
        c.setEditTime(editTime);
        c.setOwner(owner);
        c.setName(name);
        c.setPhone(phone);
        c.setWebsite(website);
        boolean flag = cs.update(c);
        System.out.println(flag);
        PrintJson.printJsonFlag(response,flag);
    }


    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到备注的修改操作");
        String id = request.getParameter("id");
        String noteContent = request.getParameter("noteContent");
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "1";
        CustomerRemark cr = new CustomerRemark();
        cr.setId(id);
        cr.setNoteContent(noteContent);
        cr.setEditTime(editTime);
        cr.setEditBy(editBy);
        cr.setEditFlag(editFlag);
        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        boolean flag = cs.updateRemark(cr);
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("success",true);
        map.put("cr",cr);
        PrintJson.printJsonObj(response,map);
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到详情页面的添加备注操作");
        String noteContent = request.getParameter("noteContent");
        String customerId = request.getParameter("customerId");
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "0";
        CustomerRemark cr = new CustomerRemark();
        cr.setId(id);
        cr.setNoteContent(noteContent);
        cr.setCustomerId(customerId);
        cr.setCreateTime(createTime);
        cr.setCreateBy(createBy);
        cr.setEditFlag(editFlag);


        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        boolean flag = cs.saveRemark(cr);
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("success",flag);
        map.put("cr",cr);
        PrintJson.printJsonObj(response,map);

    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到删除备注操作");
        String id = request.getParameter("id");
        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        boolean flag = cs.deleteRemark(id);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getRemarkListByCid(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到根据市场id，取得备注信息列表");
        String customerId = request.getParameter("customerId");
        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        List<CustomerRemark> crList = cs.getRemarkListByCid(customerId);
        PrintJson.printJsonObj(response,crList);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到跳转详细信息页的操作");
        String id = request.getParameter("id");
        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> customerUserList = us.getUserList();
        Customer c = cs.detail(id);
        request.setAttribute("c",c);
        request.setAttribute("customerUserList",customerUserList);
        request.getRequestDispatcher("/workbench/customer/detail.jsp").forward(request,response);
    }

    private void getUserListAndCustomer(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到查询客户信息列表和根据市场活动id查单条记录的操作");
        String id = request.getParameter("id");
        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        Map<String,Object> map =  cs.getUserListAndCustomer(id);
        PrintJson.printJsonObj(response,map);
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到删除市场活动信息的操作");
        String ids[] = request.getParameterValues("id");
        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        boolean flag = cs.delete(ids);
        PrintJson.printJsonFlag(response,flag);

    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到查询客户信息列表的操作(结合条件查询+分页查询)");
        String name = request.getParameter("name");
        String owner = request.getParameter("owner");
        String phone = request.getParameter("phone");
        String website = request.getParameter("website");
        String pageNoStr = request.getParameter("pageNo");
        int pageNo = Integer.valueOf(pageNoStr);
        //每页展现的记录数
        String pageSizeStr = request.getParameter("pageSize");
        //计算出略过的记录数
        int pageSize = Integer.valueOf(pageSizeStr);
        int skipCount = (pageNo-1)*pageSize;
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("phone",phone);
        map.put("website",website);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());

        PaginationVO<Customer> vo = cs.pageList(map);

        PrintJson.printJsonObj(response,vo);

    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行市场活动的添加操作");
        String id = UUIDUtil.getUUID();
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String website = request.getParameter("website");
        String address = request.getParameter("address");
        String nextContactTime = request.getParameter("nextContactTime");
        String contactSummary = request.getParameter("contactSummary");
        String description = request.getParameter("description");
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();

        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        Customer c = new Customer();
        c.setId(id);
        c.setOwner(owner);
        c.setName(name);
        c.setPhone(phone);
        c.setWebsite(website);
        c.setContactSummary(contactSummary);
        c.setNextContactTime(nextContactTime);
        c.setDescription(description);
        c.setAddress(address);
        c.setCreateTime(createTime);
        c.setCreateBy(createBy);
        boolean flag = cs.save(c);
        PrintJson.printJsonFlag(response,flag);

    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("取得用户信息列表");
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> uList = us.getUserList();
        PrintJson.printJsonObj(response,uList);

    }


}
