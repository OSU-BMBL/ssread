<template>
  <v-card>
    <v-card-text>
      <v-row
        ><v-col xs="12" md="12" lg="12">
          <v-text-field
            v-model="search"
            prepend-icon="mdi-magnify"
            label="Search"
            single-line
            hide-details
          ></v-text-field>
          <v-btn color="primary">
            Download
          </v-btn>
          <v-data-table
            dense
            :search="search"
            :headers="headers"
            :items="regulon"
            :items-per-page="10"
            class="elevation-1"
          >
          </v-data-table>
          <iframe
            src="https://bmbl.bmi.osumc.edu/iris3/results.php?jobid=20200520163920"
            height="800"
            width="100%"
          ></iframe>
          <p class="text--primary ma-4">
            <span class="font-weight-bold"
              ><a
                href="https://bmbl.bmi.osumc.edu/iris3/results.php?jobid=20200520163920"
                target="_blank"
                style="text-decoration:none;"
              >
                Open cell-type-specific regulon result page in new tab</a
              ></span
            >
          </p>
        </v-col></v-row
      >
    </v-card-text>
  </v-card>
</template>

<script>
import { mapState } from 'vuex' // <--- To map data from Vuex

export default {
  name: 'RegulonInfo',
  components: {},
  props: {},

  data() {
    return {
      search: '',
      headers: [
        { text: 'Index', value: 'index' },
        { text: 'Transcription factor', value: 'tf_name' },
        { text: 'Regulon specificity score', value: 'rss' },
        { text: 'Regulon p-value', value: 'rss_pval' },
        { text: 'Genes', value: 'gene_symbol' }
      ]
    }
  },
  computed: {
    ...mapState({
      regulon: (state) => state.ad.regulon
    })
  },
  methods: {}
}
</script>

<style lang="scss" scoped></style>
