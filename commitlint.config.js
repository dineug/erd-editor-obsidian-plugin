/** @type {import('@commitlint/types').UserConfig} */
export default {
  extends: ['@commitlint/config-conventional'],
  rules: {
    // Subjects are capitalized, as in the erd-editor monorepo
    // (e.g. "feat: Release the ERD Editor Obsidian plugin"),
    // which config-conventional would otherwise reject as sentence-case.
    'subject-case': [0],
  },
};
