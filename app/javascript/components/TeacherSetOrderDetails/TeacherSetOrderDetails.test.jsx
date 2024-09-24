import { render, screen, cleanup, waitFor } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import * as React from "react";
import TeacherSetOrderDetails from "../TeacherSetOrderDetails/TeacherSetOrderDetails.jsx";
import { createRoot } from 'react-dom/client';
import { act } from 'react-dom/test-utils';
import { MemoryRouter } from 'react-router-dom';
import dateFormat from 'dateformat';

jest.mock('axios');
jest.mock('dateformat', () => jest.fn());

// Mock motionMediaQuery object with a mock addListener method
const mockMotionMediaQuery = {
  addListener: jest.fn(),
};

describe('YourComponent', () => {
  beforeEach(() => {
    // Reset the mock before each test
    dateFormat.mockClear();
  });    

  test('displays order as cancelled', async() => {
    const orderDetails = {
      status: 'cancelled',
      updated_at: '2024-09-09T10:00:00Z',
      created_at: '2024-09-01T10:00:00Z',
      quantity: 2,
    };
    // Define props with teacherSetDetails
    const teacherSetDetails = {
      availability: 'available',
      suitabilities_string: 'Grade 1-3',
      title: "ts title"
    };
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);

    await act(async () => {
      (root.render(<MemoryRouter><TeacherSetOrderDetails orderDetails={orderDetails} teacherSetDetails={teacherSetDetails}/></MemoryRouter>))
    });
    expect(screen.getByText('Order cancelled')).toBeInTheDocument();
    expect(screen.getByText('Cancelled')).toBeInTheDocument();
    expect(screen.getByText('Order placed')).toBeInTheDocument();
    expect(screen.queryByText('display_none')).toBeNull(); // Ensure the cancellation class is correct
  });
});
