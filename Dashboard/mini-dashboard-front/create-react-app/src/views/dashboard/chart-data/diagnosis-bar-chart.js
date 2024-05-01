import { ResponsiveBar } from '@nivo/bar';

const DiagnosisBarChart = ({ data }) => (
    <div style={{ height: 400 }}>
        <ResponsiveBar
            data={data}
            keys={['양호', '취약', '인터뷰', 'N/A']}
            indexBy="status"
            margin={{ top: 10, right: 130, bottom: 70, left: 60 }}
            padding={0.3}
            valueScale={{ type: 'linear' }}
            indexScale={{ type: 'band', round: true }}
            colors={['#C3B6F2', '#8477D9', '#9389D9', '#CEDEF2']} // 사용자 지정 색상 배열로 설정
            borderWidth={1}
            borderColor={{
                from: 'color',
                modifiers: [['darker', 0.3]]
            }}
            axisTop={null}
            axisRight={null}
            axisBottom={{
                tickSize: 5,
                tickPadding: 5,
                tickRotation: 0,
                legend: 'status',
                legendPosition: 'middle',
                legendOffset: 32
            }}
            axisLeft={{
                tickSize: 5,
                tickPadding: 5,
                tickRotation: 0,
                legend: 'count',
                legendPosition: 'middle',
                legendOffset: -40
            }}
            labelSkipWidth={12}
            labelSkipHeight={12}
            labelTextColor={{ from: 'color', modifiers: [['darker', 1.6]] }}
            animate={true}
            motionStiffness={90}
            motionDamping={15}
            enableLabel={false}
        />
    </div>
);

export default DiagnosisBarChart;
