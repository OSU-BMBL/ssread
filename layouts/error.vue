<template>
  <v-container class="text-center" justify-center align-center column>
    <v-row>
      <v-col cols="3"></v-col>
      <v-col cols="6">
        <h1 class="display-2 primary--text">Whoops, 404</h1>

        <p class="title ">
          This page doesn't exist.
        </p>

        <v-btn nuxt to="/" color="primary" outlined>
          Return to home
        </v-btn>
        <lost-image />
      </v-col>
      <v-col cols="3"></v-col>
    </v-row>
  </v-container>
</template>
<script>
import lostImage from '@/components/svg/404'

export default {
  name: 'NuxtError',
  components: {
    lostImage
  },
  props: {
    error: {
      // <--- Send in the error
      type: Object,
      default: null
    }
  },
  computed: {
    statusCode() {
      // <--- Get the status code
      return (this.error && this.error.statusCode) || 500
    },
    message() {
      // <--- Print the error
      // return 'Page not found'
      return this.error.message
    }
  },
  head() {
    return {
      title: this.message // <--- Set the SEO title
    }
  }
}
</script>
