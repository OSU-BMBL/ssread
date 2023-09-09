<template>
  <div>
    <v-layout column justify-center align-center class="bg">
      <p class="text-h1 font-weight-regular" align-center>ssREAD</p>
      <p class="text-bg display-1">
        A Single-cell and Spatial RNA-Seq Database for Alzheimer's Disease
      </p>
    </v-layout>
    <div>
      <v-container>
        <v-row>
          <v-col cols="6"
            ><p class="text-h4 mt-6" align-center>Datasets</p>
            <p class="font-weight-medium mt-6" align-center>
              Over 2,500,000 cells and 300 Spatial Transcriptomics samples from
              46 Human & Mouse studies.
            </p>
            <ul class="py-2">
              <li>
                Detailed annotations including cell types and spatial layers
              </li>
              <li>
                Differential gene expressions and functional enrichment analysis
              </li>
              <li>
                Spatially variable genes and deconvolution with single-cell
                datasets
              </li>
            </ul>
            <v-btn class="mt-6" large color="primary" to="/singlecell"
              >Browse</v-btn
            >
          </v-col>
          <v-col class="pa-6" cols="6"
            ><client-only
              ><vue-plotly
                :data="barData1"
                :layout="barLayout1"
                :options="options"/></client-only
          ></v-col>
        </v-row>
      </v-container>
    </div>
    <div class="bg-1">
      <v-container>
        <v-row>
          <!--<v-col class="pa-6" cols="6"
            ><client-only
              ><vue-plotly
                :data="sankeyData1"
                :layout="sankeyLayout1"
                :options="options"/></client-only
          ></v-col>-->
          <v-col class="pa-6" cols="3"
            ><client-only
              ><vue-plotly
                :data="pieData1"
                :layout="layout1"
                :options="options"/></client-only
          ></v-col>
          <v-col class="pa-6" cols="3"
            ><client-only
              ><vue-plotly
                :data="pieData2"
                :layout="layout2"
                :options="options"/></client-only
          ></v-col>
          <v-col cols="6"
            ><p class="text-h4 mt-6" align-center>Search</p>
            <p class="font-weight-medium mt-6" align-center>
              Query results over 35 single-cell & single-nuclei RNA-seq and 11
              spatial studies in 19 brain regions.
            </p>
            <ul class="py-2">
              <li>Search differentially expressed genes</li>
              <li>
                Find overlapping DEGs from multiple comparisons
              </li>
            </ul>
            <v-btn class="mt-6" large color="primary" to="/query">Query</v-btn>
          </v-col>
        </v-row>
      </v-container>
    </div>
    <div>
      <v-container>
        <v-row>
          <v-col cols="6"
            ><p class="text-h4 mt-6" align-center>Downloads</p>
            <p class="font-weight-medium mt-6" align-center>
              Download all raw & processed datasets.
            </p>
            <ul class="py-2">
              <li>
                Raw gene expression & authors' label
              </li>
              <li>
                High quality processed data & metadata
              </li>
              <li>
                Text format or objects can be directly loaded into Seurat /
                Scanpy
              </li>
            </ul>
            <v-btn class="mt-6" large color="primary" to="/downloads"
              >Download</v-btn
            >
          </v-col>

          <v-col class="pa-6" cols="3"
            ><client-only
              ><vue-plotly
                :data="pieData3"
                :layout="layout3"
                :options="options"/></client-only
          ></v-col>
          <v-col class="pa-6" cols="3"
            ><client-only
              ><vue-plotly
                :data="pieData4"
                :layout="layout4"
                :options="options"/></client-only
          ></v-col>
        </v-row>
      </v-container>
    </div>
    <div class="bg-1">
      <v-container>
        <v-row>
          <v-col class="pa-6" cols="6"
            ><v-radio-group v-model="radioGroup">
              <v-radio label="Cells" value="1"></v-radio>
              <v-radio label="Spatial spots" value="2"></v-radio>
            </v-radio-group>
            <client-only
              ><vue-plotly
                v-if="radioGroup == 1"
                :data="allCellDim"
                :layout="umapLayout"
                :options="options"/>

              <vue-plotly
                v-if="radioGroup == 2"
                :data="allSpatialDim"
                :layout="spatialLayout"
                :options="options"/></client-only
          ></v-col>

          <v-col cols="6"
            ><p class="text-h4 mt-6" align-center>Interactive visualizations</p>
            <p class="font-weight-medium mt-6" align-center>
              User-friendly web server to provide comprehensive analysis
              interpretations and filters support multiple selections
            </p>
            <ul class="py-2">
              <li>
                Scatter plots for clusters, cell types, and spatial layers
              </li>
              <li>
                Feature plots and violin plots for gene expression profile
              </li>
              <li>
                Real-time gene set enrichment analysis
              </li>
            </ul>
            <v-btn class="mt-6" large color="primary" to="/spatial/ST001"
              >Check example</v-btn
            >
          </v-col>
        </v-row>
      </v-container>
    </div>
  </div>
</template>
<script>
import { mapState } from 'vuex'
import _ from 'lodash'

export default {
  async asyncData({ store, error, params }) {
    try {
      await store.dispatch('ad_v2/fetchDatasets')
      await store.dispatch('ad_v2/fetchAllDeMeta')
      await store.dispatch('ad_v2/clearExpression')
      await store.dispatch('ad_v2/fetchSpatialDimension', {
        id: 'ST00101'
      })
    } catch (e) {
      error({
        statusCode: 503,
        message: 'ERROR CODE 503'
      })
    }
  },

  data() {
    return {
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
      radioGroup: '1',
      dialog: false,
      selectDatasetDialog: false,
      totalStudy: '16',
      computedDialogData: [],
      headers: [
        {
          text: 'Data ID',
          align: 'start',
          sortable: false,
          value: 'data_id'
        },
        { text: 'Species', value: 'species' },
        { text: 'Gender', value: 'gender' },
        { text: 'Condition', value: 'condition' },
        { text: 'Region', value: 'region' },
        { text: 'Braak stage', value: 'stage' },
        { text: 'Age', value: 'age' },
        { text: 'Mice model', value: 'mice_model' },
        { text: 'GEO/synapse ID', value: 'public_id' },
        { text: '#Cells', value: 'n_cell' }
      ],
      browseDefault: {
        species: 'All',
        condition: 'All',
        region: 'All',
        gender: 'All'
      },
      browseItems: {
        species: ['All', 'Human', 'Mouse'],
        condition: ['All', 'Control', 'AD'],
        region: [
          'All',
          'Cerebellum',
          'Cerebral cortex',
          'Cortex',
          'Cortex and hippocampus',
          'Dorsolateral Prefrontal cortex',
          'Entorhinal Cortex',
          'Hippocampus',
          'Middle temporal gyrus',
          'Prefrontal cortex',
          'Subventricular zone and hippocampus',
          'Superior frontal gyrus (BA8)',
          'Superior parietal lobe'
        ],
        gender: ['All', 'Female', 'Male']
      },
      pieData1: [
        {
          values: [35, 11],
          labels: [
            'single-cell & single-nuclei RNA-seq',
            'spatial transcriptomics'
          ],
          type: 'pie'
        }
      ],
      layout1: {
        paper_bgcolor: '#faf5ff',
        plot_bgcolor: '#faf5ff',
        title: {
          text: 'Studies',
          font: {
            size: 16
          }
        },
        autosize: true,
        width: this.pieWidth,
        height: 500,
        margin: {
          l: 20,
          r: 20,
          b: 10,
          t: 30,
          pad: 0
        },
        legend: {
          font: {
            size: 14
          },
          orientation: 'h'
        }
      },
      pieData2: [
        {
          values: [114, 75, 120, 100],
          labels: [
            'AD (sc/sn RNA-seq)',
            'Control (sc/sn RNA-seq)',
            'AD (ST)',
            'Control (ST)'
          ],
          type: 'pie'
        }
      ],
      layout2: {
        paper_bgcolor: '#faf5ff',
        plot_bgcolor: '#faf5ff',
        title: {
          text: 'Condition',
          font: {
            size: 20
          }
        },
        autosize: true,
        width: this.pieWidth,
        height: 500,
        margin: {
          l: 20,
          r: 20,
          b: 10,
          t: 30,
          pad: 0
        },
        legend: {
          font: {
            size: 14
          },
          orientation: 'h'
        }
      },
      pieData3: [
        {
          values: [94, 95, 43, 208],
          labels: [
            'Human (sc/sn RNA-seq)',
            'Mouse (sc/sn RNA-seq)',
            'Human (ST)',
            'Mouse (ST)'
          ],
          type: 'pie'
        }
      ],
      layout3: {
        title: {
          text: 'Species',
          font: {
            size: 20
          }
        },
        autosize: true,
        width: this.pieWidth,
        height: 500,
        margin: {
          l: 20,
          r: 20,
          b: 10,
          t: 30,
          pad: 0
        },
        legend: {
          font: {
            size: 14
          },
          orientation: 'h'
        }
      },
      pieData4: [
        {
          values: [90, 99, 169, 142],
          labels: [
            'Female (sc/sn RNA-seq)',
            'Male (sc/sn RNA-seq)',
            'Female (ST)',
            'Male (ST)'
          ],
          type: 'pie'
        }
      ],
      layout4: {
        title: {
          text: 'Sex',
          font: {
            size: 20
          }
        },
        autosize: true,
        width: this.pieWidth,
        height: 500,
        margin: {
          l: 20,
          r: 20,
          b: 210,
          t: 50,
          pad: 4
        },
        legend: {
          font: {
            size: 14
          },
          orientation: 'h'
        }
      },
      barData1: [
        {
          x: [
            'Cerebellum',
            'Cerebral cortex',
            'Cortex',
            'Cortex and hippocampus',
            'Dorsolateral Prefrontal cortex',
            'Entorhinal Cortex',
            'Hippocampus',
            'Middle temporal gyrus',
            'Prefrontal cortex',
            'Subventricular zone and hippocampus',
            'Superior frontal gyrus (BA8)',
            'Superior parietal lobe'
          ],
          y: [2, 8, 45, 6, 4, 10, 16, 17, 41, 23, 3, 14],
          name: 'single-cell & single-nuclei RNA-seq',
          marker: {
            color: [
              '#76D6FE',
              '#76D6FE',
              '#76D6FE',
              '#76D6FE',
              '#76D6FE',
              '#76D6FE',
              '#76D6FE',
              '#76D6FE',
              '#76D6FE',
              '#76D6FE',
              '#76D6FE',
              '#76D6FE'
            ]
          },
          type: 'bar'
        },
        {
          x: [
            'Dorsolateral prefrontal cortex',
            'Forebrain',
            'Main olfactory bulb',
            'Middle temporal gyrus',
            'Whole brain sections',
            'Central ventricle and the habenula',
            'Coronal brain sections',
            'Cortex and striatum',
            'Hippocampi and olfactory bulbs',
            'Hippocampus and prefrontal cortex',
            'Ventral cortex, thalamus, and hippocampus',
            'Superior parietal lobe'
          ],

          y: [12, 8, 3, 11, 75, 106, 6, 11, 48, 11, 20],

          name: 'spatial transcriptomics',
          marker: {
            color: [
              '#FF7E7A',
              '#FF7E7A',
              '#FF7E7A',
              '#FF7E7A',
              '#FF7E7A',
              '#FF7E7A',
              '#FF7E7A',
              '#FF7E7A',
              '#FF7E7A',
              '#FF7E7A',
              '#FF7E7A',
              '#FF7E7A',
              '#FF7E7A',
              '#FF7E7A',
              '#FF7E7A'
            ]
          },
          type: 'bar'
        }
      ],
      barLayout1: {
        barmode: 'group',
        title: {
          text: 'Number of datasets',
          font: {
            size: 20
          }
        },
        autosize: true,
        width: this.pieWidth,
        height: 600,
        margin: {
          l: 30,
          r: 40,
          b: 180,
          t: 40,
          pad: 10
        },
        legend: {
          x: 1,
          xanchor: 'right',
          y: 1,
          font: {
            size: 14
          }
        }
      },
      sankeyData1: [
        {
          type: 'sankey',
          arrangement: 'snap',
          orientation: 'h',

          node: {
            pad: 15,

            thickness: 30,

            line: {
              color: 'black',

              width: 0.5
            },

            label: [
              'Single-cell & Single nuclei',
              'Spatial Transcriptomics',
              'Human',
              'Mouse',
              'Male',
              'Female',
              'AD',
              'Control'
            ],

            color: [
              '#E64B35FF',
              '#E64B35FF',
              '#4DBBD5FF',
              '#4DBBD5FF',
              '#00A087FF',
              '#00A087FF',
              '#3C5488FF',
              '#3C5488FF'
            ]
          },

          link: {
            source: [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5],

            target: [2, 3, 2, 3, 4, 5, 4, 5, 6, 7, 6, 7],

            value: [82, 30, 20, 140, 40, 37, 50, 45, 59, 31, 47, 35]
          }
        }
      ],
      sankeyLayout1: {
        title: 'Number of datasets',
        paper_bgcolor: '#faf5ff',
        plot_bgcolor: '#faf5ff',
        font: {
          size: 12
        },
        autosize: true,
        width: this.pieWidth,
        height: 500,
        margin: {
          l: 40,
          r: 40,
          b: 80,
          t: 50,
          pad: 10
        }
      },
      umapLayout: {
        autosize: true,
        paper_bgcolor: '#faf5ff',
        plot_bgcolor: '#faf5ff',
        title: 'Example UMAP plot',
        height: 500,
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
      options: {
        toImageButtonOptions: {
          format: 'png', // one of png, svg, jpeg, webp
          filename: 'download_piechart' + new Date().toISOString(),
          height: 700,
          width: 700,
          scale: 1 // Multiply title/legend/axis/canvas sizes by this factor
        },
        showLink: false,
        displaylogo: false,
        modeBarButtonsToRemove: ['hoverClosestPie']
      }
    }
  },
  computed: {
    ...mapState({
      dataset: (state) => {
        const data = state.ad_v2.datasets
        delete data.silhouette_score
        delete data.ari_score
        return data
      },
      dialogData: (state) => state.ad_v2.dialogDataset,
      selectDatasetDialogData: (state) => state.ad_v2.SelectDatasetDialogData,
      dimension: (state) => state.ad_v2.spatialDimension
    }),
    bannerMessage() {
      return `You are visiting ssREAD's dev version. Please let us know for any issues or suggestions via qin.ma@osumc.edu.`
    },
    currentBrowseItems() {
      return this.browseItems.species
    },
    filterDataset() {
      let result =
        this.browseDefault.species === 'All'
          ? this.dataset
          : this.dataset.filter(
              (row) => row.species === this.browseDefault.species
            )
      result =
        this.browseDefault.condition === 'All'
          ? result
          : result.filter(
              (row) => row.condition === this.browseDefault.condition
            )
      result =
        this.browseDefault.region === 'All'
          ? result
          : result.filter((row) => row.region === this.browseDefault.region)
      result =
        this.browseDefault.gender === 'All'
          ? result
          : result.filter((row) => row.gender === this.browseDefault.gender)
      return result
    },
    displayResetFilter() {
      return (
        this.browseDefault.species !== 'All' ||
        this.browseDefault.condition !== 'All' ||
        this.browseDefault.region !== 'All' ||
        this.browseDefault.gender !== 'All'
      )
    },
    pieWidth() {
      // return this.$refs.pie.clientWidth
      return 320
    },
    brainRegions() {
      const region = this.dataset
        .map((row) => row.region)
        .filter((value, index, self) => self.indexOf(value) === index)
        .sort()
      return region
    },
    totalBrainRegions() {
      return this.brainRegions.length
    },
    totalDatasets() {
      return this.dataset.length
    },
    totalCells() {
      return _.sumBy(this.dataset, 'n_original_cell')
    },
    allCellDim() {
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
    },
    allSpatialDim() {
      const clusterNames = [
        ...new Set(this.dimension.map((row) => row.cluster))
      ].sort()

      const traces = new Array([])
      for (const [i, clusterName] of clusterNames.entries()) {
        const Y = this.dimension
          .filter((row) => row.cluster === clusterName)
          .map((row) => row.row * -1)
        const X = this.dimension
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
    },
    spatialLayout() {
      return {
        autosize: true,
        paper_bgcolor: '#faf5ff',
        plot_bgcolor: '#faf5ff',
        height: 500,
        title: 'Example spatial spots',
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
      }
    }
  },
  mounted() {
    // this.$notifier.showAlert({ content: this.bannerMessage, color: 'accent' })
  },
  methods: {
    async handleClick(item) {
      // this.$router.push('/browse/' + dataset.data_id)
      await this.$store.dispatch('ad_v2/setDialog', item.data_id)
      this.computedDialogData = this.dialogData[0]
      this.dialog = true
    },

    clickSelectDatasetDialog(item) {
      //  await this.$store.dispatch('ad_v2/setDialog', item.data_id)
      //  this.computedSelectDatasetDialogData = this.selectDatasetDialogData[0]
      this.selectDatasetDialog = true
    },

    updateSelectDataset() {
      this.selectDatasetDialog = false
      this.$router.push({ hash: '' })
      this.$vuetify.goTo('#datasetTable')
    },
    resetFilter() {
      this.browseDefault.species = 'All'
      this.browseDefault.condition = 'All'
      this.browseDefault.region = 'All'
      this.browseDefault.gender = 'All'
    },
    openDetailsPage() {
      this.$router.push(this.computedDialogData.data_id)
    }
  },
  head() {
    return {
      title: 'Home',
      meta: [
        {
          hid: 'scREAD homepage',
          name: 'scREAD home page',
          content: `Alzheimers disease single-cell RNA-seq database, 
            Alzheimers disease AD single-cell datasets database analysis workflow pipeline,
            Search gene expression, DEG, , Differential expression and Gene set enrichment analysis,
            control atlases from different brain regions of human and mouse species,
            UMAP plot for cell types, subclusters, and specific gene expression,
            AD scRNA-Seq, snRNA-Seq datasets, single-cell RNA-seq, single-nucleus RNA-seq`
        }
      ]
    }
  }
}
</script>
<style scoped>
.bg {
  opacity: 1;
  background: url('https://bmblx.bmi.osumc.edu/spatial/scread-bg2.png');
  background-size: cover;
  height: 43vh;
}

.bg-1 {
  background-color: #faf5ff;
}
</style>
