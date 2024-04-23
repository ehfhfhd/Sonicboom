import React, { useState } from 'react';

function Dashboard({ data }) {
  const [activeMainTab, setActiveMainTab] = useState('summary');  // 메인 탭 상태 관리
  const [activeDetailTab, setActiveDetailTab] = useState('tab1'); // 상세 탭 상태 관리
  const [selectedServerIndex, setSelectedServerIndex] = useState(0);
  const [expandedCategories, setExpandedCategories] = useState({});

  const serverInfo = data[selectedServerIndex].Server_Info;
  const checkResults = data[selectedServerIndex].Check_Results;

  const handleServerSelectionChange = (e) => {
    setSelectedServerIndex(e.target.value);
  };

  // 서버 선택 드롭다운
  const renderServerSelection = () => (
    <select onChange={handleServerSelectionChange} value={selectedServerIndex}>
      {data.map((server, index) => (
        <option key={index} value={index}>
          {server.Server_Info.SW_NM} - {server.Server_Info.IP_ADDRESS}
        </option>
      ))}
    </select>
  );

  const renderSummaryTab = () => {
    // 서버 수 계산
    const totalServers = data.length;
  
    // 각 위험도 및 상태에 대한 항목 수 계산
    const totalHighRisk = data.reduce((acc, server) => acc + server.Check_Results.filter(result => result.Importance === "(상)").length, 0);
    const totalMediumRisk = data.reduce((acc, server) => acc + server.Check_Results.filter(result => result.Importance === "(중)").length, 0);
    const totalLowRisk = data.reduce((acc, server) => acc + server.Check_Results.filter(result => result.Importance === "(하)").length, 0);
  
    const totalOk = data.reduce((acc, server) => acc + server.Check_Results.filter(result => result.status === "[양호]").length, 0);
    const totalVulnerable = data.reduce((acc, server) => acc + server.Check_Results.filter(result => result.status === "[취약]").length, 0);
    const totalInterview = data.reduce((acc, server) => acc + server.Check_Results.filter(result => result.status === "[인터뷰]").length, 0);
    const totalNA = data.reduce((acc, server) => acc + server.Check_Results.filter(result => result.status === "[N/A]").length, 0);
  
    return (
      <div>
        <h1>전체 서버 요약 결과</h1>
        <h3>총 점검 서버: {totalServers} 대</h3>
        <h4>서버 진단 결과</h4>
        <ul>
          <li>양호: {totalOk}개</li>
          <li>취약: {totalVulnerable}개</li>
          <li>인터뷰 필요: {totalInterview}개</li>
          <li>N/A: {totalNA}개</li>
        </ul>
        <h4>발견된 취약점 (구분: 위험도)</h4>
        <ul>
          <li>상: {totalHighRisk}개</li>
          <li>중: {totalMediumRisk}개</li>
          <li>하: {totalLowRisk}개</li>
        </ul>
      </div>
    );
  };
  

  // // 전체 서버 요약 결과 탭
  // const renderSummaryTab = () => (
  //   <div>
  //     <h2>전체 서버 요약 결과</h2>
  //     {/* <ul>
  //         <li>총 점검 항목 수: {checkResults.length}</li>
  //         <li>(상) 항목 수: {checkResults.filter(result => result.Importance === "(상)").length}</li>
  //         <li>(중) 항목 수: {checkResults.filter(result => result.Importance === "(중)").length}</li>
  //         <li>(하) 항목 수: {checkResults.filter(result => result.Importance === "(하)").length}</li>
  //     </ul>
  //     <p>모든 취약점이 발견되었을 경우 점수 합: {
  //       checkResults.filter(result => result.Importance === "(상)").length*10
  //       + checkResults.filter(result => result.Importance === "(중)").length*6
  //       + checkResults.filter(result => result.Importance === "(하)").length*2
  //       }
  //     </p> */}
  //     <h3>총 점검서버: {}대</h3>
  //     <h4>서버 진단 결과</h4>
  //     <ul>
  //       <li></li>
  //     </ul>
  //     <h4>발견된 취약점(구분: 위험도)</h4>
  //     <ul>
  //       <li></li>
  //     </ul>
  //     <p>서버 점수: </p>
  //   </div>
  // );

  // 서버별 진단 결과 탭
  const renderServerDetailsTab = () => (
    <div>
      <h1>{serverInfo.SW_NM} 서버 진단 결과</h1>
      {renderServerSelection()}
      <div>
        <button onClick={() => setActiveDetailTab('tab1')}>서버 정보 및 점검 요약 결과</button>
        <button onClick={() => setActiveDetailTab('tab2')}>서버 진단 결과</button>
        <button onClick={() => setActiveDetailTab('tab3')}>인터뷰 필요 항목</button>
        <button onClick={() => setActiveDetailTab('tab4')}>주요 취약 항목</button>
      </div>
      {activeDetailTab === 'tab1' && renderServerInfo()}
      {activeDetailTab === 'tab2' && renderCheckDetails()}
      {activeDetailTab === 'tab3' && renderInterviewDetails()}
      {activeDetailTab === 'tab4' && renderVulnerableDetails()}
    </div>
  );

  // 서버 정보 및 점검 요약 결과
  const renderServerInfo = () => (
    <>
      <h2>서버 정보:</h2>
      <ul>
        <li>OS 타입: {serverInfo.SW_TYPE}</li>
        <li>서버명: {serverInfo.SW_NM}</li>
        <li>서버 정보: {serverInfo.SW_INFO}</li>
        <li>호스트명: {serverInfo.HOST_NM}</li>
        <li>점검 날짜: {serverInfo.DATE}</li>
        <li>점검 일시: {serverInfo.TIME}</li>
        <li>서버 IP: {serverInfo.IP_ADDRESS}</li>
        <li>ID: {serverInfo.UNIQ_ID}</li>
      </ul>
      <h2>결과 요약:</h2>
      <ul>
          <li>총 점검 항목 수: {checkResults.length}</li>
          <li>취약 상태 항목 수: {checkResults.filter(result => result.status === "[취약]").length}</li>
          <li>양호 상태 항목 수: {checkResults.filter(result => result.status === "[양호]").length}</li>
          <li>인터뷰 필요 항목 수: {checkResults.filter(result => result.status === "[인터뷰]").length}</li>
          <li>N/A 항목 수: {checkResults.filter(result => result.status === "[N/A]").length}</li>
      </ul>
    </>
  );

  const renderCheckDetails = () => {
    let lastCategory = '';
    return (
      <>
        {checkResults.map((result, index) => {
          const categoryChanged = result.Category !== lastCategory;
          lastCategory = result.Category;

          return (
            <div key={index}>
              {categoryChanged && <h3 onClick={() => toggleCategory(result.Category)}>{result.Category}</h3>}
              {expandedCategories[result.Category] && (
                <>
                  <h4>{result.Sub_Category} {result.Importance}</h4>
                  <p>{result.Description} <b>{result.status}</b></p>
                  {/* <p>{result.status}</p> */}
                  <ul>
                    {result.details?.map((detail, detailIndex) => (
                      <li key={detailIndex}>{detail}</li>
                    ))}
                  </ul>
                  <ul>
                    {result.solutions?.map((solution, solutionIndex) => (
                      <li key={solutionIndex}>{solution}</li>
                    ))}
                  </ul>
                </>
              )}
            </div>
          );
        })}
      </>
    );
  };

  const renderInterviewDetails = () => {
    let lastCategory = '';
    return (
      <>
        {checkResults.filter(result => result.status === "[인터뷰]").map((result, index) => {
          const categoryChanged = result.Category !== lastCategory;
          lastCategory = result.Category;

          return (
            <div key={index}>
              {categoryChanged && <h3 onClick={() => toggleCategory(result.Category)}>{result.Category}</h3>}
              {expandedCategories[result.Category] && (
                <>
                  <h4>{result.Sub_Category} {result.Importance}</h4>
                  <p>{result.Description}</p>
                  {/* <p>{result.status}</p> */}
                  <ul>
                    {result.details?.map((detail, detailIndex) => (
                      <li key={detailIndex}>{detail}</li>
                    ))}
                  </ul>
                  <ul>
                    {result.solutions?.map((solution, solutionIndex) => (
                      <li key={solutionIndex}>{solution}</li>
                    ))}
                  </ul>
                </>
              )}
            </div>
          );
        })}
      </>
    );
  };

  const renderVulnerableDetails = () => {
    let lastCategory = '';
    return (
      <>
        {checkResults.filter(result => result.status === "[취약]" && result.Importance === "(상)").map((result, index) => {
          const categoryChanged = result.Category !== lastCategory;
          lastCategory = result.Category;

          return (
            <div key={index}>
              {categoryChanged && <h3 onClick={() => toggleCategory(result.Category)}>{result.Category}</h3>}
              {expandedCategories[result.Category] && (
                <>
                  <h4>{result.Sub_Category} {result.Importance}</h4>
                  <p>{result.Description}</p>
                  <p>{result.status}</p>
                  <ul>
                    {result.details?.map((detail, detailIndex) => (
                      <li key={detailIndex}>{detail}</li>
                    ))}
                  </ul>
                  <ul>
                    {result.solutions?.map((solution, solutionIndex) => (
                      <li key={solutionIndex}>{solution}</li>
                    ))}
                  </ul>
                </>
              )}
            </div>
          );
        })}
      </>
    );
  };

  const toggleCategory = (category) => {
    setExpandedCategories(prevState => ({
      ...prevState,
      [category]: !prevState[category],
    }));
  };

  return (
    <div>
      <button onClick={() => setActiveMainTab('summary')}>전체 서버 요약</button>
      <button onClick={() => setActiveMainTab('details')}>서버별 진단 결과</button>
      {activeMainTab === 'summary' ? renderSummaryTab() : renderServerDetailsTab()}
    </div>
  );
}

export default Dashboard;

