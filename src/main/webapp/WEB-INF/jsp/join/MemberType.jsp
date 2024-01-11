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
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
<meta name="google-signin-client_id" content="553481187522-m3sbg31sugosj070irrba110mokm47vj.apps.googleusercontent.com">
<script src="https://apis.google.com/js/platform.js" async defer></script>

<title>회원가입</title>
<script src="https://code.jquery.com/jquery-latest.min.js"></script>
<link rel="stylesheet" href="/asset/member/css/login.css">
</head>
<body>

<div class="tit_intro_step">
	<ul>
		<li>약관동의</li>
		<li class="current">회원유형</li>
		<li>정보입력</li>
		<li>가입완료</li>
	</ul>
</div>

<h2 class="icon1">회원유형 선택</h2>
<div class="confirm-area user-area">
	<article>
		<h3 class="icon2 ico-user">일반회원</h3>
		<div class="confirm_box">
			<p class="mB20">일반회원</p>
			<div class="btn-cont"><a href="/join/memberRegist.do?loginType=normal" class="btn spot member-type"><span>회원가입</span></a></div>
		</div>
	</article>
	
	<article>
		<h3 class="icon2 ico-user">SNS회원</h3>
		<div class="confirm_box">
			<p class="mB20">카카오 회원</p>
			<div class="btn-cont">
				<a class="btn-kakao" href="#" data-type="join">
					<img src="http://k.kakaocdn.net/14/dn/btroDszwNrM/I6efHub1SN5KCJqLm1Ovx1/o.jpg" width="150" alt="카카오 로그인 버튼"/>
				</a>
			</div>
		</div>
	</article>
	
	<article>
		<h3 class="icon2 ico-user">SNS회원</h3>
		<div class="confirm_box">
			<p class="mB20">네이버 회원</p>
			<div class="btn-cont">
				<a class="btn-naver" href="${naverAuthUrl}" data-type="join">
					<img src="/asset/front/images/common/btn-naver.png" width="150" alt="네이버 로그인 버튼"/>
				</a>
			</div>
		</div>
	</article>
	
	
	<article>
		<h3 class="icon2 ico-user">SNS회원</h3>
		<div class="confirm_box"  margin="auto">
			<p class="mB20">구글회원</p>
			<div class="btn-cont" >
			<div class="g-signin2" data-width="150" data-height="40" data-onsuccess="onSignIn" align="center"></div>

	</article>
		
		
</div>

<form id="joinFrm" name="joinFrm" method="post" action="/join/insertMember.do">
	<input type="hidden" name="loginType" value=""/>
	<input type="hidden" name="emplyrId"/>
	<input type="hidden" name="userNm"/>
	<input type="hidden" name="emailAdres"/>
</form>

<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script>
$(document).ready(function(){
	//카카오 로그인 버튼
	$(".btn-kakao").click(function(){
		const type = $(this).data("type");
		kakaoLogin(type);
		return false;
	});
});

//카카오 키 정보 입력
Kakao.init('2a3e332780189603d4027c2c218ee6a4'); // 본인 Javascript key

//카카오 SDK 초기화
Kakao.isInitialized();

//카카오로그인
function kakaoLogin(type){
	Kakao.Auth.login({
		success: function (response) {
			Kakao.API.request({
				url: '/v2/user/me',
				success:function (response) {
					console.log(response)
					$("input[name=loginType]").val("KAKAO");
					$("input[name=emplyrId]").val(response.id);
					$("input[name=userNm]").val(response.properties.nickname);
					$("input[name=emailAdres]").val(response.kakao_account.email);
					$("#joinFrm").submit();
				},
				fail: function (error){
					console.log(error)
				},
			})
		}, fail: function (error){
			console.log(error)
		},
	})
}
<c:if test="${ not empty message}">
	alert("${message}");
</c:if>

<c:if test="${ not empty loginMessage}">
	alert("${loginMessage}");
</c:if>

</script>

</body>
</html>