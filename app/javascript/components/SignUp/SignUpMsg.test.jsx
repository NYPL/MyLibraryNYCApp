import '@testing-library/jest-dom/extend-expect';
import * as React from "react";
import SignUpMsg from "../SignUp/SignUpMsg.jsx";
import { createRoot } from 'react-dom/client';
import { act } from 'react-dom/test-utils';
import {screen } from '@testing-library/react';
jest.mock('axios');

describe("SignUp Message", () => {
  afterEach(() => {
    // Clear all mocks after each test
    jest.clearAllMocks();
  });

  test("SignUp Message", async () => {
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);

    const signUpDetails = {
      userSignedIn: true,
      signedUpMessage: "Your registration is successful!",
    };

    await act(async () => {
      root.render(<SignUpMsg signUpDetails={signUpDetails} />); 
    });

    // Expect Notification to be rendered
    const notificationElement = screen.getByLabelText('SignUp Notification');
    expect(notificationElement).toBeInTheDocument();

    // Verify the content of Notification
    expect(screen.getByText("Registration Successful!")).toBeInTheDocument();
    expect(screen.getByText("Your registration is successful!")).toBeInTheDocument();
  })
});
