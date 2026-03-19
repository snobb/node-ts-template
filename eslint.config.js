import js from '@eslint/js';
import globals from 'globals';
import tseslint from 'typescript-eslint';
import prettierConfig from 'eslint-config-prettier';

export default tseslint.config(
  {
    ignores: ['dist/**', 'coverage/**', 'node_modules/**'],
  },

  js.configs.recommended,

  // TypeScript Recommended (includes parser & plugin setup)
  ...tseslint.configs.recommended,

  {
    // Environment & Language Options
    languageOptions: {
      parserOptions: {
        projectService: true, // The 2026 way to handle tsconfig automatically
        tsconfigRootDir: import.meta.dirname,
      },
    },
    languageOptions: {
      globals: {
        ...globals.node,
        ...globals.es2025, // Enables modern ES features
      },
      parserOptions: {
        project: true, // Auto-finds your tsconfig.json
      },
    },

    rules: {
      'no-console': 'warn',
      'no-unused-vars': 'off', // Turned off in favor of TS version
      '@typescript-eslint/no-unused-vars': ['error', { argsIgnorePattern: '^_', varsIgnorePattern: '^_' }],
      '@typescript-eslint/no-explicit-any': 'warn',
      '@typescript-eslint/consistent-type-definitions': ['error', 'type'],
    },
  },

  // Prettier - disable all stylistic rules that might conflict with Prettier
  prettierConfig,
);
