import { render, screen, cleanup } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import { axe, toHaveNoViolations } from "jest-axe";
import * as React from "react";
import renderer from "react-test-renderer";
import SignIn from "../SignIn/SignIn.jsx";
import {BrowserRouter as Router} from 'react-router-dom';

describe("SignIn", () => {
  test("SignIn", () => {
    // render the component on virtual dom
    const { container } = render(<Router><SignIn /></Router>,);
    expect(screen.getByTestId("hero")).toBeInTheDocument();
    expect(screen.getByTestId("hero-content")).toBeInTheDocument();
    expect(screen.getByLabelText("Breadcrumb")).toBeInTheDocument();
    expect(screen.getByPlaceholderText("Enter email address")).toBeInTheDocument();
    expect(screen.getByText('Sign up').closest('a')).toHaveAttribute('href', '/signup')
    expect(screen.getByText("Not Registered? Please")).toBeInTheDocument();
    expect(screen.getByText("Have questions?")).toBeInTheDocument();
    expect(screen.getByText('Faq Page').closest('a')).toHaveAttribute('href', '/faq')
    expect(screen.getByText('Contact Us').closest('a')).toHaveAttribute('href', '/contact')
  });
});