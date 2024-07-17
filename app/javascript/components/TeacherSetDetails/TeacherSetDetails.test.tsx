import { render, screen, cleanup, waitFor } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import * as React from "react";
import TeacherSetDetails from "../TeacherSetDetails/TeacherSetDetails.jsx";
import { createRoot } from 'react-dom/client';
import { act } from 'react-dom/test-utils';
import axios from 'axios'; 
import { useHref, MemoryRouter } from 'react-router-dom';

jest.mock('axios');

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

  it('should fetch teacher set details', async () => {
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);

    const mockTeacherSetData = {
      teacher_set: {
        title: 'Sample Teacher Set Title',
        description: 'Sample Teacher Set Description',
      },
      allowed_quantities: [1, 2, 3],
      books: ['book1', 'book2'],
      teacher_set_notes: [{content: 'Sample notes'}],
      user: {
        status: 'active',
      },
    };

    axios.get.mockResolvedValue({ data: mockTeacherSetData });

    await act(async () => {
      root.render(<MemoryRouter><TeacherSetDetails /></MemoryRouter>);
    });

    expect(screen.getByText("What is in the box")).toBeInTheDocument();
    expect(screen.getByText("Sample Teacher Set Description")).toBeInTheDocument();
  });

  it('teacher sets are unavailable', async () => {
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);

    const mockTeacherSetData = {
      teacher_set: {
        available_copies: 0,
      },
      allowed_quantities: [1, 2, 3],
      books: ['book1', 'book2'],
      teacher_set_notes: [{content: 'Sample notes'}],
      user: {
        status: 'active',
      },
    };

    axios.get.mockResolvedValue({ data: mockTeacherSetData });

    await act(async () => {
      root.render(<MemoryRouter><TeacherSetDetails /></MemoryRouter>);
    });
    expect(screen.getByText("This Teacher Set is unavailable.")).toBeInTheDocument();
  });

  it('unable to order teacher sets', async () => {
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);

    const mockTeacherSetData = {
      teacher_set: {
        available_copies: 2,
      },
      allowed_quantities: [],
      books: ['book1', 'book2'],
      teacher_set_notes: [{content: 'Sample notes'}],
      user: {
        status: 'active',
      },
    };

    axios.get.mockResolvedValue({ data: mockTeacherSetData });

    await act(async () => {
      root.render(<MemoryRouter><TeacherSetDetails /></MemoryRouter>);
    });
    expect(screen.getByText("Unable to order additional Teacher Sets.")).toBeInTheDocument();
  });
});