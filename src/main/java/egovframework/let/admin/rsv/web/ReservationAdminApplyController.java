package egovframework.let.admin.rsv.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.let.rsv.service.ReservationApplyService;
import egovframework.let.rsv.service.ReservationApplyVO;
import egovframework.let.rsv.service.ReservationService;
import egovframework.let.rsv.service.ReservationVO;
import egovframework.let.utl.fcc.service.EgovStringUtil;
import egovframework.rte.psl.dataaccess.util.EgovMap;



@Controller
public class ReservationAdminApplyController {

	
	@Resource(name="reservationService")
	private ReservationService reservationService;
	
	@Resource(name="reservationApplyService")
	private ReservationApplyService reservationApplyService;
	
	//예약자 정보 목록 가져오기
	@RequestMapping(value= "/admin/rsv/selectApplyList.do")
	public String selectApplyList(@ModelAttribute("searchVO") ReservationApplyVO searchVO, HttpServletRequest request, ModelMap model ) throws Exception{
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if(user == null || user.getId() == null) {
			model.addAttribute("message","로그인 후 사용가능합니다.");
			return "redirect:" +Globals.MAIN_PAGE;
		}
		//관리자	
		searchVO.setMngAt("Y");
		
		List<EgovMap> resultList = reservationApplyService.selectReservationApplyList(searchVO);
		model.addAttribute("resultList", resultList);
		
		//엑셀 다운로드
		if("Y".equals(searchVO.getExcelAt())) {
			return "admin/rsv/RsvApplySelectListExcel";
		}
		
		
		return "admin/rsv/RsvApplySelectList";
	}
	
	//예약정보 상세
	@RequestMapping(value= "/admin/rsv/rsvApplySelect.do")
	public String rsvApplySelect(@ModelAttribute("searchVO") ReservationApplyVO searchVO, HttpServletRequest request, ModelMap model ) throws Exception{
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		//현재 인증된 사용자의 정보를 가져오기 위해 EgovUserDetailsHelper를 사용합니다. 
		//사용자가 인증되어 있지 않거나 사용자 정보가 없으면, 로그인이 필요하다는 메시지를 모델에 추가하고, 메인 페이지로 리다이렉트합니다.
		
		if(user == null || user.getId() == null) {
			model.addAttribute("message","로그인 후 사용가능합니다.");
			return "redirect:" +Globals.MAIN_PAGE;
		}else {
			model.addAttribute("USER_INFO",user);
			//모델에 사용자 정보 추가: 사용자가 인증되어 있다면, 모델에 사용자 정보를 추가합니다. 
			//model.addAttribute("USER_INFO", user);는 "USER_INFO"라는 이름으로 사용자 정보를 모델에 추가합니다.
		}
		ReservationApplyVO result = reservationApplyService.selectReservationApply(searchVO);
		//예약 신청 정보 조회 : 예약 신청 정보를 검색하기 위해 reservationApplyService를 사용합니다.
		
		//이중서브밋방지
		request.getSession().removeAttribute("sessionReservationApply");
		//세션 속성이 삭제되면 다음 요청에서는 해당 속성에 대한 데이터를 가져올 수 없게 됩니다.
		
		model.addAttribute("result",result);
		//모델에 결과 추가: 조회된 예약 신청 정보를 모델에 추가합니다. "result"라는 이름으로 조회
		return "admin/rsv/RsvApplySelect";
	}
	//if문에서 로그인 유무를 확인하고, 사용자 정보가 없다면 로그인페이지로 리다이렉트하고 메시지를 model에 추가한다.
	//사용자가 로그인한 경우 사용자 정보를 model에 추가한다.
	//searchVO의 예약정보를 검색하고, 그 결과를 model에 result라는 이름으로 추가한다.
	// 이중서브밋 방지를 위해 session에 저장되어있던 예약정보를 삭제한다. 
	
	//예약정보 승인
	@RequestMapping(value= "/admin/rsv/rsvApplyConfirm.do")
	public String updateReservationConfirm(@ModelAttribute("searchVO") ReservationApplyVO searchVO, HttpServletRequest request, ModelMap model ) throws Exception{
		//이중 서브밋 방지
		if(request.getSession().getAttribute("sessionReservationApply") != null) {
			return "forward:/admin/rsv/selectApplyList.do";
		}
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if(user == null || user.getId() == null) {
			model.addAttribute("message","로그인 후 사용가능합니다.");
			return "redirect:" +Globals.MAIN_PAGE;
		}
		searchVO.setUserId(user.getId());
		reservationApplyService.updateReservationConfirm(searchVO);
		
		//이중 서브밋 방지
		request.getSession().setAttribute("sessionReservationApply", searchVO);
		return "forward:/admin/rsv/selectApplyList.do";
		}
	//예약정보 삭제하기
	@RequestMapping(value= "/admin/rsv/rsvApplyDelete.do")
	public String rsvApplyDelete(@ModelAttribute("searchVO") ReservationApplyVO searchVO, HttpServletRequest request, ModelMap model ) throws Exception{
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if(user == null || user.getId() == null) {
			model.addAttribute("message","로그인 후 사용가능합니다.");
			return "redirect:" +Globals.MAIN_PAGE;
		}
		searchVO.setUserId(user.getId());
		reservationApplyService.deleteReservationApply(searchVO);
										
		return "forward:/admin/rsv/selectApplyList.do";
		}
	
	//예약자정보 엑셀 다운로드
	@RequestMapping(value= "/admin/rsv/excel.do")
	public ModelAndView excel(@ModelAttribute("searchVO") ReservationApplyVO searchVO, HttpServletRequest request, HttpServletResponse response, ModelMap model)throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		List<String> columMap = new ArrayList<String>();
		List<Object> valueMap = new ArrayList<Object>();
		String fileName = "";
		
		columMap.add("번호");
		columMap.add("신청자명");
		columMap.add("연락처");
		columMap.add("이메일");
		columMap.add("신청일");
	
		map.put("title","예약신청현황");
		fileName = EgovStringUtil.getConvertFileName(request, "예약신청현황");
		
		//관리자
		searchVO.setMngAt("Y");
		//목록
		List<EgovMap> resultList = reservationApplyService.selectReservationApplyList(searchVO);
		
		if(resultList != null) {
			EgovMap tmpVO = null;
			Map<String, Object> tmpMap = null;
			for(int i=0; i < resultList.size(); i++) {
				tmpVO = resultList.get(i);
				
				tmpMap = new HashMap<String,Object>();
				tmpMap.put("번호", i+1);
				tmpMap.put("신청자명", tmpVO.get("chargerNm").toString() + "(" + tmpVO.get("frstRegisterId").toString() + ")");
				tmpMap.put("연락처", tmpVO.get("telno").toString());
				tmpMap.put("이메일", tmpVO.get("email").toString());
				tmpMap.put("신청일", tmpVO.get("frstRegistPnttmYmd").toString());
						
				valueMap.add(tmpMap);
				
				
			}
		}
		map.put("columMap",columMap);
		map.put("valueMap", valueMap);
		
		response.setHeader("Content-Disposition", "attachment; filename="+ fileName + ".xls");
		return new ModelAndView("excelDownloadView","dataMap",map);
	}
		
}
