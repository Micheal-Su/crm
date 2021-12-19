package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.ContactsRemark;

public interface ContactsRemarkDao {

    int save(ContactsRemark contactsRemark);

    int getCountByCids(String[] ids);

    int deleteByCids(String[] ids);
}
