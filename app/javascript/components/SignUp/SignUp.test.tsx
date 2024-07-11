import '@testing-library/jest-dom/extend-expect';
import * as React from "react";
import SignUp from "../SignUp/SignUp.jsx";
import { createRoot } from 'react-dom/client';
import axios from 'axios';
import { act } from 'react-dom/test-utils';
import { waitFor, screen, fireEvent } from '@testing-library/react';
import { useNavigate } from 'react-router-dom';
jest.mock('axios');

const mockUseNavigate = jest.fn();
jest.mock('react-router-dom', () => ({
  ...jest.requireActual('react-router-dom'), // Use actual react-router-dom for other functions
  useNavigate: () => mockUseNavigate, // Mock useNavigate
}));

describe("SignUp", () => {
  afterEach(() => {
    // Clear all mocks after each test
    jest.clearAllMocks();
  });

  test("test active schools", async () => {
    const active_schools = {
      "J. M. Rapport School Career Development - Albert Tuitt Campus (X362 J.M. RAPPORT SCHOOL CAREER)": 1156,
      "P.S. X017- Adlai Campus (X450 P.S. X017 - ADLAI CAMPUS)": 1158,
      "PS8 The Emily Warren Roebling School (K008 PS8 EMILY WARREN ROEBLING)": 1157,
      "Renaissance High School for Musical Theater and the Arts (X405 RENAISSANCE HS FOR MUSICAL)": 1159
    }
    
    axios.get.mockResolvedValue({ data: { activeSchools: active_schools, emailMasks: ["schools.nyc.gov", "@nypl.org"] } });
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);

    // Use act to ensure all updates are processed before assertions
    await act(async () => {
      root.render(<SignUp />);
    });

    expect(screen.getByText("Email address must end with @schools.nyc.gov or a participating school domain.")).toBeInTheDocument();
    expect(screen.getByText("J. M. Rapport School Career Development - Albert Tuitt Campus (X362 J.M. RAPPORT SCHOOL CAREER)")).toBeInTheDocument();
  });

  test("test active schools with no active schools", async () => {
    axios.get.mockResolvedValue({ data: { activeSchools: {}, emailMasks: ["schools.nyc.gov", "@nypl.org"] } });
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);

    // Use act to ensure all updates are processed before assertions
    await act(async () => {
      root.render(<SignUp />);
    });
  });
});
