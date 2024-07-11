import { render, screen, cleanup, queryByAttribute } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import * as React from "react";
import Contact from "../Contact/Contact.jsx";
import { createRoot } from 'react-dom/client';
import { act } from 'react-dom/test-utils';

describe("Contact", () => {
  test("Contact", async () => {
    // render the component on virtual dom
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);
    // Use act to ensure all updates are processed before assertions
    await act(async () => {
      root.render(<Contact />);
    });
  });
});
