module.exports = {
  root: true,
  env: {
    node: true,
    browser: true,
    es2022: true, // Allows modern JS features like optional chaining (?.)
  },
  extends: [
    'eslint:recommended', // Catches standard JS mistakes (typos, unused variables)
    'plugin:vue/vue3-essential', // Crucial for Vue! Catches template-breaking bugs
    // Note: If you are using Vue 2, change 'vue3-essential' to 'essential'
  ],
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
  },
  rules: {
    // You can add custom rule overwrites here later if it gets too annoying
    'no-console': process.env.NODE_ENV === 'production' ? 'warn' : 'off',
  },
}
