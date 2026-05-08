import { fileURLToPath, URL } from 'node:url'
import Vue from '@vitejs/plugin-vue'
import Fonts from 'unplugin-fonts/vite'
import { defineConfig } from 'vite'
import Vuetify, { transformAssetUrls } from 'vite-plugin-vuetify'

export default defineConfig({
  plugins: [
    Vue({
      template: { transformAssetUrls },
    }),
    Vuetify({
      autoImport: true,
      // NOTE: Ensure src/styles/settings.scss actually exists!
      /*   styles: {
        configFile: 'src/styles/settings.scss',
      },*/
    }),
    Fonts({
      fontsource: {
        families: [
          {
            name: 'Roboto',
            weights: [100, 300, 400, 500, 700, 900],
            styles: ['normal', 'italic'],
          },
        ],
      },
    }),
  ],
  define: { 'process.env': {} },
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url)),
    },
    extensions: ['.js', '.json', '.jsx', '.mjs', '.ts', '.tsx', '.vue'],
  },
  server: {
    port: 3000,
    proxy: {
      // This is the "bridge" to the lightning data
      '/blitz-js': {
        target: 'https://www.blitzortung.org/en/JS/live_lightning_maps.js',
        changeOrigin: true,
        secure: false,
        rewrite: (path) => path.replace(/^\/blitz-js/, ''),
      },
      '/api-kc2g': {
        target: 'https://prop.kc2g.com',
        changeOrigin: true,
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) YourAppName/1.0',
          Referer: 'https://prop.kc2g.com/',
        },
        rewrite: (path) => path.replace(/^\/api-kc2g/, ''),
      },
    },
  },
})
