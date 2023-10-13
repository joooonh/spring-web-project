package com.example.service;

import com.example.domain.BoardVO;
import com.example.domain.Criteria;

import java.util.List;

public interface BoardService {

    public void register(BoardVO board);

    public BoardVO get(Long bno);

    public boolean modify(BoardVO board);

    public boolean remove(Long bno);

    public List<BoardVO> getList(Criteria criteria);

    public int getTotal(Criteria cri);
}
