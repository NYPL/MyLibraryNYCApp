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
// Mocking the nypl design-system-react-components hook
// jest.mock('', () => ({
//   useNYPLBreakpoints: jest.fn(() => ({
//     isLargerThanMedium: true,
//     isLargerThanMobile: false,
//   })),
//   useColorMode: jest.fn().mockReturnValue({
//     colorMode: 'light',
//   }),
//   useColorModeValue: jest.fn().mockReturnValue({
//     color: 'light-color-value',
//   }),
  // SkeletonLoader: jest.fn(),
  // TemplateAppContainer: jest.fn(),
  // HorizontalRule: jest.fn(),
  // Flex: jest.fn(),
  // Spacer: jest.fn(),
  // Heading: jest.fn(),
  // SearchBar: jest.fn(),
  // Accordion: jest.fn(),
  // Button: jest.fn(),
  // ButtonGroup: jest.fn(),
  // Select: jest.fn(),
  // Icon: jest.fn(),
  // Card: jest.fn(),
  // CardHeading: jest.fn(),
  // CardContent: jest.fn(),
  // Pagination: jest.fn(),
  // Checkbox: jest.fn(),
  // Slider: jest.fn(),
  // CheckboxGroup: jest.fn(),
  // Text: jest.fn(),
  // Box: jest.fn(),
  // Notification: jest.fn(),
  // Toggle: jest.fn(),
//}));