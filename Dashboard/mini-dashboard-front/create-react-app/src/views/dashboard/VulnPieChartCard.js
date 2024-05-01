import React from 'react';
import { Card, CardContent, Typography, Grid } from '@mui/material';
import VulnPieChart from './chart-data/vuln-pie-chart';

const VulnPieChartCard = ({ data }) => {
  // 데이터에서 위험도별 개수를 추출합니다.
  const totalHighRisk = data.find(d => d.id === "High Risk").value;
  const totalMediumRisk = data.find(d => d.id === "Medium Risk").value;
  const totalLowRisk = data.find(d => d.id === "Low Risk").value;

  const cardStyle = {
    height: '450px',
  };

  return (
    <Card style={cardStyle}>
      <CardContent>
        <Grid container>
          <Grid item xs={9}>
            <Typography variant="h5" color="textPrimary" gutterBottom>
              발견된 취약점 (구분: 위험도)
            </Typography>
            <VulnPieChart data={data} />
          </Grid>
          <Grid item xs={3} style={{ display: 'flex', flexDirection: 'column', justifyContent: 'center' }}>
            <Typography variant="body2" style={{ marginBottom: '10px' }}>상: {totalHighRisk}개</Typography>
            <Typography variant="body2" style={{ marginBottom: '10px' }}>중: {totalMediumRisk}개</Typography>
            <Typography variant="body2">하: {totalLowRisk}개</Typography>
          </Grid>
        </Grid>
      </CardContent>
    </Card>
  );
};

export default VulnPieChartCard;
