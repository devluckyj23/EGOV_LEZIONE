<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Language" content="ko" >
<title>데이터 가져오기~</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-latest.min.js"></script>
<script src="https://cdn.tiny.cloud/1/0zvh09hz8ume20inu1wv5rlj38i4rs74p3z0yxfsqq2d5uxu/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>
<script>
$(function(){
    var plugins = [
        "advlist", "autolink", "lists", "link", "image", "charmap", "print", "preview", "anchor",
        "searchreplace", "visualblocks", "code", "fullscreen", "insertdatetime", "media", "table",
        "paste", "code", "help", "wordcount", "save"
    ];
    var edit_toolbar = 'formatselect fontselect fontsizeselect |'
               + ' forecolor backcolor |'
               + ' bold italic underline strikethrough |'
               + ' alignjustify alignleft aligncenter alignright |'
               + ' bullist numlist |'
               + ' table tabledelete |'
               + ' link image';

    tinymce.init({
    language: "ko_KR", //한글판으로 변경
        selector: '#cn',
        height: 300,
        menubar: false,
        plugins: plugins,
        toolbar: edit_toolbar,
        
        /*** image upload ***/
        image_title: true,
        /* enable automatic uploads of images represented by blob or data URIs*/
        automatic_uploads: true,
        /*
            URL of our upload handler (for more details check: https://www.tiny.cloud/docs/configure/file-image-upload/#images_upload_url)
            images_upload_url: 'postAcceptor.php',
            here we add custom filepicker only to Image dialog
        */
        file_picker_types: 'image',
        /* and here's our custom image picker*/
        file_picker_callback: function (cb, value, meta) {
            var input = document.createElement('input');
            input.setAttribute('type', 'file');
            input.setAttribute('accept', 'image/*');

            /*
            Note: In modern browsers input[type="file"] is functional without
            even adding it to the DOM, but that might not be the case in some older
            or quirky browsers like IE, so you might want to add it to the DOM
            just in case, and visually hide it. And do not forget do remove it
            once you do not need it anymore.
            */
            input.onchange = function () {
                var file = this.files[0];

                var reader = new FileReader();
                reader.onload = function () {
                    /*
                    Note: Now we need to register the blob in TinyMCEs image blob
                    registry. In the next release this part hopefully won't be
                    necessary, as we are looking to handle it internally.
                    */
                    var id = 'blobid' + (new Date()).getTime();
                    var blobCache =  tinymce.activeEditor.editorUpload.blobCache;
                    var base64 = reader.result.split(',')[1];
                    var blobInfo = blobCache.create(id, file, base64);
                    blobCache.add(blobInfo);

                    /* call the callback and populate the Title field with the file name */
                    cb(blobInfo.blobUri(), { title: file.name });
                };
                reader.readAsDataURL(file);
            };
            input.click();
        },
        /*** image upload ***/
        
        content_style: 'body { font-family:Helvetica,Arial,sans-serif; font-size:14px }'
    });
});
</script>

<style>
table{border-collapse: collapse;}
th{font-weight:bold;}
/* th, td{padding:5px;border:1px solid #000;} */
a{text-decoration:underline;margin:5px;}
</style>
</head>
<body>
	
<c:choose>
	<c:when test="${not empty result.testId}">
		<c:set var="actionUrl" value="/test/update.do"/>
		<c:set var="actionUser" value="${result.userNm}"/>
	</c:when>
	<c:otherwise>
		<c:set var="actionUrl" value="/test/insert.do"/>
		<c:set var="actionUser" value="${USER_INFO.name}"/>
	</c:otherwise>
</c:choose>	

<form action="${actionUrl}" method="post" name="testVO" enctype="multipart/form-data">
	<input type="hidden" name="testId" value="${result.testId}"/>
	
<div style="width:75%; margin:auto">
	<table class="table m-3">
		<tbody>
			<tr>
				<th class="table-light text-center">제목</th>
				<td>
					<input style="width:75%; border-radius:0" type="text" id="sj" name="sj" value="${result.sj}" placeholder ="제목을 입력하세요." />
				</td>
			</tr>
			<tr>
				<th class="table-light text-center">작성자</th>
				<td>
					<input style="width:50%; border-radius:0" type="text" id="userNm" name="userNm" value="<c:out value="${result.userNm}" default="${USER_INFO.name}" />" placeholder ="작성자를 입력하세요." /> <%-- ${actionUser} --%> <%-- <c:out value="${result.userNm}" default="${USER_INFO.name}" /> --%>
				</td>
			</tr>
			<tr>
				<th class="table-light text-center align-middle">내용</th>
				<td>
					<textarea id="cn" name="cn" rows="15" placeholder="내용을 입력하세요."><c:out value="${result.cn}"/></textarea>
				</td>
			</tr>
			<tr>
				<th class="table-light text-center align-middle">파일첨부</th>
				<td>
					<input id="file" type="file" name="file_1"/><br/>
					<input id="file" type="file" name="file_2"/>
				</td>
			</tr>
		</tbody>
	</table>
	
	<div class="text-lg-center m-3">
		<c:choose>
			<c:when test="${not empty result.testId}">
				<button type="submit">수정</button>
			</c:when>
			<c:otherwise>
				<button type="submit">등록</button>
			</c:otherwise>
		</c:choose>
		<button><a href="/test/selectList.do">취소</a></button>
	</div>
</div>
	
</form>

</body>
</html>