package com.example.task;

import com.example.domain.BoardAttachVO;
import com.example.mapper.BoardAttachMapper;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Log4j
@Component
public class FileCheckTask {

    @Setter(onMethod_ = {@Autowired})
    private BoardAttachMapper attachMapper;

    private String getFolderYesterDay() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DATE, -1);
        String str = sdf.format(cal.getTime());

        return str.replace("-", File.separator);
    }

    @Scheduled(cron = "0 0 2 * * *")
    public void checkFiles() throws Exception {
        log.warn("File Check Task run.........");
        log.warn(new Date());

        // db에서 어제 날짜로 저장된 모든 첨부파일 목록 조회
        List<BoardAttachVO> fileList = attachMapper.getOldFiles();

        // BoardAttachVO 타입의 첨부파일 목록을 Paths의 목록으로 변환 (나중에 비교하기 위해서)
        List<Path> fileListPaths = fileList.stream()
                                        .map(vo -> Paths.get(
                                                    "/Users/joooonh/Documents/upload/", vo.getUploadPath(),
                                                        vo.getUuid() + "_" + vo.getFileName())).collect(Collectors.toList());

        // 이미지 파일의 경우 섬네일 파일도 목록에 필요
        fileList.stream()
                .filter(vo -> vo.isFileType() == true)
                .map(vo -> Paths.get("/Users/joooonh/Documents/upload/", vo.getUploadPath(), "s_" + vo.getUuid() + "_" + vo.getFileName()))
                .forEach(p -> fileListPaths.add(p));

        log.warn("================================");

        fileListPaths.forEach(p -> log.warn(p));

        // db에 어제 날짜로 저장된 파일 목록 조회
        File targetDir = Paths.get("/Users/joooonh/Documents/upload/", getFolderYesterDay()).toFile();

        // 실제 폴더에 있는 파일 중 db에 없는 파일을 찾아서 목록으로 준비
        File[] removeFiles = targetDir.listFiles(file -> fileListPaths.contains(file.toPath()) == false);

        log.warn("================================");

        // 실제 폴더와 db 상의 데이터가 안맞는 파일들 삭제
        for (File file : removeFiles) {
            log.warn(file.getAbsolutePath());
            file.delete();
        }

    }

}
