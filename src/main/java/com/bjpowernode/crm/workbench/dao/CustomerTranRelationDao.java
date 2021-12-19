package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.CustomerTranRelation;

public interface CustomerTranRelationDao {

    int getCountByCids(String[] ids);

    int save(CustomerTranRelation customerTranRelation);

    int updateCustomer(CustomerTranRelation ctr);

    CustomerTranRelation getByTranId(String id);
}
