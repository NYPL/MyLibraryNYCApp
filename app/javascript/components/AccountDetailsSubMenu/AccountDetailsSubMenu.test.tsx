import { render, screen, cleanup, waitFor } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import * as React from "react";
import AccountDetailsSubMenu from "../AccountDetailsSubMenu/AccountDetailsSubMenu.jsx";
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

describe("AccountDetailsSubMenu", () => {
  it ('should render Account menu', async () => {
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);

    // Call the function with mock parameters (if required)
    await act(async () => {
      root.render(<AccountDetailsSubMenu userSignedIn={true} />);
    });

    // Find the anchor element by its text content
    const accountLink = screen.getByText('My Account');
    
    // Assert the href attribute
    expect(accountLink).toHaveAttribute('href', '/account_details');
    expect(accountLink).toBeInTheDocument();
  });

  it ('should render SignIn menu', async () => {
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);

    // Call the function with mock parameters (if required)
    await act(async () => {
      root.render(<AccountDetailsSubMenu userSignedIn={false} />);
    });

    // Find the anchor element by its text content
    const accountLink = screen.getByText('Sign In');
    
    // Assert the href attribute
    expect(accountLink).toHaveAttribute('href', '/signin');
    expect(accountLink).toBeInTheDocument();
  });
});  