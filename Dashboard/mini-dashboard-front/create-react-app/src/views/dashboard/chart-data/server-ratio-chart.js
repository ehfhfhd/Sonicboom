import { ResponsivePie } from '@nivo/pie';
const ServerRatioChart = ({ data }) => (
    <div style={{ height: '350px', width: '100%' }}>
        <ResponsivePie
            data={data}
            margin={{ top: 20, right: 150, bottom: 100, left: 20 }}
            startAngle={-90}
            endAngle={270}
            innerRadius={0.65}
            activeOuterRadiusOffset={8}
            colors={['#6037B2']} // 색상 배열로 직접 제공
            borderWidth={1}
            borderColor={{
                from: 'color',
                modifiers: [['darker', 0.3]]
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
                    anchor: 'right',
                    direction: 'column',
                    justify: false,
                    translateX: 120, // 차트로부터 범례의 수평 거리를 조정합니다.
                    translateY: 0,
                    itemsSpacing: 2,
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

export default ServerRatioChart;
