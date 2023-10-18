package com.example.service;

import com.example.domain.BoardAttachVO;
import com.example.domain.BoardVO;
import com.example.domain.Criteria;
import com.example.mapper.BoardAttachMapper;
import com.example.mapper.BoardMapper;
import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Log4j
@Service
@AllArgsConstructor
public class BoardServiceImpl implements BoardService {

    @Setter(onMethod_ = @Autowired)   // 스프링 4.3 이상부터 단일 파라미터를 받는 생성자는 파라미터 자동 주입
    private BoardMapper mapper;
    @Setter(onMethod_ = @Autowired)
    private BoardAttachMapper attachMapper;

    @Transactional
    @Override
    public void register(BoardVO board) {
        log.info("register....." + board);

        mapper.insertSelectKey(board);

        if (board.getAttachList() == null || board.getAttachList().size() <= 0) {
            return;
        }

        board.getAttachList().forEach(attach -> {
            attach.setBno(board.getBno());
            attachMapper.insert(attach);
        });
    }

    @Override
    public BoardVO get(Long bno) {
        log.info("get..." + bno);

        return mapper.read(bno);
    }

    @Transactional
    @Override
    public boolean modify(BoardVO board) {
        log.info("modify..." + board);

        // 어떤 파일을 수정하고 삭제했는지 알아야 함 -> 모든 첨부파일 삭제 후 다시 추가하는 방식으로 처리
        attachMapper.deleteAll(board.getBno());

        boolean modifyResult = mapper.update(board) == 1;   // true 반환

        // db가 변경됐고, 첨부파일 목록이 남아있으면 삭제한 파일 외의 파일을 다시 추가
        if (modifyResult && board.getAttachList() != null && board.getAttachList().size() > 0) {
            board.getAttachList().forEach(attach -> {
                attach.setBno(board.getBno());
                attachMapper.insert(attach);
            });
        }
        return modifyResult;
    }

    @Transactional
    @Override
    public boolean remove(Long bno) {
        log.info("remove..." + bno);

        attachMapper.deleteAll(bno);

        return mapper.delete(bno) == 1;
    }

    @Override
    public List<BoardVO> getList(Criteria cri) {
        log.info("get List with criteria: " + cri);

        return mapper.getListWithPaging(cri);
    }

    @Override
    public int getTotal(Criteria cri) {
        return mapper.getTotalCount(cri);
    }

    @Override
    public List<BoardAttachVO> getAttachList(Long bno) {
        log.info("get Attach list by bno" + bno);

        return attachMapper.findByBno(bno);
    }
}
