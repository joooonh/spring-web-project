package com.example.service;

import com.example.domain.Criteria;
import com.example.domain.ReplyPageDto;
import com.example.domain.ReplyVO;
import com.example.mapper.ReplyMapper;
import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Log4j
@AllArgsConstructor
public class ReplyServiceImpl implements ReplyService {

    private ReplyMapper mapper;

    @Override
    public int register(ReplyVO vo) {
        log.info("register..." + vo);
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

    @Override
    public int remove(Long rno) {
        log.info("remove..." + rno);
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
