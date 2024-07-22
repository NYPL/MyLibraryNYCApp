import * as React from "react";
import ColorMode from "../ColorMode/ColorMode.jsx";
import { createRoot } from 'react-dom/client';
import { act } from 'react-dom/test-utils';

describe("ColorMode", () => {
  test("ColorMode", async () => {
    // render the component on virtual dom
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);
    // Use act to ensure all updates are processed before assertions
    await act(async () => {
      root.render(<ColorMode />);
    });
  });
});
