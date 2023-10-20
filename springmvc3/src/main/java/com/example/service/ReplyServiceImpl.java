package com.example.service;

import com.example.domain.Criteria;
import com.example.domain.ReplyPageDto;
import com.example.domain.ReplyVO;
import com.example.mapper.BoardMapper;
import com.example.mapper.ReplyMapper;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Log4j
public class ReplyServiceImpl implements ReplyService {

    @Setter(onMethod_ = @Autowired)
    private ReplyMapper mapper;
    @Setter(onMethod_ = @Autowired)
    private BoardMapper boardMapper;

    @Transactional
    @Override
    public int register(ReplyVO vo) {
        log.info("register..." + vo);
        // 댓글 등록 시 게시물에 대한 댓글 수 증가
        boardMapper.updateReplyCnt(vo.getBno(), 1);
        return mapper.insert(vo);
    }

    @Override
    public ReplyVO get(Long rno) {
        log.info("get..." + rno);
        return mapper.read(rno);
    }

    @Override
    public int modify(ReplyVO vo) {
        log.info("modify..." + vo);
        return mapper.update(vo);
    }

    @Transactional
    @Override
    public int remove(Long rno) {
        log.info("remove..." + rno);
        ReplyVO vo = mapper.read(rno);
        // 댓글 삭제 시 게시물에 대한 댓글 수 감소
        boardMapper.updateReplyCnt(vo.getBno(), -1);
        return mapper.delete(rno);
    }

//    @Override
//    public List<ReplyVO> getList(Criteria cri, Long bno) {
//        log.info("get Reply List of a Board " + bno);
//        return mapper.getListWithPaging(cri, bno);
//    }

    @Override
    public ReplyPageDto getListPage(Criteria cri, Long bno) {
        return new ReplyPageDto(
                mapper.getCountByBno(bno),
                mapper.getListWithPaging(cri, bno));
    }
}
