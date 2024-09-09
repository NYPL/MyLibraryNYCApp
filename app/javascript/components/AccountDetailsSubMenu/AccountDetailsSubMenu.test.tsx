import { render, screen, cleanup, waitFor, fireEvent } from "@testing-library/react";
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
    expect(screen.getByText('Sign In')).toBeInTheDocument();
  });

  it ("should render about menu", async () => {
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);
    
    jest.mock('', () => ({
      useNYPLBreakpoints: jest.fn(() => ({
        isLargerThanMedium: true,
        isLargerThanMobile: false,
      })),
      handleHover: jest.fn(),
      useColorModeValue: jest.fn().mockReturnValue({
        color: 'light-color-value',
      }),
    }));

    await act(async () => {
      root.render(<MemoryRouter><AccountDetailsSubMenu userSignedIn={true} /></MemoryRouter>);
    });

    // Find the anchor element by its text content
    const accountLink = screen.getByText('My Account');

    // Assert that the link is rendered
    const linkElement = screen.getByText('My Account');
    expect(linkElement).toBeInTheDocument();

    // Simulate mouse enter event on the link
    fireEvent.mouseEnter(linkElement);

    expect(screen.getByText('Settings')).toBeInTheDocument();
    expect(screen.getByText('My orders')).toBeInTheDocument();
    expect(screen.getByText('Sign out')).toBeInTheDocument();
  });
});

describe('SignOutLink', () => {
  it('calls signOut function on click', async () => {
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);

    // Mock props
    const props = {
      colorMode: 'light',
      handleLogout: jest.fn(),
      setShowAboutMenu: jest.fn(),
      handleSignOutMsg: jest.fn(),
      hideSignUpMessage: jest.fn(),
    };

    // Mock Axios delete request
    axios.delete.mockResolvedValueOnce({ data: { status: 200, logged_out: true, sign_out_msg: 'Signed out successfully' } });


    await act(async () => {
      root.render(<MemoryRouter><AccountDetailsSubMenu {...props} /></MemoryRouter>);
    });

    // Simulate click on sign out link
    fireEvent.click(screen.getByText('Sign out'));

    // Wait for Axios request to resolve
    await act(async () => {
      await axios.delete;
    });

    // Assertions
    expect(axios.delete).toHaveBeenCalledWith('/users/logout', {});
  });
});
