package com.example.controller;

import com.example.domain.Criteria;
import com.example.domain.ReplyPageDto;
import com.example.domain.ReplyVO;
import com.example.service.ReplyService;
import com.example.service.ReplyServiceImpl;
import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RequestMapping("/replies/")
@RestController
@Log4j
@AllArgsConstructor
public class ReplyController {

    private ReplyService service;

    // 댓글 등록 - post 방식으로만 동작, json 데이터만 받음(consumes), 문자열 반환(produces) - "success"
    // @RequestBody - json 데이터를 ReplyVO 타입으로 변환
    @PreAuthorize("isAuthenticated()")  // 댓글 등록이 로그인한 사용자인지 확인
    @PostMapping(value = "/new", consumes = "application/json", produces = {MediaType.TEXT_PLAIN_VALUE})
    public ResponseEntity<String> create(@RequestBody ReplyVO vo) {
        log.info("ReplyVO: " + vo);

        int insertCount = service.register(vo);
        log.info("Reply INSERT COUNT: " + insertCount);

        return insertCount == 1
                ? new ResponseEntity<>("success", HttpStatus.OK)
                : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }

    // 댓글 목록 조회 - ajax 요청에 대한 응답으로 xml, json 형식으로 ReplyVO 리스트를 응답(produces)
    @GetMapping(value = "/pages/{bno}/{page}", produces = {MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_VALUE})
    public ResponseEntity<ReplyPageDto> getList(@PathVariable("page") int page, @PathVariable("bno") Long bno) {

        Criteria cri = new Criteria(page, 10);
        log.info("get Reply List bno: " + bno);
        log.info("cri: " + cri);

        return new ResponseEntity<>(service.getListPage(cri, bno), HttpStatus.OK);
    }

    // 특정 댓글 조회 - xml, json 형식으로 ReplyVO 객체 응답
    @GetMapping(value = "/{rno}", produces = {MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_VALUE})
    public ResponseEntity<ReplyVO> get(@PathVariable("rno") Long rno) {
        log.info("get: " + rno);

        return new ResponseEntity<>(service.get(rno), HttpStatus.OK);
    }

    // 댓글 삭제 - 문자열 반환("success")
    @PreAuthorize("principal.username == #vo.replyer")  // 로그인한 사용자와 댓글 작성자가 같은지 확인
    @DeleteMapping(value = "/{rno}")
    public ResponseEntity<String> remove(@RequestBody ReplyVO vo, @PathVariable("rno") Long rno) {
        log.info("remove: " + rno);
        log.info("replyer: " + vo.getReplyer());

        return service.remove(rno) == 1
                ? new ResponseEntity<>("success", HttpStatus.OK)
                : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }

    // 댓글 수정 - json 형태를 받아서 (consumes), 문자열 반환 (produces)
    @PreAuthorize("principal.username == #vo.replyer")  // 로그인한 사용자와 댓글 작성자가 같은지 확인
    @RequestMapping(method = {RequestMethod.PUT, RequestMethod.PATCH},
                    value = "/{rno}",
                    consumes = "application/json")
    public ResponseEntity<String> modify(@RequestBody ReplyVO vo, @PathVariable("rno") Long rno) {
        vo.setRno(rno);
        log.info("rno: " + rno);
        log.info("modify: " + vo);

        return service.modify(vo) == 1
                ? new ResponseEntity<>("success", HttpStatus.OK)
                : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
}
