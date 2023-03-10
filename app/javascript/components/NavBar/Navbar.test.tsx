import { render, screen, cleanup } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import { axe, toHaveNoViolations } from "jest-axe";
import { shallow } from 'enzyme';
import * as React from "react";
import renderer from "react-test-renderer";
import NavBar from "../NavBar/Navbar.jsx";
import {BrowserRouter as Router} from 'react-router-dom';

describe("NavBar", () => {
  test("NavBar", () => {
    // render the component on virtual dom
    const { wrapper } = shallow(<Router><NavBar /></Router>,);
    const mlnNavBarList = screen.findByTestId("mln-navbar-list");
    expect(mlnNavBarList).toBeTruthy();
    const mlnNavBar = screen.findByTestId("mln-navbar");
    expect(mlnNavBar).toBeTruthy();
  });
});
