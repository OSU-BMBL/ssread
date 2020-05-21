<template>
  <v-hover v-slot:default="{ hover }" open-delay="0">
    <v-card
      class="mx-auto"
      :elevation="hover ? 10 : 2"
      :class="{ 'on-hover': hover }"
    >
      <v-card-title class="primary white--text subtitle-1"
        >Dimension reduction plots</v-card-title
      >

      <v-card-text>
        <p class="my-3 text--primary">
          One can visualize the single-cell metadata and gene expression
          overlaid onto a dimension reduction plot.
        </p>
        <p class="display-1 text--primary"></p>
      </v-card-text>
    </v-card>
  </v-hover>
</template>

<script>
import axios from 'axios'
export default {
  name: 'DimensionInfo',
  props: {
    de: {
      type: Array,
      required: true
    }
  },
  data() {
    return {
      search: '',
      headers: [
        { text: 'Gene name', value: 'gene' },
        { text: 'Log fold-change', value: 'avg_logFC' },
        { text: 'Adjusted p-value', value: 'p_val_adj' }
        /* ,
        { text: 'Cell type', value: 'ct' },
        { text: 'Comparison type', value: 'type' } */
      ],
      enrich: []
    }
  },
  computed: {
    genes() {
      return [
        'PHF14',
        'RBM3',
        'MSL1',
        'PHF21A',
        'ARL10',
        'INSR',
        'JADE2',
        'P2RX7',
        'LINC00662',
        'CCDC101',
        'PPM1B',
        'KANSL1L',
        'CRYZL1',
        'ANAPC16',
        'TMCC1',
        'CDH8',
        'RBM11',
        'CNPY2',
        'HSPA1L',
        'CUL2',
        'PLBD2',
        'LARP7',
        'TECPR2',
        'ZNF302',
        'CUX1',
        'MOB2',
        'CYTH2',
        'SEC22C',
        'EIF4E3',
        'ROBO2',
        'ADAMTS9-AS2',
        'CXXC1',
        'LINC01314',
        'ATF7',
        'ATP5F1'
      ]
    }
  },
  methods: {
    async handleClick(genes) {
      // const ENRICHR_URL = 'http://amp.pharm.mssm.edu/Enrichr/addList'
      // const description = 'Example gene list'
      const payload = {
        list: this.genes,
        description: 'description'
      }

      const enrich = await axios.post(
        'http://amp.pharm.mssm.edu/Enrichr/addList',
        payload
      )
      console.log(enrich)
    }
  }
}
</script>

<style lang="scss" scoped></style>
