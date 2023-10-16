<%--
  Created by IntelliJ IDEA.
  User: joooonh
  Date: 2023/10/12
  Time: 5:53 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@include file="../includes/header.jsp" %>

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
                    <button data-oper="modify" class="btn btn-default" onclick="location.href='/board/modify?bno=<c:out value="${board.bno }"/>'">Modify</button>
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

<!-- 댓글 -->
<div class="row">
    <div class="col-lg-12">
        <!-- /.panel -->
        <div class="panel panel-default">
            <div class="panel-heading">
                <i class="fa fa-comments fa-fw"></i> Reply
                <button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">New Reply</button>
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

    // 댓글 추가 버튼 클릭 이벤트
    $("#addReplyBtn").on("click", function (e) {
        modal.find("input").val("");                        // 입력 필드 비우기
        modalInputReplyDate.closest("div").hide();          // 필요 없는 항목들 숨기기
        modal.find("button[id != 'modalCloseBtn']").hide(); // 닫기 버튼 외의 버튼 숨기기

        modalRegisterBtn.show();

        $(".modal").modal("show");
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

        var reply = {rno:modal.data("rno"), reply:modalInputReply.val()};

        replyService.update(reply, function (result) {

            alert(result);
            modal.modal("hide");
            showList(pageNum);

        });
    });

    // 특정 댓글 삭제 이벤트
    modalRemoveBtn.on("click", function (e) {

        var rno = modal.data("rno");

        replyService.remove(rno, function (result) {

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
