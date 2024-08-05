import { render, screen, cleanup, waitFor, fireEvent } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import * as React from "react";
import BookTitles from "../BookTitles/BookTitles.jsx";
import { createRoot } from 'react-dom/client';
import { act } from 'react-dom/test-utils';
import axios from 'axios'; 
import { MemoryRouter } from 'react-router-dom';
jest.mock('axios');

// Mock useLocation
jest.mock('react-router-dom', () => ({
  ...jest.requireActual('react-router-dom'), // Use actual react-router-dom for other functions
  useNavigate: jest.fn(), // Mock useNavigate if needed
}));
  
describe('BookTitles component', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('renders book titles correctly when books are provided', async() => {
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);
    const mockBooks = [
      { id: 1, title: 'Book 1' },
      { id: 2, title: 'Book 2' },
    ];
    await act(async () => {
      root.render(<MemoryRouter><BookTitles books={mockBooks} teacherSet={{ id: 123 }}/></MemoryRouter>);
    });

    // Check if the "Book titles" header is rendered
    const bookTitlesHeader = screen.getByText('Book titles');
    expect(bookTitlesHeader).toBeInTheDocument();
  });

  it('does not render anything when books array is empty', async() => {
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);
    await act(async () => {
      root.render(<MemoryRouter><BookTitles books={[]} teacherSet={{ id: 123 }} /></MemoryRouter>);
    });
  });
});
  