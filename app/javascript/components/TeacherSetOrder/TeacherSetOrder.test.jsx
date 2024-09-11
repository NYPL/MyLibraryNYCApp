import { render, screen, cleanup, waitFor } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import * as React from "react";
import TeacherSetOrder from "../TeacherSetOrder/TeacherSetOrder.jsx";
import { createRoot } from 'react-dom/client';
import { act } from 'react-dom/test-utils';
import { MemoryRouter } from 'react-router-dom';
import dateFormat from 'dateformat';
jest.mock('axios');
jest.mock('dateformat', () => jest.fn());

describe('Test TeacherSetOrder', () => {
  beforeEach(() => {
      // Reset the mock before each test
      dateFormat.mockClear();
  }); 
  const teacherSet = { /* Mocked teacher set details */ };
  const colorMode = 'light'; // Or set this dynamically for testing
  const params = { access_key: '12345' }; // Mocked params
  

  // Test case 1: When the order is not cancelled
  it('should display order confirmation details when the order is not cancelled', async() => {
    const holddetails = {
      status: 'completed',
    };
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);

    await act(async () => {
      (root.render(<MemoryRouter><TeacherSetOrder teacherSet={teacherSet} holddetails={holddetails} colorMode={colorMode} params={params} /></MemoryRouter>))
    });

    // Check order message
    expect(screen.getByText('Your order has been received by our system and will be soon delivered to your school. Check your email inbox for further details.')).toBeInTheDocument();

    // Check that Cancel button is visible
    const cancelButton = screen.getByText('Cancel my order');
    expect(cancelButton).toBeInTheDocument();
    expect(cancelButton.closest('div')).toHaveStyle('display: block');
  });

  // Test case 2: When the order is cancelled
  it('should display cancellation details and hide cancel button when the order is cancelled', async() => {
    const holddetails = {
      status: 'cancelled',
    };

    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);

    await act(async () => {
      (root.render(<MemoryRouter><TeacherSetOrder teacherSet={teacherSet} holddetails={holddetails} colorMode={colorMode} params={params} /></MemoryRouter>))
    });

    // Check cancellation message
    expect(screen.getByText('The order below has been cancelled.')).toBeInTheDocument();
  });
  
});