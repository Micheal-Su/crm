package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.domain.CustomerRemark;
import com.bjpowernode.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface CustomerService {
    List<Customer> getCustomerName(String name);

    PaginationVO<Customer> pageList(Map<String, Object> map);

    boolean updateRemark(CustomerRemark ar);

    boolean saveRemark(CustomerRemark ar);

    boolean deleteRemark(String id);

    Customer detail(String id);

    boolean save(Customer c);

    Map<String, Object> getUserListAndCustomer(String id);

    boolean update(Customer c);

    boolean delete(String[] ids);

    List<CustomerRemark> getRemarkListByCid(String customerId);

    List<Contacts> getContactsListByCid(String customerId);

    boolean deleteContacts(String customerId,String contactsId);

    List<Tran> getTranListByCustomerId(String customerId);

    boolean deleteInDetail(String id);

//    boolean addContacts(String customerId, String contactsId);
}
