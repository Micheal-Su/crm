package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranDao {

    int save(Tran t);

    int update(Tran t);

    Tran getTranById(String id);

    int changeStage(Tran t);

    int getTranTotal();

    List<Map<String, Object>> getTranList();

    int getTotalByCondition(Map<String, Object> map);

    List<Tran> getTranListByCondition(Map<String, Object> map);

    Tran detail(String id);

    int getCountByCusIds(String[] ids);

    int deleteByCusIds(String[] ids);

    int delete(String[] ids);

    int getCountByContactsIds(String[] ids);

    int deleteByContactsIds(String[] ids);
}
