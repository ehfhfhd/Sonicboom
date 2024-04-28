import React from 'react';
import { useDiagnostics } from '../../hooks/useDiagnostics';
import { Grid } from '@mui/material';
import VulnPieChartCard from './VulnPieChartCard';
import DiagnosisBarChartCard from './DiagnosisBarChartCard';
import ServerScoreCard from './ServerScoreCard';
import CategoryRadarChartCard from './CategoryRadarChartCard';

const Dashboard = () => {
  const { diagnosticsData } = useDiagnostics();

  if (!diagnosticsData) {
    return <div>Loading...</div>;
  }

  const { pieChartData, barChartData } = calculateChartData(diagnosticsData);

  return (
    <Grid container spacing={3}>
      <Grid item xs={12} md={4}>
        <ServerScoreCard data={diagnosticsData} />
      </Grid>
      <Grid item xs={12} md={8}>
        <CategoryRadarChartCard data={diagnosticsData} />
      </Grid>
      <Grid item xs={12} md={5}>
        <VulnPieChartCard data={pieChartData} />
      </Grid>
      <Grid item xs={12} md={7}>
        <DiagnosisBarChartCard data={barChartData} />
      </Grid>
    </Grid>
  );
};

export default Dashboard;

function calculateChartData(data) {
  const totalHighRisk = data.reduce((acc, server) => acc + server.Check_Results.filter(result => result.Importance === "(상)").length, 0);
  const totalMediumRisk = data.reduce((acc, server) => acc + server.Check_Results.filter(result => result.Importance === "(중)").length, 0);
  const totalLowRisk = data.reduce((acc, server) => acc + server.Check_Results.filter(result => result.Importance === "(하)").length, 0);
  
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
