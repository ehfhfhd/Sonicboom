import React, { createContext, useState, useContext, useEffect } from 'react';
import axios from 'axios';

// Create a context for diagnostics data
const DiagnosticsContext = createContext();

// Export a hook to allow easy usage of the context
export const useDiagnostics = () => useContext(DiagnosticsContext);

// Provider component to wrap the app in App.js
export const DiagnosticsProvider = ({ children }) => {
  const [diagnosticsData, setDiagnosticsData] = useState(0);
  console.log('Diagnostics Data from Hook:', diagnosticsData);
  useEffect(() => {
    // Fetch the diagnostics data from the API
    axios.get('http://localhost:5001/api/diagnostics')
      .then(response => {
        setDiagnosticsData(response.data);
      })
      .catch(error => {
        console.error('There was an error fetching the diagnostics data:', error);
      });
  }, []);

  return (
    <DiagnosticsContext.Provider value={{ diagnosticsData, setDiagnosticsData }}>
      {children}
    </DiagnosticsContext.Provider>
  );
};
