import { render, screen, cleanup } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import * as React from "react";
import TeacherSetBooks from "../TeacherSetBooks/TeacherSetBooks.jsx";
import { createRoot } from 'react-dom/client';
import { act } from 'react-dom/test-utils';

describe("TeacherSetBooks", () => {
  test("TeacherSetBooks", () => {
    const rootElement = document.createElement('div');
    document.body.appendChild(rootElement);
    const root = createRoot(rootElement);
    // Use act to ensure all updates are processed before assertions
    root.render(<TeacherSetBooks />);
  });
});
