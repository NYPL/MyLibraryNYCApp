import '@testing-library/jest-dom/extend-expect';
import React, {useState} from "react";
import SignUpMsg from "../SignUp/SignUpMsg.jsx";
import { createRoot } from 'react-dom/client';
import { act } from 'react-dom/test-utils';
import {screen, fireEvent, waitFor, render} from '@testing-library/react';
import axios from 'axios';
import validator from 'validator'; 
jest.mock('axios');
jest.mock('validator'); 
import NewsletterSignup from "../NewsLetter/NewsLetter.jsx";
import NewsLetter from "../NewsLetter/NewsLetter.jsx";
import { MemoryRouter } from 'react-router-dom';

const titleString = "Sign Up for Our Newsletter";
const confirmationHeading = "Thank you for signing up!";
const confirmationText =
  "You can update your email subscription preferences at any time using the links at the bottom of the email.";
const errorHeading = "Oops! Something went wrong.";

describe("NewsletterSignup Unit Tests", () => {
  const onSubmit = jest.fn();
  const onChange = jest.fn();
  const valueEmail = "";
  it("Renders the Minimum Required Elements for the Form", async () => {
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);
    await act(async () => {
      root.render(<MemoryRouter>render(
        <NewsletterSignup
          onSubmit={onSubmit}
          onChange={onChange}
          title={titleString}
          errorHeading={errorHeading}
          confirmationHeading={confirmationHeading}
          confirmationText={confirmationText}
        />
      );</MemoryRouter>);
    });
    expect(screen.getByRole("form")).toBeInTheDocument();
    expect(screen.getByRole("textbox")).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Submit" })).toBeInTheDocument();
    expect(screen.getByRole("heading", { level: 2 })).toBeInTheDocument();
    //expect(onSubmit).toHaveBeenCalledTimes(0);
  });
});

describe('handleSubmit', () => {
  const handleSubmit = jest.fn();

  it('should handle a valid email submission', async () => {
   // validator.isEmail.mockReturnValue(true);
    axios.get.mockResolvedValue({ data: { status: 'success' } });
    jest.spyOn(validator, 'isEmail').mockImplementation(() => true);

    await act(async () => {
      (<MemoryRouter>render(<NewsLetter />)</MemoryRouter>)
    });

    const emailInput = screen.getByPlaceholderText('Enter your email address');
    const submitButton = screen.getByRole("button", { name: "Submit" });

    fireEvent.change(emailInput, { target: { value: 'test@example.com' } });
    fireEvent.click(submitButton);
    
    console.log(validator.isEmail('test@example.com'));

  });
});
