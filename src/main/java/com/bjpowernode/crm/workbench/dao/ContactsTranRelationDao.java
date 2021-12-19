package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.ContactsTranRelation;

public interface ContactsTranRelationDao {

    int getCountByCids(String[] ids);

    int save(ContactsTranRelation contactsTranRelation);

    int updateContacts(ContactsTranRelation ctr);

    ContactsTranRelation getByTranId(String id);
}
