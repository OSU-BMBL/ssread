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
          <download-excel :data="regulon" type="csv">
            <v-btn color="primary"> Download</v-btn>
          </download-excel>
          <v-data-table
            dense
            :search="search"
            :headers="headers"
            :items="regulon"
            :items-per-page="10"
            class="elevation-1"
          >
            <template v-slot:item="row">
              <tr>
                <td>{{ row.item.index }}</td>
                <td>
                  <a
                    :href="
                      'https://www.genecards.org/cgi-bin/carddisp.pl?gene=' +
                        row.item.tf_name
                    "
                    target="_blank"
                    style="text-decoration:none;"
                    >{{ row.item.tf_name }}</a
                  >
                </td>
                <td>{{ row.item.rss }}</td>
                <td>{{ row.item.rss_pval }}</td>
                <td>{{ row.item.gene_symbol }}</td>
              </tr>
            </template>
          </v-data-table>
          <no-ssr v-show="false">
            <iframe :src="iris3Frame" height="800" width="100%"></iframe>
            <p class="text--primary ma-4">
              <span class="font-weight-bold"
                ><a
                  :href="
                    'https://bmbl.bmi.osumc.edu/iris3/results_scread.php?jobid=' +
                      jobid
                  "
                  target="_blank"
                  style="text-decoration:none;"
                >
                  Open cell-type-specific regulon result page in new tab</a
                ></span
              >
            </p></no-ssr
          >
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
  props: {
    jobid: {
      type: String,
      required: true
    }
  },

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
      regulon: (state) => state.ad.regulon,
      cellType: (state) => state.ad.dimension
    }),
    iris3Frame() {
      return (
        'https://bmbl.bmi.osumc.edu/iris3/results_scread.php?jobid=' +
        this.jobid
      )
    }
  },
  methods: {}
}
</script>

<style lang="scss" scoped></style>
