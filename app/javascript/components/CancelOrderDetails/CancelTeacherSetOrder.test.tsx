import { render, screen, cleanup, waitFor, fireEvent } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import * as React from "react";
import CancelTeacherSetOrder from "../CancelTeacherSetOrder/CancelTeacherSetOrder.jsx";
import { createRoot } from 'react-dom/client';
import { act } from 'react-dom/test-utils';
import axios from 'axios'; 
import { MemoryRouter } from 'react-router-dom';
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
  useHref: jest.fn(), // Mock useHref if needed
  useParams: jest.fn(),
}));

// Mock motionMediaQuery object with a mock addListener method
const mockMotionMediaQuery = {
  addListener: jest.fn(),
};

describe("Teacher Set Details", () => {
  beforeAll(() => {
    // Mock window.matchMedia to return mockMotionMediaQuery
    window.matchMedia = jest.fn().mockImplementation(query => ({
      matches: false,
      media: query,
      addListener: mockMotionMediaQuery.addListener,
      removeListener: jest.fn(),
    }));
  });
});
