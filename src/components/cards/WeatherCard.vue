<template>
    <div value="weather">Weather goes here</div>
</template>

<script>
export default {
    // This tells the compiler "This is a Vue Component"
    name: 'WeatherCard',

    data() {
        return {
            loading: true,
            weather: {
                current: {
                    temp: null,
                    feelsLike: null,
                    conditionText: '',
                    windSpeed: null,
                    windDir: '',
                    humidity: null,
                    pressure: null,
                    uv: null,
                    visibility: null,
                    dewPoint: null,
                    clouds: null,
                    high: null,
                    low: null,
                    icon: ''
                },
                forecast: []
            },
            panel: null
        };
    }
    // Your methods: { }, mounted() { }, etc. will go here later
};
</script>