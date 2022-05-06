<template>
  <div>
    <v-row>
      <v-col xs="12" md="8" lg="6" class="px-4 py-2 my-2">
        <p class="subtitle-1 font-weight-bold text--primary">
          Clusters to plot:
          <v-tooltip top>
            <template v-slot:activator="{ on, attrs }">
              <v-icon color="primary" dark v-bind="attrs" v-on="on"
                >mdi-help-circle-outline</v-icon
              >
            </template>
            <span>Select UMAP coordinates source or spots coordinates.</span>
          </v-tooltip>
        </p>

        <v-autocomplete
          v-model="clusterCoordinatesSelect"
          :items="clusterCoordinatesItems"
          item-text="cell_type"
          item-value="cell_type"
          label=""
          return-object
          @change="updateCluster()"
        ></v-autocomplete>
        <v-switch
          v-model="toggleImage"
          :label="`Toggle raw image: ${toggleImage.toString()}`"
        ></v-switch>
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
              >Limit testing to genes which show, on average, at least X-fold
              difference (log-scale) between the two groups of cells.</span
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
        <div v-show="!toggleImage">
          <client-only>
            <vue-plotly
              :data="allCellDim"
              :layout="layout"
              :options="options"
            />
          </client-only>
        </div>
        <div v-show="toggleImage" class="mx-6 mt-16">
          <v-img contain :src="image" max-height="600px"></v-img>
        </div>
      </v-col>
      <v-col xs="12" md="12" lg="6" class="px-4 py-0 my-0">
        <client-only>
          <vue-plotly
            :data="allSpatialDim"
            :layout="spatialLayout"
            :options="options"
          />
        </client-only>
      </v-col>
      <v-col xs="12" md="12" lg="6" class="px-4 py-0 my-0"
        ><dataset-barplot
          source="spatial"
          :freq="dimensionFreq"
          :colors="allColors"
        ></dataset-barplot>
      </v-col>
    </v-row>
    <v-row>
      <v-col xs="12" md="8" lg="5" class="px-4 py-0 my-0">
        <p class="subtitle-1 font-weight-bold text--primary">
          Gene expression<v-tooltip top>
            <template v-slot:activator="{ on, attrs }">
              <v-icon color="primary" dark v-bind="attrs" v-on="on"
                >mdi-help-circle-outline</v-icon
              >
            </template>
            <span
              >Select or search gene of interest to plot gene expression value
              on the UMAP plot, darker points indicate higher expression
              values.</span
            >
          </v-tooltip>
        </p>
        <!--<v-switch
          v-model="toggleSvg"
          :label="
            `Only include spatially variable genes: ${toggleSvg.toString()}`
          "
        ></v-switch>-->
        <v-autocomplete
          v-model="gene"
          :items="selectedAllGenes"
          :label="'Select or search: (' + selectedAllGenes.length + ' genes)'"
          @change="updateExpression()"
        ></v-autocomplete>
      </v-col>
    </v-row>

    <v-row>
      <v-col xs="12" md="12" lg="6" class="px-4 py-0 my-0">
        <div v-if="showPlot">
          <client-only>
            <vue-plotly
              :data="expressionUmapDim"
              :layout="layout"
              :options="options"
            />
          </client-only>
        </div>
        <div v-else>
          <p>Please enter a gene symbol.</p>
        </div>
      </v-col>
      <v-col xs="12" md="12" lg="6" class="px-4 py-0 my-0">
        <div v-if="showPlot">
          <client-only>
            <vue-plotly
              source="spatial"
              :data="expressionSpatialDim"
              :layout="spatialLayout"
              :options="options"
            />
          </client-only>
        </div>
        <div v-else>
          <p>Please enter a gene symbol.</p>
        </div>
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
  </div>
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
      required: false,
      default: () => 'ST00101'
    },
    image: {
      type: String,
      required: false,
      default: () =>
        'https://spatial-dlpfc.s3.us-east-2.amazonaws.com/images/151507_tissue_hires_image.png'
    },
    dimension: {
      type: Array,
      required: true
    }
  },

  data() {
    return {
      gene: null,
      toggleImage: false,
      toggleSvg: false,
      pointSize: 6,
      headers: [
        { text: 'Gene name', value: 'gene' },
        { text: 'Log fold-change', value: 'avg_logFC' },
        { text: 'Adjusted p-value', value: 'p_val_adj' }
      ],
      clusterCoordinatesSelect: 'layer',
      colors: [
        '#E64B35FF',
        '#4DBBD5FF',
        '#00A087FF',
        '#3C5488FF',
        '#F39B7FFF',
        '#8491B499',
        '#91D1C2FF',
        '#7E6148FF',
        '#7E6148FE'
      ],

      layout: {
        autosize: true,
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
          showgrid: true,
          zeroline: false,
          showline: false,
          showticklabels: false,
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
          showgrid: true,
          zeroline: false,
          showline: false,
          showticklabels: false,
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
      spatialLayout: {
        autosize: true,
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
          showgrid: true,
          zeroline: false,
          showline: false,
          showticklabels: false,
          tickfont: {
            size: 16,
            color: 'black'
          },
          title: {
            text: '',
            font: {
              size: 18
            }
          }
        },
        yaxis: {
          showgrid: true,
          zeroline: false,
          showline: false,
          showticklabels: false,
          tickfont: {
            size: 16,
            color: 'black'
          },
          title: {
            text: '',
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
      },
      svg: [
        'NPY',
        'PLP1',
        'IGKC',
        'HBB',
        'HBA2',
        'MBP',
        'SST',
        'IGHG3',
        'CNP',
        'CRYAB',
        'CRHBP',
        'TF',
        'IGHM',
        'GFAP',
        'IGHG4',
        'SCGB2A2',
        'CARTPT',
        'IGLC2',
        'MOBP',
        'MAG',
        'IGLC3',
        'PPP1R14A',
        'HBA1',
        'MGP',
        'SAA1',
        'S100B',
        'IGHA1',
        'SPP1',
        'CORT',
        'CLDN11',
        'CLDND1',
        'GPR17',
        'ERMN',
        'FABP4',
        'PCP4',
        'RNASE1',
        'CNR1',
        'JCHAIN',
        'NOS1',
        'ENC1',
        'NEFM',
        'MOG',
        'NEFH',
        'NEFL',
        'TMEM144',
        'HSPA2',
        'SCGB1D2',
        'CARNS1',
        'MAL',
        'TAC1',
        'CXCL14',
        'CCK',
        'CHODL',
        'SELENOP',
        'TNFRSF11B',
        'ENPP2',
        'HPCAL1',
        'NME7',
        'MARCKSL1',
        'FDCSP',
        'LINC00844',
        'PTGDS',
        'SNAP25',
        'IGHG1',
        'SCD',
        'PLLP',
        'ATP1B1',
        'IGHA2',
        'VGLL3',
        'OPALIN',
        'ANKRD7',
        'CPB1',
        'VSNL1',
        'PACRG-AS3',
        'AC048382.5',
        'AC008080.4',
        'AQP1',
        'PLEKHH1',
        'AL136141.1',
        'MYRF',
        'PVALB',
        'KLK6',
        'ELOVL1',
        'TTYH2',
        'LAMP2'
      ]
    }
  },
  computed: {
    ...mapState({
      expression: (state) => state.ad_v2.expression,
      allGenes: (state) => state.ad_v2.expressionGenes
    }),
    dimensionFreq() {
      const names = _.map(this.dimension, this.clusterCoordinatesSelect).sort()
      const counts = {}
      for (const num of names) {
        counts[num] = counts[num] ? counts[num] + 1 : 1
      }
      return counts
    },
    dimensionViolin() {
      const names = _.map(this.dimension, this.clusterCoordinatesSelect).sort()
      const expression = this.expression
      const geneName = this.gene
      const clusterName = this.clusterCoordinatesSelect
      return { names, expression, geneName, clusterName }
    },
    selectedAllGenes() {
      if (this.toggleSvg) {
        return this.svg
      } else {
        return this.allGenes
      }
    },
    allColors() {
      return this.colors
    },

    showPlot() {
      return this.gene !== null
    },

    clusterCoordinatesItems() {
      return ['layer', 'cluster']
    },
    allCellDim() {
      if (this.clusterCoordinatesSelect === 'cluster') {
        const clusterNames = [
          ...new Set(this.dimension.map((row) => row.cluster))
        ].sort()

        const traces = new Array([])
        for (const [i, clusterName] of clusterNames.entries()) {
          const X = this.dimension
            .filter((row) => row.cluster === clusterName)
            .map((row) => row.umap_1)
          const Y = this.dimension
            .filter((row) => row.cluster === clusterName)
            .map((row) => row.umap_2)
          const cellNames = this.dimension
            .filter((row) => row.cluster === clusterName)
            .map((row) => row.cell_name)
          const trace = {
            x: X,
            y: Y,
            mode: 'markers',
            text: cellNames,
            marker: {
              size: this.pointSize,
              color: this.colors[i]
            },
            colorscale: 'YlOrRd',
            name: clusterName
          }
          traces.push(trace)
        }
        return traces
      } else {
        const clusterNames = [
          ...new Set(this.dimension.map((row) => row.layer))
        ].sort()
        const traces = new Array([])
        for (const [i, clusterName] of clusterNames.entries()) {
          const X = this.dimension
            .filter((row) => row.layer === clusterName)
            .map((row) => row.umap_1)
          const Y = this.dimension
            .filter((row) => row.layer === clusterName)
            .map((row) => row.umap_2)
          const cellNames = this.dimension
            .filter((row) => row.layer === clusterName)
            .map((row) => row.cell_name)
          const trace = {
            x: X,
            y: Y,
            mode: 'markers',
            text: cellNames,
            marker: {
              size: this.pointSize,
              color: this.colors[i]
            },
            colorscale: 'YlOrRd',
            name: clusterName
          }
          traces.push(trace)
        }
        return traces
      }
    },
    allSpatialDim() {
      if (this.clusterCoordinatesSelect === 'cluster') {
        const clusterNames = [
          ...new Set(this.dimension.map((row) => row.cluster))
        ].sort()

        const traces = new Array([])
        for (const [i, clusterName] of clusterNames.entries()) {
          const X = this.dimension
            .filter((row) => row.cluster === clusterName)
            .map((row) => row.row * -1)
          const Y = this.dimension
            .filter((row) => row.cluster === clusterName)
            .map((row) => row.col)
          const cellNames = this.dimension
            .filter((row) => row.cluster === clusterName)
            .map((row) => row.cell_name)
          const trace = {
            x: X,
            y: Y,
            mode: 'markers',
            text: cellNames,
            marker: {
              size: this.pointSize,
              color: this.colors[i]
            },
            colorscale: 'YlOrRd',
            name: clusterName
          }
          traces.push(trace)
        }
        return traces
      } else {
        const clusterNames = [
          ...new Set(this.dimension.map((row) => row.layer))
        ].sort()
        const traces = new Array([])
        for (const [i, clusterName] of clusterNames.entries()) {
          const X = this.dimension
            .filter((row) => row.layer === clusterName)
            .map((row) => row.row * -1)
          const Y = this.dimension
            .filter((row) => row.layer === clusterName)
            .map((row) => row.col)
          const cellNames = this.dimension
            .filter((row) => row.layer === clusterName)
            .map((row) => row.cell_name)
          const trace = {
            x: X,
            y: Y,
            mode: 'markers',
            text: cellNames,
            marker: {
              size: this.pointSize,
              color: this.colors[i]
            },
            colorscale: 'YlOrRd',
            name: clusterName
          }
          traces.push(trace)
        }
        return traces
      }
    },

    expressionUmapDim() {
      const X = _.map(this.dimension, 'umap_1')
      const Y = _.map(this.dimension, 'umap_2')
      const cellNames = _.map(this.dimension, 'cell_name')
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
    },
    expressionSpatialDim() {
      const X = this.dimension.map((row) => row.row * -1)

      const Y = _.map(this.dimension, 'col')
      const cellNames = _.map(this.dimension, 'cell_name')
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
        id: this.dataId,
        type: this.clusterCoordinatesSelect
      }
      await this.$store.dispatch('ad_v2/fetchDimension', params)
      await this.$store.dispatch('ad_v2/fetchSpatialDimension', {
        id: this.dataId
      })
    },
    async updateExpression() {
      await this.$store.dispatch('ad_v2/fetchExpression', {
        gene: this.gene,
        id: this.dataId
      })
    }
  }
}
</script>

<style lang="scss" scoped></style>
