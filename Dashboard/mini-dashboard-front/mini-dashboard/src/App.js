import React, { useState, useEffect } from 'react';
import axios from 'axios';
import Dashboard from './components/Dashboard';
// import 'bootstrap/dist/css/bootstrap.min.css';

function App() {
  const [diagnosticsData, setDiagnosticsData] = useState(null);

  useEffect(() => {
    axios.get('http://localhost:5001/api/diagnostics')
      .then(response => {
        setDiagnosticsData(response.data);
      })
      .catch(error => {
        console.error('There was an error fetching the diagnostics data:', error);
      });
  }, []);

  if (!diagnosticsData) {
    return <div>Loading...</div>;
  }

  // 데이터가 로드되면 Dashboard 컴포넌트에 데이터를 전달합니다.
  return <Dashboard data={diagnosticsData} />;
}

export default App;


