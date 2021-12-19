package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface ContactsService {
    boolean save(Contacts contacts,String customerName);

    PaginationVO<Contacts> pageList(Map<String, Object> map);

    Contacts detail(String id);

    Map<String, Object> getUserListAndContacts(String id);

    boolean update(Contacts c, String customerName);

    boolean delete(String[] ids);

    List<Tran> getTranListByContactsId(String contactsId);

    List<Contacts> getContactsListByName(String cname);

    Contacts getContactsById(String contactsId);

    boolean bundActivity(String cid, String[] aids);

    boolean unbundActivity(String id);
}
