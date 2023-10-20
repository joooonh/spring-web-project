package com.example.controller;

import com.example.domain.BoardAttachVO;
import com.example.domain.BoardVO;
import com.example.domain.Criteria;
import com.example.domain.PageDTO;
import com.example.service.BoardService;
import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor     // 생성자를 통해 의존성 자동 주입
public class BoardController {

    private BoardService service;

    // 파일 삭제 메소드
    private void deleteFiles(List<BoardAttachVO> attachList) {

        if (attachList == null || attachList.size() == 0) {
            return;
        }
        log.info("delete attach files.....");
        log.info(attachList);

        attachList.forEach(attach -> {
            try {
                Path file = Paths.get(
                        "/Users/joooonh/Documents/upload/" + attach.getUploadPath() + "/" + attach.getUuid() + "_" + attach.getFileName());

                Files.deleteIfExists(file);

                if (Files.probeContentType(file).startsWith("image")) {
                    Path thumbNail = Paths.get(
                            "/Users/joooonh/Documents/upload/" + attach.getUploadPath() + "/s_" + attach.getUuid() + "_" + attach.getFileName());

                    Files.delete(thumbNail);
                }
            } catch (Exception e) {
                log.error("delete file error" + e.getMessage());
            }
        });
    }

    @GetMapping("/list")
    public void list(Criteria cri, Model model) {
        log.info("list: " + cri);
        int total = service.getTotal(cri);

        model.addAttribute("list", service.getList(cri));
        model.addAttribute("pageMaker", new PageDTO(cri, total));
    }

    @GetMapping("/register")
    @PreAuthorize("isAuthenticated()")
    public void register() {

    }

    @PostMapping("/register")
    @PreAuthorize("isAuthenticated()")
    public String register(BoardVO board, RedirectAttributes rttr) {

        log.info("=======================");
        log.info("register: " + board);

        if (board.getAttachList() != null) {
            board.getAttachList().forEach(attach -> log.info("attach: " + attach));
        }

        log.info("========================");

        service.register(board);

        // 등록 작업 후 다시 목록 화면으로 이동 + 새롭게 등록된 게시물 번호를 같이 전달 (임시 저장 후 삭제)
        rttr.addFlashAttribute("result", board.getBno());

        // 스프링 mvc 내부적으로 response.sendRedirect() 처리
        return "redirect:/board/list";
    }

    @GetMapping({"/get", "/modify"})
    public void get(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model) {
        log.info("/get or /modify");
        model.addAttribute("board", service.get(bno));
    }

    @PreAuthorize("principal.username == #writer")  // 로그인한 사용자가 작성자인 경우에만 수정
    @PostMapping("/modify")
    public String modify(BoardVO board, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
        log.info("modify: " + board);

        if (service.modify(board)) {
            rttr.addFlashAttribute("result", "success");
        }

        return "redirect:/board/list" + cri.getListLink();
    }

    @PreAuthorize("principal.username == #writer")  // 로그인한 사용자가 작성자인 경우에만 삭제
    @PostMapping("/remove")
    public String remove(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr, String writer) {
        log.info("remove..." + bno);

        List<BoardAttachVO> attachList = service.getAttachList(bno);

        if (service.remove(bno)) {

            // 파일 삭제
            deleteFiles(attachList);
            rttr.addFlashAttribute("result", "success");
        }

        return "redirect:/board/list" + cri.getListLink();
    }

    @GetMapping(value = "/getAttachList", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno) {
        log.info("getAttachList " + bno);

        return new ResponseEntity<>(service.getAttachList(bno), HttpStatus.OK);
    }


}
