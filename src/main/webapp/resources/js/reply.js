console.log("Reply Module.......");

// ajax 호출 담당
// 코드 블록을 즉시 실행하고, 클로저를 형성하여 함수 내부의 변수와 함수를 외부에서 접근할 수 없음
var replyService = (function() {

    // 댓글 등록
    // 외부에서 호출할 수 있는 공개 함수 (reply : 추가할 댓글 데이터)
    function add(reply, callback, error) {

        console.log("add reply.......");

        // ajax 호출이 replyService 객체 안에 감춰져 있음 -> 필요한 파라미터들만 전달
        $.ajax({
            type : 'post',
            url : '/replies/new',
            data : JSON.stringify(reply),               // reply 객체를 json 으로 변환하여 서버로의 요청 데이터로 사용
            contentType : "application/json; charset=utf-8",
            success: function (result, status, xhr) {   // 요청 성공 시 응답 데이터를 result로 받아서 callback 함수 호출
                if (callback) {
                    callback(result);
                }
            },
            error: function (xhr, status, er) {
                if (error) {
                    error(er);
                }
            },
        })
    }

    // 댓글 목록 조회
    // param 객체를 통해 파라미터를 전달받아 json 목록 호출
    function getList(param, callback, error) {

        var bno = param.bno;
        var page = param.page || 1;

        $.getJSON("/replies/pages/" + bno + "/" + page + ".json", function (data) {
            if (callback) {
                // callback(data);                      // 댓글 목록만 가져오는 경우
                callback(data.replyCnt, data.list);     // 댓글 숫자와 목록을 가져오는 경우
            }
        }).fail(function (xhr, status, err) {
            if (error) {
                error();
            }
        });
    }

    // 댓글 삭제 (댓글 작성자를 같이 전송)
    function remove(rno, replyer, callback, error) {
        $.ajax({
            type : 'delete',
            url : '/replies/' + rno,
            data : JSON.stringify({rno:rno, replyer:replyer}),
            contentType : "application/json; charset=utf-8",
            success: function (deleteResult, status, xhr) {
                if (callback) {
                    callback(deleteResult);
                }
            },
            error: function (xhr, status, er) {
                if (error) {
                    error(er);
                }
            },
        })
    }

    // 댓글 수정
    function update(reply, callback, error) {
        console.log("RNO: " + reply.rno);

        $.ajax({
            type : 'put',
            url : '/replies/' + reply.rno,
            data : JSON.stringify(reply),
            contentType : "application/json; charset=utf-8",
            success: function (result, status, xhr) {
                if (callback) {
                    callback(result);
                }
            },
            error: function (xhr, status, er) {
                if (error) {
                    error(er);
                }
            }
        });
    }

    // 특정 댓글 조회
    function get(rno, callback, error) {

        $.get("/replies/" + rno + ".json", function (result) {
            if (callback) {
                callback(result);
            }
        }).fail(function (xhr, status, err) {
            if (error) {
                error();
            }
        });
    }

    // 시간 처리
    function displayTime(timeValue) {

        var today = new Date();
        var gap = today.getTime() - timeValue;
        var dateObj = new Date(timeValue);
        var str = "";

        if (gap < (1000 * 60 * 60 * 24)) {  // 하루 (24시간 * 60분 * 60초 * 1000밀리초)
            var hh = dateObj.getHours();
            var mi = dateObj.getMinutes();
            var ss = dateObj.getSeconds();

            // 한자릿수인 경우 앞에 0을 추가하여 두자릿수로 만들기
            // join('') - 배열의 각 요소를 하나의 문자열로 합침
            return [(hh > 9 ? '' : '0') + hh, ':',
                    (mi > 9 ? '' : '0') + mi, ':',
                    (ss > 9 ? '' : '0') + ss ].join('');
        } else {
            var yy = dateObj.getFullYear();
            var mm = dateObj.getMonth() + 1;    // getMon() is zero-based
            var dd = dateObj.getDate();

            return [yy, '/',
                    (mm > 9 ? '' : '0') + mm, '/',
                    (dd > 9 ? '' : '0') + dd].join('');
        }
    };

    // 각 메소드를 외부로 공개하는 객체 반환. 클라이언트에서 각 메소드 호출 가능
    return {
        add : add,
        getList : getList,
        remove : remove,
        update : update,
        get : get,
        displayTime : displayTime
    };
})();