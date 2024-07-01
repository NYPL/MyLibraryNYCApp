import { screen } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import * as React from "react";
import ParticipatingSchools from "../ParticipatingSchools/ParticipatingSchools.jsx";
jest.mock('axios');
import { createRoot } from 'react-dom/client';

describe("ParticipatingSchools", () => {
  test("ParticipatingSchools", () => {
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);

    // Use act to ensure all updates are processed before assertions
    root.render(<ParticipatingSchools />);
  });
});
