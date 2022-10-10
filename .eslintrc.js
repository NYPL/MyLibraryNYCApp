module.exports = {
    "env": {
        browser: true,
        node: true,
        es6: true,
        jest: true
    },
    "parser": "@typescript-eslint/parser",
    "extends": [
        "eslint:recommended",
        "plugin:react/recommended",
        "plugin:@typescript-eslint/recommended",
    ],
    "parserOptions": {
        "ecmaFeatures": {
            "jsx": true
        },
        "ecmaVersion": "latest",
        "sourceType": "module"
    },
    "plugins": [
        "react",
        "@typescript-eslint",
        "prettier"
    ],
    "rules": {
        // disabling this bc it is checked by typescript so it is
        // redundant and doesn't function properly
        "react/prop-types": 0,
        "prettier/prettier": "error",
        "@typescript-eslint/no-empty-interface": 0,
        "@typescript-eslint/no-use-before-define": [
          "error",
          { functions: false, variables: false },
        ],

        "@typescript-eslint/no-unused-vars": [
          "error",
          {
            vars: "all",
            args: "after-used",
            // ignore underscore _vars or jsx imports or React imports
            argsIgnorePattern: "^_.*",
            varsIgnorePattern: "^jsx$|^React$|^_.*",
            ignoreRestSiblings: true,
          },
        ],
        "react/no-unescaped-entities": [
          "error",
          {
            forbid: [">", "}"],
          },
        ],
        // disable this rule because it is unnecessarily strict for TS
        "@typescript-eslint/explicit-function-return-type": 0,
        "@typescript-eslint/explicit-module-boundary-types": 0,
        // camelcase: "error",
        // "@typescript-eslint/camelcase": 0,
        eqeqeq: ["error", "smart"],
        "id-blacklist": [
          "error",
          "any",
          "Number",
          "number",
          "String",
          "string",
          "Boolean",
          "Undefined",
        ],
        "id-match": "error",
        "no-eval": "error",
        "no-redeclare": "error",
        "no-var": "error",
    },
    settings: {
      react: {
        version: "detect",
      },
    },
}
