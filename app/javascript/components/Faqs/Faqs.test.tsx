

import React from 'react';
import '@testing-library/jest-dom/extend-expect';
import axios from 'axios';
import Faqs from './Faqs'; // Ensure the path to your Faqs component is correct
import { act } from 'react-dom/test-utils';
import { createRoot } from 'react-dom/client';
import { waitFor, screen } from '@testing-library/react';
jest.mock('axios');

describe('Faq component', () => {
  afterEach(() => {
    // Clear all mocks after each test
    jest.clearAllMocks();
  });

  test('Test faq axios api call with data', async () => {
    const faqs = [
      { answer: "You can see the list of participating schools", id: 6, position: 1, question: "kml" },
      { answer: "test 2", id: 7, position: 2, question: "kml2" }
    ];
    axios.get.mockResolvedValue({ data: { faqs } });

    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);
    
    // Use act to ensure all updates are processed before assertions
    await act(async () => {
      root.render(<Faqs />);
    });

    await waitFor(() => {
      expect(screen.getByText("kml")).toBeInTheDocument();
      expect(screen.getByText("kml2")).toBeInTheDocument();
    });
  });

  test('Test faq axios api call with empty array', async () => {
    axios.get.mockResolvedValue({ data: { faqs: [] } });

    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);
    
    // Use act to ensure all updates are processed before assertions
    await act(async () => {
      root.render(<Faqs />);
    });

    await waitFor(() => {
      expect(screen.queryByText("What are Teacher Sets?")).not.toBeInTheDocument();
      expect(screen.queryByText("Does my school participate in MyLibraryNYC?")).not.toBeInTheDocument();
    });
  });
});
