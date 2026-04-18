// plugins/vuetify.ts
import { createVuetify } from 'vuetify'

// These are the lines Vite was complaining about
import '@mdi/font/css/materialdesignicons.css'
import 'vuetify/styles'

// This part ensures Vuetify knows how to use the icons you just installed
import { aliases, mdi } from 'vuetify/iconsets/mdi'

export default createVuetify({
  theme: {
    defaultTheme: 'dark',
  },
  icons: {
    defaultSet: 'mdi',
    aliases,
    sets: {
      mdi,
    },
  },
})
