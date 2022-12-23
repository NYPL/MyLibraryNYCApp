import { render, screen, cleanup, queryByAttribute } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import { axe, toHaveNoViolations } from "jest-axe";
import * as React from "react";
import renderer from "react-test-renderer";
import Contact from "../Contact/Contact.jsx";

const getById = queryByAttribute.bind(null, 'id');


describe("Contact ", () => {


  test("Contact ", () => {
    const dom = render(<Contact />);

    expect(screen.getByTestId("hero")).toBeInTheDocument();
    expect(screen.getByTestId("hero-content")).toBeInTheDocument();
    expect(screen.getByLabelText("Breadcrumb")).toBeInTheDocument();

    const table = getById(dom.container, 'my-library-nyc-questions-secondary')

    const JoiningMln = screen.getByText("Joining MyLibraryNYC");
    expect(JoiningMln).toBeInTheDocument();

    const questionsMyLibraryNYC = screen.getByText("Do you have questions about MyLibraryNYC or how to join?");
    expect(questionsMyLibraryNYC).toBeInTheDocument();
  });

  test("Test contact links", () => {
    const dom = render(<Contact />);
    expect(screen.getByText('Participating schools').closest('a')).toHaveAttribute('href', 'http://www.mylibrarynyc.org/schools')
    expect(screen.getByText('mylibrarynyc@bklynlibrary.org').closest('a')).toHaveAttribute('href', 'mailto:mylibrarynyc@bklynlibrary.org')
  })

});