package com.example.service;

import com.example.domain.Criteria;
import com.example.domain.ReplyPageDto;
import com.example.domain.ReplyVO;

import java.util.List;

public interface ReplyService {

    public int register(ReplyVO vo);

    public ReplyVO get(Long rno);

    public int modify(ReplyVO vo);

    public int remove(Long rno);

//    public List<ReplyVO> getList(Criteria cri, Long bno);

    public ReplyPageDto getListPage(Criteria cri, Long bno);
}
