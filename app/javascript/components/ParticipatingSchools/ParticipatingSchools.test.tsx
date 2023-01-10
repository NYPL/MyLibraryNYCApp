import { render, screen, cleanup } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import { axe, toHaveNoViolations } from "jest-axe";
import * as React from "react";
import renderer from "react-test-renderer";
import ParticipatingSchools from "../ParticipatingSchools/ParticipatingSchools.jsx";
import {BrowserRouter as Router} from 'react-router-dom';

describe("ParticipatingSchools", () => {
  test("ParticipatingSchools", () => {
    // render the component on virtual dom
    const { container } = render(<ParticipatingSchools />,);
  });
});