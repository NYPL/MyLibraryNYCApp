import { render, screen, cleanup } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import { axe, toHaveNoViolations } from "jest-axe";
import * as React from "react";
import renderer from "react-test-renderer";
import ParticipatingSchools from "../ParticipatingSchools/ParticipatingSchools.jsx";
import {BrowserRouter as Router} from 'react-router-dom';
import { shallow, configure } from 'enzyme';
import Adapter from 'enzyme-adapter-react-16';
configure({ adapter: new Adapter() });
import axios from "axios";
jest.mock('axios');

describe("ParticipatingSchools", () => {
  test("ParticipatingSchools", () => {
    // render the component on virtual dom
    const schools = [{alphabet_anchor: 'A', school_names: ["A. Philip Randolph Campus High School (M540)"]}]
    const data =  { schools: schools, anchor_tags: ['#', 'A', 'B', 'C'], school_not_found: "There are no results that match your search criteria." }
    axios.get.mockResolvedValue({data: data});
    render(<ParticipatingSchools />);
    const JoiningMln = screen.getByText("There are no results that match your search criteria.");
    expect(JoiningMln).toBeInTheDocument();
  });
});