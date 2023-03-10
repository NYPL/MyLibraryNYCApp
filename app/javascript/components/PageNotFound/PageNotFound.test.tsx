import { render, screen, cleanup } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import { axe, toHaveNoViolations } from "jest-axe";
import { shallow } from 'enzyme';
import * as React from "react";
import renderer from "react-test-renderer";
import PageNotFound from "../PageNotFound/PageNotFound.jsx";
import {BrowserRouter as Router} from 'react-router-dom';


describe("PageNotFound", () => {
  test("PageNotFound", () => {
    // render the component on virtual dom
    const { wrapper } = shallow(<PageNotFound />,);
    const pageNotFoundMsg1 = screen.findByTestId("page-not-found-error-msg-1");
    expect(pageNotFoundMsg1).toBeTruthy();
    const pageNotFoundMsg2 = screen.findByTestId("page-not-found-error-msg-2");
    expect(pageNotFoundMsg2).toBeTruthy();

    //screen.getByRole("Does your school participate in MyLibraryNYC?").toBeInTheDocument();
    //expect(component.find('h3')).toEqual("h3");
    //expect(wrapper.find('p').text()).to.equal("To continue using our site, you can:");

  });
});