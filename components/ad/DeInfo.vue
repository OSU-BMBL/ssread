<template>
  <v-hover v-slot:default="{ hover }" open-delay="0">
    <v-card
      class="mx-auto"
      :elevation="hover ? 10 : 2"
      :class="{ 'on-hover': hover }"
    >
      <v-card-title class="primary white--text title-1"
        >Differential expression (DE) / Gene set enrichment
      </v-card-title>
      <v-card-text>
        <p class="display-1 text--primary"></p>
      </v-card-text>
      <v-row xs="12" md="8" lg="12">
        <v-col cols="md-6 lg-6">
          <v-col xs="12" md="10" lg="10" class="px-4 py-0 my-2">
            <p class="subtitle-1 font-weight-bold py-0 my-2">
              Group:
              <v-tooltip top>
                <template v-slot:activator="{ on, attrs }">
                  <v-icon color="primary" dark v-bind="attrs" v-on="on"
                    >mdi-help-circle-outline</v-icon
                  >
                </template>
                <span>tolltip.</span>
              </v-tooltip>
            </p>
            <v-select
              v-model="comparisonSelect"
              :hint="` ${comparisonSelect.hint}`"
              :items="comparisonItems"
              item-text="comparisonText"
              item-value="hint"
              label="DE Comparison type:"
              return-object
              single-line
              persistent-hint
              @change="updateDe()"
            ></v-select>
          </v-col>
          <v-col xs="12" md="10" lg="10" class="px-4 py-0 my-2">
            <p class="subtitle-1 font-weight-bold py-0 my-2">
              Cell type of interest:
              <v-tooltip top>
                <template v-slot:activator="{ on, attrs }">
                  <v-icon color="primary" dark v-bind="attrs" v-on="on"
                    >mdi-help-circle-outline</v-icon
                  >
                </template>
                <span>tolltip.</span>
              </v-tooltip>
            </p>
            <v-select
              v-model="cellTypeSelect"
              :items="cellTypeItems"
              item-text="type"
              item-value="abbr"
              label="Cell type of interest"
              return-object
              single-line
              @change="updateDe()"
            ></v-select>
          </v-col>

          <v-row>
            <v-col xs="12" md="10" lg="11" class="px-7 py-0 my-2">
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
                    style="width: 80px"
                  ></v-text-field>
                </template>
              </v-slider>
            </v-col>
          </v-row>
          <v-row>
            <v-col xs="12" md="10" lg="11" class="px-7 py-0 my-2">
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
                    style="width: 80px"
                  ></v-text-field> </template
              ></v-slider>
            </v-col>
          </v-row>
          <v-col cols="12" md="8">
            <v-radio-group v-model="deDirection" row>
              <span class="subtitle-1 font-weight-bold">DE direction: </span>
              <v-radio label="All" value="all"></v-radio>
              <v-radio label="UP" value="up"></v-radio>
              <v-radio label="Down" value="down"></v-radio>
            </v-radio-group>
          </v-col>
        </v-col>

        <v-col cols="md-6 lg-8">
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
            <template v-slot:top>
              <v-toolbar flat>
                <v-toolbar-title
                  >DE genes
                  {{ comparisonSelect.hint }}
                  <v-btn color="primary">
                    Download
                  </v-btn></v-toolbar-title
                >
                <v-spacer></v-spacer>
              </v-toolbar>
            </template>
          </v-data-table>
        </v-col>
      </v-row>
      <v-divider></v-divider>
      <v-expansion-panels v-model="panel" hover multiple>
        <v-expansion-panel>
          <v-expansion-panel-header>KEGG pathway</v-expansion-panel-header>
          <v-expansion-panel-content>
            <v-text-field
              v-model="keggSearch"
              prepend-icon="mdi-magnify"
              label="Search"
              single-line
              hide-details
            ></v-text-field>
            <v-data-table
              dense
              :search="keggSearch"
              :headers="enrichHeaders"
              :items="keggResult"
              :items-per-page="10"
              class="elevation-1"
              :expanded.sync="expanded"
              show-expand
            >
              <template v-slot:top>
                <v-toolbar flat>
                  <v-toolbar-title>
                    KEGG Pathway
                    <v-tooltip top>
                      <template v-slot:activator="{ on, attrs }">
                        <v-icon color="primary" dark v-bind="attrs" v-on="on"
                          >mdi-help-circle-outline</v-icon
                        >
                      </template>
                      <span
                        >KEGG Pathway enrichment analysis using the DE genes
                        above.</span
                      > </v-tooltip
                    ><v-btn color="primary">
                      Download
                    </v-btn></v-toolbar-title
                  >
                  <v-spacer></v-spacer>
                </v-toolbar>
              </template>
              <template v-slot:expanded-item="{ item }">
                <td :colspan="headers.length">
                  {{ item.genes.join(',') }}
                </td>
              </template>
            </v-data-table>
          </v-expansion-panel-content>
        </v-expansion-panel>

        <v-expansion-panel>
          <v-expansion-panel-header
            >GO: Biological Process</v-expansion-panel-header
          >
          <v-expansion-panel-content>
            <v-text-field
              v-model="bpSearch"
              prepend-icon="mdi-magnify"
              label="Search"
              single-line
              hide-details
            ></v-text-field>
            <v-data-table
              dense
              :search="bpSearch"
              :headers="enrichHeaders"
              :items="bpResult"
              :items-per-page="10"
              class="elevation-1"
              :expanded.sync="expanded"
              show-expand
            >
              <template v-slot:top>
                <v-toolbar flat>
                  <v-toolbar-title
                    >GO: Biological Process<v-tooltip top>
                      <template v-slot:activator="{ on, attrs }">
                        <v-icon color="primary" dark v-bind="attrs" v-on="on"
                          >mdi-help-circle-outline</v-icon
                        >
                      </template>
                      <span
                        >GO: Biological Process enrichment analysis using the DE
                        genes above.</span
                      > </v-tooltip
                    ><v-btn color="primary">
                      Download
                    </v-btn>
                  </v-toolbar-title>
                  <v-spacer></v-spacer>
                </v-toolbar>
              </template>
              <template v-slot:expanded-item="{ item }">
                <td :colspan="headers.length">
                  {{ item.genes.join(',') }}
                </td>
              </template>
            </v-data-table>
          </v-expansion-panel-content>
        </v-expansion-panel>

        <v-expansion-panel>
          <v-expansion-panel-header
            >GO: Molecular Function</v-expansion-panel-header
          >
          <v-expansion-panel-content>
            <v-text-field
              v-model="mfSearch"
              prepend-icon="mdi-magnify"
              label="Search"
              single-line
              hide-details
            ></v-text-field>
            <v-data-table
              dense
              :search="mfSearch"
              :headers="enrichHeaders"
              :items="mfResult"
              :items-per-page="10"
              class="elevation-1"
              :expanded.sync="expanded"
              show-expand
            >
              <template v-slot:top>
                <v-toolbar flat>
                  <v-toolbar-title
                    >GO: Molecular Function<v-tooltip top>
                      <template v-slot:activator="{ on, attrs }">
                        <v-icon color="primary" dark v-bind="attrs" v-on="on"
                          >mdi-help-circle-outline</v-icon
                        >
                      </template>
                      <span
                        >GO: Molecular Function enrichment analysis using the DE
                        genes above.</span
                      > </v-tooltip
                    ><v-btn color="primary">
                      Download
                    </v-btn></v-toolbar-title
                  >
                  <v-spacer></v-spacer>
                </v-toolbar>
              </template>
              <template v-slot:expanded-item="{ item }">
                <td :colspan="headers.length">
                  {{ item.genes.join(',') }}
                </td>
              </template>
            </v-data-table>
          </v-expansion-panel-content>
        </v-expansion-panel>
        <v-expansion-panel>
          <v-expansion-panel-header
            >GO: Cellular Component</v-expansion-panel-header
          >
          <v-expansion-panel-content>
            <v-text-field
              v-model="ccSearch"
              prepend-icon="mdi-magnify"
              label="Search"
              single-line
              hide-details
            ></v-text-field>
            <v-data-table
              dense
              :search="ccSearch"
              :headers="enrichHeaders"
              :items="ccResult"
              :items-per-page="10"
              class="elevation-1"
              :expanded.sync="expanded"
              show-expand
            >
              <template v-slot:top>
                <v-toolbar flat>
                  <v-toolbar-title
                    >GO: Cellular Component<v-tooltip top>
                      <template v-slot:activator="{ on, attrs }">
                        <v-icon color="primary" dark v-bind="attrs" v-on="on"
                          >mdi-help-circle-outline</v-icon
                        >
                      </template>
                      <span
                        >GO: Cellular Component enrichment analysis using the DE
                        genes above.</span
                      > </v-tooltip
                    ><v-btn color="primary">
                      Download
                    </v-btn>
                  </v-toolbar-title>
                  <v-spacer></v-spacer>
                </v-toolbar>
              </template>
              <template v-slot:expanded-item="{ item }">
                <td :colspan="headers.length">
                  {{ item.genes.join(',') }}
                </td>
              </template>
            </v-data-table>
          </v-expansion-panel-content>
        </v-expansion-panel>
        <v-expansion-panel>
          <v-expansion-panel-header
            >Cell-type-specific regulons</v-expansion-panel-header
          >
          <v-expansion-panel-content>
            <regulon-info :data-id="dataId"></regulon-info
          ></v-expansion-panel-content>
        </v-expansion-panel>
      </v-expansion-panels>
      <v-row>
        <v-col xs="12" md="6" lg="6"> </v-col>
      </v-row>
    </v-card>
  </v-hover>
</template>

<script>
import { mapState } from 'vuex'
import axios from 'axios'
import FormData from 'form-data'
import _ from 'lodash'
import RegulonInfo from '@/components/ad/RegulonInfo'
export default {
  name: 'DeInfo',
  components: {
    'regulon-info': RegulonInfo
  },
  props: {
    dataId: {
      type: String,
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
      ct: 'ast',
      panel: [],
      searchDe: '',
      keggSearch: '',
      bpSearch: '',
      mfSearch: '',
      ccSearch: '',
      headers: [
        { text: 'Gene name', value: 'gene' },
        { text: 'Log fold-change', value: 'avg_logFC' },
        { text: 'Adjusted p-value', value: 'p_val_adj' }
        /* ,
        { text: 'Cell type', value: 'ct' },
        { text: 'Comparison type', value: 'type' } */
      ],
      enrichHeaders: [
        { text: 'Index', value: 'index' },
        { text: 'Name', value: 'name' },
        { text: 'Adjusted p-value', value: 'adjPvalue' },
        { text: 'Odds ratio', value: 'odd' },
        { text: 'Combined score', value: 'score' },
        { text: '', value: 'data-table-expand' }
      ],
      expanded: [],
      comparison: [
        'Cell type specific genes',
        'Disease vs disease (same region, different ** )',
        'Disease vs disease (based on stage)',
        'Subcluster specific genes'
      ],
      comparisonSelect: {
        comparisonText: 'Cell type specific genes',
        hint:
          'Find differentially expressed genes in each cell type by comparing it to all of the others.',
        bDataId: 'AD00103',
        type: 'cell_type_specific'
      },
      comparisonItems: [
        {
          comparisonText: 'Cell type specific genes',
          hint:
            'Find differentially expressed genes in each cell type by comparing it to all of the others.',
          bDataId: 'AD00103',
          type: 'cell_type_specific'
        },
        {
          comparisonText: 'Control vs disease (same region)',
          hint:
            'Compare current dataset with control dataset: H-H-Prefrontal cortex-Female (AD00106)',
          bDataId: 'AD001063',
          type: 'a_vs_b'
        },
        {
          comparisonText: 'Disease vs disease (same region)',
          hint:
            'Compare current dataset with disease dataset: H-AD.late-Prefrontal cortex-Male_001 (AD00102)',
          bDataId: 'AD00102',
          type: 'a_vs_b'
        },
        {
          comparisonText: 'Disease vs disease (different region)',
          hint:
            'Compare current dataset with disease dataset: H-AD.earyly-Prefrontal cortex-female_001 (AD00104)',
          bDataId: 'AD00105',
          type: 'a_vs_b'
        },
        {
          comparisonText: 'Disease vs disease (different region)',
          hint:
            'Compare current dataset with disease dataset: H-AD.earyly-Prefrontal cortex-female_001 (AD00104)',
          bDataId: 'AD00105',
          type: 'a_vs_b'
        },
        {
          comparisonText: 'Subcluster specific genes',
          hint:
            'Comparing the subcluster of interest against other subclusters within the same cell type.',
          bDataId: 'AD00103',
          type: 'subcluster'
        }
      ],
      cellTypeSelect: {
        type: 'Astrocytes',
        abbr: 'ast'
      },
      cellTypeItems: [
        {
          type: 'Astrocytes',
          abbr: 'ast'
        },
        {
          type: 'Microglia',
          abbr: 'mic'
        },
        { type: 'Endothelial cells', abbr: 'end' },
        { type: 'Excitatory neurons', abbr: 'exc' },
        { type: 'Inhibitory neurons', abbr: 'inh' },
        {
          type: 'Oligodendrocytes',
          abbr: 'oli'
        },
        { type: 'Oligodendrocyte precursor cells', abbr: 'opc' },
        { type: 'Pericytes', abbr: 'per' }
      ],
      cellType: [
        'Astrocytes',
        'Microglia',
        'Endothelial cells',
        'Excitatory neurons',
        'Inhibitory neurons',
        'Oligodendrocytes',
        'Oligodendrocyte precursor cells',
        'Pericytes'
      ],
      lfc_slider: 0.05,
      lfc_range: 1,
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
      ccResult: []
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
    filterDe() {
      switch (this.deDirection) {
        case 'up':
          return this.de
            .map((row) => {
              return Object.assign({}, row, {
                p_val_adj: row.p_val_adj.toExponential(6)
              })
            })
            .filter(
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
    }
  },
  watch: {
    filterDe() {
      this.sendKegg(this.genes)
      this.sendBp(this.genes)
      this.sendMf(this.genes)
      this.sendCc(this.genes)
    }
  },
  methods: {
    async sendKegg(genes) {
      const geneSetLibrary = 'KEGG_2019_Human'
      const formData = new FormData()
      formData.append('method', 'post')
      formData.append('name', 'list')
      formData.append('enctype', 'multipart/form-data')
      formData.append('list', genes.join('\n'))
      formData.append('description', 'test test')
      const geneListEnrichrId = await axios
        .post('https://amp.pharm.mssm.edu/Enrichr/addList', formData)
        .then(function(response) {
          return response.data.userListId
        })
      const enrichrResult = await axios
        .get(
          'https://amp.pharm.mssm.edu/Enrichr/enrich?userListId=' +
            geneListEnrichrId +
            '&backgroundType=' +
            geneSetLibrary
        )
        .then(function(response) {
          return response.data
        })
      this.keggResult = enrichrResult.KEGG_2019_Human.map((value) => ({
        index: value[0],
        name: value[1],
        pvalue: value[2],
        odd: value[3].toFixed(2),
        score: value[4].toFixed(2),
        genes: value[5],
        adjPvalue: value[6].toExponential(4),
        key8: value[7]
      }))
      return enrichrResult
    },
    async sendBp(genes) {
      const geneSetLibrary = 'GO_Biological_Process_2018'
      const formData = new FormData()
      formData.append('method', 'post')
      formData.append('name', 'list')
      formData.append('enctype', 'multipart/form-data')
      formData.append('list', genes.join('\n'))
      formData.append('description', 'test test')
      const geneListEnrichrId = await axios
        .post('https://amp.pharm.mssm.edu/Enrichr/addList', formData)
        .then(function(response) {
          return response.data.userListId
        })
      const enrichrResult = await axios
        .get(
          'https://amp.pharm.mssm.edu/Enrichr/enrich?userListId=' +
            geneListEnrichrId +
            '&backgroundType=' +
            geneSetLibrary
        )
        .then(function(response) {
          return response.data
        })
        .catch(() => {
          return { GO_Biological_Process_2018: [[1, 'not found']] }
        })
      console.log(enrichrResult)
      this.bpResult = enrichrResult.GO_Biological_Process_2018.map((value) => ({
        index: value[0],
        name: value[1],
        pvalue: value[2],
        odd: value[3].toFixed(2),
        score: value[4].toFixed(2),
        genes: value[5],
        adjPvalue: value[6].toExponential(4),
        key8: value[7]
      }))
      return enrichrResult
    },
    async sendMf(genes) {
      const geneSetLibrary = 'GO_Molecular_Function_2018'
      const formData = new FormData()
      formData.append('method', 'post')
      formData.append('name', 'list')
      formData.append('enctype', 'multipart/form-data')
      formData.append('list', genes.join('\n'))
      formData.append('description', 'test test')
      const geneListEnrichrId = await axios
        .post('https://amp.pharm.mssm.edu/Enrichr/addList', formData)
        .then(function(response) {
          return response.data.userListId
        })
      const enrichrResult = await axios
        .get(
          'https://amp.pharm.mssm.edu/Enrichr/enrich?userListId=' +
            geneListEnrichrId +
            '&backgroundType=' +
            geneSetLibrary
        )
        .then(function(response) {
          return response.data
        })
      this.mfResult = enrichrResult.GO_Molecular_Function_2018.map((value) => ({
        index: value[0],
        name: value[1],
        pvalue: value[2],
        odd: value[3].toFixed(2),
        score: value[4].toFixed(2),
        genes: value[5],
        adjPvalue: value[6].toExponential(4),
        key8: value[7]
      }))
      return enrichrResult
    },
    async sendCc(genes) {
      const geneSetLibrary = 'GO_Cellular_Component_2018'
      const formData = new FormData()
      formData.append('method', 'post')
      formData.append('name', 'list')
      formData.append('enctype', 'multipart/form-data')
      formData.append('list', genes.join('\n'))
      formData.append('description', 'test test')
      const geneListEnrichrId = await axios
        .post('https://amp.pharm.mssm.edu/Enrichr/addList', formData)
        .then(function(response) {
          return response.data.userListId
        })
      const enrichrResult = await axios
        .get(
          'https://amp.pharm.mssm.edu/Enrichr/enrich?userListId=' +
            geneListEnrichrId +
            '&backgroundType=' +
            geneSetLibrary
        )
        .then(function(response) {
          return response.data
        })
      this.ccResult = enrichrResult.GO_Cellular_Component_2018.map((value) => ({
        index: value[0],
        name: value[1],
        pvalue: value[2],
        odd: value[3].toFixed(2),
        score: value[4].toFixed(2),
        genes: value[5],
        adjPvalue: value[6].toExponential(4),
        key8: value[7]
      }))
      return enrichrResult
    },

    async updateDe() {
      const params = {
        aDataId: this.dataId,
        bDataId: this.comparisonSelect.bDataId,
        type: this.comparisonSelect.type,
        ct: this.cellTypeSelect.abbr
      }
      await this.$store.dispatch('ad/fetchDe', params)
    }
  }
}
</script>

<style lang="scss" scoped>
.v-messages__message {
  line-height: 16px;
  font-size: 14px;
}
</style>
