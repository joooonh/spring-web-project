<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Insert title here</title>
</head>
<body>
<h1>Upload with Ajax</h1>

<div class='uploadDiv'>
  <input type='file' name='uploadFile' multiple>
</div>

<button id='uploadBtn'> Upload </button>

<script src="https://code.jquery.com/jquery-3.3.1.min.js"
        integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>

<script>
$(document).ready(function() {

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
        }
    })

  });


});

</script>

</body>
</html>
