import { ResponsiveRadar } from '@nivo/radar';

const CategoryRadarChart = ({ data }) => {
    return (
        <div style={{ height: 400 }}>
        <ResponsiveRadar
            data={data}
            keys={['score']}
            indexBy="category"
            maxValue={100}
            margin={{ top: 40, right: 120, bottom: 60, left: 80 }}
            colors={[ '#9389D9' ]}
            borderWidth={2}
            borderColor={{ from: 'color' }}
            gridLevels={4}
            gridShape="linear"
            gridLabelOffset={24}
            enableDots={false}
            dotSize={10}
            dotColor={{ from: 'color' }}
            dotBorderWidth={0}
            dotBorderColor={{ from: 'color', modifiers: [] }}
            enableDotLabel={true}
            dotLabel="value"
            dotLabelYOffset={-12}
            fillOpacity={0.3}
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
    );
};

export default CategoryRadarChart;
