
import * as React from "react";
import SignIn from "../SignIn/SignIn.jsx";
import { createRoot } from 'react-dom/client';
import { act } from 'react-dom/test-utils';
import { useNavigate, MemoryRouter, useHref } from 'react-router-dom';

describe("SignIn", () => {
  afterEach(() => {
    // Clear all mocks after each test
    jest.clearAllMocks();
  });

  const mockUseNavigate = jest.fn();
  jest.mock('react-router-dom', () => ({
    ...jest.requireActual('react-router-dom'), // Use actual react-router-dom for other functions
    useNavigate: () => mockUseNavigate, // Mock useNavigate
  }));

  test("SignIn", async () => {
    // render the component on virtual dom
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);

    // Use act to ensure all updates are processed before assertions
    await act(async () => {
      root.render(<MemoryRouter><SignIn /></MemoryRouter>);
    });
  });
});
