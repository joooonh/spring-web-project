package com.example.mapper;

import com.example.domain.Criteria;
import com.example.domain.ReplyVO;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;
import java.util.stream.IntStream;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {com.example.config.RootConfig.class})
@Log4j
public class ReplyMapperTests {

    private Long[] bnoArr = {1900567L, 1900566L, 1900565L, 1900564L, 1900563L};

    @Setter(onMethod_ = @Autowired)
    private ReplyMapper mapper;

    @Test
    public void testMapper() {
        log.info(mapper);
    }

    @Test
    public void testCreate() {
        IntStream.rangeClosed(1, 10).forEach(i -> {
            ReplyVO vo = new ReplyVO();

            // 게시물의 번호
            vo.setBno(bnoArr[i % 5]);
            vo.setReply("댓글 테스트: " + i);
            vo.setReplyer("replyer" + i);

            mapper.insert(vo);
        });
    }

    @Test
    public void testRead() {
        Long targetRno = 5L;

        ReplyVO vo = mapper.read(targetRno);

        log.info("vo: " + vo);
    }

    @Test
    public void testDelete() {
        Long targetRno = 1L;

        mapper.delete(targetRno);
    }

    @Test
    public void testUpdate() {
        Long targetRno = 10L;

        ReplyVO vo = mapper.read(targetRno);
        vo.setReply("Update Reply ");

        int count = mapper.update(vo);

        log.info("update count: " + count);
    }

    @Test
    public void testList() {
        Criteria cri = new Criteria();
        List<ReplyVO> replies = mapper.getListWithPaging(cri, bnoArr[0]);
        replies.forEach(reply -> log.info("reply: " + reply));
    }

    @Test
    public void testList2() {
        Criteria cri = new Criteria(2, 10);
        List<ReplyVO> replies = mapper.getListWithPaging(cri, 1900567L);
        replies.forEach(reply -> log.info("reply"));
    }
}
