package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {

    int getCountByCids(String[] ids);

    int deleteByCids(String[] ids);

    List<ClueRemark> getListByClueId(String clueId);

    int delete(ClueRemark clueRemark);

    int saveRemark(ClueRemark cr);

    int deleteRemark(String id);

    int updateRemark(ClueRemark cr);
}
