package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.ContactsRemark;

import java.util.List;

public interface ContactsRemarkDao {

    int save(ContactsRemark contactsRemark);

    int getCountByCids(String[] ids);

    int deleteByCids(String[] ids);

    int getCountByCid(String id);

    int deleteByCid(String id);

    int saveRemark(ContactsRemark cr);

    int deleteRemark(String id);

    int updateRemark(ContactsRemark cr);

    List<ContactsRemark> getListByContactsId(String contactsId);
}
