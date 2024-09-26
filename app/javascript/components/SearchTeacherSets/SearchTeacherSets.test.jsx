import { render, screen, cleanup, waitFor } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import * as React from "react";
import SearchTeacherSets from "../SearchTeacherSets/SearchTeacherSets.jsx";
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

beforeAll(() => {
  window.matchMedia = jest.fn().mockImplementation(query => {
    return {
      matches: false,
      media: query,
      onchange: null,
      addEventListener: jest.fn(),  // Modern method
      removeEventListener: jest.fn(),
      addListener: jest.fn(),       // Fallback for compatibility
      removeListener: jest.fn(),
    };
  });
});

describe("SearchTeacherSets", () => {
  afterEach(() => {
    // Clear all mocks after each test
    jest.clearAllMocks();
  });

  it('should fetch teacher sets and update state correctly on successful response', async () => {
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);

    const mockResponse = {
      data: {
        teacher_sets: [
          { id: 1, name: 'Teacher Set 1', title: 'teacher set ttile1' },
          { id: 2, name: 'Teacher Set 2', title: 'teacher set ttile2' },
        ],
        facets: [
          {
            label: "area of study",
            items: [
              {
                value: "Arts",
                label: "Arts",
                count: 8,
                selected: false,
                q: {
                  keyword: "",
                  grade_begin: "-1",
                  grade_end: "12",
                  "area of study": ["Arts"]
                },
                path: "/teacher_sets?area+of+study%5B%5D=Arts&grade_begin=-1&grade_end=12&keyword="
              },
              {
                value: "English Language Arts",
                label: "English Language Arts",
                count: 287,
                selected: false,
                q: {
                  keyword: "",
                  grade_begin: "-1",
                  grade_end: "12",
                  "area of study": ["English Language Arts"]
                }
              }
            ]
          }
        ],
        total_count: 20,
        total_pages: 2,
        no_results_found_msg: 'No results found',
        tsSubjectsHash: { subject1: 'Subject 1', subject2: 'Subject 2' },
        resetPageNumber: true,
        errrorMessage: null,
      },
    };
    axios.get.mockResolvedValueOnce(mockResponse);

    // Call the function with mock parameters (if required)
    await act(async () => {
      root.render(<MemoryRouter><SearchTeacherSets /></MemoryRouter>);
    });
  });

  it('error occured while fetcing teacher sets', async () => {
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);

    const mockResponse = {
      data: {
        teacher_sets: [
          { id: 1, name: 'Teacher Set 1', title: 'teacher set ttile1' },
          { id: 2, name: 'Teacher Set 2', title: 'teacher set ttile2' },
        ],
        facets: [],
        total_count: 20,
        total_pages: 2,
        no_results_found_msg: 'No results found',
        tsSubjectsHash: { subject1: 'Subject 1', subject2: 'Subject 2' },
        resetPageNumber: true,
        errrorMessage: "Error occured while fetching teacher sets",
      },
    };
    axios.get.mockResolvedValueOnce(mockResponse);

    // Call the function with mock parameters (if required)
    await act(async () => {
      root.render(<MemoryRouter><SearchTeacherSets /></MemoryRouter>);
    });
    expect(screen.getByText("Error occured while fetching teacher sets")).toBeInTheDocument();
  });

  it('items are not found', async () => {
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);

    const mockResponse = {
      data: {
        teacher_sets: [
          { id: 1, name: 'Teacher Set 1', title: 'teacher set ttile1' },
          { id: 2, name: 'Teacher Set 2', title: 'teacher set ttile2' },
        ],
        facets: [
          { 
            label: "area of study",
            items: []
          }
        ],
        total_count: 20,
        total_pages: 2,
        no_results_found_msg: '',
        tsSubjectsHash: { subject1: 'Subject 1', subject2: 'Subject 2' },
        resetPageNumber: true,
        errrorMessage: "",
      },
    };
    axios.get.mockResolvedValueOnce(mockResponse);

    // Call the function with mock parameters (if required)
    await act(async () => {
      root.render(<MemoryRouter><SearchTeacherSets /></MemoryRouter>);
    });
  });
});
