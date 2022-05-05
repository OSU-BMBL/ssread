<template>
  <v-hover v-slot:default="{ hover }" open-delay="0">
    <v-card
      class="mx-auto"
      :elevation="hover ? 6 : 2"
      :class="{ 'on-hover': hover }"
    >
      <v-card-title class="primary white--text title-1"
        >Cell clustering
      </v-card-title>
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
                <span
                  >Select UMAP coordinates source, either using all cells or
                  subset of a specific cell type.</span
                >
              </v-tooltip>
            </p>

            <v-autocomplete
              v-model="clusterCoordinatesSelect"
              :items="clusterCoordinatesItems"
              item-text="cell_type"
              item-value="cell_type"
              label=""
              return-object
              lg="3"
              @change="updateCluster()"
            ></v-autocomplete>
            <p
              v-if="
                clusterCoordinatesSelect === 'All cell types' &&
                  dataset[0].ari_score !== 'NA'
              "
              class="text--primary"
            >
              ARI score: {{ dataset[0].ari_score }}
              <v-tooltip top>
                <template v-slot:activator="{ on, attrs }">
                  <v-icon color="primary" dark v-bind="attrs" v-on="on"
                    >mdi-help-circle-outline</v-icon
                  >
                </template>
                <span
                  >The identified cell labels are evaluated by the Adjusted Rand
                  Index (ARI) by comparing with the benchmark labels provided
                  from the original study.</span
                >
              </v-tooltip>
            </p>
            <p
              v-if="
                clusterCoordinatesSelect === 'All cell types' &&
                  dataset[0].silhouette_score > 0.4
              "
              class="text--primary"
            >
              Average silhouette width: {{ dataset[0].silhouette_score }}
              <v-tooltip top>
                <template v-slot:activator="{ on, attrs }">
                  <v-icon color="primary" dark v-bind="attrs" v-on="on"
                    >mdi-help-circle-outline</v-icon
                  >
                </template>
                <span
                  >Silhouette width measures how similar a cell is to its type
                  compared to other clusters.</span
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
                <span
                  >Select or search gene of interest to plot gene expression
                  value on the UMAP plot, darker points indicate higher
                  expression values.</span
                >
              </v-tooltip>
            </p>
            <v-autocomplete
              v-model="gene"
              :items="allGenes"
              :label="'Select or search: (' + allGenes.length + ' genes)'"
              @change="updateExpression()"
            ></v-autocomplete>
          </v-col>
        </v-row>
        <v-row>
          <v-col xs="12" md="6" lg="3" class="px-4 py-0 my-0">
            <p class="subtitle-1 font-weight-bold">
              Point size:
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
              v-model="pointSize"
              max="10"
              min="1"
              hide-details
              :thumb-size="24"
              thumb-label="always"
              class="align-center"
              step="1"
              ticks="always"
              tick-size="4"
            >
            </v-slider>
          </v-col>
        </v-row>

        <v-row>
          <v-col xs="12" md="12" lg="6" class="px-4 py-0 my-0">
            <div>
              <client-only>
                <vue-plotly
                  :data="allCellDim"
                  :layout="layout"
                  :options="options"
                />
              </client-only>
            </div>
          </v-col>
          <v-col xs="12" md="12" lg="6" class="px-4 py-0 my-0">
            <div v-if="showPlot">
              <client-only>
                <vue-plotly
                  :data="expressionDim"
                  :layout="layout"
                  :options="options"
                />
              </client-only>
            </div>
            <div v-else>
              <p>Please enter a gene symbol.</p>
            </div>
          </v-col>
          <v-col xs="12" md="12" lg="6" class="px-4 py-0 my-0"
            ><dataset-barplot
              source="single-cell"
              :freq="dimensionFreq"
              :colors="allColors"
            ></dataset-barplot>
          </v-col>
          <v-col xs="12" md="12" lg="6" class="px-4 py-0 my-0"
            ><div v-if="showPlot">
              <dataset-violin
                :result="dimensionViolin"
                :colors="allColors"
              ></dataset-violin>
            </div>
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>
  </v-hover>
</template>

<script>
import _ from 'lodash'
import { mapState } from 'vuex'
import DatasetBarplot from '../figures/DimensionBarplot.vue'
import DatasetViolinplot from '../figures/DimensionViolinplot.vue'
export default {
  name: 'DimensionInfo',
  components: {
    'dataset-barplot': DatasetBarplot,
    'dataset-violin': DatasetViolinplot
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
    dimension: {
      type: Array,
      required: true
    },
    ct: {
      type: Array,
      required: true
    }
  },

  data() {
    return {
      gene: null,
      search: '',
      pointSize: 4,
      headers: [
        { text: 'Gene name', value: 'gene' },
        { text: 'Log fold-change', value: 'avg_logFC' },
        { text: 'Adjusted p-value', value: 'p_val_adj' }
      ],
      clusterCoordinatesSelect: 'All cell types',
      enrich: [],
      layout: {
        autosize: true,
        height: 800,
        margin: {
          l: 10,
          r: 10,
          b: 210,
          t: 20,
          pad: 0
        },
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
          tickfont: {
            size: 16,
            color: 'black'
          },
          title: {
            text: 'UMAP_1',
            font: {
              size: 18
            }
          }
        },
        yaxis: {
          tickfont: {
            size: 16,
            color: 'black'
          },
          title: {
            text: 'UMAP_2',
            font: {
              size: 18
            }
          }
        }
      },
      options: {
        toImageButtonOptions: {
          format: 'png', // one of png, svg, jpeg, webp
          filename: 'download_umap' + new Date().toISOString(),
          height: 1000,
          width: 800,
          scale: 1 // Multiply title/legend/axis/canvas sizes by this factor
        },
        showLink: false,
        displaylogo: false,
        modeBarButtonsToRemove: [
          'hoverCompareCartesian',
          'hoverClosestCartesian'
        ]
      }
    }
  },
  computed: {
    ...mapState({
      expression: (state) => state.ad.expression,
      allGenes: (state) => state.ad.expressionGenes
    }),
    allColors() {
      const result = this.allCellDim.map((i) => {
        return i.marker.color
      })
      return result
    },
    dimensionFreq() {
      const names = this.dimension
        .map((item) => {
          if (item.subcluster !== 'all') {
            return `${item.cell_type}_${item.subcluster}`
          } else {
            if (item.cell_type === 'Oligodendrocyte precursor cells') {
              return 'Oligodendrocyte <br>precursor cells'
            }
            return item.cell_type
          }
        })
        .sort()
      const counts = {}
      for (const num of names) {
        counts[num] = counts[num] ? counts[num] + 1 : 1
      }
      return counts
    },
    showPlot() {
      return this.gene !== null
    },
    dimensionViolin() {
      const rawNames = this.dimension.map((item) => {
        if (item.subcluster !== 'all') {
          return `${item.cell_type}_${item.subcluster}`
        } else {
          if (item.cell_type === 'Oligodendrocyte precursor cells') {
            return 'Oligodendrocyte <br>precursor cells'
          }
          return item.cell_type
        }
      })
      const indices = Array.from(rawNames.keys())
      indices.sort((a, b) => rawNames[a].localeCompare(rawNames[b]))
      const names = indices.map((i) => rawNames[i])
      const expression = indices.map((i) => this.expression[i])
      const geneName = this.gene
      const clusterName = this.clusterCoordinatesSelect
      return { names, expression, geneName, clusterName }
    },
    clusterCoordinatesItems() {
      const cellTypeList = _.map(this.ct, 'cell_type')
      cellTypeList.unshift('All cell types')
      return cellTypeList
    },
    allCellDim() {
      function getTrace(dim, cellType, customColor, markerSize) {
        const currentDimension = dim.filter((row) => row.cell_type === cellType)
        const X = _.map(currentDimension, 'umap_1')
        const Y = _.map(currentDimension, 'umap_2')
        const cellNames = _.map(currentDimension, 'cell_name')
        const trace = {
          x: X,
          y: Y,
          marker: {
            size: markerSize,
            symbol: 'circle',
            color: customColor
          },
          mode: 'markers',
          type: 'scatter',
          name: cellType,
          text: cellNames
        }
        return trace
      }

      function getSubclusterTrace(
        dim,
        select,
        subcluster,
        customColor,
        markerSize
      ) {
        const currentDimension = dim.filter(
          (row) => row.subcluster === subcluster
        )
        const X = _.map(currentDimension, 'umap_1')
        const Y = _.map(currentDimension, 'umap_2')
        const cellNames = _.map(currentDimension, 'cell_name')
        const trace = {
          x: X,
          y: Y,
          marker: {
            size: markerSize,
            symbol: 'circle',
            color: customColor
          },
          mode: 'markers',
          type: 'scatter',
          name: select + '_' + subcluster,
          text: cellNames
        }
        return trace
      }

      if (this.clusterCoordinatesSelect === 'All cell types') {
        const trace1 = getTrace(
          this.dimension,
          'Astrocytes',
          '#E64B35FF',
          this.pointSize
        )
        const trace2 = getTrace(
          this.dimension,
          'Endothelial cells',
          '#00A087FF',
          this.pointSize
        )
        const trace3 = getTrace(
          this.dimension,
          'Excitatory neurons',
          '#3C5488FF',
          this.pointSize
        )
        const trace4 = getTrace(
          this.dimension,
          'Inhibitory neurons',
          '#F39B7FFF',
          this.pointSize
        )
        const trace5 = getTrace(
          this.dimension,
          'Microglia',
          '#4DBBD5FF',
          this.pointSize
        )

        const trace6 = getTrace(
          this.dimension,
          'Oligodendrocytes',
          '#8491B499',
          this.pointSize
        )
        const trace7 = getTrace(
          this.dimension,
          'Oligodendrocyte precursor cells',
          '#91D1C2FF',
          this.pointSize
        )

        const trace8 = getTrace(
          this.dimension,
          'Pericytes',
          '#7E6148FF',
          this.pointSize
        )
        const trace9 = getTrace(
          this.dimension,
          'NK cells',
          '#7E6148FE',
          this.pointSize
        )
        return [
          trace1,
          trace2,
          trace3,
          trace4,
          trace5,
          trace6,
          trace7,
          trace8,
          trace9
        ]
      } else {
        const sub0 = getSubclusterTrace(
          this.dimension,
          this.clusterCoordinatesSelect,
          '0',
          '#E64B35FF',
          this.pointSize
        )
        const sub1 = getSubclusterTrace(
          this.dimension,
          this.clusterCoordinatesSelect,
          '1',
          '#4DBBD5FF',
          this.pointSize
        )
        const sub2 = getSubclusterTrace(
          this.dimension,
          this.clusterCoordinatesSelect,
          '2',
          '#00A087FF',
          this.pointSize
        )
        const sub3 = getSubclusterTrace(
          this.dimension,
          this.clusterCoordinatesSelect,
          '3',
          '#3C5488FF',
          this.pointSize
        )
        const sub4 = getSubclusterTrace(
          this.dimension,
          this.clusterCoordinatesSelect,
          '4',
          '#F39B7FFF',
          this.pointSize
        )
        const sub5 = getSubclusterTrace(
          this.dimension,
          this.clusterCoordinatesSelect,
          '5',
          '#8491B499',
          this.pointSize
        )
        const sub6 = getSubclusterTrace(
          this.dimension,
          this.clusterCoordinatesSelect,
          '6',
          '#91D1C2FF',
          this.pointSize
        )
        const sub7 = getSubclusterTrace(
          this.dimension,
          this.clusterCoordinatesSelect,
          '7',
          '#7E6148FF',
          this.pointSize
        )
        const sub8 = getSubclusterTrace(
          this.dimension,
          this.clusterCoordinatesSelect,
          '8',
          '#631879FF',
          this.pointSize
        )
        const sub9 = getSubclusterTrace(
          this.dimension,
          this.clusterCoordinatesSelect,
          '9',
          '#3C5488FF',
          this.pointSize
        )
        const sub10 = getSubclusterTrace(
          this.dimension,
          this.clusterCoordinatesSelect,
          '10',
          '#EE0000FF',
          this.pointSize
        )
        const sub11 = getSubclusterTrace(
          this.dimension,
          this.clusterCoordinatesSelect,
          '11',
          '#008B45FF',
          this.pointSize
        )
        const sub12 = getSubclusterTrace(
          this.dimension,
          this.clusterCoordinatesSelect,
          '12',
          '#008280FF',
          this.pointSize
        )
        const sub13 = getSubclusterTrace(
          this.dimension,
          this.clusterCoordinatesSelect,
          '13',
          '#BB0021FF',
          this.pointSize
        )
        const sub14 = getSubclusterTrace(
          this.dimension,
          this.clusterCoordinatesSelect,
          '14',
          '#5F559BFF',
          this.pointSize
        )
        const sub15 = getSubclusterTrace(
          this.dimension,
          this.clusterCoordinatesSelect,
          '15',
          '#A20056FF',
          this.pointSize
        )
        const sub16 = getSubclusterTrace(
          this.dimension,
          this.clusterCoordinatesSelect,
          '16',
          '#808180FF',
          this.pointSize
        )
        const sub17 = getSubclusterTrace(
          this.dimension,
          this.clusterCoordinatesSelect,
          '17',
          '#808180FF',
          this.pointSize
        )
        const sub18 = getSubclusterTrace(
          this.dimension,
          this.clusterCoordinatesSelect,
          '18',
          '#808180FF',
          this.pointSize
        )
        const sub19 = getSubclusterTrace(
          this.dimension,
          this.clusterCoordinatesSelect,
          '19',
          '#808180FF',
          this.pointSize
        )
        const sub20 = getSubclusterTrace(
          this.dimension,
          this.clusterCoordinatesSelect,
          '20',
          '#808180FF',
          this.pointSize
        )
        const sub21 = getSubclusterTrace(
          this.dimension,
          this.clusterCoordinatesSelect,
          '21',
          '#808180FF',
          this.pointSize
        )
        const sub22 = getSubclusterTrace(
          this.dimension,
          this.clusterCoordinatesSelect,
          '22',
          '#808180FF',
          this.pointSize
        )
        const sub23 = getSubclusterTrace(
          this.dimension,
          this.clusterCoordinatesSelect,
          '23',
          '#808180FF',
          this.pointSize
        )
        const sub24 = getSubclusterTrace(
          this.dimension,
          this.clusterCoordinatesSelect,
          '24',
          '#808180FF',
          this.pointSize
        )
        const result = [
          sub0,
          sub1,
          sub2,
          sub3,
          sub4,
          sub5,
          sub6,
          sub7,
          sub8,
          sub9,
          sub10,
          sub11,
          sub12,
          sub13,
          sub14,
          sub15,
          sub16,
          sub17,
          sub18,
          sub19,
          sub20,
          sub21,
          sub22,
          sub23,
          sub24
        ]
        return result
      }
    },
    expressionDim() {
      const X = _.map(this.dimension, 'umap_1')
      const Y = _.map(this.dimension, 'umap_2')
      const cellNames = _.map(this.dimension, 'cell_name')
      /*
      // Actual gene expression object, this is much shorter than the dimension object
      const actualExpression = this.expression.reduce(
        (acc, cur) => ({ ...acc, [cur.cell_name]: cur.expression }),
        {}
      )
      // create a tmp object to set {cell_name:0}
      const tmpExpression = cellNames.reduce(
        (o, key) => Object.assign(o, { [key]: 0 }),
        {}
      )

      // Object.values(_.extend({}, tmpExpression, actualExpression))
*/
      // merge actualExpression and tmpExpression, overwrite 0 with actual expression values
      const trace = {
        x: X,
        y: Y,
        mode: 'markers',
        text: cellNames,
        marker: {
          size: this.pointSize,
          color: this.expression
        },
        colorscale: 'YlOrRd'
      }
      return [trace]
    }
  },
  methods: {
    async updateCluster() {
      const params = {
        id: this.$route.params.id,
        type: this.clusterCoordinatesSelect
      }
      await this.$store.dispatch('ad/fetchDimension', params)
    },
    async updateExpression() {
      await this.$store.dispatch('ad/fetchExpression', {
        gene: this.gene,
        id: this.dataset[0].data_id
      })
    }
  }
}
</script>

<style lang="scss" scoped></style>
