package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface CustomerDao {

    Customer getCustomerByName(String company);

    int save(Customer cus);

    List<Customer> getCustomerName(String name);


    int getTotalByCondition(Map<String, Object> map);

    List<Customer> getCustomerListByCondition(Map<String, Object> map);

    Customer getById(String id);

    int update(Customer c);

    int delete1(String[] ids);

    Customer detail(String id);

    List<Tran> getTranListByCid(String customerId);

}
