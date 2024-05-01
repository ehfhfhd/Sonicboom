import React, { useState, useEffect } from 'react';
import ServerSelection from './ServerSelection';
import Summary from './Summary';
import { useDiagnostics } from '../../hooks/useDiagnostics';

const SubDashboard = () => {
  const { diagnosticsData } = useDiagnostics();
  const [selectedServerIndex, setSelectedServerIndex] = useState();

  // 데이터가 로드된 후 인덱스 설정
  useEffect(() => {
    if (diagnosticsData && diagnosticsData.length > 0 && selectedServerIndex === undefined) {
      setSelectedServerIndex(0); // 첫 번째 서버를 기본값으로 설정
    }
  }, [diagnosticsData, selectedServerIndex]);

  // 데이터 로딩 확인
  if (!diagnosticsData || diagnosticsData.length === 0) {
    return <div>Loading...</div>; // 로딩 상태 표시
  }

  return (
    <div>
      <ServerSelection
        diagnosticsData={diagnosticsData}
        selectedServerIndex={selectedServerIndex}
        setSelectedServerIndex={setSelectedServerIndex}
      />
      <Summary
        diagnosticsData={diagnosticsData}
        selectedServerIndex={selectedServerIndex}
      />
    </div>
  );
};

export default SubDashboard;
