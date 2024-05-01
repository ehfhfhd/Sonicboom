// import React from 'react';
// import { TextField, MenuItem, Box } from '@mui/material';
// import { useDiagnostics } from '../../../../hooks/useDiagnostics';  // Adjust the import path as necessary

// const ServerSelection = () => {
//   const { diagnosticsData } = useDiagnostics();
//   const [selectedServerIndex, setSelectedServerIndex] = React.useState(0);

//   const handleServerSelectionChange = (event) => {
//     setSelectedServerIndex(event.target.value);
//   };

//   return (
//     <Box sx={{ px: 2, pt: 0.25 }}>
//       <TextField
//         id="outlined-select-server"
//         select
//         sx={{ width: 300}}
//         value={selectedServerIndex}
//         onChange={handleServerSelectionChange}
//         SelectProps={{
//           native: false
//         }}
//         variant="outlined"
//       >
//         {diagnosticsData?.map((server, index) => (
//           <MenuItem key={index} value={index}>
//             {server.Server_Info.SW_NM} - {server.Server_Info.IP_ADDRESS}
//           </MenuItem>
//         ))}
//       </TextField>
//     </Box>
//   );
// };

// export default ServerSelection;

// import React from 'react';
// import { TextField, MenuItem, Box, Typography } from '@mui/material';
// import { useDiagnostics } from '../../../../hooks/useDiagnostics';

// const ServerSelection = () => {
//   const { diagnosticsData } = useDiagnostics();
//   const [selectedServerIndex, setSelectedServerIndex] = React.useState('');

//   React.useEffect(() => {
//     if (diagnosticsData && diagnosticsData?.length > 0) {
//       setSelectedServerIndex(0);
//     } else {
//       setSelectedServerIndex('');
//     }
//   }, [diagnosticsData]);
//   const handleServerSelectionChange = (event) => {
//     setSelectedServerIndex(event.target.value);
//   };

//   if (!diagnosticsData || diagnosticsData?.length === 0) {
//     return (
//       <Box sx={{ px: 2, pt: 0.25 }}>
//         <Typography variant="body1">서버 정보가 없습니다.</Typography>
//       </Box>
//     );
//   }

//   return (
//     <Box sx={{ px: 2, pt: 0.25 }}>
//       <TextField
//         id="outlined-select-server"
//         name="server-selection"
//         select
//         sx={{ width: 300 }}
//         value={selectedServerIndex}
//         onChange={handleServerSelectionChange}
//         SelectProps={{
//           native: false
//         }}
//         variant="outlined"
//       >
//         {diagnosticsData?.map((server, index) => (
//           <MenuItem key={index} value={index}>
//             {server.Server_Info.SW_NM} - {server.Server_Info.IP_ADDRESS}
//           </MenuItem>
//         ))}
//       </TextField>
//     </Box>
//   );
// };

// export default ServerSelection;

import React from 'react';
import { TextField, MenuItem, Box, Typography } from '@mui/material';
import { useDiagnostics } from '../../../../hooks/useDiagnostics';

const ServerSelection = () => {
  const { diagnosticsData } = useDiagnostics();
  const firstIndex = diagnosticsData && diagnosticsData.length > 0 ? 0 : '';
  const [selectedServerIndex, setSelectedServerIndex] = React.useState(firstIndex);

  const handleServerSelectionChange = (event) => {
    setSelectedServerIndex(event.target.value);
  };

  if (!diagnosticsData || diagnosticsData.length === 0) {
    return (
      <Box sx={{ px: 2, pt: 0.25 }}>
        <Typography variant="body1">서버 정보가 없습니다.</Typography>
      </Box>
    );
  }

  return (
    <Box sx={{ px: 2, pt: 0.25 }}>
      <TextField
        id="outlined-select-server"
        name="server-selection"
        select
        sx={{ width: 300 }}
        value={selectedServerIndex}
        onChange={handleServerSelectionChange}
        SelectProps={{
          native: false
        }}
        variant="outlined"
      >
        {diagnosticsData?.map((server, index) => (
          <MenuItem key={index} value={index}>
            {server.Server_Info.SW_NM} - {server.Server_Info.IP_ADDRESS}
          </MenuItem>
        ))}
      </TextField>

    </Box>
  );
};

export default ServerSelection;
