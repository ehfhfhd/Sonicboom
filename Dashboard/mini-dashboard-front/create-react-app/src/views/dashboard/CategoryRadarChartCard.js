import React from 'react';
import { Card, CardContent, Typography } from '@mui/material';
import CategoryRadarChart from './chart-data/category-radar-chart';

const CategoryRadarChartCard = ({ data }) => {
    const cardStyle = {
        height: '450px',
      };
    
    return (
        <Card style={cardStyle}>
            <CardContent>
                <Typography variant="h5" component="div" gutterBottom>
                    영역별 점수
                </Typography>
                <CategoryRadarChart data={data} />
            </CardContent>
        </Card>
    );
};

export default CategoryRadarChartCard;
