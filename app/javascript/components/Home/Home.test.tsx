import { screen } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import * as React from "react";
import Home from "../Home/Home.jsx";
import { act } from 'react-dom/test-utils';
jest.mock('axios');
import { createRoot } from 'react-dom/client';
import { useNavigate } from 'react-router-dom';

const mockUseNavigate = jest.fn();
jest.mock('react-router-dom', () => ({
  ...jest.requireActual('react-router-dom'), // Use actual react-router-dom for other functions
  useNavigate: () => mockUseNavigate, // Mock useNavigate
}));

describe("Home", () => {
  test("Home", async () => {
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);
    // Use act to ensure all updates are processed before assertions
    await act(async () => {
      root.render(<Home />);
    });
  });
});

