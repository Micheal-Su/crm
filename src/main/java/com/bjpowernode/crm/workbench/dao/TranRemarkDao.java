package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.TranRemark;

import java.util.List;

public interface TranRemarkDao {

    int getCountByTids(String[] ids);

    int deleteByTids(String[] ids);

    List<TranRemark> getListByTranId(String tranId);

    int delete(TranRemark tranRemark);

    int saveRemark(TranRemark cr);

    int deleteRemark(String id);

    int updateRemark(TranRemark cr);
}
