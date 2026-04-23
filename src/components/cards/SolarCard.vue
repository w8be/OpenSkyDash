<template>
    <v-sheet value="solar" transition="fade-transition" flat class="mx-auto lightning-card bg-grey-darken-4"
        style="max-width: 300px; min-width:300px">

        <div class="d-flex justify-space-between align-center header-bg px-3 py-2"
            style="position: relative; z-index: 10;">
            <div class="d-flex align-center">
                <v-icon icon="mdi-white-balance-sunny" color="error" size="large" </v-icon>
                    <div class="d-flex flex-column align-start ml-2">
                        <span class="text-subtitle-1 font-weight-bold text-brown-lighten-4"
                            style="line-height: 1.2rem;">Solar</span>
                        <span class="text-grey-darken-1" style="font-size: 0.55rem;">NOAA.org</span>
                    </div>
            </div>
        </div>
    </v-sheet>

</template>