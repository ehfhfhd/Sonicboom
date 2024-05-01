import React from 'react';
import { Card, CardContent, Typography, Grid } from '@mui/material';
import ServerRatioChart from './chart-data/server-ratio-chart';

const ServerScoreCard = ({ data }) => {
  if (!data) {
    return <div>Loading...</div>;
  }

  const totalServers = data.length;

  // 서버 이름별 개수를 계산합니다.
  const serverCountByName = data.reduce((acc, server) => {
    const name = server.Server_Info?.SW_NM;
    if (!acc[name]) {
      acc[name] = 0;
    }
    acc[name] += 1;
    return acc;
  }, {});

  // serverRatioData의 데이터 구조를 구성합니다.
  const serverRatioData = Object.entries(serverCountByName).map(([name, count]) => ({
    id: name,
    value: count
  }));


  // 서버 점수 계산 함수
  const calculateServerScore = () => {
    const maximum = data.reduce((acc, server) => {
      return acc + (server.Check_Results.filter(result => result.Importance === "(상)").length * 3)
                 + (server.Check_Results.filter(result => result.Importance === "(중)").length * 2)
                 + (server.Check_Results.filter(result => result.Importance === "(하)").length);
    }, 0);

    const minus = data.reduce((acc, server) => {
      return acc + (server.Check_Results.filter(result => result.status === "[취약]" && result.Importance === "(상)").length * 3)
                 + (server.Check_Results.filter(result => result.status === "[취약]" && result.Importance === "(중)").length * 2)
                 + (server.Check_Results.filter(result => result.status === "[취약]" && result.Importance === "(하)").length);
    }, 0);

    return maximum > 0 ? (((maximum - minus) / maximum) * 100).toFixed(1) : "0.0";
  };

  const serverScore = calculateServerScore();
  const cardStyle = {
    height: '450px',
  };
  
  return (
    <Card style={cardStyle}>
      <CardContent>
        <Grid container spacing={3}>
          <Grid item xs={6}>
            <Typography variant="h5" style={{ marginBottom: '5px' }}>서버 점수</Typography>
            <Typography variant="h1" style={{ color: '#6037B2' }}>
              {serverScore}점
            </Typography>
          </Grid>
          <Grid item xs={6}>
            <Typography variant="h5" style={{ marginBottom: '5px' }}>점검 서버 수</Typography>
            <Typography variant="h1" style={{ color: '#6037B2' }}>
              {totalServers}대
            </Typography>
          </Grid>
          <Grid>
            <Typography variant="h3">
            ㅤ
            </Typography>
          </Grid>
          <Grid item xs={12}>
            <Typography variant="h5">서버 구성</Typography>
            <ServerRatioChart data={serverRatioData} />
          </Grid>
        </Grid>
      </CardContent>
    </Card>
  );
};

export default ServerScoreCard;