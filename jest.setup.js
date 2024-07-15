import '@testing-library/jest-dom'
global.env = {}
global.IS_REACT_ACT_ENVIRONMENT = true
global.env = { RAILS_ENV: "test" }
Object.defineProperty(window, 'matchMedia', {
  writable: true,
  value: jest.fn().mockImplementation(query => ({
    matches: false,
    media: query,
    onchange: null,
    addEventListener: jest.fn(),
    removeEventListener: jest.fn(),
    dispatchEvent: jest.fn(),
  })),
});
