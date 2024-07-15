import { render, screen, cleanup } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import * as React from "react";
import TeacherSetBooks from "../TeacherSetBooks/TeacherSetBooks.jsx";
import { createRoot } from 'react-dom/client';
import { act } from 'react-dom/test-utils';
jest.mock('axios');

// Mock useLocation
jest.mock('react-router-dom', () => ({
  ...jest.requireActual('react-router-dom'), // Use actual react-router-dom for other functions
  useLocation: jest.fn().mockReturnValue({
    pathname: '/mock-path',
    search: '',
    hash: '',
    state: null,
    key: 'testKey',
  }),
  useNavigate: jest.fn(), // Mock useNavigate if needed
}));

describe("TeacherSetBooks", () => {
  test("TeacherSetBooks", async () => {
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);
    // Use act to ensure all updates are processed before assertions
    await act(async () => {
      root.render(<TeacherSetBooks />);
    });
    
  });
});
