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
              <no-ssr>
                <vue-plotly
                  :data="allCellDim"
                  :layout="layout"
                  :options="options"
              /></no-ssr>
            </div>
          </v-col>
          <v-col xs="12" md="12" lg="6" class="px-4 py-0 my-0">
            <div>
              <vue-plotly
                :data="expressionDim"
                :layout="layout"
                :options="options"
              />
            </div>
          </v-col>
        </v-row>
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
          l: 50,
          r: 50,
          b: 200,
          t: 20,
          pad: 4
        },
        legend: {
          margin: {
            l: 50,
            r: 50,
            b: 180,
            t: 20,
            pad: 4
          },
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
      options: {}
    }
  },
  computed: {
    ...mapState({
      expression: (state) => state.ad.expression,
      allGenes: (state) => state.ad.expressionGenes
    }),
    clusterCoordinatesItems() {
      const cellTypeList = _.map(this.ct, 'cell_type')
      cellTypeList.unshift('All cell types')
      return cellTypeList
    },
    allCellDim() {
      function getTrace(dim, cellType, customColor, markerSize) {
        const cuurentDimension = dim.filter((row) => row.cell_type === cellType)
        const X = _.map(cuurentDimension, 'umap_1')
        const Y = _.map(cuurentDimension, 'umap_2')
        const cellNames = _.map(cuurentDimension, 'cell_name')
        const trace = {
          x: X,
          y: Y,
          marker: {
            size: markerSize,
            symbol: 'circle'
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
        const cuurentDimension = dim.filter(
          (row) => row.subcluster === subcluster
        )
        const X = _.map(cuurentDimension, 'umap_1')
        const Y = _.map(cuurentDimension, 'umap_2')
        const cellNames = _.map(cuurentDimension, 'cell_name')
        const trace = {
          x: X,
          y: Y,
          marker: {
            size: markerSize,
            symbol: 'circle'
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
          'Microglia',
          '#4DBBD5FF',
          this.pointSize
        )
        const trace3 = getTrace(
          this.dimension,
          'Endothelial cells',
          '#00A087FF',
          this.pointSize
        )
        const trace4 = getTrace(
          this.dimension,
          'Excitatory neurons',
          '#3C5488FF',
          this.pointSize
        )
        const trace5 = getTrace(
          this.dimension,
          'Inhibitory neurons',
          '#F39B7FFF',
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
        return [trace1, trace2, trace3, trace4, trace5, trace6, trace7, trace8]
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
        return [sub0, sub1, sub2, sub3, sub4, sub5, sub6, sub7]
      }
    },
    expressionDim() {
      const X = _.map(this.dimension, 'umap_1')
      const Y = _.map(this.dimension, 'umap_2')
      const cellNames = _.map(this.dimension, 'cell_name')

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
      // merge actualExpression and tmpExpression, overwrite 0 with actual expression values
      const trace = {
        x: X,
        y: Y,
        mode: 'markers',
        text: cellNames,
        marker: {
          size: this.pointSize,
          color: Object.values(_.extend({}, tmpExpression, actualExpression))
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
      await console.log(params)
      await this.$store.dispatch('ad/fetchDimension', params)
    },
    async updateExpression() {
      await this.$store.dispatch('ad/fetchExpression', this.gene)
    }
  }
}
</script>

<style lang="scss" scoped></style>
