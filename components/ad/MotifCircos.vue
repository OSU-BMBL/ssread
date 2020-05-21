<template>
  <v-hover v-slot:default="{ hover }" open-delay="0">
    <v-card
      class="mx-auto"
      :elevation="hover ? 10 : 2"
      :class="{ 'on-hover': hover }"
    >
      <v-card-title class="accent white--text subtitle-1"
        >Circos plot</v-card-title
      >
      <v-card-text> </v-card-text>

      <v-card-actions>
        <v-btn text color="secondary">
          Edit in new page
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-hover>
</template>

<script>
export default {
  name: 'MotifCircos',
  props: {
    circos: {
      type: Object,
      required: false,
      default() {
        return { message: 'hello' }
      }
    }
  }
}
</script>

<style lang="scss" scoped></style>
