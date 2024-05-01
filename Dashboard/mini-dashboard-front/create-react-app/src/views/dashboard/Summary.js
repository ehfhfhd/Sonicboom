import React, { useState } from 'react';
import { useDiagnostics } from '../../hooks/useDiagnostics';
import { Grid, TextField, MenuItem, Box, Typography } from '@mui/material';
import MainCard from 'ui-component/cards/MainCard';
import { gridSpacing } from 'store/constant';

const Summary = () => {
  const { diagnosticsData } = useDiagnostics();
  const [selectedServerIndex, setSelectedServerIndex] = useState('');

  const handleServerChange = (event) => {
    setSelectedServerIndex(event.target.value);
  };

  if (!diagnosticsData) {
    return <div>Loading...</div>;
  }

  const serverInfo = diagnosticsData[selectedServerIndex]?.Server_Info;

  return (
    <Box sx={{ px: 2, py: 2 }}>
      <TextField
        select
        label="Select a Server"
        value={selectedServerIndex}
        onChange={handleServerChange}
        fullWidth
        variant="outlined"
        sx={{ mb: 2 }}
      >
        {diagnosticsData.map((server, index) => (
          <MenuItem key={index} value={index}>
            {server.Server_Info.SW_NM} - {server.Server_Info.IP_ADDRESS}
          </MenuItem>
        ))}
      </TextField>
      {selectedServerIndex !== '' && (
        <>
          <MainCard           
          title={
            <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'start', color: '#6037B2'}}>
              <span><b>서버 정보</b></span>
            </div>
          }
          sx={{ mb: 2 }}>
            <Grid container spacing={gridSpacing}>
              <Grid item xs={12}>
                <Box sx={{ px: 2, pt: 0.25 }}>
                  <ul style={{ listStyle: 'none', padding: 0 }}>
                    {InfoListItem("OS 타입", serverInfo.SW_TYPE)}
                    {InfoListItem("서버명", serverInfo.SW_NM)}
                    {InfoListItem("서버 정보", serverInfo.SW_INFO)}
                    {InfoListItem("호스트명", serverInfo.HOST_NM)}
                    {InfoListItem("점검 날짜", serverInfo.DATE)}
                    {InfoListItem("점검 일시", serverInfo.TIME)}
                    {InfoListItem("서버 IP", serverInfo.IP_ADDRESS)}
                    {InfoListItem("ID", serverInfo.UNIQ_ID)}
                  </ul>
                </Box>
              </Grid>
            </Grid>
          </MainCard>
          <MainCard           
          title={
            <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'start', color: '#6037B2'}}>
              <span><b>결과 요약</b></span>
            </div>
          }
          sx={{ mb: 2 }}>
            <Grid container spacing={gridSpacing}>
              <Grid item xs={12}>
                <Box sx={{ px: 2, pt: 0.25 }}>
                  <ul style={{ padding: 0 }}>
                    {InfoListItem("총 점검 항목 수", diagnosticsData[selectedServerIndex].Check_Results.length)}
                    {InfoListItem("취약 상태 항목 수", diagnosticsData[selectedServerIndex].Check_Results.filter(result => result.status === "[취약]").length)}
                    {InfoListItem("양호 상태 항목 수", diagnosticsData[selectedServerIndex].Check_Results.filter(result => result.status === "[양호]").length)}
                    {InfoListItem("인터뷰 필요 항목", diagnosticsData[selectedServerIndex].Check_Results.filter(result => result.status === "[인터뷰]").length)}
                    {InfoListItem("N/A 항목 수", diagnosticsData[selectedServerIndex].Check_Results.filter(result => result.status === "[N/A]").length)}
                  </ul>
                </Box>
              </Grid>
            </Grid>
          </MainCard>
        </>
      )}
    </Box>
  );
};

const InfoListItem = (label, value) => (
  <li style={{ marginBottom: '8px', display: 'flex', alignItems: 'center' }}>
    <Typography variant="subtitle1" sx={{ minWidth: '160px', fontWeight: 'bold' }}>
      {label}
    </Typography>
    <Typography variant="body2">{value}</Typography>
  </li>
);

export default Summary;
