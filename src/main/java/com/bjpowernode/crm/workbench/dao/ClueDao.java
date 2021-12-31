package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueDao {


    int getTotalByCondition(Map<String, Object> map);

    int save(Clue clue);

    Clue detail(String id);

    Clue getById(String clueId);

    int deletes(String[] clueIds);

    int delete(String clueId);

    List<Clue> getClueListByCondition(Map<String, Object> map);

    int update(Clue c);

    int deleteInDetail(String id);
}
