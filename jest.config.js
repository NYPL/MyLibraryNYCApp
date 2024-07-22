module.exports = {
  collectCoverage: true,
  collectCoverageFrom: ['<rootDir>/app/javascript/components/**/*.{js,jsx,tsx,ts}',
    "!**/*.d.ts",
    "!**/node_modules/**",
  ],
  coverageDirectory: 'coverage',
  testEnvironment: 'jsdom',
  setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],
  testPathIgnorePatterns: [
    "/node_modules/",
    "/lib",
    "/config",
    "<rootDir>/app/javascript/styles/application.scss",
  ],
  transformIgnorePatterns: [
    "./node_modules/",
    "^.+\\.module\\.(css|sass|scss)$",
  ],
  moduleNameMapper: {
    "\\.(jpg|jpeg|png|gif|eot|otf|webp|svg|ttf|woff|woff2|mp4|webm|wav|mp3|m4a|aac|oga)$":
      "<rootDir>/app/javascript/components/Home/Home.test.tsx",
    "^.+\\.module\\.(css|sass|scss)$": "identity-obj-proxy",
  }
}
