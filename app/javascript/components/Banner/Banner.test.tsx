import { render, screen, cleanup, waitFor, fireEvent } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import * as React from "react";
import Banner from "../Banner/Banner.jsx";
import { createRoot } from 'react-dom/client';
import { act } from 'react-dom/test-utils';
import axios from 'axios'; 
import { MemoryRouter } from 'react-router-dom';
jest.mock('axios');

const mockResponse = jest.fn();

describe('Banner', () => {
  beforeEach(() => {
  jest.clearAllMocks();
});
  beforeEach(() => {
    mockResponse.mockClear();
  });
  it('test Mln banner', async () => {
    const mockResponse = {
      data: {
        bannerText: 'Test Banner Text',
        bannerTextFound: true
      }
    };
    axios.get.mockResolvedValue(mockResponse);
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);
    await act(async () => {
      root.render(<MemoryRouter><Banner /></MemoryRouter>);
    });
    expect(screen.getByText('Test Banner Text')).toBeInTheDocument
  });
});

describe('Banner text is null ', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  beforeEach(() => {
    mockResponse.mockClear();
  });

  it('test Mln banner with no banner text', async () => {
    const mockResponse = {
      data: {
        bannerText: '',
        bannerTextFound: false
      }
    };
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);
    await act(async () => {
      axios.get.mockResolvedValue(mockResponse);
      root.render(<MemoryRouter><Banner /></MemoryRouter>);
    });
    expect(screen.queryByText('Test Banner Text')).not.toBeInTheDocument
  });
});
