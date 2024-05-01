// import React from 'react';
// import { useDiagnostics } from '../../hooks/useDiagnostics';
// import { Grid } from '@mui/material';
// import VulnPieChartCard from './VulnPieChartCard';
// import DiagnosisBarChartCard from './DiagnosisBarChartCard';
// import ServerScoreCard from './ServerScoreCard';
// import CategoryRadarChartCard from './CategoryRadarChartCard';

// const Dashboard = () => {
//   const { diagnosticsData } = useDiagnostics();
//   const categoryData = diagnosticsData
//   ?.map(data => data.Check_Results)
//   ?.flat();

//   if (!diagnosticsData) {
//     return <div>Loading...</div>;
//   }

//   const { pieChartData, barChartData } = calculateChartData(diagnosticsData);
//   const radarChartData = [
//     { category: "계정관리", score: calculateRatio(categoryData, "1. 계정관리") },
//     { category: "파일 및 디렉토리 관리", score: calculateRatio(categoryData, "2. 파일 및 디렉토리 관리") },
//     { category: "서비스 관리", score: calculateRatio(categoryData, "3. 서비스 관리") },
//     { category: "패치 관리", score: calculateRatio(categoryData, "4. 패치 관리") },
//     { category: "로그 관리", score: calculateRatio(categoryData, "5. 로그 관리") }
//   ];

// function calculateRatio(checkResultsArray, category) {
//   if (!checkResultsArray) return 0;

//   const vulnerableResults = checkResultsArray.filter(item => 
//     item.Category === category && item.status === "[취약]"
//   );
//   const totalResults = checkResultsArray.filter(item => 
//     item.Category === category
//   );

//   if (totalResults.length === 0) return 0;
//   const ratio = ((totalResults.length - vulnerableResults.length) / totalResults.length) * 100;
//   return Number(ratio.toFixed(1));
// }

//   return (
//     <Grid container spacing={3}>
//       <Grid item xs={12} md={5}>
//         <ServerScoreCard data={diagnosticsData} />
//       </Grid>
//       <Grid item xs={12} md={7}>
//         <DiagnosisBarChartCard data={barChartData} />
//       </Grid>
//       <Grid item xs={12} md={6}>
//         <VulnPieChartCard data={pieChartData} />
//       </Grid>
//       <Grid item xs={12} md={6}>
//         <CategoryRadarChartCard data={radarChartData} />
//       </Grid>
//     </Grid>
//   );
// };

// export default Dashboard;

// function calculateChartData(data) {
//   const totalHighRisk = data.reduce((acc, server) => acc + server.Check_Results.filter(result => result.Importance === "(상)" && result.status === "[취약]").length, 0);
//   const totalMediumRisk = data.reduce((acc, server) => acc + server.Check_Results.filter(result => result.Importance === "(중)" && result.status === "[취약]").length, 0);
//   const totalLowRisk = data.reduce((acc, server) => acc + server.Check_Results.filter(result => result.Importance === "(하)" && result.status === "[취약]").length, 0);
  
//   const totalOk = data.reduce((acc, server) => acc + server.Check_Results.filter(result => result.status === "[양호]").length, 0);
//   const totalVulnerable = data.reduce((acc, server) => acc + server.Check_Results.filter(result => result.status === "[취약]").length, 0);
//   const totalInterview = data.reduce((acc, server) => acc + server.Check_Results.filter(result => result.status === "[인터뷰]").length, 0);
//   const totalNA = data.reduce((acc, server) => acc + server.Check_Results.filter(result => result.status === "[N/A]").length, 0);

//   return {
//     pieChartData: [
//       { id: "High Risk", label: "상", value: totalHighRisk },
//       { id: "Medium Risk", label: "중", value: totalMediumRisk },
//       { id: "Low Risk", label: "하", value: totalLowRisk }
//     ],
//     barChartData: [
//       { status: "양호", 양호: totalOk },
//       { status: "취약", 취약: totalVulnerable },
//       { status: "인터뷰", 인터뷰: totalInterview },
//       { status: "N/A", 'N/A': totalNA }
//     ]
//   };
// }


import React from 'react';
import { useDiagnostics } from '../../hooks/useDiagnostics';
import { Grid } from '@mui/material';
import VulnPieChartCard from './VulnPieChartCard';
import DiagnosisBarChartCard from './DiagnosisBarChartCard';
import ServerScoreCard from './ServerScoreCard';
import CategoryRadarChartCard from './CategoryRadarChartCard';

const Dashboard = () => {
  const { diagnosticsData } = useDiagnostics();
  const categoryData = diagnosticsData
  ?.map(data => data.Check_Results)
  ?.flat();

  if (!diagnosticsData) {
    return <div>Loading...</div>;
  }

  const { pieChartData, barChartData } = calculateChartData(diagnosticsData);
  const radarChartData = [
    { category: "계정관리", score: calculateRatio(categoryData, "1. 계정관리") },
    { category: "파일 및 디렉토리 관리", score: calculateRatio(categoryData, "2. 파일 및 디렉토리 관리") },
    { category: "서비스 관리", score: calculateRatio(categoryData, "3. 서비스 관리") },
    { category: "패치 관리", score: calculateRatio(categoryData, "4. 패치 관리") },
    { category: "로그 관리", score: calculateRatio(categoryData, "5. 로그 관리") }
  ];

function calculateRatio(checkResultsArray, category) {
  if (!checkResultsArray) return 0;

  const vulnerableResults = checkResultsArray.filter(item => 
    item.Category === category && item.status === "[취약]"
  );
  const totalResults = checkResultsArray.filter(item => 
    item.Category === category
  );

  if (totalResults.length === 0) return 0;
  const ratio = ((totalResults.length - vulnerableResults.length) / totalResults.length) * 100;
  return Number(ratio.toFixed(1));
}

  return (
    <Grid container spacing={3}>
      <Grid item xs={12} md={5}>
        <ServerScoreCard data={diagnosticsData} />
      </Grid>
      <Grid item xs={12} md={7}>
        <DiagnosisBarChartCard data={barChartData} />
      </Grid>
      <Grid item xs={12} md={6}>
        <VulnPieChartCard data={pieChartData} />
      </Grid>
      <Grid item xs={12} md={6}>
        <CategoryRadarChartCard data={radarChartData} />
      </Grid>
    </Grid>
  );
};

export default Dashboard;

function calculateChartData(data) {
  const totalHighRisk = data.reduce((acc, server) => acc + server.Check_Results.filter(result => result.Importance === "(상)" && result.status === "[취약]").length, 0);
  const totalMediumRisk = data.reduce((acc, server) => acc + server.Check_Results.filter(result => result.Importance === "(중)" && result.status === "[취약]").length, 0);
  const totalLowRisk = data.reduce((acc, server) => acc + server.Check_Results.filter(result => result.Importance === "(하)" && result.status === "[취약]").length, 0);
  
  const totalOk = data.reduce((acc, server) => acc + server.Check_Results.filter(result => result.status === "[양호]").length, 0);
  const totalVulnerable = data.reduce((acc, server) => acc + server.Check_Results.filter(result => result.status === "[취약]").length, 0);
  const totalInterview = data.reduce((acc, server) => acc + server.Check_Results.filter(result => result.status === "[인터뷰]").length, 0);
  const totalNA = data.reduce((acc, server) => acc + server.Check_Results.filter(result => result.status === "[N/A]").length, 0);

  return {
    pieChartData: [
      { id: "High Risk", label: "상", value: totalHighRisk },
      { id: "Medium Risk", label: "중", value: totalMediumRisk },
      { id: "Low Risk", label: "하", value: totalLowRisk }
    ],
    barChartData: [
      { status: "양호", 양호: totalOk },
      { status: "취약", 취약: totalVulnerable },
      { status: "인터뷰", 인터뷰: totalInterview },
      { status: "N/A", 'N/A': totalNA }
    ]
  };
}


