package egovframework.let.test.web;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.EgovFileMngService;
import egovframework.com.cmm.service.FileVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.let.test.service.TestService;
import egovframework.let.test.service.TestVO;
import egovframework.let.utl.fcc.service.EgovStringUtil;
import egovframework.let.utl.fcc.service.FileMngUtil;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
public class TestController {
	
	@Resource(name = "testService")
	private TestService testService;
	
	@Resource(name = "EgovFileMngService")
	private EgovFileMngService fileMngService;
		
	@Resource(name = "fileMngUtil")
	private FileMngUtil fileUtil;
	
	//CRUD 목록 가져오기
	@RequestMapping(value = "/test/selectList.do")
	public String selectList(TestVO testVO, HttpServletRequest request, ModelMap model) throws Exception{
		PaginationInfo paginationInfo = new PaginationInfo();
		
		paginationInfo.setCurrentPageNo(testVO.getPageIndex());
		paginationInfo.setRecordCountPerPage(testVO.getPageUnit());
		paginationInfo.setPageSize(testVO.getPageSize());
		
		testVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		testVO.setLastIndex(paginationInfo.getLastRecordIndex());
		testVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());
		
		List<EgovMap> resultList = testService.selectTestList(testVO);
		model.addAttribute("resultList", resultList);
		
		int totCnt = testService.selectTestListCnt(testVO);
		
		paginationInfo.setTotalRecordCount(totCnt);
		model.addAttribute("paginationInfo", paginationInfo);
		
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		model.addAttribute("USER_INFO", user);
		
		return "test/TestSelectList";
	}
	
	//CRUD 가져오기
	@RequestMapping(value = "/test/select.do")
	public String select(TestVO testVO, HttpServletRequest request, ModelMap model) throws Exception{
		TestVO result = testService.selectTest(testVO);
		model.addAttribute("result", result);
		return "test/TestSelect"; //jsp 명칭 가져옴
		
	}
	
	//CRUD 등록/수정
	@RequestMapping(value = "/test/testRegist.do")
	public String TestRegist(TestVO testVO, HttpServletRequest request, ModelMap model) throws Exception{
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if(user == null || user.getId() == null) {
			model.addAttribute("message", "로그인 후 사용가능합니다.");
			return "forward:/test/selectList.do";
		}else {
			model.addAttribute("USER_INFO", user);
		}
		
		TestVO result = new TestVO();
		
		if(!EgovStringUtil.isEmpty(testVO.getTestId())) {
			result = testService.selectTest(testVO);
			//본인 및 관리자만 허용
			if(!user.getId().equals(result.getFrstRegisterId()) && !"admin".equals(user.getId())) {
				model.addAttribute("message", "작성자 본인만 확인 가능합니다.");
				return "forward:/test/selectList.do";
			}
		}
		
		
		model.addAttribute("result", result);
		
		request.getSession().removeAttribute("sessionBoard");
		
		return "test/TestRegist";
	}
	
	//CRUD 등록하기
	@RequestMapping(value = "/test/insert.do")
	public String insert(final MultipartHttpServletRequest multiRequest, TestVO testVO, HttpServletRequest request, ModelMap model) throws Exception{
		
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if(user == null || user.getId() == null) {
			model.addAttribute("message", "로그인 후 사용가능합니다.");
			return "forward:/test/selectList.do";
		}
		
		//이중 서브밋 방지 체크
		if(request.getSession().getAttribute("sessionBoard") != null) {
			return "forward:/test/selectList.do";
		}
		
		//~ 파일첨부 ~
		List<FileVO> result = null;
		String atchFileId = "";
		
		final Map<String, MultipartFile> files = multiRequest.getFileMap();
		if(!files.isEmpty()) {
			result = fileUtil.parseFileInf(files, "TEST_", 0, "", "test.fileStorePath");
			atchFileId = fileMngService.insertFileInfs(result);
		}
		testVO.setAtchFileId(atchFileId);
		//~ 파일첨부 ~
		
		testVO.setUserId(user.getId());
		
		testService.insertTest(testVO);
		
		//이중 서브밋 방지
		request.getSession().setAttribute("sessionBoard", testVO);
		
		return "forward:/test/selectList.do";
	}
		
	//CRUD 수정하기
	@RequestMapping(value = "/test/update.do")
	public String update(final MultipartHttpServletRequest multiRequest, TestVO testVO, HttpServletRequest request) throws Exception{
		
		String atchFileId = testVO.getAtchFileId();
		final Map<String, MultipartFile> files = multiRequest.getFileMap();
		if(!files.isEmpty()) {
			if(EgovStringUtil.isEmpty(atchFileId)) {
				List<FileVO> result = fileUtil.parseFileInf(files, "TEST_", 0, "", "test.fileStorePath");
				atchFileId = fileMngService.insertFileInfs(result);
				testVO.setAtchFileId(atchFileId);
			} else {
				FileVO fvo = new FileVO();
				fvo.setAtchFileId(atchFileId);
				int cnt = fileMngService.getMaxFileSN(fvo);
				List<FileVO> _result = fileUtil.parseFileInf(files, "TEST_", cnt, atchFileId, "test.fileStorePath");
				fileMngService.updateFileInfs(_result);	
			}
		}
		
		testService.updateTest(testVO);
		return "forward:/test/selectList.do";		
	}
		
	//CRUD 삭제하기
	@RequestMapping(value = "/test/delete.do")
	public String delete(TestVO testVO, HttpServletRequest request, ModelMap model) throws Exception{
		
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if(user == null || user.getId() == null) {
			model.addAttribute("message", "로그인 후 사용가능합니다.");
			return "forward:/test/selectList.do";
		}
		
		
		//~삭제 방지 알람~
		TestVO result = new TestVO();
		
		if(!EgovStringUtil.isEmpty(testVO.getTestId())) {
			result = testService.selectTest(testVO);
			//본인 및 관리자만 허용
			if(!user.getId().equals(result.getFrstRegisterId()) && !"admin".equals(user.getId())) {
				model.addAttribute("message", "작성자 본인만 확인 가능합니다.");
				return "forward:/test/selectList.do";
			}
		}
		//~삭제 방지 알람~
		
		testVO.setUserId(user.getId());
		
		testService.deleteTest(testVO);
		
		return "forward:/test/selectList.do";
	}
	
	
}
