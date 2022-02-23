<template>
  <v-snackbar v-model="show" width="100%" :color="color" top :timeout="timeout">
    <div class="text-subtitle-1 font-weight-bold">{{ message }}</div>
    <v-spacer></v-spacer>
    <template v-slot:action="{ attrs }">
      <v-btn
        outlined
        color="grey lighten-5"
        v-bind="attrs"
        @click="show = false"
      >
        Close
      </v-btn>
    </template>
  </v-snackbar>
</template>

<script>
export default {
  data: () => {
    return {
      show: false,
      message: '',
      color: '',
      timeout: 3000
    }
  },
  created() {
    this.$store.subscribe((mutation, state) => {
      if (mutation.type === 'snackbar/showMessage') {
        this.message = state.snackbar.content
        this.color = state.snackbar.color
        this.show = true
        this.timeout = state.snackbar.timeout
      }
    })
  }
}
</script>

<style lang="scss" scoped></style>
