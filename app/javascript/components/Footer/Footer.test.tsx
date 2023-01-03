import { render, screen, cleanup } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import { axe, toHaveNoViolations } from "jest-axe";
import * as React from "react";
import renderer from "react-test-renderer";
import Footer from "../Footer/Footer.jsx";

describe("Footer ", () => {
  test("Footer ", () => {
    // render the component on virtual dom
    const { container } = render(<Footer />);
  });
});
