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
<meta http-equiv="X-UA-Compatible" content="IE=dege" />
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
<title>회원</title>
<script src="https://code.jquery.com/jquery-latest.min.js"></script>
</head>
<body>

<!-- BBS Style -->
<link href="/asset/BBSTMP_0000000000001/style.css" rel="stylesheet" />
<!-- 공통 Style -->
<link href="/asset/LYTTMP_0000000000000/style.css" rel="stylesheet" />

<%-- 기본 URL --%>
<c:url var="_BASE_PARAM" value="">
	<c:if test="${not empty searchVO.searchCondition}"><c:param name="searchCondition" value="${searchVO.searchCondition}" /></c:if>
	<c:if test="${not empty searchVO.searchKeyword}"><c:param name="searchKeyword" value="${searchVO.searchKeyword}" /></c:if>
</c:url>

<div class="container">
	<div id="contents">
		<table class="chart2">
			<caption>게시글 작성</caption>
			<colgroup>
				<col style="width:120px" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">고유번호</th>
					<td><c:out value="${result.esntlId}"/></td>
				</tr>
				<tr>
					<th scope="row">회원ID</th>
					<td><c:out value="${result.emplyrId}"/></td>
				</tr>
				<tr>
					<th scope="row">회원명</th>
					<td><c:out value="${result.userNm}"/></td>
				</tr>
				<tr>
					<th scope="row">비밀번호</th>
					<td><button type="button" id="btn-pw" class="btn spot">비밀번호 재발급</button></td>
				</tr>
				<tr>
					<th scope="row">이메일주소</th>
					<td><c:out value="${result.emailAdres}"/></td>
				</tr>
				<tr>
					<th scope="row">가입일</th>
					<td><fmt:formatDate value="${result.sbscrbDe}" pattern="yyyy-MM-dd"/></td>
				</tr>
				
			</tbody>
		</table>
		<div class="btn-cont ac">
			<c:url var="listUrl" value="/admin/member/memberList.do${_BASE_PARAM}"/>
			<a href="${listUrl}" class="btn">목록</a>
		</div>
	</div>
</div>

<script>
//비밀번호 재발급
$("#btn-pw").click(function(){
	$.ajax({
		url : "/admin/member/changePwRandom.do",
		type : "post",
		data : {"emplyrId" : "${result.emplyrId}", "esntlId" : "${result.esntlId}", "emailAdres" : "${result.emailAdres}"},
		dataType : "json",
		success : function(data) {
			if(data.successYn == "Y") {
				alert("비밀번호 재발급이 완료되었습니다.");
			} else {
				alert(data.message);
			}
		}, error : function() {
			alert("error");
		}
	});
	
	return false;
});
</script>

</body>
</html>