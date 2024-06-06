import { render, screen, cleanup } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import { axe, toHaveNoViolations } from "jest-axe";
import * as React from "react";
import renderer from "react-test-renderer";
import Home from "../Home/Home.jsx";
import {BrowserRouter as Router} from 'react-router-dom';


describe("Home ", () => {
  test("Home ", () => {
    // render the component on virtual dom
    const { container } = render(<Router><Home /></Router>,);
    //select the elements you want to interact with

    const JoiningMln = screen.getByText("Welcome to MyLibraryNYC");
    expect(JoiningMln).toBeInTheDocument();

    const searchForTs = screen.getByText("Search For Teacher Sets");
    expect(searchForTs).toBeInTheDocument();
    
  });
});