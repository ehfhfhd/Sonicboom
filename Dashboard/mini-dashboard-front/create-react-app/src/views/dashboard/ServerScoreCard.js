import React from 'react';
import { Card, CardContent, Typography } from '@mui/material';

const ServerScoreCard = ({ data }) => {
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

    return (((maximum - minus) / maximum) * 100).toFixed(1);
  };

  const serverScore = calculateServerScore();

  // 카드 스타일을 지정합니다.
  const cardStyle = {
    height: '300px',
  };

  return (
    <Card style={cardStyle}>
      <CardContent>
        <Typography variant="h6">
          서버 점수
        </Typography>
        <Typography variant="h1" style={{ color: '#6037B2' }}>
          {serverScore}점
        </Typography>
      </CardContent>
    </Card>
  );
};

export default ServerScoreCard;
