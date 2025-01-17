import { defineConfig } from 'vite';

export default defineConfig({
  test: {
    setupFiles: ['./setup-tests/setup-tests.ts'],
    globals: true,
  },
});
