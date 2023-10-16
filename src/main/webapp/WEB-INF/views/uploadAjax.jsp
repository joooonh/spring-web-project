<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Insert title here</title>
</head>
<body>
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
</style>
<h1>Upload with Ajax</h1>

    <div class='uploadDiv'>
      <input type='file' name='uploadFile' multiple>
    </div>

    <div class='uploadResult'>
      <ul>

      </ul>
    </div>

  <button id='uploadBtn'> Upload </button>

<script src="https://code.jquery.com/jquery-3.3.1.min.js"
        integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>

<script>
$(document).ready(function() {

    // 업로드된 파일 이름 출력 함수
    var uploadResult = $(".uploadResult ul");

    function showUploadFile(uploadResultArr) {

        var str = "";

        $(uploadResultArr).each(function (i, obj) {

          // 이미지 파일이 아닌 경우에는 파일 아이콘 출력
          if (!obj.image) {
              str += "<li><img src='/resources/img/attach.png'>" + obj.fileName + "</li>";
          } else {
              // 이미지 파일인 경우 섬네일 출력
              // 파일 이름에 포함된 공백이나 한글 이름 인코딩 -> URI 호출에 적합한 문자열로 인코딩
              var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
              str += "<li><img src='/display?fileName=" + fileCallPath + "'></li>";
          }

        });

        uploadResult.append(str);
    }

    // 업로드 후에 업로드 부분 초기화 하기 위해 <input type='file'>이 포함된 <div>를 복사
    var cloneObj = $(".uploadDiv").clone();

    // 파일 확장자와 크기 처리 이벤트
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

    // 파일 업로드 버튼 클릭 이벤트
    $("#uploadBtn").on("click", function (e) {

        // jQuery를 이용하는 경우 파일 업로드 객체 (= 가상의 <form> 태그)
        var formData = new FormData();

        var inputFile = $("input[name='uploadFile']");

        var files = inputFile[0].files;

        console.log(files);

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
          processData : false,      // 반드시 false
          contentType : false,      // 반드시 false
          data : formData,
              type : 'POST',
              dataType : 'json',
              success: function (result) {

                  console.log(result);

                  // 업로드된 파일 이름 출력
                  showUploadFile(result);

                  // 업로드 후 계속 업로드하기 위해 업로드 부분 초기화
                  $(".uploadDiv").html(cloneObj.html());
              }
      })

    });


});

</script>

</body>
</html>
