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
            <div class="panel-heading">
                Board Register
            </div>
            <!-- /.panel-heading -->
            <div class="panel-body">

                    <div class="form-group">
                        <label>Bno</label>
                        <input class="form-control" name='bno' value='<c:out value="${board.bno}"/>' readonly="readonly">
                    </div>
                    <div class="form-group">
                        <label>Title</label>
                        <input class="form-control" name='title' value='<c:out value="${board.title}"/>' readonly="readonly">
                    </div>
                    <div class="form-group">
                        <label>Text area</label>
                        <textarea class="form-control" rows="3" name='content' readonly="readonly"><c:out value="${board.content}"/> </textarea>
                    </div>
                    <div class="form-group">
                        <label>Writer</label>
                        <input class="form-control" name='writer' value='<c:out value="${board.writer}"/>' readonly="readonly">
                    </div>

                    <!-- 인증된 게시글 작성자만이 수정/삭제 가능 -->
                    <sec:authentication property="principal" var="pinfo"/>
                        <sec:authorize access="isAuthenticated()">
                            <c:if test="${pinfo.username eq board.writer}">
                                <button data-oper="modify" class="btn btn-default" onclick="location.href='/board/modify?bno=<c:out value="${board.bno }"/>'">Modify</button>
                            </c:if>
                        </sec:authorize>

                    <button data-oper="list" class="btn btn-info" onclick="location.href='/board/list'">List</button>

                    <!-- 버튼 클릭 이벤트 적용을 위한 form -->
                    <form id="operForm" action="/board/modify" method="get">
                        <input type="hidden" id="bno" name="bno" value="<c:out value="${board.bno}"/>">
                        <input type="hidden" name="pageNum" value="<c:out value="${cri.pageNum}"/>">
                        <input type="hidden" name="amount" value="<c:out value="${cri.amount}"/>">
                        <input type="hidden" name="type" value="<c:out value="${cri.type}"/>">
                        <input type="hidden" name="keyword" value="<c:out value="${cri.keyword}"/>">
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

<!-- 댓글 -->
<div class="row">
    <div class="col-lg-12">
        <!-- /.panel -->
        <div class="panel panel-default">
            <div class="panel-heading">
                <i class="fa fa-comments fa-fw"></i> Reply
                <sec:authorize access="isAuthenticated()">
                    <button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">New Reply</button>
                </sec:authorize>
            </div>
            <!-- /.panel-heading -->
            <div class="panel-body">
                <ul class="chat">
                    <!-- start reply -->
                    <li class="left clearfix" data-rno='12'>
                        <div>
                            <div class="header">
                                <strong class="primary-font">user00</strong>
                                <small class="pull-right text-muted">2018-01-01 13:13</small>
                            </div>
                            <p>Good job!</p>
                        </div>
                    </li>
                    <!--  end reply -->
                </ul>
                <!--  ./end ul -->
            </div>
            <!-- ./panel .chat-panel -->
            <div class="panel-footer">
                <!-- 댓글 페이지 번호 출력되는 공간 -->
            </div>
        </div>
    </div>
    <!-- ./ end row -->
</div>

<!-- 댓글 작성 모달창 -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label>Reply</label>
                    <input class="form-control" name='reply' value='New Reply!!!!'>
                </div>
                <div class="form-group">
                    <label>Replyer</label>
                    <input class="form-control" name='replyer' value='replyer'>
                </div>
                <div class="form-group">
                    <label>Reply Date</label>
                    <input class="form-control" name='replyDate' value=''>
                </div>
            </div>
            <div class="modal-footer">
                <button id='modalModBtn' type="button" class="btn btn-warning">Modify</button>
                <button id='modalRemoveBtn' type="button" class="btn btn-danger">Remove</button>
                <button id='modalRegisterBtn' type="button" class="btn btn-primary">Register</button>

                <button id='modalCloseBtn' type="button" class="btn btn-default">Close</button>
            </div>
        </div>
    </div>
</div>
<!-- 댓글 추가 모달창 끝 -->

<!-- reply.js 파일 사용 -->
<script type="text/javascript" src="/resources/js/reply.js"></script>
<!-- 자바스크립트 -->
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
                        str += "<img src='/display?fileName=" + fileCallPath + "'>";
                        str += "</div>";
                        str += "</li>";
                    }else {
                        str += "<li data-path = '" + attach.uploadPath + "' data-uuid = '" + attach.uuid + "' data-filename = '"
                            + attach.fileName + "'data-type'" + attach.fileType + "'><div>";
                        str += "<span>" + attach.fileName + "</span><br/>";
                        str += "<img src = '/resources/img/attach.png'>";
                        str += "</div>";
                        str += "</li>";
                    }
                });

                $(".uploadResult ul").html(str);
            });
        })();
    });
</script>
<script type="text/javascript">

$(document).ready(function() {

    // 버튼 클릭 이벤트
    var operForm = $("#operForm");

    $("button[data-oper='modify']").on("click", function (e) {
        operForm.attr("action", "/board/modify").submit();
    });

    $("button[data-oper='list']").on("click", function (e) {
        operForm.find("#bno").remove();
        operForm.attr("action", "/board/list");
        operForm.submit();
    });
    // 버튼 클릭 이벤트 끝

    // 댓글 전체 목록 조회 이벤트
    var bnoValue = '<c:out value="${board.bno}"/>';
    var replyUL = $(".chat");

    showList(1);

    function showList(page) {

        replyService.getList({bno: bnoValue, page: page || 1}, function (replyCnt, list) {

            console.log("replyCnt: " + replyCnt);
            console.log("list: " + list);
            console.log(list);

            // 페이지가 -1로 전달되면 마지막 페이지를 찾아서 다시 호출
            if (page == -1) {
                pageNum = Math.ceil(replyCnt / 10.0);
                showList(pageNum);
                return;
            }

            var str = "";
            if (list == null || list.length == 0) {
                return;
            }

            for (var i = 0, len = list.length || 0; i < len; i++) {
                str += "<li class='left clearfix' data-rno='" + list[i].rno + "'>";
                str += "    <div><div class='header'><strong class='primary-font'>[" + list[i].rno + "] " + list[i].replyer + "</strong>";
                str += "        <small class='pull-right text-muted'>" + replyService.displayTime(list[i].replyDate) + "</small></div>";
                str += "        <p>" + list[i].reply + "</p></div></li>";
            }

            replyUL.html(str);

            // 댓글 페이지 번호 출력
            showReplyPage(replyCnt);

        });
        // end function
    }
    // 댓글 전체 목록 조회 이벤트 끝

    // 댓글 추가 모달창 이벤트
    var modal = $(".modal");
    var modalInputReply = modal.find("input[name='reply']");
    var modalInputReplyer = modal.find("input[name='replyer']");
    var modalInputReplyDate = modal.find("input[name='replyDate']");

    var modalModBtn = $("#modalModBtn");
    var modalRemoveBtn = $("#modalRemoveBtn");
    var modalRegisterBtn = $("#modalRegisterBtn");

    // 스프링 시큐리티 적용 - 현재 로그인한 사용자를 댓글 작성자로 되도록 설정
    var replyer = null;

    <sec:authorize access="isAuthenticated()">
        replyer = '<sec:authentication property="principal.username"/>';
    </sec:authorize>

    // 스프링 시큐리티 - post, put, patch, delte 시 반드시 csrf 토큰 전달해야 함
    // 댓글은 ajax로 전송하므로 여기서 csrf 같이 전송
    var csrfHeaderName = "${_csrf.headerName}";
    var csrfTokenValue = "${_csrf.token}";

    // 댓글 추가 버튼 클릭 이벤트
    $("#addReplyBtn").on("click", function (e) {
        modal.find("input").val("");                        // 입력 필드 비우기
        modal.find("input[name='replyer']").val(replyer);   // 현재 로그인한 사용자가 댓글 작성자
        modalInputReplyDate.closest("div").hide();          // 필요 없는 항목들 숨기기
        modal.find("button[id != 'modalCloseBtn']").hide(); // 닫기 버튼 외의 버튼 숨기기

        modalRegisterBtn.show();

        $(".modal").modal("show");
    });

    // 스프링 시큐리티 - ajax로 댓글 등록 시 csrf 토큰 적용 (beforeSend 말고 기본 설정으로 지정)
    // ajaxSend() - 모든 ajax 전송 시 csrf 토큰 같이 전송하도록 세팅
    $(document).ajaxSend(function (e, xhr, options) {
        xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
    });

    // 댓글 추가 이벤트
    modalRegisterBtn.on("click", function (e) {

        var reply = {
            reply: modalInputReply.val(),
            replyer: modalInputReplyer.val(),
            bno: bnoValue
        };

        replyService.add(reply, function (result) {
            alert(result);

            modal.find("input").val("");    // 댓글 추가되면 입력 필드 비우기
            modal.modal("hide");            // 모달창 닫기

            // showList(1);                    // 댓글 추가 후 다시 댓글 전체 목록 보이기
            showList(-1);                   // 새 댓글 추가 시 댓글이 추가된 맨 마지막 페이지로 이동
        });
    });

    // 특정 댓글 조회 이벤트 위임 (이벤트 대상은 <ul>, 실제 이벤트 대상은 <li>)
    $(".chat").on("click", "li", function (e) {

        var rno = $(this).data("rno");

        replyService.get(rno, function (reply) {

            modalInputReply.val(reply.reply);
            modalInputReplyer.val(reply.replyer);
            modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly", "readonly");
            // 수정, 삭제에 필요한 rno를 data-rno 속성을 만들어서 추가
            modal.data("rno", reply.rno);

            modal.find("button[id != 'modalCloseBtn']").hide();
            modalModBtn.show();
            modalRemoveBtn.show();

            $(".modal").modal("show");
        });
    });

    // 특정 댓글 수정 이벤트
    modalModBtn.on("click", function (e) {

        var originalReplyer = modalInputReplyer.val();      // 댓글의 원래 작성자
        var reply = {
            rno:modal.data("rno"),
            reply:modalInputReply.val(),
            replyer:originalReplyer};

        if (!replyer) {
            alert("로그인 후 수정이 가능합니다.");
            modal.modal("hide");
            return;
        }
        console.log("Original Replyer: " + originalReplyer);
        if (replyer != originalReplyer) {
            alert("자신이 작성한 댓글만 삭제가 가능합니다.");
            modal.modal("hide");
            return;
        }

        replyService.update(reply, function (result) {
            alert(result);
            modal.modal("hide");
            showList(pageNum);
        });
    });

    // 특정 댓글 삭제 이벤트
    modalRemoveBtn.on("click", function (e) {

        var rno = modal.data("rno");

        console.log("RNO: " + rno);
        console.log("REPLYER: " + replyer);

        // 댓글 삭제 시 로그인한 사용자가 작성한 댓글만 삭제 가능

        if (!replyer) {
            alert("로그인 후 삭제가 가능합니다.");
            modal.modal("hide");
            return;
        }
        var originalReplyer = modalInputReplyer.val();      // 댓글의 원래 작성자
        console.log("original Replyer: " + originalReplyer);
        if (replyer != originalReplyer) {
            alert("자신이 작성한 댓글만 삭제가 가능합니다.");
            modal.modal("hide");
            return;
        }

        replyService.remove(rno, originalReplyer, function (result) {
            alert(result);
            modal.modal("hide");
            showList(pageNum);
        });
    });

    // 댓글 페이지 번호 출력
    var pageNum = 1;
    var replyPageFooter = $(".panel-footer");

    function showReplyPage(replyCnt) {

        var endNum = Math.ceil(pageNum / 10.0) * 10;
        var startNum = endNum - 9;

        var prev = startNum != 1;
        var next = false;

        // 현재 페이지 범위의 끝 페이지 * 게시글 10개 >= 전체 댓글 수 이면 endNum에는 다음 페이지 번호 표시
        // 현재 페이지 범위가 모든 댓글을 다루고 있으면 next 버튼 필요 없음
        if (endNum * 10 >= replyCnt) {
            endNum = Math.ceil(replyCnt / 10.0);
        }
        // 현재 페이지 범위의 끝 페이지 번호가 전체 댓글 수보다 작으면 next 표시
        if (endNum * 10 < replyCnt) {
            next = true;
        }

        var str = "<ul class='pagination pull-right'>";

        if (prev) {
            str += "<li class='page-item'><a class='page-link' href='" + (startNum - 1) + "'>Previous</a></li>";
        }

        for (var i = startNum; i <= endNum; i++) {
            var active = pageNum == i ? "active" : "";

            str += "<li class='page-item " + active + " '><a class='page-link' href='" + i + "'>" + i + "</a></li>";
        }

        if (next) {
            str += "<li class='page-item'><a class='page-link' href='" + (endNum + 1) + "'>Next</a></li>";
        }

        str += "</ul></div>";

        console.log(str);
        replyPageFooter.html(str);
    }

    // 댓글 페이지 번호 클릭 이벤트
    replyPageFooter.on("click", "li a", function (e) {
        e.preventDefault();
        console.log("page click");

        var targetPageNum = $(this).attr("href");
        console.log("targetPageNum: " + targetPageNum);

        pageNum = targetPageNum;

        showList(pageNum);
    });

    // 첨부파일 클릭 시 이벤트 처리
    $(".uploadResult").on("click", "li", function (e) {
        console.log("view image");

        var liObj = $(this);
        var path = encodeURIComponent(liObj.data("path") + "/" + liObj.data("uuid") + "_" + liObj.data("filename"));

        if (liObj.data("type")) {
            showImage(path.replace(new RegExp(/\\/g), "/"));
        } else {
            self.location = "/download?fileName=" + path;
        }
    });

    // 첨부파일 클릭 시 이미지 띄우기
    function showImage(fileCallPath) {

        $(".bigPictureWrapper").css("display", "flex").show();

        // animate() : 지정된 시간 동안 화면에서 열리는 효과 -> 1초 동안 가로 세로 모두 100%로 확대
        $(".bigPicture")
            .html("<img src='/display?fileName=" + fileCallPath + "'>")
            .animate({width: '100%', height: '100%'}, 1000);
    }

    // 확대된 이미지 클릭 시 창 닫기
    $(".bigPictureWrapper").on("click", function (e) {
        $(".bigPicture").animate({width: '0%', height: '0%'}, 1000);
        setTimeout(function() {
            $('.bigPictureWrapper').hide();
        }, 1000);
    });

});

/* 댓글 crud 작업

    // 댓글 등록
    // reply.js 파일의 add 메소드 호출하여 ajax 요청
    // reply, replyer, bno 전달
    replyService.add(
        {reply:"JS TEST", replyer:"tester", bno:bnoValue},
        function(result) {              // 요청 성공 시 실행되는 콜백 함수
            alert("RESULT: " + result);
        }
    )

    // 댓글 목록 조회
    replyService.getList({bno:bnoValue, page:1}, function (list) {
        for (var i = 0, len = list.length || 0; i < len; i++) {
            console.log(list[i]);
        }
    });

    // 댓글 삭제
    replyService.remove(13, function (count) {
        console.log(count);

        if (count === "success") {
            alert("REMOVED");
        }
    }, function (err) {
        alert('ERROR...');
    });

    // 댓글 수정
    replyService.update(
        {rno: 14, bno: bnoValue, reply: "Modified Reply..."},
        function (result) {
            alert("수정 완료...");
    });

    // 특정 댓글 조회
    replyService.get(12, function (data) {
        console.log(data);
    });

*/
</script>

<%@include file="../includes/footer.jsp" %>
