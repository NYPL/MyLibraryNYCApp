import { render, screen, cleanup, waitFor } from "@testing-library/react";
import axios from 'axios';
import '@testing-library/jest-dom/extend-expect';
import { axe, toHaveNoViolations } from "jest-axe";
import * as React from "react";
import renderer from "react-test-renderer";
import Faqs from "../Faqs/Faqs.jsx";
jest.mock('axios');

const faqs = [{answer:"You can see the list of participating schools", id: 6, position: 1, question:"kml"},{answer:"test 2", id: 7,position: 2, question: "kml2"}]

describe('Faq component', () => {
  test('Test faq axios api call ', async () => {
    axios.get.mockResolvedValue({data: faqs});
    render(<Faqs />);
    expect(screen.getByTestId("hero")).toBeInTheDocument();
    expect(screen.getByTestId("hero-content")).toBeInTheDocument();
    expect(screen.getByLabelText("Breadcrumb")).toBeInTheDocument();
  });
});
