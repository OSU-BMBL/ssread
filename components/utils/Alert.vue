<template>
  <v-alert
    v-model="show"
    width="100%"
    type="info"
    :color="color"
    dismissible
    top
    transition="scale-transition"
  >
    <div class="text-subtitle-1 font-weight-bold">{{ message }}</div>
  </v-alert>
</template>

<script>
export default {
  data: () => {
    return {
      show: false,
      message: '',
      color: '',
      timeout: 50000
    }
  },
  created() {
    this.$store.subscribe((mutation, state) => {
      if (mutation.type === 'alert/showAlert') {
        this.message = state.alert.content
        this.color = state.alert.color
        this.show = true
        setTimeout(() => {
          this.show = false
        }, this.timeout)
      }
    })
  }
}
</script>

<style lang="scss" scoped></style>
