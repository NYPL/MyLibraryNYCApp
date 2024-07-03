import '@testing-library/jest-dom/extend-expect';
import * as React from "react";
import SignUp from "../SignUp/SignUp.jsx";
import { createRoot } from 'react-dom/client';

describe("SignUp", () => {
  test("SignUp", () => {
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);

    // Use act to ensure all updates are processed before assertions
    root.render(<SignUp />);
  });
});
