package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.ContactsActivityRelation;

public interface ContactsActivityRelationDao {

    int unbundByCids(String[] ids);

    int getCountByCids(String[] ids);

    int save(ContactsActivityRelation contactsActivityRelation);

    int bund(ContactsActivityRelation car);

    int unbund(String id);
}
