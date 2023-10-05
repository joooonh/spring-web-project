package com.example.service;

import com.example.domain.BoardVO;
import com.example.mapper.BoardMapper;
import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Log4j
@Service
@AllArgsConstructor
public class BoardServiceImpl implements BoardService {

//    @Setter(onMethod_ = @Autowired)   // 스프링 4.3 이상부터 단일 파라미터를 받는 생성자는 파라미터 자동 주입
    private BoardMapper mapper;

    @Override
    public void register(BoardVO board) {
        log.info("register....." + board);
        mapper.insertSelectKey(board);
    }

    @Override
    public BoardVO get(Long bno) {
        log.info("get..." + bno);

        return mapper.read(bno);
    }

    @Override
    public boolean modify(BoardVO board) {
        log.info("modify..." + board);

        return mapper.update(board) == 1;   // true 반환
    }

    @Override
    public boolean remove(Long bno) {
        log.info("remove..." + bno);

        return mapper.delete(bno) == 1;
    }

    @Override
    public List<BoardVO> getList() {
        log.info("getList.....");

        return mapper.getList();
    }
}
