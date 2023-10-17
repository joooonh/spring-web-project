<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Insert title here</title>
</head>
<body>
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

    // <a> 태그에서 직접 호출할 수 있게 하기 위해 global scope에 작성
    function showImage(fileCallPath) {

        $(".bigPictureWrapper").css("display", "flex").show();

        // animate() : 지정된 시간 동안 화면에서 열리는 효과 -> 1초 동안 가로 세로 모두 100%로 확대
        $(".bigPicture")
            .html("<img src='/display?fileName=" + encodeURI(fileCallPath) + "'>")
            .animate({width: '100%', height: '100%'}, 1000);
    }

$(document).ready(function() {

    // 첨부파일 x 버튼 클릭 이벤트 (첨부파일 업로드 후에 생성되기 때문에 이벤트 위임 방식으로 처리)
    $(".uploadResult").on("click", "span", function (e) {

        var targetFile = $(this).data("file");  // data-file : 파일 경로
        var type = $(this).data("type");        // data-type
        console.log(targetFile);

        $.ajax({
            url: '/deleteFile',
            data: {fileName:targetFile, type:type},
            dataType: 'text',
            type: 'POST',
            success: function (result) {
                alert(result);
            },
        })
    });

    // 확대된 이미지 클릭 시 축소하여 숨기는 이벤트
    $(".bigPictureWrapper").on("click", function (e) {
        $(".bigPicture").animate({width: '0%', height: '0%'}, 1000);
        setTimeout(() => {
            $(this).hide();
        }, 1000);
    });

    // 업로드된 파일 이름 출력 함수
    var uploadResult = $(".uploadResult ul");

    function showUploadFile(uploadResultArr) {

        var str = "";

        $(uploadResultArr).each(function (i, obj) {

          if (!obj.image) {
              // 파일 이름에 포함된 공백이나 한글 이름 인코딩 -> URI 호출에 적합한 문자열로 인코딩 (파일이름.jpg -> %EC%A7%80.jpg)
              var fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);

              var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");

              // 이미지 파일이 아닌 경우에는 파일 아이콘 출력 -> 파일 아이콘 클릭 시 다운로드 하기 위해 <a> 태그
              str += "<li><div><a href='/download?fileName=" + fileCallPath + "'>" +
                        "<img src='/resources/img/attach.png'>" + obj.fileName + "</a>" +
                            "<span data-file=\'" + fileCallPath + "\' data-type='file'> x </span>" + "</div></li>";
          } else {
              // 이미지 파일인 경우 섬네일 출력
              var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);

              var originPath = obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName;

              // /g : 문자열 내 모든 패턴 검사
              originPath = originPath.replace(new RegExp(/\\/g), "/");

              str += "<li><a href=\"javascript:showImage(\'"+originPath+"\')\">" +
                        "<img src='/display?fileName=" + fileCallPath + "'></a>" +
                            "<span data-file=\'" + fileCallPath + "\' data-type='image'> x </span>" + "</li>";
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
          processData : false,      // default contentType에 맞춰 데이터를 쿼리스트링으로 처리할지 여부 (반드시 false)
          contentType : false,      // 서버로 보낼 (반드시 false)
          data : formData,
              type : 'POST',
              dataType : 'json',    // 서버한테 받고 싶은
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
