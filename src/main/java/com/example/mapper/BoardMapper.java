package com.example.mapper;

import com.example.domain.BoardVO;
import com.example.domain.Criteria;

import java.util.List;

public interface BoardMapper {

    public List<BoardVO> getList();

    public List<BoardVO> getListWithPaging(Criteria criteria);

    public int getTotalCount(Criteria cri);

    public void insert(BoardVO boardVO);

    public void insertSelectKey(BoardVO boardVO);

    public BoardVO read(Long bno);

    public int delete(Long bno);

    public int update(BoardVO boardVO);
}
