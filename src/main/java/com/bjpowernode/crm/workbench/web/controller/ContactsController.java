package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.settings.dao.UserDao;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.settings.service.impl.UserServiceImpl;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.PrintJson;
import com.bjpowernode.crm.utils.ServiceFactory;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.service.*;
import com.bjpowernode.crm.workbench.service.ContactsService;
import com.bjpowernode.crm.workbench.service.ContactsService;
import com.bjpowernode.crm.workbench.service.impl.*;
import com.bjpowernode.crm.workbench.service.impl.ContactsServiceImpl;
import com.bjpowernode.crm.workbench.service.impl.ContactsServiceImpl;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ContactsController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        System.out.println("进入到联系人控制器");
        String path = request.getServletPath();
        if ("/workbench/contacts/getUserList.do".equals(path)) {
            getUserList(request, response);
        } else if ("/workbench/contacts/save.do".equals(path)) {
            save(request, response);
        } else if ("/workbench/contacts/pageList.do".equals(path)) {
            pageList(request, response);
        } else if ("/workbench/contacts/saveRemark.do".equals(path)) {
            saveRemark(request, response);
        } else if ("/workbench/contacts/deleteRemark.do".equals(path)) {
            deleteRemark(request, response);
        } else if ("/workbench/contacts/updateRemark.do".equals(path)) {
            updateRemark(request, response);
        } else if ("/workbench/contacts/getRemarkListByCid.do".equals(path)) {
            getRemarkListByCid(request, response);
        } else if ("/workbench/contacts/detail.do".equals(path)) {
            detail(request, response);
        } else if ("/workbench/contacts/getById.do".equals(path)) {
            getById(request, response);
        } else if ("/workbench/contacts/getUserListAndContacts.do".equals(path)) {
            getUserListAndContacts(request, response);
        } else if ("/workbench/contacts/update.do".equals(path)) {
            update(request, response);
        }else if ("/workbench/contacts/delete.do".equals(path)) {
            delete(request, response);
        }else if ("/workbench/contacts/deleteInDetail.do".equals(path)) {
            deleteInDetail(request, response);
        }else if ("/workbench/contacts/getCustomerName.do".equals(path)) {
            getCustomerName(request, response);
        }else if ("/workbench/contacts/bundTran.do".equals(path)) {
            bundTran(request, response);
        }else if ("/workbench/contacts/deleteTran.do".equals(path)) {
            deleteTran(request, response);
        }else if ("/workbench/contacts/bundActivity.do".equals(path)) {
            bundActivity(request, response);
        }else if ("/workbench/contacts/unbundActivity.do".equals(path)) {
            unbundActivity(request, response);
        }else if ("/workbench/contacts/getTranListByContactsId.do".equals(path)) {
            getTranListByContactsId(request, response);
        }else if ("/workbench/contacts/getActivityListByContactsNameButNotId.do".equals(path)) {
            getActivityListByContactsNameButNotId(request, response);
        }else if ("/workbench/contacts/getActivityListByContactsId.do".equals(path)) {
            getActivityListByContactsId(request, response);
        }
    }

    private void getRemarkListByCid(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到根据交易id，取得备注信息列表");
        String contactsId = request.getParameter("contactsId");
        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        List<ContactsRemark> crList = cs.getRemarkListByCid(contactsId);
        PrintJson.printJsonObj(response,crList);
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到备注的修改操作");
        String id = request.getParameter("id");
        String noteContent = request.getParameter("noteContent");
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "1";
        ContactsRemark cr = new ContactsRemark();
        cr.setId(id);
        cr.setNoteContent(noteContent);
        cr.setEditTime(editTime);
        cr.setEditBy(editBy);
        cr.setEditFlag(editFlag);
        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean flag = cs.updateRemark(cr);
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("success",flag);
        map.put("cr",cr);
        PrintJson.printJsonObj(response,map);
    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到删除备注操作");
        String id = request.getParameter("id");
        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean flag = cs.deleteRemark(id);
        PrintJson.printJsonFlag(response,flag);
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到联系人详情页面的添加备注操作");
        String noteContent = request.getParameter("noteContent");
        String contactsId = request.getParameter("contactsId");
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "0";
        ContactsRemark cr = new ContactsRemark();
        cr.setId(id);
        cr.setNoteContent(noteContent);
        cr.setContactsId(contactsId);
        cr.setCreateTime(createTime);
        cr.setCreateBy(createBy);
        cr.setEditFlag(editFlag);

        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean flag = cs.saveRemark(cr);
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("success",flag);
        map.put("cr",cr);
        PrintJson.printJsonObj(response,map);

    }

    private void deleteInDetail(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("contactsId");
        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean flag = cs.deleteInDetail(id);
        PrintJson.printJsonFlag(response,flag);
    }

    private void unbundActivity(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到线索模块-解除关联市场活动操作");
        String id = request.getParameter("id");
        System.out.println(id+"\n\n\n\n\n");
        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean flag = cs.unbundActivity(id);
        PrintJson.printJsonFlag(response,flag);
    }

    private void deleteTran(HttpServletRequest request, HttpServletResponse response) {

    }

    private void bundActivity(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到线索模块-绑定事件操作");
        String cid = request.getParameter("cid");
        String aids[]  = request.getParameterValues("aid");
        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean flag = cs.bundActivity(cid,aids);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getActivityListByContactsId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到线索模块-展现关联的市场活动列表");
        String contactsId = request.getParameter("contactsId");
        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> aList = as.getActivityListByContactsId(contactsId);
        PrintJson.printJsonObj(response,aList);

    }

    private void getActivityListByContactsNameButNotId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到线索模块-关联查询操作");
        String aname = request.getParameter("aname");
        String contactsId = request.getParameter("contactsId");
        Map<String,String> map = new HashMap<String, String>();
        map.put("aname",aname);
        map.put("contactsId",contactsId);
        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> aList = as.getActivityListByContactsNameButNotId(map);
        PrintJson.printJsonObj(response,aList);
    }

    private void getById(HttpServletRequest request, HttpServletResponse response) {
        String contactsId = request.getParameter("contactsId");
        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        Contacts contacts = cs.getContactsById(contactsId);
        PrintJson.printJsonObj(response, contacts);
    }

    private void getTranListByContactsId(HttpServletRequest request, HttpServletResponse response) {
        String contactsId = request.getParameter("contactsId");
        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        List<Tran> tranList = cs.getTranListByContactsId(contactsId);

        PrintJson.printJsonObj(response, tranList);
    }

    private void bundTran(HttpServletRequest request, HttpServletResponse response) {
        String id = UUIDUtil.getUUID();
        String owner = request.getParameter("owner");
        String money = request.getParameter("money");
        String name = request.getParameter("name");
        String expectedDate = request.getParameter("expectedDate");
        String customerName = request.getParameter("customerName");
        String stage = request.getParameter("stage");
        String type = request.getParameter("type");
        String source = request.getParameter("source");
        String activityId = request.getParameter("activityId");
        String contactsId = request.getParameter("contactsId");
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
        t.setContactsId(contactsId);
        t.setCreateBy(createBy);
        t.setCreateTime(createTime);
        t.setDescription(description);
        t.setContactSummary(contactSummary);
        t.setNextContactTime(nextContactTime);
        TranService cs = (TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean flag = cs.save(t, customerName,contactsId);
//        关联联系人和交易也在ts.save里处理了
        PrintJson.printJsonFlag(response, flag);
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到删除线索信息的操作");
        String ids[] = request.getParameterValues("id");
        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean flag = cs.delete(ids);
        PrintJson.printJsonFlag(response,flag);

    }

    private void getCustomerName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("取得 客户名称列表（按照客户名进行模糊查询）");
        String name = request.getParameter("name");
        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        List<Customer> cList = cs.getCustomerName(name);
        PrintJson.printJsonObj(response, cList);
    }


    private void update(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("执行线索的修改操作");
        String id = request.getParameter("id");
        String owner = request.getParameter("owner");
        String fullname = request.getParameter("fullname");
        String mphone = request.getParameter("mphone");
        String appellation = request.getParameter("appellation");
        String job = request.getParameter("job");
        String email = request.getParameter("email");
        String birth = request.getParameter("birth");
        String customerName = request.getParameter("customerName");
        String description = request.getParameter("description");
        String source = request.getParameter("source");
        String address = request.getParameter("address");
        String nextContactTime = request.getParameter("nextContactTime");
        String contactSummary = request.getParameter("contactSummary");
        //修改时间：当前系统时间
        String editTime = DateTimeUtil.getSysTime();
        //修改人：当前登录用户
        String editBy = ((User) request.getSession().getAttribute("user")).getName();

        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        Contacts c = new Contacts();
        c.setId(id);
        c.setAddress(address);
        c.setContactSummary(contactSummary);
        c.setNextContactTime(nextContactTime);
        c.setEditBy(editBy);
        c.setDescription(description);
        c.setEditTime(editTime);
        c.setOwner(owner);
        c.setFullname(fullname);
        c.setBirth(birth);
        c.setMphone(mphone);
        c.setAppellation(appellation);
        c.setJob(job);
        c.setEmail(email);
        c.setSource(source);
        boolean flag = cs.update(c, customerName);
        PrintJson.printJsonFlag(response,flag);
    }



    private void getUserListAndContacts(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        Map<String,Object> map =  cs.getUserListAndContacts(id);
        PrintJson.printJsonObj(response,map);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("跳转到联系人详细信息页");
        String id = request.getParameter("id");
        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        Contacts c = cs.detail(id);
        List<User> contactsUserList = us.getUserList();
        request.setAttribute("c", c);
        request.setAttribute("contactsUserList", contactsUserList);
        request.getRequestDispatcher("/workbench/contacts/detail.jsp").forward(request,response);

    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到查询联系人信息列表的操作(结合条件查询+分页查询)");
        String fullname = request.getParameter("fullname");
        String owner = request.getParameter("owner");
        String customerName = request.getParameter("customerName");
        String source = request.getParameter("source");
        String birth = request.getParameter("birth");
        String pageNoStr = request.getParameter("pageNo");

        int pageNo = Integer.valueOf(pageNoStr);
        //每页展现的记录数
        String pageSizeStr = request.getParameter("pageSize");
        //计算出略过的记录数
        int pageSize = Integer.valueOf(pageSizeStr);
        int skipCount = (pageNo-1)*pageSize;
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("fullname",fullname);
        map.put("customerName",customerName);
        map.put("owner",owner);
        map.put("source",source);
        map.put("birth",birth);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());

        PaginationVO<Contacts> vo = cs.pageList(map);

        PrintJson.printJsonObj(response,vo);
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> uList = us.getUserList();
        PrintJson.printJsonObj(response, uList);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到联系人线索操作");
        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        String id = UUIDUtil.getUUID();
        String owner = request.getParameter("owner");
        String source = request.getParameter("source");
        String customerName = request.getParameter("customerName");
        String fullname = request.getParameter("fullname");
        String appellation = request.getParameter("appellation");
        String email = request.getParameter("email");
        String mphone = request.getParameter("mphone");
        String job = request.getParameter("job");
        String birth = request.getParameter("birth");
        String createBy = ((User) request.getSession().getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSysTime();
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");
        String address = request.getParameter("address");

        Contacts contacts = new Contacts();
        contacts.setId(id);
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
        boolean flag = cs.save(contacts,customerName);
        PrintJson.printJsonFlag(response, flag);
    }
}
