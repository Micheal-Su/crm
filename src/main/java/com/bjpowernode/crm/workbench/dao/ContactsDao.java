package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.domain.ContactsCustomerRelation;
import com.bjpowernode.crm.workbench.domain.Tran;;import java.util.List;
import java.util.Map;


public interface ContactsDao {

    int save(Contacts con);

    String getContactsNameById(String id);

    int getTotalByCondition(Map<String, Object> map);

    List<Contacts> getContactsListByCondition(Map<String, Object> map);

    Contacts detail(String id);

    int getTheCusCount(String[] ids);

    int deletesByCusId(String[] ids);

    Contacts getById(String id);

    int update(Contacts c);

    int deletes(String[] ids);

    List<Contacts> getContactsListByCid(String customerId);

    List<Tran> getTranListByCid(String contactsId);

    List<Contacts> getContactsListByName(String cname);

    int deleteByCusId(String customerId);

    int deleteById(String customerId);
}
