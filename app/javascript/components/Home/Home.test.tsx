import { screen } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import * as React from "react";
import Home from "../Home/Home.jsx";
jest.mock('axios');
import { createRoot } from 'react-dom/client';

describe("Home ", () => {
  test("Home ", () => {
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);
    root.render(<Home />)
  });
});
