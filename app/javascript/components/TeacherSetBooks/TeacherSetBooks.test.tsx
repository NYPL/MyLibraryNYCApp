import { render, screen, cleanup } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import { axe, toHaveNoViolations } from "jest-axe";
import * as React from "react";
import renderer from "react-test-renderer";
import TeacherSetBooks from "../TeacherSetBooks/TeacherSetBooks.jsx";
import {BrowserRouter as Router} from 'react-router-dom';

describe("TeacherSetBooks", () => {
  test("TeacherSetBooks", () => {
    // render the component on virtual dom
    const { container } = render(<Router><TeacherSetBooks /></Router>,);
    expect(screen.getByText("Book Details")).toBeInTheDocument();
  });
});