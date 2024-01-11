package egovframework.let.test.service;

import java.util.List;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface TestService {

	public List<EgovMap> selectTestList(TestVO vo) throws Exception;

	public int selectTestListCnt(TestVO vo) throws Exception;

	public TestVO selectTest(TestVO vo) throws Exception;

	public String insertTest(TestVO vo) throws Exception;

	public void updateTest(TestVO vo) throws Exception;

	public void deleteTest(TestVO vo) throws Exception;

}
