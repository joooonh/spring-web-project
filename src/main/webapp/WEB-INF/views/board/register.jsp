<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<%@include file="../includes/header.jsp" %>

<div class="bigPictureWrapper">
    <div class="bigPicture">

    </div>
</div>
<style>
    .uploadResult {
        width:100%;
        background-color : gray;
    }
    .uploadResult ul {
        display:flex;
        flex-flow: row;
        justify-contetn: center;
        align-items: center;
    }
    .uploadResult ul li {
        list-style: none;
        padding: 10px;
    }
    .uploadResult ul li img{
        width: 20px;
    }
    .uploadResult ul li span {
        color: white;
    }
    .bigPictureWrapper {
        position: absolute;
        display: none;
        justify-content: center;
        align-items: center;
        top: 0%;
        width: 100%;
        height: 100%;
        background-color: gray;
        z-index: 100;
        background: rgba(255,255,255,0.5);
    }
    .bigPicture {
        position: relative;
        display: flex;
        justify-content: center;
        align-items: center;
    }
    .bigPicture img {
        width: 600px;
    }
</style>

<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">Board Register</h1>
    </div>
    <!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">
                Board Register
            </div>
            <!-- /.panel-heading -->
            <div class="panel-body">
                <form role="form" action="/board/register" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">   <!-- 스프링 시큐리티 post 방식은 반드시 csrf 토큰 사용 -->
                    <div class="form-group">
                        <label>Title</label>
                        <input class="form-control" name='title'>
                    </div>
                    <div class="form-group">
                        <label>Text area</label>
                        <textarea class="form-control" rows="3" name='content'></textarea>
                    </div>
                    <div class="form-group">
                        <label>Writer</label>
                        <input class="form-control" name='writer' value="<sec:authentication property='principal.username'/>" readonly="readonly">
                    </div>
                    <button type="submit" class="btn btn-default">Submit Button</button>
                    <button type="reset" class="btn btn-default">Reset Button</button>
                </form>

            </div>
            <!-- /.panel-body -->
        </div>
        <!-- /.panel -->
    </div>
    <!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">

            <div class="panel-heading">File Attach</div>
            <!-- /.panel-heading -->
            <div class="panel-body">
                <div class="form-group uploadDiv">
                    <input type="file" name="uploadFile" multiple>
                </div>

                <div class="uploadResult">
                    <ul>

                    </ul>
                </div>
            </div>
            <!-- end panel-body -->

        </div>
        <!-- end panel-heading -->
    </div>
    <!-- end panel -->
</div>
<!-- /.row -->

<script>
$(document).ready(function (e) {

    // 스프링 시큐리티 - post, put, patch, delte 시 반드시 csrf 토큰 전달해야 함
    // 첨부파일은 ajax로 전송하므로 여기서 csrf 같이 전송
    var csrfHeaderName = "${_csrf.headerName}";
    var csrfTokenValue = "${_csrf.token}";

    $("input[type='file']").change(function (e) {
        var formData = new FormData();
        var inputFile = $("input[name='uploadFile']");
        var files = inputFile[0].files;

        for (var i = 0; i < files.length; i++) {

            if (!checkExtension(files[i].name, files[i].size)) {
                return false;
            }
            formData.append("uploadFile", files[i]);
        }

        $.ajax({
            url: '/uploadAjaxAction',
            processData: false,         // default contentType에 맞춰 데이터를 쿼리스트링으로 처리할지 여부 (반드시 false)
            contentType: false,         // 서버로 보낼 (반드시 false)
            beforeSend: function (xhr) {
                xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);   // ajax를 보낼 때 csrf 토큰을 같이 전송
            },
            data: formData,
            type: 'POST',
            dataType: 'json',           // 서버한테 받고 싶은
            success: function (result) {
                console.log(result);
                showUploadResult(result);   // 업로드 처리 결과 함수
            },
        })
    });

    // 파일 업로드는 버튼 클릭하지 않고, 내용 변경되는 것 감지해서 처리
    // 파일 확장자와 크기 처리 함수
    var regex = new RegExp("(.*?)\.(exe|sh|zip|alx)$");   // 파일 확장자 검사 정규식
    var maxSize = 5242880;    // 5MB

    function checkExtension(fileName, fileSize) {

        if (fileSize >= maxSize) {
            alert("파일 사이즈 초과");
            return false;
        }

        if (regex.test(fileName)) {
            alert("해당 종류의 파일은 업로드할 수 없습니다.");
            return false;
        }
        return true;
    }

    // 파일 업로드 결과 처리 함수
    function showUploadResult(uploadResultArr) {

        if (!uploadResultArr || uploadResultArr.length == 0) {
            return;
        }

        var uploadUL = $(".uploadResult ul");

        var str = "";

        $(uploadResultArr).each(function (i, obj) {

            if (!obj.image) {
                // 이미지 파일이 아닌 경우

                // 파일 이름에 포함된 공백이나 한글 이름 인코딩 -> URI 호출에 적합한 문자열로 인코딩 (파일이름.jpg -> %EC%A7%80.jpg)
                var fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);

                var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");

                // 이미지 파일이 아닌 경우에는 파일 아이콘 출력 -> 파일 아이콘 클릭 시 다운로드 하기 위해 <a> 태그
                str += "<li ";
                str += "data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.image + "' ><div>";
                str += "<span> " + obj.fileName + "</span>"
                str += "<button type='button' data-file=\'" + fileCallPath +"\' ";
                str += "data-type='file' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
                str += "<img src='/resources/img/attach.png'>";
                str += "</div>";
                str += "</li>";

            } else {
                // 이미지 파일인 경우 섬네일 출력

                // 파일 이름 인코딩
                var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);

                str += "<li ";
                str += "data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.image + "' ><div>";
                str += "<span> " + obj.fileName + "</span>"
                str += "<button type='button' data-file=\'" + fileCallPath +"\' ";
                str += "data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
                str += "<img src='/display?fileName=" + fileCallPath + "'>";
                str += "</div>";
                str += "</li>";
            }
        });

        uploadUL.append(str);
    }

    // form의 submit 기본동작 막고, 첨부파일 정보를 hidden으로 담아서 submit
    var formObj = $("form[role='form']");

    $("button[type='submit']").on("click", function (e) {
        e.preventDefault();
        console.log("submit clicked");

        var str = "";

        $(".uploadResult ul li").each(function (i, obj) {

            var jobj = $(obj);
            console.dir(jobj);

            str += "<input type='hidden' name='attachList[" + i + "].fileName' value='" + jobj.data("filename") + "'>";
            str += "<input type='hidden' name='attachList[" + i + "].uuid' value='" + jobj.data("uuid") + "'>";
            str += "<input type='hidden' name='attachList[" + i + "].uploadPath' value='" + jobj.data("path") + "'>";
            str += "<input type='hidden' name='attachList[" + i + "].fileType' value='" + jobj.data("type") + "'>";

        });

        formObj.append(str).submit();

    });

    // 첨부파일 등록 방식 - input 필드 변화
    $("input[type='file']").change(function (e) {

        // jQuery를 이용하는 경우 파일 업로드 객체 (= 가상의 <form> 태그)
        var formData = new FormData();

        var inputFile = $("input[name='uploadFile']");

        var files = inputFile[0].files;

        // FormData 객체에 각 파일 데이터 추가
        for (var i = 0; i < files.length; i++) {

            // 파일 확장자와 크기 검사
            if (!checkExtension(files[i].name, files[i].size)) {
                return false;
            }

            formData.append("uploadFile", files[i]);
        }

        // ajax를 통해서 formData 객체 전송
        $.ajax({
            url : '/uploadAjaxAction',
            processData : false,      // default contentType에 맞춰 데이터를 쿼리스트링으로 처리할지 여부 (반드시 false)
            contentType : false,      // 서버로 보낼 (반드시 false)
            data : formData,
            type : 'POST',
            dataType : 'json',        // 서버한테 받고 싶은
            success: function (result) {
                console.log(result);

                // 업로드된 파일 결과 처리 함수
                showUploadResult(result);
            }
        })
    });

    // 첨부파일 x 버튼 클릭 이벤트 (첨부파일 업로드 후에 생성되기 때문에 이벤트 위임 방식으로 처리)
    $(".uploadResult").on("click", "button", function (e) {

        var targetFile = $(this).data("file");  // data-file : 파일 경로
        var type = $(this).data("type");        // data-type
        var targetLi = $(this).closest("li");

        $.ajax({
            url: '/deleteFile',
            data: {fileName:targetFile, type:type},
            beforeSend: function (xhr) {
                xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
            },
            dataType: 'text',
            type: 'POST',
            success: function (result) {
                alert(result);
                targetLi.remove();      // 첨부파일 미리보기 삭제
            },
        })
    });

});

</script>

<%@include file="../includes/footer.jsp" %>
