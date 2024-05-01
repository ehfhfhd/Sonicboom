import React from 'react';
import { Card, CardContent, Typography, Grid } from '@mui/material';
import DiagnosisBarChart from './chart-data/diagnosis-bar-chart';

const DiagnosisBarChartCard = ({ data }) => {
  // 데이터에서 각 상태별 개수를 추출합니다.
  const totalOk = data.find(d => d.status === "양호").양호;
  const totalVulnerable = data.find(d => d.status === "취약").취약;
  const totalInterview = data.find(d => d.status === "인터뷰").인터뷰;
  const totalNA = data.find(d => d.status === "N/A")['N/A'];

  const cardStyle = {
    height: '450px',
  };

  return (
    <Card style={cardStyle}>
      <CardContent>
        <Grid container>
          <Grid item xs={9}>
            <Typography variant="h5" color="textPrimary" gutterBottom>
              진단 결과
            </Typography>
            <DiagnosisBarChart data={data} />
          </Grid>
          <Grid item xs={3} style={{ display: 'flex', flexDirection: 'column', justifyContent: 'center' }}>
            <Typography variant="body2" style={{ marginBottom: '10px' }}>양호: {totalOk}개</Typography>
            <Typography variant="body2" style={{ marginBottom: '10px' }}>취약: {totalVulnerable}개</Typography>
            <Typography variant="body2" style={{ marginBottom: '10px' }}>인터뷰 필요: {totalInterview}개</Typography>
            <Typography variant="body2">N/A: {totalNA}개</Typography>
          </Grid>
        </Grid>
      </CardContent>
    </Card>
  );
};

export default DiagnosisBarChartCard;
