package com.example.mapper;

import com.example.domain.Criteria;
import com.example.domain.ReplyVO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ReplyMapper {

    public int insert(ReplyVO vo);

    public ReplyVO read(Long rno);  // 특정 댓글 읽기

    public int delete(Long rno);

    public int update(ReplyVO reply);

    public List<ReplyVO> getListWithPaging(
            @Param("cri")Criteria cri,
            @Param("bno")Long bno);

    public int getCountByBno(Long bno);
}
