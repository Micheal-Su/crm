package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Tran;
import com.bjpowernode.crm.workbench.domain.TranHistory;
import com.bjpowernode.crm.workbench.domain.TranRemark;

import java.util.List;
import java.util.Map;

public interface TranService {
    boolean save(Tran t, String customerName, String contactsName);

    boolean update(Tran t, String contactsName);

    Tran getTranById(String id);

    List<TranHistory> getTranHistoryByTranId(String tranId);

    boolean changeStage(Tran t);


    Map<String, Object> getCharts();

    PaginationVO<Tran> pageList(Map<String, Object> map);

    Map<String, Object> getUserListAndTransaction(String id);

    Tran detail(String id);

    boolean delete(String[] ids);

    List<TranRemark> getRemarkListByTid(String tranId);

    boolean saveRemark(TranRemark tr);

    boolean updateRemark(TranRemark tr);

    boolean deleteRemark(String id);

    boolean deleteInDetail(String id);

    boolean deleteById(String tranId);
}
