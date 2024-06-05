import { render, screen, cleanup } from "@testing-library/react";
import { mount, shallow } from 'enzyme';
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
    expect(screen.getByLabelText("Signup Error Notifications")).toBeInTheDocument();
    expect(screen.getByText("Some of your information needs to be updated before your account can be created. See the fields highlighted below.")).toBeInTheDocument();
    expect(screen.getByLabelText("Preferred email address")).toBeInTheDocument();
    expect(screen.getByLabelText("First name (Required)")).toBeInTheDocument();
    expect(screen.getByLabelText("Last name (Required)")).toBeInTheDocument();
    expect(screen.getByLabelText("Your school (Required)")).toBeInTheDocument();
    expect(screen.getByLabelText("Password (Required)")).toBeInTheDocument();
    expect(screen.getByLabelText("Select if you would like to receive the MyLibraryNYC email newsletter (we will use your alternate email if supplied above)")).toBeInTheDocument();
  });

  // it("Updates the state", () => {
  //   const wrapper = shallow(<Router><SignUp /></Router>,);
  //   const input = wrapper.find("#sign-up-email").at(0).simulate('change');
  //   //input.simulate("change", { target: { value: 'deepika@gmail.com' } });  // 'value' instead of 'num'
  //   console.log(wrapper.state())
  //   //expect(wrapper.state().num).toEqual(2);  // SUCCESS
  // });
});

