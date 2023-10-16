package com.example.mapper;

import com.example.domain.BoardVO;
import com.example.domain.Criteria;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface BoardMapper {

    public List<BoardVO> getList();

    public List<BoardVO> getListWithPaging(Criteria criteria);

    public int getTotalCount(Criteria cri);

    public void insert(BoardVO boardVO);

    public Integer insertSelectKey(BoardVO boardVO);

    public BoardVO read(Long bno);

    public int delete(Long bno);

    public int update(BoardVO boardVO);

    // amount - 댓글 수 증감
    // @Param - sql에 2개 이상의 데이터 전달
    public void updateReplyCnt(@Param("bno") Long bno, @Param("amount") int amount);
}
