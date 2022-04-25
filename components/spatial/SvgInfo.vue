<template>
  <v-card class="mx-auto">
    <v-card-title class="primary white--text title-1"
      >Spatially variable genes
    </v-card-title>
    <v-card-text>
      <p class="display-1 text--primary"></p>
    </v-card-text>
    <v-row xs="12" md="8" lg="12">
      <v-col cols="lg-6">
        <v-row>
          <v-col xs="12" md="12" lg="12" class="px-4 py-0 my-1">
            <p class="subtitle-1 font-weight-bold">
              Log2 fold-change cutoff:
              <v-tooltip top>
                <template v-slot:activator="{ on, attrs }">
                  <v-icon color="primary" dark v-bind="attrs" v-on="on"
                    >mdi-help-circle-outline</v-icon
                  >
                </template>
                <span
                  >Limit testing to genes which show, on average, at least
                  X-fold difference (log-scale) between the two groups of
                  cells.</span
                >
              </v-tooltip>
            </p>
            <v-slider
              v-model="lfc_range"
              max="5"
              min="0"
              hide-details
              :thumb-size="24"
              thumb-label="always"
              class="align-center"
              :step="lfc_slider"
            >
              <template v-slot:append>
                <v-text-field
                  v-model="lfc_range"
                  class="mt-0 pt-0"
                  hide-details
                  single-line
                  type="number"
                  style="width: 70px"
                ></v-text-field>
              </template>
            </v-slider>
          </v-col>
          <v-col xs="12" md="12" lg="12" class="px-4 py-0 my-1">
            <p class="subtitle-1 font-weight-bold">
              Adjusted p-value cutoff:<v-tooltip top>
                <template v-slot:activator="{ on, attrs }">
                  <v-icon color="primary" dark v-bind="attrs" v-on="on"
                    >mdi-help-circle-outline</v-icon
                  >
                </template>
                <span
                  >The adjusted p-value is calculated from differentially
                  expressed genes between two groups of cells using a Wilcoxon
                  Rank Sum test in Seurat R package.</span
                >
              </v-tooltip>
            </p>
            <v-slider
              v-model="p_range"
              :tick-labels="ticksLabels"
              max="8"
              min="1"
              step="1"
              ticks="always"
              tick-size="4"
            >
              <template v-slot:append>
                <v-text-field
                  v-model="pSliderValue"
                  class="mt-0 pt-0"
                  center
                  hide-details
                  single-line
                  type="number"
                  style="width: 70px"
                ></v-text-field> </template
            ></v-slider>
          </v-col>
        </v-row>
        <v-col cols="12" md="12" lg="12">
          <v-radio-group v-model="deDirection" row>
            <span class="subtitle-1 font-weight-bold"
              >Foldchange direction:
            </span>
            <v-radio label="All" value="all"></v-radio>
            <v-radio label="UP" value="up"></v-radio>
            <v-radio label="Down" value="down"></v-radio>
          </v-radio-group>
        </v-col>
      </v-col>

      <v-col cols="md-12 lg-12">
        <v-text-field
          v-model="searchDe"
          prepend-icon="mdi-magnify"
          label="Search"
          single-line
          hide-details
        ></v-text-field
        ><v-data-table
          dense
          :search="searchDe"
          :headers="headers"
          :items="filterDe"
          :items-per-page="15"
          class="elevation-1"
        >
          <template slot="no-data">
            <v-alert :value="true">
              {{ deErrorMsg }}
            </v-alert>
          </template>
          <template v-slot:top>
            <v-toolbar flat>
              <v-toolbar-title>
                <download-excel :data="filterDe" type="csv">
                  <v-btn color="primary"> Download</v-btn>
                </download-excel></v-toolbar-title
              >
              <v-tooltip top>
                <template v-slot:activator="{ on, attrs }">
                  <v-icon color="primary" dark v-bind="attrs" v-on="on"
                    >mdi-help-circle-outline</v-icon
                  >
                </template>
                <p>
                  Note: The DEGs table will be automatically updated using the
                  option panel on the left, and the functional gene set
                  enrichment analysis will be performed real-time based on
                  current DEGs list.
                </p>
                <p>
                  Note: Be careful about fold-change direction when browsing
                  cross datasets DE comparisons, i.e., check current dataset's
                  position in the 'A vs B' group comparison.
                </p>
                <p>
                  Log fold-change : log fold-chage of the average expression
                  between the two groups. Positive values indicate that the
                  feature is more highly expressed in the first group.
                </p>
                <p>
                  Pct.1 : The percentage of cells where the feature is detected
                  in the first group
                </p>
                <p>
                  Pct.2 : The percentage of cells where the feature is detected
                  in the second group
                </p>
                <p>
                  Adjusted p-value : Adjusted p-value, based on bonferroni
                  correction using all features in the dataset.
                </p>
              </v-tooltip>
              <v-btn color="primary" @click="copyGenes(genes)"
                >Copy Genes</v-btn
              >
              <v-spacer></v-spacer>
            </v-toolbar>
          </template>
          <template v-slot:item="row">
            <tr>
              <td>
                <a
                  :href="
                    'https://www.genecards.org/cgi-bin/carddisp.pl?gene=' +
                      row.item.gene
                  "
                  target="_blank"
                  style="text-decoration:none;"
                  >{{ row.item.gene }}</a
                >
              </td>

              <td>{{ row.item.avg_logFC }}</td>
              <td>0</td>
              <td>[3,2]</td>
              <td>{{ row.item.p_val_adj.toExponential(2) }}</td>
              <td>{{ row.item.pct_1 }}</td>
              <td>{{ row.item.pct_2 }}</td>
              <td>{{ row.item.pct_2.toExponential(1) * 0.5 }}</td>
              <td>{{ row.item.pct_1.toExponential(1) * 2 }}</td>
              <td>{{ row.item.pct_2.toExponential(1) * 3 }}</td>
            </tr>
          </template>
        </v-data-table>
      </v-col>
    </v-row>
    <v-divider></v-divider>
  </v-card>
</template>

<script>
import { mapState } from 'vuex'
import _ from 'lodash'

export default {
  name: 'SvgInfo',
  components: {},
  props: {
    dataId: {
      type: String,
      required: true
    },
    dataset: {
      type: Array,
      required: true
    },
    ct: {
      type: Array,
      required: true
    }
  },
  async asyncData({ store, error, params }) {
    const defaultDeParams = {
      aDataId: params.id,
      bDataId: params.id,
      type: 'cell_type_specific',
      ct: 'ast'
    }
    try {
      await store.dispatch('ad/fetchDataset', params.id)
      await store.dispatch('ad/fetchDimension', params.id)
      await store.dispatch('ad/fetchDe', defaultDeParams)
      await store.dispatch('ad/fetchDeMeta', params.id)
    } catch (e) {
      error({
        statusCode: 503,
        message: 'ERROR CODE 503,' + params.id
      })
    }
  },
  data() {
    return {
      bDataId: this.dataId,
      type: 'cell_type_specific',
      panel: [],
      searchDe: '',
      keggSearch: '',
      bpSearch: '',
      mfSearch: '',
      ccSearch: '',
      headers: [
        { text: 'Gene name', value: 'gene' },
        { text: 'Log fold-change', value: 'avg_logFC' },
        { text: 'target_domain', value: 'avg_logFC' },
        { text: 'neighbors', value: 'avg_logFC' },
        { text: 'Adjusted p-value', value: 'p_val_adj' },
        { text: 'in_group_fraction', value: 'pct_1' },
        { text: 'out_group_fraction', value: 'pct_2' },
        { text: 'in_out_group_ratio', value: 'pct_1' },
        { text: 'in_group_mean_exp', value: 'pct_1' },
        { text: 'out_group_mean_exp', value: 'pct_2' }
      ],

      groupSelect: {
        groupText: 'Cluster specific genes',
        hint: 'TODO.',
        type: 'cell_type_specific'
      },
      groupItems: [
        {
          groupText: 'Cluster specific genes',
          hint: 'TODO.',
          type: 'cell_type_specific'
        },
        {
          groupText: 'Layer specific genes',
          hint: 'TODO',
          bDataId: 'AD00106',
          type: 'cell_type_specific'
        },
        {
          groupText: 'Spatially variable genes',
          hint: 'TODO.',
          type: 'cell_type_specific'
        }
      ],
      cellTypeSelect: '',
      subclusterSelect: '',
      comparisonSelect: {},
      lfc_slider: 0.05,
      lfc_range: 0.5,
      p_slider: 0.001,
      p_range: '6',
      ticksLabels: [
        '10^-6',
        '10^-5',
        '10^-4',
        '10^-3',
        '0.01',
        '0.05',
        '0.1',
        '1'
      ],
      deDirection: 'all',
      keggResult: [],
      bpResult: [],
      mfResult: [],
      ccResult: [],
      noRegulonJob: [
        '20200615211954',
        '20200615212123',
        '20200615213156',
        '20200616120129',
        '20200616115909',
        '20200616120507'
      ]
    }
  },
  computed: {
    ...mapState({
      de: (state) => state.ad.de.rows,
      n_de: (state) => state.ad.de.count,
      de_meta: (state) => state.ad.deMeta
    }),
    genes() {
      return _.map(this.filterDe, 'gene')
    },

    pSliderValue() {
      switch (this.p_range) {
        case 1:
          return '0.000001'
        case 2:
          return '0.00001'
        case 3:
          return '0.0001'
        case 4:
          return '0.001'
        case 5:
          return '0.01'
        case 6:
          return '0.05'
        case 7:
          return '0.01'
        case 8:
          return '1'
        default:
          return '0'
      }
    },
    subclusterItems() {
      return this.ct
        .filter(
          (item) =>
            item.cell_type === this.cellTypeSelect && item.subcluster !== 'all'
        )
        .map((item) => item.subcluster)
    },
    comparisonItems() {
      return this.de_meta.filter(
        (row) => row.description === this.groupSelect.groupText
      )
    },
    filterDe() {
      switch (this.deDirection) {
        case 'up':
          return this.de.filter(
            (row) =>
              row.avg_logFC >= this.lfc_range &&
              row.p_val_adj <= this.pSliderValue
          )
        case 'down':
          return this.de.filter(
            (row) =>
              row.avg_logFC <= -1 * this.lfc_range &&
              row.p_val_adj <= this.pSliderValue
          )
        default:
          return this.de.filter(
            (row) =>
              (row.avg_logFC <= -1 * this.lfc_range ||
                row.avg_logFC >= this.lfc_range) &&
              row.p_val_adj <= this.pSliderValue
          )
      }
    },
    deErrorMsg() {
      if (
        this.groupSelect.groupText === 'Disease vs control (same region)' &&
        !this.comparisonItems.includes(this.comparisonSelect)
      ) {
        return 'Please select comparison group from the left.'
      } else if (
        this.groupSelect.groupText ===
          'Disease vs disease (different region)' &&
        !this.comparisonItems.includes(this.comparisonSelect)
      ) {
        return 'Please select comparison group from the left.'
      } else if (
        this.groupSelect.groupText === 'Disease vs disease (same region)' &&
        !this.comparisonItems.includes(this.comparisonSelect)
      ) {
        return 'Please select comparison group from the left.'
      } else if (
        this.groupSelect.groupText === 'Subcluster specific genes' &&
        this.subclusterItems.length < 2
      ) {
        return 'Not enough subclusters in this cell type, DE results not available.'
      } else if (
        this.groupSelect.groupText === 'Subcluster specific genes' &&
        !this.subclusterSelect
      ) {
        return 'Please select comparison group from the left.'
      }
      return 'Sorry, no DE genes found in current group.'
    },
    clusterItems() {
      if (this.groupSelect.groupText === 'Cluster specific genes') {
        return [1, 2, 3, 4, 5, 6, 7, 8]
      } else {
        return ['L1', 'L2', 'L3', 'L4', 'L5', 'L6', 'NA', 'WM']
      }
    }
  },
  watch: {},
  created() {
    this.cellTypeSelect = '0'
  },
  methods: {
    async updateDe() {
      if (this.groupSelect.groupText === 'Spatially variable genes') {
        const params = {
          aDataId: this.dataId,
          bDataId: this.dataId,
          type: this.groupSelect.type,
          ct: 'Endothelial cells'
        }
        await this.$store.dispatch('ad/fetchDe', params)
      } else if (this.groupSelect.groupText === 'Layer specific genes') {
        const params = {
          aDataId: this.dataId,
          bDataId: this.dataId,
          type: this.groupSelect.type,
          ct: 'Astrocytes'
        }
        await this.$store.dispatch('ad/fetchDe', params)
      }
    },
    clearDeSelection() {
      this.comparisonSelect = {}
      this.ccResult = []
      this.bpResult = []
      this.mfResult = []
      this.keggResult = []
      this.$store.dispatch('ad/clearDE')
    },
    submitEnrichr(type) {
      if (this.filterDe.length) {
        switch (type) {
          case 'kegg':
            this.sendKegg(this.genes)
            break
          case 'bp':
            this.sendBp(this.genes)
            break
          case 'mf':
            this.sendMf(this.genes)
            break
          case 'cc':
            this.sendCc(this.genes)
            break
        }
      }
    },
    async copyGenes(genes) {
      try {
        await this.$copyText(genes.join('\n'))
      } catch (e) {
        console.error(e)
      }
    }
  }
}
</script>

<style lang="scss"></style>
