// plugins/vuetify.ts
import { createVuetify } from 'vuetify'

import * as labsComponents from 'vuetify/labs/components'

import '@mdi/font/css/materialdesignicons.css'
import 'vuetify/styles'
import { aliases, mdi } from 'vuetify/iconsets/mdi'

export default createVuetify({
  // Register all labs components, or just VSparkline from that set
  components: {
    ...labsComponents,
  },
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
