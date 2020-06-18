<template>
  <v-hover v-slot:default="{ hover }" open-delay="0">
    <v-card
      class="mx-auto"
      :elevation="hover ? 10 : 2"
      :class="{ 'on-hover': hover }"
    >
      <v-card-title class="primary white--text title-1"
        >Cell clustering</v-card-title
      >
      <v-card-text>
        <p class="my-3 text--primary"></p>
        <p class="display-1 text--primary"></p>
        <v-row>
          <v-col xs="12" md="8" lg="3" class="px-4 py-0 my-0">
            <p class="subtitle-1 font-weight-bold text--primary">
              Cell type & subcluster:<v-tooltip top>
                <template v-slot:activator="{ on, attrs }">
                  <v-icon color="primary" dark v-bind="attrs" v-on="on"
                    >mdi-help-circle-outline</v-icon
                  >
                </template>
                <span>Tooltip</span>
              </v-tooltip>
            </p>

            <v-select
              v-model="clusterCoordinatesSelect"
              :items="clusterCoordinatesItems"
              item-text="text"
              item-value="value"
              label=""
              return-object
              lg="3"
            ></v-select>
            <p class=" text--primary">
              ARI score compared with cell labels provided in the original
              paper: 0.9827172<v-tooltip top>
                <template v-slot:activator="{ on, attrs }">
                  <v-icon color="primary" dark v-bind="attrs" v-on="on"
                    >mdi-help-circle-outline</v-icon
                  >
                </template>
                <span
                  >Adjusted Rand Index (ARI) computes a similarity measure
                  between two clusterings by considering all pairs of cells and
                  counting pairs that are assigned in the same or different
                  clusters in the predicted and true clusterings.</span
                >
              </v-tooltip>
            </p>
          </v-col>
          <v-col xs="12" md="8" lg="3" class="px-4 py-0 my-0"> </v-col>
          <v-col xs="12" md="8" lg="3" class="px-4 py-0 my-0">
            <p class="subtitle-1 font-weight-bold text--primary">
              Gene expression<v-tooltip top>
                <template v-slot:activator="{ on, attrs }">
                  <v-icon color="primary" dark v-bind="attrs" v-on="on"
                    >mdi-help-circle-outline</v-icon
                  >
                </template>
                <span>Tooltip</span>
              </v-tooltip>
            </p>
            <v-autocomplete
              v-model="gene"
              :items="allGenes"
              label="Select or search gene name:"
              @change="updateExpression()"
            ></v-autocomplete>
          </v-col>
        </v-row>
        <no-ssr>
          <v-row>
            <v-col xs="12" md="12" lg="6" class="px-4 py-0 my-0">
              <vue-plotly
                :data="allCellDim"
                :layout="layout"
                :options="options"
              />
            </v-col>
            <v-col xs="12" md="12" lg="6" class="px-4 py-0 my-0">
              <vue-plotly
                :data="expressionDim"
                :layout="layout"
                :options="options"
              />
            </v-col>
          </v-row>
        </no-ssr>
      </v-card-text>
    </v-card>
  </v-hover>
</template>

<script>
import _ from 'lodash'
import { mapState } from 'vuex' // <--- To map data from Vuex

export default {
  name: 'DimensionInfo',
  components: {},
  props: {
    dimension: {
      type: Array,
      required: true
    }
  },

  data() {
    return {
      allGenes: [
        `MIR1302-10`,
        `RP11-34P13.7`,
        `AL627309.1`,
        `AP006222.2`,
        `RP4-669L17.10`
      ],
      gene: null,
      search: '',
      headers: [
        { text: 'Gene name', value: 'gene' },
        { text: 'Log fold-change', value: 'avg_logFC' },
        { text: 'Adjusted p-value', value: 'p_val_adj' }
      ],
      clusterCoordinatesSelect: {
        text: 'All cell types'
      },
      clusterCoordinatesItems: [
        {
          text: 'All cell types'
        },
        {
          text: 'Astrocytes'
        },
        {
          text: 'Microglia'
        },
        {
          text: 'Endothelial cells'
        },
        {
          text: 'Excitatory neurons'
        },
        {
          text: 'Inhibitory neurons'
        },
        {
          text: 'Oligodendrocytes'
        },
        {
          text: 'Oligodendrocyte precursor cells'
        },
        {
          text: 'Pericytes'
        }
      ],
      colorSelect: {
        text: 'Cell type'
      },
      colorItems: [
        {
          text: 'Cell type'
        },
        {
          text: 'Group'
        },
        {
          text: 'pca_1'
        },
        {
          text: 'pca_2'
        },
        {
          text: 'pca_3'
        }
      ],
      color1: ['Group', 'Sex', 'Stage'],
      enrich: [],
      layout: {
        autosize: true,
        width: 700,
        height: 800,
        legend: {
          font: {
            size: 14
          },
          orientation: 'h',
          marker: {
            size: 20
          }
        },
        xaxis: {
          title: {
            text: 'UMAP_1',
            font: {
              size: 18
            }
          }
        },
        yaxis: {
          title: {
            text: 'UMAP_2',
            font: {
              size: 18
            }
          }
        }
      },
      options: {
        legenditem: {
          textfont: {
            color: 'red'
          },
          marker: {
            size: 20,
            symbol: 'circle'
          }
        }
      }
    }
  },
  computed: {
    ...mapState({
      expression: (state) => state.ad.expression
    }),
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
    },
    allCellDim() {
      function getTrace(dim, cellType, customColor) {
        const cuurentDimension = dim.filter((row) => row.cell_type === cellType)
        const X = _.map(cuurentDimension, 'umap_1')
        const Y = _.map(cuurentDimension, 'umap_2')
        const cellNames = _.map(cuurentDimension, 'cell_name')

        const trace = {
          x: X,
          y: Y,
          legendItems: {
            textfont: {
              color: 'red'
            },
            marker: {
              size: 20,
              symbol: 'circle'
            }
          },
          marker: {
            size: 2,
            symbol: 'circle'
          },
          mode: 'markers',
          type: 'scatter',
          name: cellType,
          text: cellNames
        }
        return trace
      }

      const trace1 = getTrace(this.dimension, 'Astrocytes', '#E64B35FF')
      const trace2 = getTrace(this.dimension, 'Microglia', '#4DBBD5FF')
      const trace3 = getTrace(this.dimension, 'Endothelial cells', '#00A087FF')
      const trace4 = getTrace(this.dimension, 'Excitatory neurons', '#3C5488FF')
      const trace5 = getTrace(this.dimension, 'Inhibitory neurons', '#F39B7FFF')
      const trace6 = getTrace(this.dimension, 'Oligodendrocytes', '#8491B499')
      const trace7 = getTrace(
        this.dimension,
        'Oligodendrocyte precursor cells',
        '#91D1C2FF'
      )
      const trace8 = getTrace(this.dimension, 'Pericytes', '#7E6148FF')
      return [trace1, trace2, trace3, trace4, trace5, trace6, trace7, trace8]
    },
    expressionDim() {
      const X = _.map(this.dimension, 'umap_1')
      const Y = _.map(this.dimension, 'umap_2')
      const cellNames = _.map(this.dimension, 'cell_name')
      const customColor = _.map(this.expression, 'expression')
      const trace = {
        x: X,
        y: Y,
        mode: 'markers',
        text: cellNames,
        marker: {
          size: 2,
          color: customColor
        }
      }
      return [trace]
    }
  },
  methods: {
    async updateDimension() {
      await this.$store.dispatch('ad/getDimension', this.gene)
    },
    async updateExpression() {
      await this.$store.dispatch('ad/fetchExpression', this.gene)
    }
  }
}
</script>

<style lang="scss" scoped></style>
