<template>
  <v-card class="mx-auto">
    <v-card-title class="primary white--text title-1"
      >Deconvolution
    </v-card-title>
    <v-card-text>
      <p class="display-1 text--primary"></p>
    </v-card-text>
    <v-row>
      <v-col cols="12"
        ><v-col xs="12" md="4" lg="4" class="px-4 py-0 my-2">
          <p class="subtitle-1 font-weight-bold py-0 my-2">
            Spatial sample:
            <v-tooltip top>
              <template v-slot:activator="{ on, attrs }">
                <v-icon color="primary" dark v-bind="attrs" v-on="on"
                  >mdi-help-circle-outline</v-icon
                >
              </template>
              <span>Select sample </span>
            </v-tooltip>
          </p>
          <v-select
            v-model="stSelect"
            :items="stItems"
            item-text="name"
            item-value="value"
            return-object
            single-line
            persistent-hint
          ></v-select> </v-col
        ><v-col xs="12" md="4" lg="4" class="px-4 py-0 my-2">
          <p class="subtitle-1 font-weight-bold py-0 my-2">
            scRNA-seq dataset:
            <v-tooltip top>
              <template v-slot:activator="{ on, attrs }">
                <v-icon color="primary" dark v-bind="attrs" v-on="on"
                  >mdi-help-circle-outline</v-icon
                >
              </template>
              <span>Select sample </span>
            </v-tooltip>
          </p>
          <v-select
            v-model="scSelect"
            :items="scItems"
            item-text="name"
            item-value="value"
            return-object
            single-line
            persistent-hint
          ></v-select> </v-col
      ></v-col>
      <v-col xs="12" md="4" lg="10" class="px-4 py-0 my-2">
        <v-img
          width="700"
          contain
          :src="`spatial/${scSelect.value}.png`"
        ></v-img
        ><v-img
          contain
          width="700"
          :src="`spatial/${scSelect.value}-cor.png`"
        ></v-img
      ></v-col>
    </v-row>
  </v-card>
</template>

<script>
export default {
  name: 'CirroInfo',
  components: {},
  props: {
    dataId: {
      type: String,
      required: true,
      default: () => 'STDS0000040'
    }
  },
  data() {
    return {
      stSelect: { name: 'ST00109', value: 'AD00105' },
      stItems: [{ name: 'ST00109', value: 'AD00105' }],
      scSelect: { name: 'AD00103', value: 'AD00103' },
      scItems: [
        { name: 'AD00101', value: 'AD00103' },
        { name: 'AD00102', value: 'AD00103' },
        { name: 'AD00103', value: 'AD00103' },
        { name: 'AD00104', value: 'AD00203' },
        { name: 'AD00105', value: 'AD00203' },
        { name: 'AD00106', value: 'AD00203' },
        { name: 'AD00201', value: 'AD00203' },
        { name: 'AD00202', value: 'AD00203' },
        { name: 'AD00203', value: 'AD00203' },
        { name: 'AD00204', value: 'AD00203' },
        { name: 'AD00205', value: 'AD00203' }
      ]
    }
  },
  computed: {},
  watch: {},
  created() {},
  methods: {}
}
</script>

<style lang="scss"></style>
