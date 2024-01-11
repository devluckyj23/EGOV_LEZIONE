package egovframework.let.test.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.let.test.service.TestService;
import egovframework.let.test.service.TestVO;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("testService")
public class TestServiceImpl extends EgovAbstractServiceImpl implements TestService{
	
	@Resource(name = "testMapper")
	private TestMapper testMapper;
	
	@Resource(name = "egovTestIdGnrService")
	private EgovIdGnrService idgenService;

	@Override
	public List<EgovMap> selectTestList(TestVO vo) throws Exception {
		return testMapper.selectTestList(vo);
	}

	@Override
	public int selectTestListCnt(TestVO vo) throws Exception {
		return testMapper.selectTestListCnt(vo);
	}

	@Override
	public TestVO selectTest(TestVO vo) throws Exception {
		return testMapper.selectTest(vo);
	}

	@Override
	public String insertTest(TestVO vo) throws Exception {
		String id = idgenService.getNextStringId();
		vo.setTestId(id);
		testMapper.insertTest(vo);
		
		return id;
	}

	@Override
	public void updateTest(TestVO vo) throws Exception {
		testMapper.updateTest(vo);
	}

	@Override
	public void deleteTest(TestVO vo) throws Exception {
		testMapper.deleteTest(vo);
	}

}
