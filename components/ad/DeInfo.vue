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
        <v-col cols="md-6 lg-7">
          <v-col xs="12" md="10" lg="10" class="px-4 py-0 my-2">
            <p class="subtitle-1 font-weight-bold py-0 my-2">
              Group:
              <v-tooltip top>
                <template v-slot:activator="{ on, attrs }">
                  <v-icon color="primary" dark v-bind="attrs" v-on="on"
                    >mdi-help-circle-outline</v-icon
                  >
                </template>
                <span
                  >Select differential expression test group between two
                  specific set of cells.
                </span>
              </v-tooltip>
            </p>
            <v-select
              v-model="groupSelect"
              :hint="` ${groupSelect.hint}`"
              :items="groupItems"
              item-text="groupText"
              item-value="hint"
              label="DE Comparison type:"
              return-object
              single-line
              persistent-hint
              @change="
                updateDe()
                clearDeSelection()
              "
            ></v-select> </v-col
          ><v-col
            v-show="
              groupSelect.groupText !== 'Cell type specific genes' &&
                groupSelect.groupText !== 'Subcluster specific genes'
            "
            xs="12"
            md="10"
            lg="10"
            class="px-4 py-0 my-2"
          >
            <p class="subtitle-1 font-weight-bold py-0 my-2">
              Dataset:
              <v-tooltip top>
                <template v-slot:activator="{ on, attrs }">
                  <v-icon color="primary" dark v-bind="attrs" v-on="on"
                    >mdi-help-circle-outline</v-icon
                  >
                </template>
                <span
                  >Based on the group information above, select data to compare
                  with the current one.</span
                >
              </v-tooltip>
            </p>
            <v-select
              v-model="comparisonSelect"
              :hint="comparisonSelect.hint"
              :items="comparisonItems"
              item-text="value"
              item-value="value"
              label="Select:"
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
                <span
                  >Select the cell type of interest to perform differential
                  expresison analysis.</span
                >
              </v-tooltip>
            </p>
            <v-select
              v-model="cellTypeSelect"
              :items="cellTypeItems"
              label="Cell type of interest"
              return-object
              single-line
              @change="updateDe()"
            ></v-select>
          </v-col>
          <v-col
            v-if="groupSelect.groupText === 'Subcluster specific genes'"
            xs="12"
            md="10"
            lg="10"
            class="px-4 py-0 my-2"
          >
            <p class="subtitle-1 font-weight-bold py-0 my-2">
              Subcluster:
              <v-tooltip top>
                <template v-slot:activator="{ on, attrs }">
                  <v-icon color="primary" dark v-bind="attrs" v-on="on"
                    >mdi-help-circle-outline</v-icon
                  >
                </template>
                <span
                  >Based on the group information above, select data to compare
                  with the current one.</span
                >
              </v-tooltip>
            </p>
            <v-select
              v-model="subclusterSelect"
              :items="subclusterItems"
              label="Select:"
              return-object
              single-line
              @change="updateDe()"
            ></v-select>
          </v-col>

          <v-row>
            <v-col xs="12" md="12" lg="12" class="px-7 py-0 my-2">
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
          </v-row>
          <v-row>
            <v-col xs="12" md="12" lg="12" class="px-7 py-0 my-2">
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
              <span class="subtitle-1 font-weight-bold">DE direction: </span>
              <v-radio label="All" value="all"></v-radio>
              <v-radio label="UP" value="up"></v-radio>
              <v-radio label="Down" value="down"></v-radio>
            </v-radio-group>
          </v-col>
        </v-col>

        <v-col cols="md-5 lg-5">
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
                <td>{{ row.item.p_val_adj }}</td>
              </tr>
            </template>
          </v-data-table>
        </v-col>
      </v-row>
      <v-divider></v-divider>
      <v-expansion-panels v-model="panel" hover multiple>
        <v-expansion-panel>
          <v-expansion-panel-header @click="submitEnrichr('kegg')"
            >KEGG pathway
          </v-expansion-panel-header>
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
              item-key="index"
              class="elevation-1"
              :expanded.sync="expandedKegg"
              show-expand
            >
              <template v-slot:top>
                <v-toolbar flat>
                  <v-toolbar-title>
                    <download-excel :data="keggResult" type="csv">
                      <v-btn color="primary"> Download</v-btn
                      ><v-tooltip top>
                        <template v-slot:activator="{ on, attrs }">
                          <v-icon color="primary" dark v-bind="attrs" v-on="on"
                            >mdi-help-circle-outline</v-icon
                          >
                        </template>
                        <span
                          >KEGG Pathway enrichment analysis using the DE genes
                          above. The results are calculated real-time using
                          Enrichr.</span
                        >
                      </v-tooltip>
                    </download-excel></v-toolbar-title
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
          <v-expansion-panel-header @click="submitEnrichr('bp')"
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
              item-key="index"
              class="elevation-1"
              :expanded.sync="expandedBp"
              show-expand
            >
              <template v-slot:top>
                <v-toolbar flat>
                  <v-toolbar-title
                    ><download-excel :data="bpResult" type="csv">
                      <v-btn color="primary"> Download</v-btn
                      ><v-tooltip top>
                        <template v-slot:activator="{ on, attrs }">
                          <v-icon color="primary" dark v-bind="attrs" v-on="on"
                            >mdi-help-circle-outline</v-icon
                          >
                        </template>
                        <span
                          >GO: Biological Process enrichment analysis using the
                          DE genes above. The results are calculated real-time
                          using Enrichr.</span
                        >
                      </v-tooltip>
                    </download-excel>
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
          <v-expansion-panel-header @click="submitEnrichr('mf')"
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
              item-key="index"
              class="elevation-1"
              :expanded.sync="expandedMf"
              show-expand
            >
              <template v-slot:top>
                <v-toolbar flat>
                  <v-toolbar-title
                    ><download-excel :data="mfResult" type="csv">
                      <v-btn color="primary"> Download</v-btn
                      ><v-tooltip top>
                        <template v-slot:activator="{ on, attrs }">
                          <v-icon color="primary" dark v-bind="attrs" v-on="on"
                            >mdi-help-circle-outline</v-icon
                          >
                        </template>
                        <span
                          >GO: Molecular Function enrichment analysis using the
                          DE genes above. The results are calculated real-time
                          using Enrichr.</span
                        >
                      </v-tooltip>
                    </download-excel></v-toolbar-title
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
          <v-expansion-panel-header @click="submitEnrichr('cc')"
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
              item-key="index"
              class="elevation-1"
              :expanded.sync="expandedCc"
              show-expand
            >
              <template v-slot:top>
                <v-toolbar flat>
                  <v-toolbar-title>
                    <download-excel :data="ccResult" type="csv">
                      <v-btn color="primary"> Download</v-btn
                      ><v-tooltip top>
                        <template v-slot:activator="{ on, attrs }">
                          <v-icon color="primary" dark v-bind="attrs" v-on="on"
                            >mdi-help-circle-outline</v-icon
                          >
                        </template>
                        <span
                          >GO: Cellular Component enrichment analysis using the
                          DE genes above. The results are calculated real-time
                          using Enrichr.</span
                        >
                      </v-tooltip>
                    </download-excel>
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
        <v-expansion-panel
          v-show="
            groupSelect.groupText === 'Cell type specific genes' &&
              !noRegulonJob.includes(dataset[0].iris3_jobid) &&
              dataset[0].iris3_jobid !== 'NA'
          "
        >
          <v-expansion-panel-header
            >Cell-type-specific regulons
          </v-expansion-panel-header>
          <v-expansion-panel-content>
            <regulon-info
              :data-id="dataId"
              :jobid="dataset[0].iris3_jobid"
            ></regulon-info
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
      expandedKegg: [],
      expandedBp: [],
      expandedMf: [],
      expandedCc: [],
      groupSelect: {
        groupText: 'Cell type specific genes',
        hint:
          'Find differentially expressed genes in each cell type by comparing it to all of the others.',
        type: 'cell_type_specific'
      },
      groupItems: [
        {
          groupText: 'Cell type specific genes',
          hint:
            'Find differentially expressed genes in each cell type by comparing it to all of the others.',
          type: 'cell_type_specific'
        },
        {
          groupText: 'Control vs disease (same region)',
          hint:
            'Compare control with disease dataset in the same species, region, gender and age.',
          bDataId: 'AD00106',
          type: 'a_vs_b'
        },
        {
          groupText: 'Disease vs disease (same region)',
          hint:
            'Compare two disease datasets in the same species, region, gender and age.',
          type: 'a_vs_b'
        },
        {
          groupText: 'Disease vs disease (different region)',
          hint:
            'Compare two disease datasets in the same species, gender and age but in different region.',
          type: 'a_vs_b'
        },
        {
          groupText: 'Subcluster specific genes',
          hint:
            'Comparing the subcluster of interest against other subclusters within the same cell type.',
          type: 'subcluster'
        }
      ],
      cellTypeSelect: '',
      subclusterSelect: '',
      comparisonSelect: {},
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
    cellTypeItems() {
      return _.map(this.ct, 'cell_type')
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
      return [0, 1, 2]
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
        this.groupSelect.groupText === 'Control vs disease (same region)' &&
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
        !this.comparisonItems.includes(this.comparisonSelect)
      ) {
        return 'Please select comparison group from the left.'
      }
      return 'Sorry, no DE genes found in current group.'
    }
  },
  watch: {
    filterDe() {
      if (this.filterDe.length) {
        if (this.panel.includes(0)) {
          this.sendKegg(this.genes)
        }
        if (this.panel.includes(1)) {
          this.sendBp(this.genes)
        }
        if (this.panel.includes(2)) {
          this.sendMf(this.genes)
        }
        if (this.panel.includes(3)) {
          this.sendCc(this.genes)
        }
      }
    }
  },
  created() {
    this.cellTypeSelect = this.ct[0].cell_type
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
      if (this.groupSelect.groupText === 'Cell type specific genes') {
        const params = {
          aDataId: this.dataId,
          bDataId: this.dataId,
          type: this.groupSelect.type,
          ct: this.cellTypeSelect
        }
        await this.$store.dispatch('ad/fetchDe', params)
      } else if (this.groupSelect.groupText === 'Subcluster specific genes') {
        const params = {
          aDataId: this.dataId,
          bDataId: this.subclusterSelect,
          type: this.groupSelect.type,
          ct: this.cellTypeSelect
        }
        if (params.bDataId !== '') {
          await this.$store.dispatch('ad/fetchDe', params)
        }
      } else if (this.comparisonItems.includes(this.comparisonSelect)) {
        const params = {
          aDataId: this.comparisonSelect.data_id,
          bDataId: this.comparisonSelect.b_data_id,
          type: this.groupSelect.type,
          ct: this.cellTypeSelect
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
    }
  }
}
</script>

<style lang="scss"></style>
