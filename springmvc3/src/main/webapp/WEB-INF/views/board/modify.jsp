<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<%@include file="../includes/header.jsp" %>
<div class = 'bigPictureWrapper'>
    <div class = 'bigPicture'>
    </div>
</div>
<style>
    .uploadResult {
        width : 100%;
        background-color : gray;
    }
    .uploadResult ul{
        display : flex;
        flex-flow : row;
        justify-content : center;
        align-items : center;
    }
    .uploadResult ul li{
        list-style : none;
        padding : 10px;
        align-content : center;
        text-align : center;
    }
    .uploadResult ul li img {
        width : 100px;
    }
    .uploadResult ul li span {
        color : white;
    }
    .bigPictureWrapper{
        position : absolute;
        display : none;
        justify-content : center;
        align-items : center;
        top : 0%;
        width : 100%;
        height : 100%;
        background-color : gray;
        z-index : 100;
        background : rgba(255, 255, 255, 0.5);
    }
    .bigPicture {
        position : relative;
        display : flex;
        justify-content : center;
        align-items : center;
    }
    .bigPicture img {
        width : 600px;
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
            <div class="panel-heading">Board Modify Page</div>
            <!-- /.panel-heading -->
            <div class="panel-body">

                <form role="form" action="/board/modify" method="post">
                    <input type="hidden" name="pageNum" value="<c:out value="${cri.pageNum}"/>">
                    <input type="hidden" name="amount" value="<c:out value="${cri.amount}"/>">
                    <input type="hidden" name="type" value="<c:out value="${cri.type}"/>">
                    <input type="hidden" name="keyword" value="<c:out value="${cri.keyword}"/>">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

                    <div class="form-group">
                        <label>Bno</label>
                        <input class="form-control" name='bno' value='<c:out value="${board.bno}"/>' readonly="readonly">
                    </div>
                    <div class="form-group">
                        <label>Title</label>
                        <input class="form-control" name='title' value='<c:out value="${board.title}"/>'>
                    </div>
                    <div class="form-group">
                        <label>Text area</label>
                        <textarea class="form-control" rows="3" name='content'><c:out value="${board.content}"/> </textarea>
                    </div>
                    <div class="form-group">
                        <label>Writer</label>
                        <input class="form-control" name='writer' value='<c:out value="${board.writer}"/>' readonly="readonly">
                    </div>
                    <div class="form-group">
                        <label>RegDate</label>
                        <input class="form-control" name='regDate' value='<fmt:formatDate pattern="yyyy/MM/dd" value="${board.regDate}"/>' readonly="readonly">
                    </div>
                    <div class="form-group">
                        <label>Update Date</label>
                        <input class="form-control" name='updateDate' value='<fmt:formatDate pattern="yyyy/MM/dd" value="${board.updateDate}"/>' readonly="readonly">
                    </div>

                    <!-- 인증된 게시글 작성자만이 수정/삭제 가능 -->
                    <sec:authentication property="principal" var="pinfo"/>
                    <sec:authorize access="isAuthenticated()">
                        <c:if test="${pinfo.username eq board.writer}">
                            <button type="submit" data-oper="modify" class="btn btn-default">Modify</button>
                            <button type="submit" data-oper="remove" class="btn btn-danger">Remove</button>
                        </c:if>
                    </sec:authorize>
                    <button type="submit" data-oper="list" class="btn btn-info">List</button>
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
        <!-- /.panel -->
        <div class="panel panel-default">
            <div class="panel-heading">Files</div>
            <!-- /.panel-heading -->
            <div class="panel-body">
                <div class="form-group uploadDiv">
                    <input type="file" name="uploadFile" multiple="multiple">
                </div>
                <div class="uploadResult">
                    <ul>
                    </ul>
                </div>
            </div>
            <!-- end panel-body -->
        </div>
        <!-- end panel -->
    </div>
    <!-- ./ end col -->
</div>
<!-- ./ end row -->

<script type="text/javascript">
    $(document).ready(function() {

        // 게시글에서 첨부파일 목록 가져오는 즉시 실행 함수
        (function() {

            var bno = '<c:out value="${board.bno}"/>';

            // 게시물의 첨부파일 목록 출력
            $.getJSON("/board/getAttachList", {bno : bno}, function(arr){
                console.log(arr);
                var str = " ";
                $(arr).each(function(i, attach){

                    //img type
                    if(attach.fileType){
                        var fileCallPath = encodeURIComponent(attach.uploadPath + "/s_" + attach.uuid + "_" + attach.fileName);

                        str += "<li data-path = '" + attach.uploadPath + "' data-uuid = '" + attach.uuid + "'data-filename = '"
                            + attach.fileName + "' data-type = '" + attach.fileType+"' ><div>";
                        str += "<span> " + attach.fileName + "</span>";
                        str += "<button type='button' data-file=\'" + fileCallPath + "\' data-type='image' ";
                        str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
                        str += "<img src='/display?fileName=" + fileCallPath + "'>";
                        str += "</div>";
                        str += "</li>";

                    }else {

                        str += "<li data-path = '" + attach.uploadPath + "' data-uuid = '" + attach.uuid + "' data-filename = '"
                            + attach.fileName + "'data-type'" + attach.fileType + "'><div>";
                        str += "<span>" + attach.fileName + "</span><br/>";
                        str += "<button type='button' data-file=\'" + fileCallPath + "\'data-type='file' ";
                        str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
                        str += "<img src = '/resources/img/attach.png'>";
                        str += "</div>";
                        str += "</li>";
                    }
                });

                $(".uploadResult ul").html(str);
            });
        })();

        // 첨부파일 추가 함수
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

        // 스프링 시큐리티 - post, put, patch, delte 시 반드시 csrf 토큰 전달해야 함
        // 첨부파일은 ajax로 전송하므로 여기서 csrf 같이 전송
        var csrfHeaderName = "${_csrf.headerName}";
        var csrfTokenValue = "${_csrf.token}";

        // 첨부파일 추가 이벤트
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
                beforeSend: function (xhr) {
                    xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);   // ajax를 보낼 때 csrf 토큰을 같이 전송
                },
                dataType : 'json',        // 서버한테 받고 싶은
                success: function (result) {
                    console.log(result);
                    // 업로드된 파일 결과 처리 함수
                    showUploadResult(result);
                }
            })
        });

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

        // 첨부파일 x 버튼 클릭 이벤트 (첨부파일 업로드 후에 생성되기 때문에 이벤트 위임 방식으로 처리)
        $(".uploadResult").on("click", "button", function (e) {

            console.log("delete file");

            if (confirm("Remove this file? ")) {
                var targetLi = $(this).closest("li");
                targetLi.remove();
            }
        });

        // form 내 버튼 클릭 이벤트
        var formObj = $("form");

        $('button').on("click", function (e) {
            e.preventDefault();
            var operation = $(this).data("oper");
            console.log(operation);

            if (operation === 'remove') {
                formObj.attr("action", "/board/remove");
            } else if (operation === 'list') {
                // 수정폼에서 목록 클릭시 필요한 부분만 잠깐 복사하고 나머지는 지움
                formObj.attr("action", "/board/list").attr("method", "get");
                var pageNumTag = $("input[name='pageNum']").clone();
                var amountTag = $("input[name='amount']").clone();
                var typeTag = $("input[name='type']").clone();
                var keywordTag = $("input[name='keyword']").clone();

                formObj.empty();

                formObj.append(pageNumTag);
                formObj.append(amountTag);
                formObj.append(typeTag);
                formObj.append(keywordTag);
            } else if (operation === 'modify') {
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
            }
            formObj.submit();
        });
    })
</script>

<%@include file="../includes/footer.jsp" %>
