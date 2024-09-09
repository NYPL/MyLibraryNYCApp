import '@testing-library/jest-dom'
import * as React from "react";

global.env = {}
global.IS_REACT_ACT_ENVIRONMENT = true
global.env = { RAILS_ENV: "test", MLN_INFO_SITE_HOSTNAME: "www.testmylibrarynyc.xxx" }
Object.defineProperty(window, 'matchMedia', {
  writable: true,
  value: jest.fn().mockImplementation(query => ({
    matches: false,
    media: query,
    onchange: null,
    addEventListener: jest.fn(),
    removeEventListener: jest.fn(),
    dispatchEvent: jest.fn(),
    mockResolvedValueOnce: jest.fn(),
  })),
});
