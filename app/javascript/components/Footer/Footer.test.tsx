import * as React from "react";
import Footer from "../Footer/Footer.jsx";
import { createRoot } from 'react-dom/client';
import { act } from 'react-dom/test-utils';

describe("Footer", () => {
  test("Footer", async () => {
    // render the component on virtual dom
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);
    // Use act to ensure all updates are processed before assertions
    await act(async () => {
      root.render(<Footer />);
    });
  });
});
