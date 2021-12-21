package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.settings.dao.UserDao;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.SqlSessionUtil;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.dao.*;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.TranService;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TranServiceImpl implements TranService {
    private TranDao tranDao = null;
    private TranRemarkDao tranRemarkDao = SqlSessionUtil.getSqlSession().getMapper(TranRemarkDao.class);
    private TranHistoryDao tranHistoryDao = SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);
    private CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    private ContactsDao contactsDao = SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);
    private ContactsTranRelationDao contactsTranRelationDao = SqlSessionUtil.getSqlSession().getMapper(ContactsTranRelationDao.class);
    private CustomerTranRelationDao customerTranRelationDao = SqlSessionUtil.getSqlSession().getMapper(CustomerTranRelationDao.class);
    private ContactsCustomerRelationDao contactsCustomerRelationDao = SqlSessionUtil.getSqlSession().getMapper(ContactsCustomerRelationDao.class);



    @Override
    public boolean save(Tran t, String customerName, String contactsName) {
        tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
        //目前没有customerId ,需要先判断是否存在该客户，自动选择创建或者获取该客户
        boolean flag = true;
        Customer cus = customerDao.getCustomerByName(customerName);
        if (cus==null){
            cus = new Customer();
            cus.setId(UUIDUtil.getUUID());
            cus.setName(customerName);
            cus.setCreateBy(t.getCreateBy());
            cus.setCreateTime(t.getCreateTime());
            cus.setContactSummary(t.getContactSummary());
            cus.setNextContactTime(t.getNextContactTime());
            cus.setOwner(t.getOwner());
            cus.setWebsite("");
            cus.setPhone("");
            //添加客户
            int count1 = customerDao.save(cus);
            if (count1!=1){
                flag=false;
            }
        }
        //客户处理完了
        //将客户的id添加到t
        t.setCustomerId(cus.getId());

        Contacts con = contactsDao.getById(t.getContactsId());
        if(t.getContactsId()==""){
            con = new Contacts();
            con.setId(UUIDUtil.getUUID());
            con.setFullname(contactsName);
            con.setCustomerId(cus.getId());
            con.setCreateBy(t.getCreateBy());
            con.setCreateTime(t.getCreateTime());
            con.setContactSummary(t.getContactSummary());
            con.setNextContactTime(t.getNextContactTime());
            con.setOwner(t.getOwner());
            con.setBirth("");
            con.setSource("");
            con.setEmail("");
            con.setMphone("");
            //添加客户
            int count1 = contactsDao.save(con);
            if (count1!=1){
                flag=false;
            }
        }


        t.setContactsId(con.getId());
        //添加交易
        int count2 = tranDao.save(t);
        if (count2!=1){
            flag=false;
        }

        ContactsCustomerRelation car = new ContactsCustomerRelation();
        car.setId(UUIDUtil.getUUID());
        car.setContactsId(con.getId());
        car.setCustomerId(cus.getId());

        int flag3 = contactsCustomerRelationDao.save(car);
        if(flag3!=1){
            flag=false;
        }
        //添加交易历史
        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setCreateTime(DateTimeUtil.getSysTime());
        th.setCreateBy(t.getCreateBy());
        th.setTranId(t.getId());
        th.setExpectedDate(t.getExpectedDate());
        th.setMoney(t.getMoney());
        th.setStage(t.getStage());

        int count3 = tranHistoryDao.save(th);
        if (count3!=1){
            flag=false;
        }

        ContactsTranRelation ctr = new ContactsTranRelation();
        ctr.setId(UUIDUtil.getUUID());
        ctr.setContactsId(t.getContactsId());
        ctr.setTranId(t.getId());
        int flag5 = contactsTranRelationDao.save(ctr);
        if(flag5!=1){
            flag=false;
        }

        CustomerTranRelation custr = new CustomerTranRelation();
        custr.setId(UUIDUtil.getUUID());
        custr.setCustomerId(t.getCustomerId());
        custr.setTranId(t.getId());
        int flag4 = customerTranRelationDao.save(custr);
        if(flag4!=1){
            flag=false;
        }
        return flag;
    }

    public boolean update(Tran t, String contactsName) {
        tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
//        一般交易中的客户名称是不会改的
        boolean flag = true;

        Contacts con = contactsDao.getContactsByName(contactsName);
        ContactsCustomerRelation ccr = new ContactsCustomerRelation();
        ccr.setCustomerId(t.getCustomerId());
        ccr.setContactsId(t.getContactsId());
//        取得原先的ccr对应关系,可能为null 注意了
        ccr = contactsCustomerRelationDao.getByCusIdAndConId(ccr);
        if (ccr == null){
            ccr = new ContactsCustomerRelation();
            ccr.setCustomerId(t.getCustomerId());
        }
        if(con==null){
            con = new Contacts();
            con.setId(UUIDUtil.getUUID());
            con.setFullname(contactsName);
            con.setCustomerId(t.getCustomerId());
            con.setCreateBy(t.getCreateBy());
            con.setCreateTime(t.getCreateTime());
            con.setContactSummary(t.getContactSummary());
            con.setNextContactTime(t.getNextContactTime());
            con.setOwner(t.getOwner());
            con.setBirth("");
            con.setSource("");
            //添加客户
            int count2 = contactsDao.save(con);
            if (count2!=1){
                flag=false;
            }
        }

        ccr.setContactsId(con.getId());//更新ccr中的联系人信息

        t.setContactsId(con.getId());

        //添加交易
        int count3 = tranDao.update(t);
        if (count3!=1){
            flag=false;
        }

        contactsCustomerRelationDao.updateContacts(ccr);//更新ccr对应关系

        //添加交易历史
        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setCreateTime(DateTimeUtil.getSysTime());
        th.setCreateBy(t.getCreateBy());
        th.setTranId(t.getId());
        th.setExpectedDate(t.getExpectedDate());
        th.setMoney(t.getMoney());
        th.setStage(t.getStage());

        int count4 = tranHistoryDao.save(th);
        if (count4!=1){
            flag=false;
        }

        ContactsTranRelation ctr = contactsTranRelationDao.getByTranId(t.getId());
        ctr.setContactsId(t.getContactsId());
        int flag4 = contactsTranRelationDao.updateContacts(ctr);
        if(flag4!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public Tran getTranById(String id) {
        tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
        Tran t = tranDao.getTranById(id);
        return t;
    }

    @Override
    public List<TranHistory> getTranHistoryByTranId(String tranId) {
        List<TranHistory> tList = tranHistoryDao.getTranHistoryByTranId(tranId);
        return tList;
    }

    @Override
    public boolean changeStage(Tran t) {
        tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
        boolean flag = true;
        int count = tranDao.changeStage(t);
        if (count!=1){
            flag=false;
        }
        //交易阶段改变后，生成一条交易历史
        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setStage(t.getStage());
        th.setPossibility(t.getPossibility());
        th.setCreateBy(t.getEditBy());
        th.setCreateTime(DateTimeUtil.getSysTime());
        th.setExpectedDate(t.getExpectedDate());
        th.setMoney(t.getMoney());
        th.setTranId(t.getId());
        //添加交易历史
        int count2 = tranHistoryDao.save(th);
        if (count2!=1){
            flag=false;
        }
        return flag;
    }


    @Override
    public Map<String, Object> getCharts() {
        tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
        //取得total
        int total = tranDao.getTranTotal();

        //取得dataList
        List<Map<String,Object>> dataList = tranDao.getTranList();
        //将total和dataList放到map中
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("total",total);
        map.put("dataList",dataList);
        //返回map

        return map;
    }

    @Override
    public PaginationVO<Tran> pageList(Map<String, Object> map) {
        tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
        int total = tranDao.getTotalByCondition(map);
        List<Tran> dataList = tranDao.getTranListByCondition(map);
        //创建一个vo对象，将total和dataList封装到vo中
        PaginationVO<Tran> vo = new PaginationVO<>();
        vo.setTotal(total);
        vo.setDataList(dataList);

        //将vo返回
        return vo;
    }

    @Override
    public Map<String, Object> getUserListAndTransaction(String id) {
        tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
        Tran t = tranDao.getTranById(id);
        List<User> userList = userDao.getUserList();
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("tranUserList", userList);
        map.put("t", t);
        return map;
    }


    @Override
    public Tran detail(String id) {
        tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
        Tran t = tranDao.detail(id);
        return t;
    }

    @Override
    public boolean delete(String[] ids) {
        tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
        boolean flag = true;
//      ids:复选框选中的id

        //查询出需要删除的备注的数量
        int count1 = tranRemarkDao.getCountByTids(ids);

        //删除备注，返回收到影响的条数（实际删除的条数）
        int count2 = tranRemarkDao.deleteByTids(ids);

        if (count1!=count2){
            flag = false;
        }

        int count3 = tranHistoryDao.getCountByTids(ids);

        //删除备注，返回收到影响的条数（实际删除的条数）
        int count4 = tranHistoryDao.deleteByTids(ids);
        if (count3!=count4){
            flag = false;
        }

        //删除交易
        int count5 = tranDao.delete(ids);
        if (count5!= ids.length){
            flag = false;
        }

        return flag;
    }

    @Override
    public List<TranRemark> getRemarkListByTid(String tranId) {
        List<TranRemark> trList = tranRemarkDao.getListByTranId(tranId);
        return trList;
    }

    @Override
    public boolean saveRemark(TranRemark tr) {
        boolean flag = true;
        int count = tranRemarkDao.saveRemark(tr);
        if (count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean updateRemark(TranRemark tr) {
        boolean flag = true;
        int count = tranRemarkDao.updateRemark(tr);
        if (count != 1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean deleteRemark(String id) {
        boolean flag = true;
        int count = tranRemarkDao.deleteRemark(id);
        if (count!=1){
            flag=false;
        }
        return flag;
    }
}
