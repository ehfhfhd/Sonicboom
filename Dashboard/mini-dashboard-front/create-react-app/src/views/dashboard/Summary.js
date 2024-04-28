// App.js

import React, { useState } from 'react';

function App() {
  const [text, setText] = useState('Summary');

  const changeText = () => {
    setText('텍스트가 변경되었습니다!');
  };

  return (
    <div>
      <h1>{text}</h1>
      <button onClick={changeText}>텍스트 변경</button>
    </div>
  );
}

export default App;
