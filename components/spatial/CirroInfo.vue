<template>
  <v-card class="mx-auto">
    <v-card-title class="primary white--text title-1"
      >Interactive visualization using Cirrocumulus
    </v-card-title>
    <v-card-text>
      <p class="display-1 text--primary"></p>
    </v-card-text>
    <v-row>
      <v-col cols="12"
        ><client-only>
          <div style="height:1000px">
            <iframe
              :src="link"
              height="1000"
              style="height:1000px; display: block!important; width: 100%!important; margin-left: 0!important; margin-right: 0!important; border: 0px;"
            ></iframe></div></client-only
      ></v-col>
    </v-row>
  </v-card>
</template>

<script>
export default {
  name: 'CirroInfo',
  components: {},
  props: {},
  data() {
    return {
      dataId: 'STDS0000040',
      link: 'https://bmblx.bmi.osumc.edu/cirro/'
    }
  },
  computed: {},
  watch: {},
  created() {},
  methods: {}
}
</script>

<style lang="scss"></style>
