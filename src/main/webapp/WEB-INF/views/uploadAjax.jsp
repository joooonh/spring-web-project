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

  $("#uploadBtn").on("click", function (e) {

    // jQuery를 이용하는 경우 파일 업로드 객체 (= 가상의 <form> 태그)
    var formData = new FormData();

    var inputFile = $("input[name='uploadFile']");

    var files = inputFile[0].files;

    console.log(files);

    // FormData 객체에 각 파일 데이터 추가
    for (var i = 0; i < files.length; i++) {
      formData.append("uploadFile", files[i]);
    }
    // ajax를 통해서 formData 객체 전송
    $.ajax({
      url : '/uploadAjaxAction',
      processData : false,      // 반드시 false
      contentType : false,      // 반드시 false
      data : formData,
      type : 'POST',
      success: function (result) {
        alert("Uploaded");
      },
    })

  });
})

</script>

</body>
</html>
