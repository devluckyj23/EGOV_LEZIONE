<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@	taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Language" content="ko" >
<title>데이터 가져오기~</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-latest.min.js"></script>
<style>
table{border-collapse: collapse;}
th{font-weight:bold;}
/* th, td{padding:5px;border:1px solid #000;} */
a{text-decoration:underline;margin:5px;}
</style>
</head>
<body>
	<div class="my-3" style="width:75%; margin:auto;">
		<table class="table">
			<tbody>
				<tr>
					<th class="table-light text-center col-2">제목</th>
					<td><c:out value="${result.sj}"/></td>
				</tr>	
				<tr>
					<th class="table-light text-center">작성자</th>
					<td><c:out value="${result.userNm}"/></td>
				</tr>
				<tr>
					<th class="table-light text-center">작성일</th>
					<td><fmt:formatDate value="${result.frstRegistPnttm}" pattern="yyyy-MM-dd hh:mm:ss"/></td>
				</tr>
				<tr style="height:300px">
					<th class="table-light text-center align-middle">내용</th>
					<td><c:out value="${result.cn}" escapeXml="false" /></td>
				</tr>
				<tr>
					<th class="table-light text-center align-middle">첨부파일목록</th>
					<td>
						<c:import url="/cmm/fms/selectFileInfs.do" charEncoding="utf-8">
							<c:param name="param_atchFileId" value="${result.atchFileId}" />
						</c:import>	
					</td>
				</tr>
			</tbody>
		</table>
	</div>	

<div class="box-btn my-3" style="width:75%; margin:auto;">
	<div class="text-lg-start">
		<c:url var="uptUrl" value="/test/testRegist.do">
			<c:param name="testId" value="${result.testId}"/>
		</c:url>
		<button><a href="${uptUrl}">수정</a></button>
	
		<c:url var="delUrl" value="/test/delete.do">
			<c:param name="testId" value="${result.testId}"/>
		</c:url>
		<button><a href="${delUrl}" class="btn-del">삭제</a></button>
	</div>
	<div class="text-lg-end">
		<button><a href="/test/selectList.do">목록</a></button>
	</div>
</div>


<script>
$(document).ready(function(){
	$(".btn-del").click(function(){
		if(!confirm("삭제하시겠습니까?")){
			return false;
		}
	});
});
</script>

</body>
</html>