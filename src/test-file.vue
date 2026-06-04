<template>
    <button @click="greet">Click Me</button>
</template>

<script>
/* This is a multi-line JavaScript comment.
   It should disappear completely as well.
*/
export default {
    methods: {
        greet() {
            // This is a single-line comment (should be deleted)
            const message = "Hello, World!"; // Inline comment (only this comment dies, the code stays!)
            console.log(message);
        }
    }
};
</script>