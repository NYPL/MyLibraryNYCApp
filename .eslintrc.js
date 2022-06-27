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
    ],
    "rules": {
        "@typescript-eslint/rule-name": "error",
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
        
    }
}
