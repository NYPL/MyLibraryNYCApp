
import { render, screen, cleanup, waitFor, fireEvent } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import * as React from "react";
import Accounts from "../Accounts/Accounts.jsx";
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
}));

describe('Accounts', () => {
  it('fetches account details on mount', async () => {
    const mockAccountDetails = {
      email: 'test@example.com',
      alt_email: 'alt@example.com',
      schools: ['School A', 'School B'],
      current_user: 'User A',
      holds: ['Hold 1', 'Hold 2'],
      school: { id: 'school_id' },
      current_password: 'password123',
      total_pages: 10,
      ordersNotPresentMsg: 'No orders found',
    };

    axios.get.mockResolvedValueOnce({ data: { accountdetails: mockAccountDetails }, request: { responseURL: env.MLN_INFO_SITE_HOSTNAME + '/account', status: 200 } });

    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);

    // Call the function with mock parameters (if required)
    await act(async () => {
      root.render(<Accounts />);
    });

    // Wait for Axios request to resolve
    await waitFor(() => {
      expect(axios.get).toHaveBeenCalledWith('/account', { params: { page: 1 } }); // Verify axios.get call
      // Assertions for state updates based on mocked data
      expect(screen.getByText('Preferred email address for reservation notifications')).toBeInTheDocument();
      expect(document.title).toBe("Account Details | MyLibraryNYC"); // Verify document title
    });
  });

  it('no orders found', async () => {
    const mockAccountDetails = {
      email: 'test@example.com',
      alt_email: 'alt@example.com',
      schools: ['School A', 'School B'],
      current_user: 'User A',
      holds: [],
      school: { id: 'school_id' },
      current_password: 'password123',
      total_pages: 10,
      ordersNotPresentMsg: 'No orders found',
    };

    axios.get.mockResolvedValueOnce({ data: { accountdetails: mockAccountDetails }, request: { responseURL: env.MLN_INFO_SITE_HOSTNAME + '/account', status: 200 } });

    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);

    // Call the function with mock parameters (if required)
    await act(async () => {
      root.render(<Accounts />);
    });

    // Wait for Axios request to resolve
      expect(axios.get).toHaveBeenCalledWith('/account', { params: { page: 1 } }); // Verify axios.get call
      // Assertions for state updates based on mocked data
      expect(document.title).toBe("Account Details | MyLibraryNYC"); // Verify document title
      expect(screen.getByText('You have not yet placed any orders.')).toBeInTheDocument();
  });
});