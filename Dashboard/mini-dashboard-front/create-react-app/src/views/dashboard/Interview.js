import React, { useState } from 'react';
import { useDiagnostics } from '../../hooks/useDiagnostics';
import { Grid, TextField, MenuItem, Box, Typography, Accordion, AccordionSummary, AccordionDetails, Divider } from '@mui/material';
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';
import MainCard from 'ui-component/cards/MainCard';
import { gridSpacing } from 'store/constant';

const Interview = () => {
  const { diagnosticsData } = useDiagnostics();
  const [selectedServerIndex, setSelectedServerIndex] = useState('');
  const [expanded, setExpanded] = useState({});

  const handleServerChange = (event) => {
    setSelectedServerIndex(event.target.value);
  };

  const handleChange = (panel) => (event, isExpanded) => {
    setExpanded(prev => ({
      ...prev,
      [panel]: isExpanded ? !prev[panel] : false
    }));
  };

  const renderCheckDetails = (checkResults) => {
    let categories = {};

    // 필터링된 결과만 처리하기 위해 filter를 추가합니다.
    checkResults.filter(result => result.status === "[인터뷰]")
      .forEach((result) => {
        if (!categories[result.Category]) {
          categories[result.Category] = [];
        }
        categories[result.Category].push(result);
      });

    return Object.keys(categories).map((category, index) => (
      <Accordion key={index} expanded={expanded[category] || false} onChange={handleChange(category)}>
        <AccordionSummary expandIcon={<ExpandMoreIcon />}>
          <Typography>{category}</Typography>
        </AccordionSummary>
        <AccordionDetails>
          {categories[category].map((result, resultIndex) => (
            <Box key={resultIndex} mb={3}>
              <Typography variant="subtitle1">{result.Sub_Category} {result.Importance}</Typography>
              <Typography variant="body2">{result.Description}&nbsp;&nbsp;<strong>{result.status}</strong></Typography>
              <Typography variant="body2">설정 확인: {result.Command}</Typography>
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
              {resultIndex < categories[category].length - 1 && <Divider sx={{ my: 2 }} />} {/* 마지막 항목이 아니면 Divider 추가 */}
            </Box>
          ))}
        </AccordionDetails>
      </Accordion>
    ));
  };

  if (!diagnosticsData) {
    return <div>Loading...</div>;
  }

  return (
    <Box sx={{ px: 2, pt: 0.25 }}>
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
        <MainCard           
        title={
          <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'start', color: '#6037B2'}}>
            <span><b>인터뷰 필요 항목</b></span>
            <Typography variant="body1" style={{ marginTop: '10px' }} color="textSecondary">
              아래의 목록은 담당자 확인이 필요합니다.
            </Typography>
          </div>
        }
        sx={{ mb: 2 }}>
          <Grid container spacing={gridSpacing}>
            <Grid item xs={12}>
              <Box sx={{ px: 2, pt: 0.25 }}>
                {renderCheckDetails(diagnosticsData[selectedServerIndex].Check_Results)}
              </Box>
            </Grid>
          </Grid>
        </MainCard>
      )}
    </Box>
  );
};

export default Interview;
