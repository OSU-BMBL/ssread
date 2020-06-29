<template>
  <v-navigation-drawer
    class="grey lighten-4"
    app
    right
    clipped
    fixed
    width="350"
    ><div v-html="content"></div>
  </v-navigation-drawer>
</template>

<script>
export default {
  name: 'Toc',
  props: {
    content: {
      type: String,
      required: true
    }
  }
}
</script>

<style lang="scss" scoped></style>
