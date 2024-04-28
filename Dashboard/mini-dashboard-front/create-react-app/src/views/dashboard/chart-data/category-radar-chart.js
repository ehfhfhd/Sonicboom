import React from 'react';
import { ResponsiveRadar } from '@nivo/radar';

const CategoryRadarChart = ({ data }) => {
    return (
        <ResponsiveRadar
            data={data}
            keys={['score']}
            indexBy="category"
            valueFormat=" >-.2f"
            margin={{ top: 70, right: 80, bottom: 40, left: 80 }}
            borderColor={{ from: 'color' }}
            gridLevels={4}
            gridLabelOffset={35}
            enableDots={false}
            colors={{ scheme: 'nivo' }}
            fillOpacity={0.15}
            blendMode="multiply"
            motionConfig="wobbly"
            legends={[
                {
                    anchor: 'top-left',
                    direction: 'column',
                    translateX: -50,
                    translateY: -40,
                    itemWidth: 80,
                    itemHeight: 20,
                    itemTextColor: '#999',
                    symbolSize: 12,
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
    );
};

export default CategoryRadarChart;
