package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryDao {

    int save(TranHistory th);

    List<TranHistory> getTranHistoryByTranId(String tranId);

    int getCountByTids(String[] ids);

    int deleteByTids(String[] ids);

    int getCountByTid(String id);

    int deleteByTid(String id);
}
