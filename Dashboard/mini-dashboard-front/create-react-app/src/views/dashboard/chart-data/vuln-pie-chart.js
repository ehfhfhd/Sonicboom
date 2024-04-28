import React from 'react';
import { ResponsivePie } from '@nivo/pie';

const VulnPieChart = ({ data }) => (
    <div style={{ height: 400 }}>
        <ResponsivePie
            data={data}
            margin={{ top: 40, right: 80, bottom: 80, left: 80 }}
            innerRadius={0.5}
            activeOuterRadiusOffset={8}
            colors={['#8477D9', '#C3B6F2', '#CEDEF2']} // 색상 배열로 직접 제공
            borderWidth={2}
            borderColor={{
                from: 'color',
                modifiers: [['darker', 0.2]]
            }}
            enableArcLinkLabels={false}
            arcLinkLabelsSkipAngle={10}
            arcLinkLabelsTextOffset={8}
            arcLinkLabelsTextColor="#6f6d6d"
            arcLinkLabelsThickness={0}
            arcLinkLabelsColor={{ from: 'color' }}
            enableArcLabels={false}
            arcLabelsRadiusOffset={1.75}
            arcLabelsSkipAngle={10}
            arcLabelsTextColor={{
                from: 'color',
                modifiers: [['darker', '0']]
            }}
            legends={[
                {
                    anchor: 'bottom',
                    direction: 'row',
                    justify: false,
                    translateX: 25,
                    translateY: 62,
                    itemsSpacing: 0,
                    itemWidth: 100,
                    itemHeight: 18,
                    itemTextColor: '#999',
                    itemDirection: 'left-to-right',
                    itemOpacity: 1,
                    symbolSize: 18,
                    symbolShape: 'circle',
                    effects: [
                        {
                            on: 'hover',
                            style: {
                                itemTextColor: '#000'
                            }
                        }
                    ]
                }
            ]}
        />
    </div>
);

export default VulnPieChart;
