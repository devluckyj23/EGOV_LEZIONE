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
<style>
table{border-collapse: collapse;}
th{font-weight:bold;}
/* th, td{padding:5px;border:1px solid #000;} */
a{text-decoration:underline;margin:5px;}
</style>
</head>
<body>

<%-- 접속계정 : ${ USER_INFO.id != null ? "a" : "b" } --%>
접속계정 : <c:out value="${USER_INFO.id}"/> <c:out value="${USER_INFO.name}"/>

	<div class="my-3" style="width:75%; margin:auto;">
	
		<div class="total">
		총 게시물
		<strong><c:out value="${paginationInfo.totalRecordCount}"/></strong>건
		현재페이지<strong><c:out value="${paginationInfo.currentPageNo}"/></strong>/
		<c:out value="${paginationInfo.totalPageCount}"/>
		</div>
	
		<table class="table table-sm table-hover text-center" style="margin:auto;">
			<thead class="table-light">
				<tr>
					<th>ID</th>
					<th class="col-4">제목</th>
					<th>작성자</th>
					<th>작성일</th>
					<th>수정일</th>
					<th>관리</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="result" items="${resultList}">
					<tr>
						<td><c:out value="${result.testId}"/></td>
						<td style="text-align:left;">
							<c:url var="viewUrl" value="/test/select.do">
								<c:param name="testId" value="${result.testId}"/>
							</c:url>
							<a href="${viewUrl}"><c:out value="${result.sj}"/></a>
						</td>
						<td><c:out value="${result.userNm}"/></td>
						<td><c:out value="${result.frstRegistPnttm}"/></td>
						<td><c:out value="${result.lastUpdtPnttm}"/></td>
						<td>
							<c:url var="delUrl" value="/test/delete.do">
								<c:param name="testId" value="${result.testId}"/>
							</c:url>
							<button><a href="${delUrl}" class="btn-del">삭제</a></button>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		
		<div id="paging_div" class="my-3">
			<ul class="paging_align text-center">
				<c:url var="pageUrl" value="/test/selectList.do?"/>
				<c:set var="pagingParam"><c:out value="${pageUrl}"/></c:set>
				<ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="${pagingParam}" />
			</ul>
		</div>
	
		<div class="text-lg-end mx-3 my-3" style="margin-top:-40px;">
			<button type="button" id="btn-reg" data-href="/test/testRegist.do">글쓰기</button>
		</div>
			
	</div> 
	

<script>
<c:if test="${not empty message}">
	alert("${message}");
</c:if>
</script>

<script>
$(document).ready(function(){
	$("#btn-reg").click(function(){
		location.href = $(this).data("href");
	});
	
	$(".btn-del").click(function(){
		if(!confirm("삭제하시겠습니까?")){
			return false;
		}
	});
});

</script>


</body>
</html>