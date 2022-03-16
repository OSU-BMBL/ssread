<template>
  <div>
    <v-layout column justify-center align-center>
      <p class="display-3 font-weight-regular" align-center>scREAD</p>
      <v-flex xs="12" md="6" lg="12">
        <p class="display-1">
          A single-cell and spatial RNA-Seq database for Alzheimer's disease
        </p>
      </v-flex>
    </v-layout>
    <v-row>
      <v-col cols="12">
        <v-card
          ><v-card-title>scRNA-seq</v-card-title>

          <v-row>
            <v-col cols="6"
              ><v-card-text
                ><p>Datasets: X</p>
                <p>Studies: X</p>
                <p>Brain regions: X</p>
                <p>Cells: X</p></v-card-text
              ></v-col
            >
            <v-col cols="6"
              ><v-card-text
                ><p>Figure 1</p>
                <p>Figure 2</p>
              </v-card-text></v-col
            >
          </v-row>

          <v-card-actions
            ><v-btn color="primary">Browse all</v-btn></v-card-actions
          ></v-card
        >
      </v-col>
      <v-col cols="12"
        ><v-card
          ><v-card-title>spatial RNA-seq</v-card-title
          ><v-row>
            <v-col cols="6"
              ><v-card-text
                ><p>Datasets: X</p>
                <p>Studies: X</p>
                <p>Brain regions: X</p>
              </v-card-text></v-col
            >
            <v-col cols="6"
              ><v-card-text
                ><p>Figure 1</p>
                <p>Figure 2</p>
              </v-card-text></v-col
            > </v-row
          ><v-card-actions
            ><v-btn color="primary">Browse all</v-btn></v-card-actions
          ></v-card
        ></v-col
      >
    </v-row>
  </div>
</template>
<script>
import { mapState } from 'vuex'
import _ from 'lodash'

export default {
  async asyncData({ store, error, params }) {
    try {
      await store.dispatch('ad/fetchDatasets')
      await store.dispatch('ad/fetchAllDeMeta')
      await store.dispatch('ad/clearExpression')
    } catch (e) {
      error({
        statusCode: 503,
        message: 'ERROR CODE 503'
      })
    }
  },

  data() {
    return {
      dialog: false,
      selectDatasetDialog: false,
      totalStudy: '16',
      computedDialogData: [],
      headers: [
        {
          text: 'scREAD data ID',
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
        condition: ['All', 'Control', 'Disease'],
        region: [
          'All',
          'Cerebellum',
          'Cerebral cortex',
          'Cortex',
          'Cortex and hippocampus',
          'Entorhinal Cortex',
          'Hippocampus',
          'Prefrontal cortex',
          'Subventricular zone and hippocampus',
          'Superior frontal gyrus (BA8)',
          'Superior parietal lobe'
        ],
        gender: ['All', 'Female', 'Male']
      },
      pieData1: [
        {
          values: [26, 47],
          labels: ['Human', 'Mouse'],
          type: 'pie'
        }
      ],
      layout1: {
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
      pieData2: [
        {
          values: [9, 20, 14, 30],
          labels: [
            'Human-control',
            'Human-disease',
            'Mouse-control',
            'Mouse-disease'
          ],
          type: 'pie'
        }
      ],
      layout2: {
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
      pieData3: [
        {
          values: [6, 14, 3, 6, 13, 2, 5, 24, 4, 4],
          labels: [
            'Human_Entorhinal Cortex',
            'Human_Prefrontal cortex',
            'Human_Superior frontal gyrus',
            'Human_Superior parietal lobe',
            'Mouse_Cortex',
            'Mouse_Cerebellum',
            'Mouse_Cerebral cortex',
            'Mouse_Hippocampus',
            'Mouse_Prefrontal cortex',
            'Mouse_Subventricular zone'
          ],
          type: 'pie'
        }
      ],
      layout3: {
        title: {
          text: 'Region',
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
      pieData4: [
        {
          values: [17, 9, 29, 18],
          labels: ['Human-male', 'Human-female', 'Mouse-male', 'Mouse-female'],
          type: 'pie'
        }
      ],
      layout4: {
        title: {
          text: 'Gender',
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
        const data = state.ad.datasets
        delete data.silhouette_score
        delete data.ari_score
        return data
      },
      dialogData: (state) => state.ad.dialogDataset,
      selectDatasetDialogData: (state) => state.ad.SelectDatasetDialogData
    }),
    bannerMessage() {
      return `You are visiting scREAD's dev version. Please let us know for any issues or suggestions via qin.ma@osumc.edu.`
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
    }
  },
  mounted() {
    this.$notifier.showAlert({ content: this.bannerMessage, color: 'accent' })
  },
  methods: {
    async handleClick(item) {
      // this.$router.push('/browse/' + dataset.data_id)
      await this.$store.dispatch('ad/setDialog', item.data_id)
      this.computedDialogData = this.dialogData[0]
      this.dialog = true
    },

    clickSelectDatasetDialog(item) {
      //  await this.$store.dispatch('ad/setDialog', item.data_id)
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
<style></style>
