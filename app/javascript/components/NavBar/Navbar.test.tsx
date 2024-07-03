import '@testing-library/jest-dom/extend-expect';
import * as React from "react";
import NavBar from "../NavBar/Navbar.jsx";
import { createRoot } from 'react-dom/client';

describe("NavBar", () => {
  test("NavBar", () => {
    // render the component on virtual dom
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);
    // Use act to ensure all updates are processed before assertions
    root.render(<NavBar />);
  });
});
