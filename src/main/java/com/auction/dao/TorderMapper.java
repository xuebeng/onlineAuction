package com.auction.dao;

import com.auction.model.Torder;
import java.util.List;

public interface TorderMapper {
    int deleteByPrimaryKey(Integer orderId);

    int insert(Torder record);

    int insertSelective(Torder record);

    Torder selectByPrimaryKey(Integer orderId);

    List<Torder> selectByUserId(Integer userId);

    List<Torder> selectAll();

    int updateByPrimaryKeySelective(Torder record);

    int updateByPrimaryKey(Torder record);

    int selectbuyerid(Integer orderId);

    int selectsellerid(Integer orderId);
}