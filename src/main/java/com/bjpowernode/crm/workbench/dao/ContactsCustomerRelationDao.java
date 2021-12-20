package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.ContactsCustomerRelation;

public interface ContactsCustomerRelationDao {
    ContactsCustomerRelation getByContactsId(String id);

    int deleteContacts(ContactsCustomerRelation ccr);

    int getCountByCids(String[] ids);

    int save(ContactsCustomerRelation contactsCustomerRelation);

    int addContacts(ContactsCustomerRelation ccr);

    int updateCustomer(ContactsCustomerRelation ccr);

    String getContactsIdById(String id);

    int updateContacts(ContactsCustomerRelation car);

    ContactsCustomerRelation getByCusIdAndConId(ContactsCustomerRelation ccr);
}
