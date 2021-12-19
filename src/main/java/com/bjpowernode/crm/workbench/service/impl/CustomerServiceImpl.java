package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.settings.dao.UserDao;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.utils.SqlSessionUtil;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.dao.*;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.CustomerService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CustomerServiceImpl implements CustomerService {
    private CustomerDao customerDao = null;
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);;
    private CustomerRemarkDao customerRemarkDao = SqlSessionUtil.getSqlSession().getMapper(CustomerRemarkDao.class);;
    private TranDao tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    private ContactsDao contactsDao = SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
    private ContactsCustomerRelationDao contactsCustomerRelationDao = SqlSessionUtil.getSqlSession().getMapper(ContactsCustomerRelationDao.class);

    @Override
    public List<Customer> getCustomerName(String name) {
        customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
        List<Customer> cList = customerDao.getCustomerName(name);
        return cList;
    }

    @Override
    public PaginationVO<Customer> pageList(Map<String, Object> map) {
        customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
        //取得total
        int total = customerDao.getTotalByCondition(map);
        //取得dataList
        List<Customer> dataList = customerDao.getCustomerListByCondition(map);

        //创建一个vo对象，将total和dataList封装到vo中
        PaginationVO<Customer> vo = new PaginationVO<>();
        vo.setTotal(total);
        vo.setDataList(dataList);
        //将vo返回
        return vo;
    }

    @Override
    public boolean updateRemark(CustomerRemark cr) {
        boolean flag = true;
        int count = customerRemarkDao.updateRemark(cr);
        if (count != 1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean saveRemark(CustomerRemark cr) {
        boolean flag = true;
        int count = customerRemarkDao.save(cr);
        if (count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean deleteRemark(String id) {
        boolean flag = true;
        int count = customerRemarkDao.deleteRemark(id);
        if (count!=1){
            flag=false;
        }
        return flag;
    }


    @Override
    public Customer detail(String id) {
        customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
        return customerDao.detail(id);
    }

    @Override
    public boolean save(Customer c) {
        customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
        boolean flag = true;
        int count = customerDao.save(c);
        if (count!=1){
            flag = false;
        }
        return flag;
    }

    @Override
    public Map<String, Object> getUserListAndCustomer(String id) {
        customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
        userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);
        List<User> userList = userDao.getUserList();
//        别闹 getById获得的owner是owner的id  detail获得的是owner的name，val是id而不是name
        Customer c = customerDao.getById(id);
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("customerUserList",userList);
        map.put("c",c);
        //再返回map就可以了
        return map;
    }

    @Override
    public boolean update(Customer c) {
        customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
        boolean flag = true;
        int count = customerDao.update(c);
        if (count!=1){
            flag = false;
        }
        return flag;
    }

    @Override
    public boolean delete(String[] ids) {
        customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
        boolean flag = true;
//      ids:复选框选中的id

        //查询出需要删除的备注的数量
        int count1 = customerRemarkDao.getCountByCids(ids);

        //删除备注，返回收到影响的条数（实际删除的条数）
        int count2 = customerRemarkDao.deleteByCids(ids);

        if (count1!=count2){
            flag = false;
        }

//      删除交易
        //查询出需要删除的交易的数量
        int count3 = tranDao.getCountByCusIds(ids);

        //删除备注，返回收到影响的条数（实际删除的条数）
        int count4 = tranDao.deleteByCusIds(ids);

        if (count3!=count4){
            flag = false;
        }

//       删了别的忘了删自己。。。。
        int count7 = customerDao.delete1(ids);
        if (count7!=1){
            flag=false;
        }

//        删除所有包含该客户的联系人中的客户信息
        int count5 = contactsDao.getTheCusCount(ids);
        int count6 = contactsDao.deletesByCusId(ids);

        System.out.println("删除客户信息成功\n\n\n\n\n\n\n");

        if (count5!=count6){
            flag = false;
        }
        return flag;

    }

    @Override
    public List<CustomerRemark> getRemarkListByCid(String customerId) {
        List<CustomerRemark> crList = customerRemarkDao.getListByCustomerId(customerId);
        return crList;
    }

    @Override
    public List<Contacts> getContactsListByCid(String customerId) {
        return contactsDao.getContactsListByCid(customerId);
    }

    @Override
    public boolean deleteContacts(String customerId,String contactsId) {
        boolean flag = true;
        ContactsCustomerRelation ccr = new ContactsCustomerRelation();
        ccr.setCustomerId(customerId);
        ccr.setContactsId(contactsId);
        int count1 = contactsDao.deleteById(contactsId);
        if (count1!=1){
            flag=false;
        }
        int count = contactsCustomerRelationDao.deleteContacts(ccr);
        if (count!=1){
            flag=false;
        }
        System.out.println("ct1:"+count1 +"\n\n\n\n\n");
        System.out.println("ct:"+count +"\n\n\n\n\n");
        return flag;
    }

    @Override
    public List<Tran> getTranListByCustomerId(String customerId) {
        customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
        List<Tran> tranList = customerDao.getTranListByCid(customerId);
        return tranList;
    }

}
