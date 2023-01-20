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


describe("ParticipatingSchools", () => {
  test("ParticipatingSchools", () => {
    // render the component on virtual dom
    const { container } = render(<ParticipatingSchools />,);
    const JoiningMln = screen.getByText("There are no results that match your search criteria.");
    expect(JoiningMln).toBeInTheDocument();
    //screen.getByRole("Does your school participate in MyLibraryNYC?").toBeInTheDocument();
    //expect(component.find('h3')).toEqual("h3");
  });
});