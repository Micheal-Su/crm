package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkDao {

    int save(CustomerRemark customerRemark);

    int getCountByCids(String[] ids);

    int deleteByCids(String[] ids);

    List<CustomerRemark> getListByCustomerId(String customerId);

    int deleteRemark(String id);

    int updateRemark(CustomerRemark cr);

    int getCountByCid(String id);

    int deleteByCid(String id);
}
