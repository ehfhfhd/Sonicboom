import React from 'react';
import { useSelector } from 'react-redux';
import { ThemeProvider } from '@mui/material/styles';
import { CssBaseline, StyledEngineProvider } from '@mui/material';
import themes from 'themes';
import NavigationScroll from 'layout/NavigationScroll';
import Routes from 'routes';
import { DiagnosticsProvider } from './hooks/useDiagnostics';

const App = () => {
  const customization = useSelector((state) => state.customization);

  return (
    <StyledEngineProvider injectFirst>
      <ThemeProvider theme={themes(customization)}>
        <CssBaseline />
        <DiagnosticsProvider>
          <NavigationScroll>
            <Routes />
          </NavigationScroll>
        </DiagnosticsProvider>
      </ThemeProvider>
    </StyledEngineProvider>
  );
};

export default App;
