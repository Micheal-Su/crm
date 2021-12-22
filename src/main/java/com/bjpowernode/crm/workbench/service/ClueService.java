package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.domain.ClueRemark;
import com.bjpowernode.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface ClueService {
    boolean save(Clue clue);

    Clue detail(String id);

    boolean unbund(String id);

    boolean bund(String cid, String[] aids);

    boolean convert(String clueId, Tran t, String createBy);

    PaginationVO<Clue> pageList(Map<String, Object> map);

    Map<String, Object> getUserListAndClue(String id);

    boolean update(Clue c);

    boolean delete(String[] ids);

    boolean saveRemark(ClueRemark cr);

    List<ClueRemark> getRemarkListByCid(String clueId);

    boolean deleteRemark(String id);

    boolean updateRemark(ClueRemark cr);

    boolean deleteInDetail(String id);
}
