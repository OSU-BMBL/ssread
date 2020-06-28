<template>
  <div>
    <client-only>
      <v-row>
        <v-col xs="12" md="12" lg="12" class="px-4 py-0 my-0">
          <v-row>
            <v-col xs="12" md="6" lg="3" class="px-4 py-0 my-0">
              <p class="subtitle-1 font-weight-bold">
                Point size:
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
          <vue-plotly :data="allCellDim" :layout="layout" :options="options" />
        </v-col>
      </v-row>
    </client-only>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import _ from 'lodash'

export default {
  name: 'HealthyAtlas',
  components: {},
  props: {
    atlasId: {
      type: String,
      required: true
    }
  },
  data() {
    return {
      gene: null,
      color1: ['Group', 'Sex', 'Stage'],
      enrich: [],
      clusterCoordinatesSelect: 'All cell types',
      pointSize: 4,
      layout: {
        autosize: true,
        width: 1000,
        height: 700,
        margin: {
          l: 50,
          r: 50,
          b: 20,
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
      dimension: (state) => state.ad.dimension
    }),
    dataId() {
      return this.$route.params.id
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
    }
  },
  methods: {}
}
</script>

<style lang="scss" scoped></style>
