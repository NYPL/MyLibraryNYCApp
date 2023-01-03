import { render, screen, cleanup } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import { axe, toHaveNoViolations } from "jest-axe";
import * as React from "react";
import renderer from "react-test-renderer";
import Faqs from "../Faqs/Faqs.jsx";

describe("Faqs ", () => {
  test("Faqs ", () => {
    // render the component on virtual dom
    const { container } = render(<Faqs />);
    //select the elements you want to interact with
    expect(screen.getByTestId("hero")).toBeInTheDocument();
    expect(screen.getByTestId("hero-content")).toBeInTheDocument();
    expect(screen.getByLabelText("Breadcrumb")).toBeInTheDocument();
  });
});