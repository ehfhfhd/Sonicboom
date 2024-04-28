import React from 'react';
import { Card, CardContent, Typography } from '@mui/material';
import { ResponsiveRadar } from '@nivo/radar';

const CategoryRadarChartCard = ({ checkResults }) => {

    // 각 카테고리별 취약점 비율 계산
    const data = [
        { category: "계정관리", score: calculateRatio(checkResults, "1. 계정관리").toFixed(1) },
        { category: "파일 및 디렉토리 관리", score: calculateRatio(checkResults, "2. 파일 및 디렉토리 관리").toFixed(1) },
        { category: "서비스 관리", score: calculateRatio(checkResults, "3. 서비스 관리").toFixed(1) },
        { category: "패치 관리", score: calculateRatio(checkResults, "4. 패치 관리").toFixed(1) },
        { category: "로그 관리", score: calculateRatio(checkResults, "5. 로그 관리").toFixed(1) }
    ];

    function calculateRatio(results, category) {
        const vulnerable = results && results.filter(result => result.Category === category && result.status === "[취약]").length;
        const total = results && results.filter(result => result.Category === category).length || 1; // 0으로 나누는 것을 방지
        return (vulnerable / total) * 100;
    }

    return (
        <Card>
            <CardContent>
                <Typography variant="h5" gutterBottom>
                    Vulnerability Analysis
                </Typography>
                <div style={{ height: 400 }}>
                    <ResponsiveRadar
                        data={data}
                        keys={['score']}
                        indexBy="category"
                        margin={{ top: 70, right: 80, bottom: 40, left: 80 }}
                        colors={{ scheme: 'nivo' }}
                        borderWidth={2}
                        borderColor={{ from: 'color' }}
                        gridLevels={5}
                        gridShape="circular"
                        gridLabelOffset={16}
                        enableDots={true}
                        dotSize={10}
                        dotColor={{ from: 'color' }}
                        dotBorderWidth={2}
                        dotBorderColor={{ from: 'color', modifiers: [] }}
                        enableDotLabel={true}
                        dotLabel="value"
                        dotLabelYOffset={-12}
                        fillOpacity={0.25}
                        blendMode="multiply"
                        animate={true}
                        motionConfig="wobbly"
                        isInteractive={true}
                        legends={[
                            {
                                anchor: 'top-left',
                                direction: 'column',
                                justify: false,
                                translateX: -50,
                                translateY: -40,
                                itemsSpacing: 0,
                                itemDirection: 'left-to-right',
                                itemWidth: 80,
                                itemHeight: 20,
                                itemOpacity: 0.75,
                                symbolSize: 12,
                                symbolShape: 'circle',
                                symbolBorderColor: 'rgba(0, 0, 0, .5)',
                                effects: [
                                    {
                                        on: 'hover',
                                        style: {
                                            itemBackground: 'rgba(0, 0, 0, .03)',
                                            itemOpacity: 1
                                        }
                                    }
                                ]
                            }
                        ]}
                    />
                </div>
            </CardContent>
        </Card>
    );
};

export default CategoryRadarChartCard;
