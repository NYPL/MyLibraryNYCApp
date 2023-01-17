import { render, screen, cleanup } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import { axe, toHaveNoViolations } from "jest-axe";
import * as React from "react";
import renderer from "react-test-renderer";
import SignUp from "../SignUp/SignUp.jsx";
import {BrowserRouter as Router} from 'react-router-dom';

describe("SignUp", () => {
  test("SignUp", () => {
    // render the component on virtual dom
    const { container } = render(<Router><SignUp /></Router>,);
    console.log(screen)
    expect(screen.getByLabelText("Signup Error Notifications")).toBeInTheDocument();
    expect(screen.getByText("Some of your information needs to be updated before your account can be created. See the fields highlighted below.")).toBeInTheDocument();
    expect(screen.getByLabelText("Your DOE Email Address")).toBeInTheDocument();
    
  });
});