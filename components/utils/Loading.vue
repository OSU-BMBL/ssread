<template lang="html">
  <div v-if="loading" class="loading-page">
    <h2>Loading...</h2>
    <v-progress-circular
      width="6"
      color="primary"
      style="color: #6A4C9C; width: 80px; height: 80px;"
      indeterminate
    ></v-progress-circular>
  </div>
</template>

<script>
export default {
  data: () => ({
    loading: false,
    progress: 0,
    error: ''
  }),
  methods: {
    start() {
      this.loading = true
    },
    finish() {
      this.loading = false
    },
    fail(error) {
      this.error = error
    }
  }
}
</script>

<style>
.loading-page {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 0.1);
  text-align: center;
  padding-top: 200px;
  font-size: 40px;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen,
    Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
  z-index: 1000;
}
</style>
