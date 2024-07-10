import React from 'react';
import '@testing-library/jest-dom/extend-expect';
import axios from 'axios';
import { act } from 'react-dom/test-utils';
import { createRoot } from 'react-dom/client';
import { waitFor, screen } from '@testing-library/react';
import ParticipatingSchools from "../ParticipatingSchools/ParticipatingSchools.jsx";
jest.mock('axios');

describe('ParticipatingSchools', () => {
  afterEach(() => {
    // Clear all mocks after each test
    jest.clearAllMocks();
  });

  test('Get Participating Schools ', async () => {
    const schools = [
      {
        "alphabet_anchor": "J",
        "school_names": [
          "J. M. Rapport School Career Development - Albert Tuitt Campus (X362 J.M. RAPPORT SCHOOL CAREER)"
        ]
      },
      {
        "alphabet_anchor": "P",
        "school_names": [
          "P.S. X017- Adlai Campus (X450 P.S. X017 - ADLAI CAMPUS)",
          "PS8 The Emily Warren Roebling School (K008 PS8 EMILY WARREN ROEBLING)"
        ]
      },
      {
        "alphabet_anchor": "R",
        "school_names": [
          "Renaissance High School for Musical Theater and the Arts (X405 RENAISSANCE HS FOR MUSICAL)"
        ]
      }
    ];
    const anchor_tags =  ["#", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    axios.get.mockResolvedValue({ data: { schools: schools, anchor_tags: anchor_tags, school_not_found: "" } });
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);
    
    // Use act to ensure all updates are processed before assertions
    await act(async () => {
      root.render(<ParticipatingSchools />);
    });

    expect(screen.getByText("J. M. Rapport School Career Development - Albert Tuitt Campus (X362 J.M. RAPPORT SCHOOL CAREER)")).toBeInTheDocument();
    expect(screen.getByText("P.S. X017- Adlai Campus (X450 P.S. X017 - ADLAI CAMPUS)")).toBeInTheDocument();
    expect(screen.getByText("Renaissance High School for Musical Theater and the Arts (X405 RENAISSANCE HS FOR MUSICAL)")).toBeInTheDocument();
    expect(screen.getByText("Start typing the name of your school.")).toBeInTheDocument();
  });

  test('No schools found', async () => {
    axios.get.mockResolvedValue({ data: { schools: [], anchor_tags: ['#', 'A', 'B', 'C'], school_not_found: "There are no results that match your search criteria." } });

    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);
    
    // Use act to ensure all updates are processed before assertions
    await act(async () => {
      root.render(<ParticipatingSchools />);
    });
    console.log(rootElement.innerHTML);
    expect(screen.getByText("There are no results that match your search criteria.")).toBeInTheDocument();
  });
});