import { render, screen, cleanup } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import { axe, toHaveNoViolations } from "jest-axe";
import * as React from "react";
import renderer from "react-test-renderer";
import { shallow } from 'enzyme';
import HaveQuestions from "../HaveQuestions/HaveQuestions.jsx";
import {BrowserRouter as Router} from 'react-router-dom';

describe("HaveQuestions ", () => {
  test("HaveQuestions ", () => {
    const { wrapper } = shallow(<HaveQuestions />,);
    const haveQuestionsLinks = screen.findByTestId("have-questions-links");
    expect(haveQuestionsLinks).toBeTruthy();
  });
});