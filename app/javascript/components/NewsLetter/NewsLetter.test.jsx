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
  it('should handle a valid email submission', async () => {
    const handleSubmit = jest.fn();
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);

    axios.get.mockResolvedValue({ data: { status: 'success' } });
    jest.spyOn(validator, 'isEmail').mockImplementation(() => true);

    await act(async () => {
      (root.render(<MemoryRouter><NewsLetter /></MemoryRouter>))
    });
    
    const emailInput = screen.getByPlaceholderText('Enter your email address');
    const submitButton = screen.getByRole("button", { name: "Submit" });
    fireEvent.change(emailInput, { target: { value: 'test@example.com' } });
    fireEvent.click(submitButton);
    validator.isEmail('test@example.com')
    jest.restoreAllMocks();
  });

  it('should handle a error email submission', async () => {
    const handleSubmit = jest.fn();
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);

    axios.get.mockResolvedValue({ data: { status: 'error' } });
    jest.spyOn(validator, 'isEmail').mockImplementation(() => true);

    await act(async () => {
      (root.render(<MemoryRouter><NewsLetter /></MemoryRouter>))
    });
    
    const emailInput = screen.getByPlaceholderText('Enter your email address');
    const submitButton = screen.getByRole("button", { name: "Submit" });
    fireEvent.change(emailInput, { target: { value: 'test@example.com' } });
    fireEvent.click(submitButton);
    validator.isEmail('test@example.com')
    jest.restoreAllMocks();
  });


  it('should handle a already email subscribed submission', async () => {
    const handleSubmit = jest.fn();
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);

    axios.get.mockResolvedValue({ data: { status: 'error', message: 'That email is already subscribed to the MyLibraryNYC newsletter.' } });
    jest.spyOn(validator, 'isEmail').mockImplementation(() => true);

    await act(async () => {
      (root.render(<MemoryRouter><NewsLetter /></MemoryRouter>))
    });
    
    const emailInput = screen.getByPlaceholderText('Enter your email address');
    const submitButton = screen.getByRole("button", { name: "Submit" });
    fireEvent.change(emailInput, { target: { value: 'test@example.com' } });
    fireEvent.click(submitButton);
    validator.isEmail('test@example.com')
    jest.restoreAllMocks();
  });
});
