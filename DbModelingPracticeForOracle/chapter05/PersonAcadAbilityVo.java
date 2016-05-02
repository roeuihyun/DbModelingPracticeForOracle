/**
 * --[PAGE128][PersonAcadAbilityVo 생성]
 */
package chapter05;

/**
 * @author Administrator
 *
 */
public class PersonAcadAbilityVo extends PersonDefaultVo{ //학력

	private String sabun; //사번
	private String seq; //일련번호
	private String majorStudyGbn; //전공구분
	private String gratYn; //졸업여부
	private String gratYear; //졸업년도
	private String gratMonth; //졸업월
	private String schoolName; //학교명
	
	
	/**
	 * @return the sabun
	 */
	public String getSabun() {
		return sabun;
	}



	/**
	 * @param sabun the sabun to set
	 */
	public void setSabun(String sabun) {
		this.sabun = sabun;
	}



	/**
	 * @return the seq
	 */
	public String getSeq() {
		return seq;
	}



	/**
	 * @param seq the seq to set
	 */
	public void setSeq(String seq) {
		this.seq = seq;
	}



	/**
	 * @return the majorStudyGbn
	 */
	public String getMajorStudyGbn() {
		return majorStudyGbn;
	}



	/**
	 * @param majorStudyGbn the majorStudyGbn to set
	 */
	public void setMajorStudyGbn(String majorStudyGbn) {
		this.majorStudyGbn = majorStudyGbn;
	}



	/**
	 * @return the gratYn
	 */
	public String getGratYn() {
		return gratYn;
	}



	/**
	 * @param gratYn the gratYn to set
	 */
	public void setGratYn(String gratYn) {
		this.gratYn = gratYn;
	}



	/**
	 * @return the gratYear
	 */
	public String getGratYear() {
		return gratYear;
	}



	/**
	 * @param gratYear the gratYear to set
	 */
	public void setGratYear(String gratYear) {
		this.gratYear = gratYear;
	}



	/**
	 * @return the gratMonth
	 */
	public String getGratMonth() {
		return gratMonth;
	}



	/**
	 * @param gratMonth the gratMonth to set
	 */
	public void setGratMonth(String gratMonth) {
		this.gratMonth = gratMonth;
	}



	/**
	 * @return the schoolName
	 */
	public String getSchoolName() {
		return schoolName;
	}



	/**
	 * @param schoolName the schoolName to set
	 */
	public void setSchoolName(String schoolName) {
		this.schoolName = schoolName;
	}



	/**
	 * 
	 */
	public PersonAcadAbilityVo() {
		// TODO Auto-generated constructor stub
	}

}
