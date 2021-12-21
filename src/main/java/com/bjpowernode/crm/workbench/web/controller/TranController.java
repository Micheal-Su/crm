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
import com.bjpowernode.crm.workbench.service.*;
import com.bjpowernode.crm.workbench.service.TranService;
import com.bjpowernode.crm.workbench.service.TranService;
import com.bjpowernode.crm.workbench.service.impl.*;
import com.bjpowernode.crm.workbench.service.impl.TranServiceImpl;
import com.bjpowernode.crm.workbench.service.impl.TranServiceImpl;


import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TranController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


        System.out.println("进入到交易控制器");
        String path = request.getServletPath();

        if ("/workbench/transaction/add.do".equals(path)) {
            add(request, response);
        } else if ("/workbench/transaction/getCustomerName.do".equals(path)) {
            getCustomerName(request, response);
        } else if ("/workbench/transaction/save.do".equals(path)) {
            save(request, response);
        } else if ("/workbench/transaction/getTranList.do".equals(path)) {
            getTranList(request, response);
        } else if ("/workbench/transaction/detail.do".equals(path)) {
            detail(request, response);
        } else if ("/workbench/transaction/getTranHistoryByTranId.do".equals(path)) {
            getTranHistoryByTranId(request, response);
        } else if ("/workbench/transaction/getRemarkListByTid.do".equals(path)) {
            getRemarkListByTid(request, response);
        } else if ("/workbench/transaction/saveRemark.do".equals(path)) {
            saveRemark(request, response);
        } else if ("/workbench/transaction/updateRemark.do".equals(path)) {
            updateRemark(request, response);
        } else if ("/workbench/transaction/deleteRemark.do".equals(path)) {
            deleteRemark(request, response);
        } else if ("/workbench/transaction/changeStage.do".equals(path)) {
            changeStage(request, response);
        } else if ("/workbench/transaction/getCharts.do".equals(path)) {
            getCharts(request, response);
        } else if ("/workbench/transaction/pageList.do".equals(path)) {
            pageList(request, response);
        } else if ("/workbench/transaction/getUserListAndTransaction.do".equals(path)) {
            getUserListAndTransaction(request, response);
        } else if ("/workbench/transaction/edit2.do".equals(path)){
            edit2(request, response);
        } else if ("/workbench/transaction/update.do".equals(path)) {
            update(request, response);
        } else if ("/workbench/transaction/updateByModal.do".equals(path)) {
            updateByModal(request, response);
        } else if ("/workbench/transaction/updateByRedirect.do".equals(path)) {
            updateByRedirect(request, response);
        } else if ("/workbench/transaction/delete.do".equals(path)) {
            delete(request, response);
        }else if ("/workbench/transaction/getContactsListByName.do".equals(path)) {
            getContactsListByName(request, response);
        }else if ("/workbench/transaction/getActivityListByName.do".equals(path)) {
            getActivityListByName(request, response);
        }
    }

    private void getActivityListByName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到交易模块-市场活动查询操作\n");
        String aname = request.getParameter("aname");
        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> aList = as.getActivityListByName(aname);
        PrintJson.printJsonObj(response,aList);
    }

    private void getContactsListByName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到交易模块-关联查询操作\n");
        String cname = request.getParameter("cname");
        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        List<Contacts> cList = cs.getContactsListByName(cname);
        PrintJson.printJsonObj(response,cList);
    }

    private void updateByRedirect(HttpServletRequest request, HttpServletResponse response) throws IOException {
        boolean flag = update(request, response);
        if (flag){
            response.sendRedirect(request.getContextPath() + "/workbench/transaction/index.jsp");
        }

    }

    private void updateByModal(HttpServletRequest request, HttpServletResponse response) throws IOException {
        boolean flag = update(request, response);
        PrintJson.printJsonFlag(response,flag);
    }


    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到删除备注操作");
        String id = request.getParameter("id");
        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean flag = ts.deleteRemark(id);
        PrintJson.printJsonFlag(response,flag);
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到备注的修改操作");
        String id = request.getParameter("id");
        String noteContent = request.getParameter("noteContent");
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "1";
        TranRemark tr = new TranRemark();
        tr.setId(id);
        tr.setNoteContent(noteContent);
        tr.setEditTime(editTime);
        tr.setEditBy(editBy);
        tr.setEditFlag(editFlag);
        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean flag = ts.updateRemark(tr);
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("success",true);
        map.put("tr",tr);
        PrintJson.printJsonObj(response,map);
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到线索详情页面的添加备注操作");
        String noteContent = request.getParameter("noteContent");
        String tranId = request.getParameter("tranId");
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "0";
        TranRemark tr = new TranRemark();
        tr.setId(id);
        tr.setNoteContent(noteContent);
        tr.setTranId(tranId);
        tr.setCreateTime(createTime);
        tr.setCreateBy(createBy);
        tr.setEditFlag(editFlag);

        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean flag = ts.saveRemark(tr);
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("success",flag);
        map.put("tr",tr);
        PrintJson.printJsonObj(response,map);

    }


    private void delete(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到删除交易信息的操作");
        String ids[] = request.getParameterValues("id");
        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean flag = ts.delete(ids);
        PrintJson.printJsonFlag(response,flag);
    }

    private static Boolean update(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("执行更新交易的操作");
        String id = request.getParameter("id");
        String owner = request.getParameter("owner");
        String money = request.getParameter("money");
        String name = request.getParameter("name");
        String expectedDate = request.getParameter("expectedDate");
//        客户名称是输入的，下面市场活动和联系人是单选的
        String customerId = request.getParameter("customerId");
        String stage = request.getParameter("stage");
        String type = request.getParameter("type");
        String source = request.getParameter("source");
        String activityId = request.getParameter("activityId");
        String contactsId = request.getParameter("contactsId");
        String contactsName = request.getParameter("contactsName");
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
        return ts.update(t,contactsName);

    }

    private void edit2(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        Tran t = ts.detail(id);
        List<User> tranUserList = us.getUserList();
        request.setAttribute("t", t);
        request.setAttribute("tranUserList", tranUserList);
        request.getRequestDispatcher("/workbench/transaction/edit.jsp").forward(request, response);
    }

    private void getUserListAndTransaction(HttpServletRequest request, HttpServletResponse response){
        String id = request.getParameter("id");
        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());
        Map<String,Object> map = ts.getUserListAndTransaction(id);
        PrintJson.printJsonObj(response, map);

    }

//    通过模态窗口修改
    private void edit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());
        Tran t = ts.getTranById(id);
        String stage = t.getStage();
        Map<String, String> pMap = (Map<String, String>) request.getServletContext().getAttribute("pMap");
        String possibility = pMap.get(stage);
        t.setPossibility(possibility);

        PrintJson.printJsonObj(response,t);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到交易信息列表的操作(结合条件查询+分页查询)");
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String customerName = request.getParameter("customerName");
        String stage = request.getParameter("stage");
        String type = request.getParameter("type");
        String source = request.getParameter("source");
        String contactsName = request.getParameter("contactsName");
        String pageNoStr = request.getParameter("pageNo");
        int pageNo = Integer.valueOf(pageNoStr);
        //每页展现的记录数
        String pageSizeStr = request.getParameter("pageSize");
        //计算出略过的记录数
        int pageSize = Integer.valueOf(pageSizeStr);
        int skipCount = (pageNo - 1) * pageSize;
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("owner",owner);
        map.put("name",name);
        map.put("customerName",customerName);
        map.put("stage",stage);
        map.put("type",type);
        map.put("source",source);
        map.put("contactsName",contactsName);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());

        PaginationVO<Tran> vo = ts.pageList(map);

        PrintJson.printJsonObj(response, vo);
    }

    private void getCharts(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到获取echarts数据");
        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());

//        List<Tran> tList = ts.getTranList();
//        int total = ts.getTranTotal();


        Map<String, Object> map = ts.getCharts();
//        map.put("total",total);
//        map.put("tList",tList);
        PrintJson.printJsonObj(response, map);

    }

    private void changeStage(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行改变阶段的操作");
        String id = request.getParameter("id");
        String stage = request.getParameter("stage");
        String money = request.getParameter("money");
        String expectedDate = request.getParameter("expectedDate");
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User) request.getSession().getAttribute("user")).getName();

        Tran t = new Tran();
        Map<String, String> pMap = (Map<String, String>) request.getServletContext().getAttribute("pMap");
        t.setPossibility(pMap.get(stage));
        t.setId(id);
        t.setStage(stage);
        t.setMoney(money);
        t.setExpectedDate(expectedDate);
        t.setEditTime(editTime);
        t.setEditBy(editBy);

        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean flag = ts.changeStage(t);

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("success", flag);
        map.put("t", t);

        PrintJson.printJsonObj(response, map);
    }

    private void getRemarkListByTid(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到根据交易id，取得备注信息列表");
        String tranId = request.getParameter("tranId");
        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());
        List<TranRemark> trList = ts.getRemarkListByTid(tranId);
        PrintJson.printJsonObj(response,trList);
    }

    private void getTranHistoryByTranId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入交易-详细页-交易历史列表");
        String tranId = request.getParameter("tranId");
        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());
        List<TranHistory> tList = ts.getTranHistoryByTranId(tranId);
        Map<String, String> pMap = (Map<String, String>) request.getServletContext().getAttribute("pMap");

        for (TranHistory th : tList) {
            String stage = th.getStage();
            String possibility = pMap.get(stage);
            th.setPossibility(possibility);
        }
        PrintJson.printJsonObj(response, tList);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入交易-跳转详细页-查询相关信息操作");
        String id = request.getParameter("id");
        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());
        Tran t = ts.detail(id);
        String stage = t.getStage();
        Map<String, String> pMap = (Map<String, String>) request.getServletContext().getAttribute("pMap");
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> tranUserList = us.getUserList();
        request.setAttribute("tranUserList", tranUserList);
        String possibility = pMap.get(stage);
        t.setPossibility(possibility);
        request.setAttribute("t", t);
        request.getRequestDispatcher("/workbench/transaction/detail.jsp").forward(request, response);
    }

    //细化页面相关，后期加上
    private void getTranList(HttpServletRequest request, HttpServletResponse response) {

    }

    private void save(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("执行添加交易操作");
        String id = UUIDUtil.getUUID();
        String owner = request.getParameter("create-owner");
        String money = request.getParameter("create-money");
        String name = request.getParameter("create-name");
        String expectedDate = request.getParameter("create-expectedDate");
        String customerName = request.getParameter("create-customerName");
        String stage = request.getParameter("create-stage");
        String type = request.getParameter("create-type");
        String source = request.getParameter("create-source");
        String activityId = request.getParameter("create-activityId");
        String contactsId = request.getParameter("create-contactsId");
        String contactsName = request.getParameter("create-contactsName");
        String createBy = ((User) request.getSession().getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSysTime();
        String description = request.getParameter("create-description");
        String contactSummary = request.getParameter("create-contactSummary");
        String nextContactTime = request.getParameter("create-nextContactTime");

        Tran t = new Tran();
        t.setId(id);
        t.setOwner(owner);
        t.setMoney(money);
        t.setName(name);
        t.setExpectedDate(expectedDate);
        t.setCustomerId(customerName);
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

        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean flag = ts.save(t, customerName,contactsName);
        if (flag) {
            //转发（一般用于session存值的时候）
//            request.getRequestDispatcher("/workbench/transaction/index.jsp").forward(request,response);
            //重定向
            response.sendRedirect(request.getContextPath() + "/workbench/transaction/index.jsp");
        }

    }

    private void getCustomerName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("取得 客户名称列表（按照客户名进行模糊查询）");
        String name = request.getParameter("name");
        CustomerService ts = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        List<Customer> cList = ts.getCustomerName(name);
        PrintJson.printJsonObj(response, cList);
    }

    private void add(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到跳转到交易添加页的操作");
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> uList = us.getUserList();
        request.setAttribute("uList", uList);
        request.getRequestDispatcher("/workbench/transaction/save.jsp").forward(request, response);
    }


}
