import * as React from "react";
import ColorMode from "../ColorMode/ColorMode.jsx";
import { createRoot } from 'react-dom/client';

describe("ColorMode", () => {
  test("ColorMode", () => {
    // render the component on virtual dom
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);
    // Use act to ensure all updates are processed before assertions
    root.render(<ColorMode />);
  });
});
