import { render, screen, cleanup, waitFor } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import * as React from "react";
import TeacherSetBooks from "./TeacherSetBooks.jsx";
import { createRoot } from 'react-dom/client';
import { act } from 'react-dom/test-utils';
import axios from 'axios'; 
import { useHref, MemoryRouter } from 'react-router-dom';
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

  it('should log error if axios request fails', async () => {
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);
    const errorMessage = 'Request failed';
    axios.get.mockRejectedValueOnce(new Error(errorMessage));

    // Mock console.log to capture logs
    const consoleSpy = jest.spyOn(console, 'log').mockImplementation(() => {});

    await act(async () => {
      root.render(<TeacherSetBooks />);
    });

    // Wait for the async operations to complete
    await waitFor(() => {
      expect(consoleSpy).toHaveBeenCalledWith(new Error(errorMessage));
    });
    consoleSpy.mockRestore(); // Restore console.log
  });

  it('should fetch book details and set document title', async () => {
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);
    const teacherSet1 = {availability: 'Available', book_id: 1, id: 1, title: 'Teacher Set 1'}
    const mockBookData = {
      book: {
        title: 'Sample Book Title',
      },
      teacher_sets: [teacherSet1],
    };

    axios.get.mockResolvedValueOnce({ data: mockBookData });

    await act(async () => {
      root.render(<MemoryRouter><TeacherSetBooks /></MemoryRouter>);
    });
    

    // Wait for the async operations to complete
    await waitFor(() => {
      expect(document.title).toBe('Book Details | Sample Book Title | MyLibraryNYC');
    });
  });

});
