
import * as React from "react";
import SignIn from "../SignIn/SignIn.jsx";
import { createRoot } from 'react-dom/client';

describe("SignIn", () => {
  test("SignIn", () => {
    // render the component on virtual dom
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);
    // Use act to ensure all updates are processed before assertions
    root.render(<SignIn />);
  });
});
