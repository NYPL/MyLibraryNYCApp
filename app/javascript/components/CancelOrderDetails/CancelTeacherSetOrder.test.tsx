import { render, screen, cleanup, waitFor, fireEvent } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import * as React from "react";
import CancelTeacherSetOrder from "../CancelOrderDetails/CancelTeacherSetOrder.jsx";
import { createRoot } from 'react-dom/client';
import { act } from 'react-dom/test-utils';
import axios from 'axios'; 
import { MemoryRouter } from 'react-router-dom';
import dateFormat from 'dateformat';

jest.mock('axios');
jest.mock('dateformat', () => jest.fn(() => 'Sunday, August 4th, 2024, 5:00:00 PM'));

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

// Mock functions for testing
const mockHandleCancelComment = jest.fn();
const mockHandleSubmit = jest.fn();
const mockHandleOrderButton = jest.fn();

describe("Teacher Set order Details", () => {
  beforeAll(() => {
    // Mock window.matchMedia to return mockMotionMediaQuery
    window.matchMedia = jest.fn().mockImplementation(query => ({
      matches: false,
      media: query,
      addListener: mockMotionMediaQuery.addListener,
      removeListener: jest.fn(),
    }));
  });

  it('test cancel order details', async() => {
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);
    // Define the props you want to pass
    const orderDetails = {
      id: '12345',
      name: 'Sample Order'
    };
    require('react-router-dom').useParams.mockReturnValue(orderDetails);

    await act(async () => {
      root.render(<MemoryRouter><CancelTeacherSetOrder /></MemoryRouter>);
    });
  });

  it('test cancel order details', async() => {
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);
    // Define the props you want to pass
    const orderDetails = {
      id: '12345',
      name: 'Sample Order'
    };
    require('react-router-dom').useParams.mockReturnValue(orderDetails);

    await act(async () => {
      root.render(<MemoryRouter><CancelTeacherSetOrder /></MemoryRouter>);
    });
  });

  it('should render confirmation elements when status is not cancelled', async() => {
    const props = {
      hold: { status: 'pending' },
      comment: '',
      handleCancelComment: mockHandleCancelComment,
      handleSubmit: mockHandleSubmit,
      handleOrderButton: mockHandleOrderButton,
      access_key: '12345',
    };

    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);

    await act(async () => {
      root.render(<MemoryRouter><CancelTeacherSetOrder {...props} /></MemoryRouter>);
    });

    // Check for presence of elements
    expect(screen.getByLabelText('Reason for cancelling order (optional)')).toBeInTheDocument();
  });
});
