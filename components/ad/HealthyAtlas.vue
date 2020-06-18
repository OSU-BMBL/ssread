<template>
  <div>
    <no-ssr>
      <v-row>
        <v-col xs="12" md="12" lg="12" class="px-4 py-0 my-0">
          <vue-plotly :data="allCellDim" :layout="layout" :options="options" />
        </v-col>
      </v-row>
    </no-ssr>
  </div>
</template>

<script>
import _ from 'lodash'

export default {
  name: 'HealthyAtlas',
  components: {},
  props: {
    dimension: {
      type: Array,
      required: true
    }
  },
  data() {
    return {
      gene: null,
      search: '',
      headers: [
        { text: 'Gene name', value: 'gene' },
        { text: 'Log fold-change', value: 'avg_logFC' },
        { text: 'Adjusted p-value', value: 'p_val_adj' }
      ],
      xAxisAllCellsSelect: {
        text: 'umap_1'
      },
      xAxisAllCellsItems: [
        {
          text: 'umap_1'
        },
        {
          text: 'umap_2'
        },
        {
          text: 'tsne_1'
        },
        {
          text: 'tsne_2'
        }
      ],
      yAxisAllCellsSelect: {
        text: 'umap_2'
      },
      yAxisAllCellsItems: [
        {
          text: 'umap_1'
        },
        {
          text: 'umap_2'
        },
        {
          text: 'tsne_1'
        },
        {
          text: 'tsne_2'
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
        width: 450,
        height: 750,
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
    dataId() {
      return this.$route.params.id
    },
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
    }
  }
}
</script>

<style lang="scss" scoped></style>
