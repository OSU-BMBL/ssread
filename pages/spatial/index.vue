<template>
  <div>
    <v-layout column justify-center align-center>
      <v-flex xs="12" md="6" lg="12">
        <p class="display-1">
          Spatial RNA-seq datasets
        </p>
      </v-flex>
    </v-layout>

    <client-only>
      <v-row v-show="false">
        <v-col ref="pie" xs="6" md="6" lg="3">
          <vue-plotly
            :data="pieData1"
            :layout="layout1"
            :options="options"
            @click="clickSelectDatasetDialog()"
          /> </v-col
        ><v-col xs="6" md="6" lg="3">
          <vue-plotly
            :data="pieData2"
            :layout="layout2"
            :options="options"
            @click="clickSelectDatasetDialog()"
          /> </v-col
        ><v-col xs="6" md="6" lg="3">
          <vue-plotly
            :data="pieData3"
            :layout="layout3"
            :options="options"
            @click="clickSelectDatasetDialog()"
          /> </v-col
        ><v-col xs="6" md="6" lg="3">
          <vue-plotly
            :data="pieData4"
            :layout="layout4"
            :options="options"
            @click="clickSelectDatasetDialog()"
          /> </v-col
      ></v-row>
    </client-only>
    <div class="motif-header">
      <v-card class="mx-auto">
        <v-card-title>
          <p class="title">
            scREAD covers 1 spatial datasets from 1 studies, 1 brain regions.
          </p>
          <v-spacer></v-spacer>
        </v-card-title>
        <v-card-text
          ><p class="title">Select filters:</p>
          <v-row>
            <v-col xs="12" md="6" lg="2">
              <p class="subtitle-1 font-weight-bold py-0 my-0">Species:</p>
              <v-select
                v-model="browseDefault.species"
                :items="browseItems.species"
                item-text="value"
                item-value="value"
                return-object
                single-line
              ></v-select>
            </v-col>
            <v-col xs="12" md="6" lg="2">
              <p class="subtitle-1 font-weight-bold py-0 my-0">Region:</p>
              <v-select
                v-model="browseDefault.region"
                :items="browseItems.region"
                item-text="value"
                item-value="value"
                return-object
                single-line
              ></v-select>
            </v-col>
            <v-col xs="12" md="6" lg="6">
              <p class="subtitle-1 font-weight-bold py-0 my-0">
                Experimental factors:
              </p>
              <v-autocomplete
                v-model="factor"
                :items="factors"
                item-text="value"
                item-value="value"
                return-object
                single-line
                multiple
              ></v-autocomplete>
            </v-col>
          </v-row>
          <v-card-actions>
            <download-excel class="mr-4" :data="filterDataset" type="csv">
              <v-btn color="primary"> Download current table</v-btn>
            </download-excel>

            <v-btn
              v-show="displayResetFilter"
              color="primary"
              dark
              @click="resetFilter"
              >RESET FILTER</v-btn
            ></v-card-actions
          ></v-card-text
        >
        <v-dialog v-model="dialog" max-width="600">
          <v-card>
            <v-card-title>Dataset overview</v-card-title>
            <v-divider class="my-2 py-2"></v-divider>
            <v-card-text>
              <p class="my-2">
                <span class="text--secondary">scREAD ID: </span>
                <span class="text--primary">ST001</span>
              </p>
              <p class="my-2">
                <span class="text--secondary">Species: </span>
                <span class="text--primary">{{
                  computedDialogData.species
                }}</span>
              </p>
              <p class="my-2">
                <span class="text--secondary">Region: </span>
                <span class="text--primary">
                  Dorsolateral prefrontal cortex</span
                >
              </p>
              <p class="my-2">
                <span class="text--secondary">Experimental factors: </span>
                <span class="text--primary">{{ computedDialogData.age }}</span>
              </p>
              <p class="my-2">
                <span class="text--secondary">Publication: </span>
                <span class="text--primary"
                  ><a
                    href="https://www.nature.com/articles/s41593-020-00787-0"
                    target="_blank"
                    >Transcriptome-scale spatial gene expression in the human
                    dorsolateral prefrontal cortex</a
                  >
                </span>
              </p>
            </v-card-text>
            <v-card-actions>
              <v-btn
                class="mx-2"
                color="primary"
                dark
                @click="openDetailsPage()"
              >
                details </v-btn
              ><v-btn color="grey darken-1" text @click="dialog = false">
                cancel
              </v-btn>
              <v-spacer></v-spacer>
            </v-card-actions>
          </v-card>
        </v-dialog>

        <v-dialog v-model="selectDatasetDialog" max-width="800">
          <v-card>
            <v-card-title>Dataset selection</v-card-title>
            <v-divider class="my-2 py-2"></v-divider>
            <v-card-text>
              <p class="my-2">
                <v-select
                  v-model="browseDefault.species"
                  :items="browseItems.species"
                  item-text="value"
                  item-value="value"
                  label="Species"
                  return-object
                  outlined
                ></v-select>
              </p>
              <p class="my-2">
                <v-select
                  v-model="browseDefault.condition"
                  :items="browseItems.condition"
                  item-text="value"
                  item-value="value"
                  label="Condition"
                  return-object
                  outlined
                ></v-select>
              </p>
              <p class="my-2">
                <v-select
                  v-model="browseDefault.gender"
                  :items="browseItems.gender"
                  item-text="value"
                  item-value="value"
                  label="Gender"
                  return-object
                  outlined
                ></v-select>
              </p>
              <p class="my-2">
                <v-select
                  v-model="browseDefault.region"
                  :items="browseItems.region"
                  item-text="value"
                  item-value="value"
                  label="Brain region"
                  return-object
                  outlined
                ></v-select>
              </p>
            </v-card-text>
            <v-card-actions>
              <v-btn
                class="mx-2"
                color="primary"
                dark
                @click="updateSelectDataset()"
              >
                apply
              </v-btn>
              <v-btn
                v-show="displayResetFilter"
                color="primary"
                dark
                @click="resetFilter"
                >RESET FILTER</v-btn
              >
              <v-btn
                color="grey darken-1"
                text
                @click="selectDatasetDialog = false"
              >
                cancel
              </v-btn>
              <v-spacer></v-spacer>
            </v-card-actions>
          </v-card>
        </v-dialog>

        <v-data-table
          id="datasetTable"
          :headers="headers"
          :items="filterDataset"
          :items-per-page="15"
          sort-by="species"
          class="elevation-1"
        >
          <template v-slot:item="row">
            <tr @click="handleClick(row.item)">
              <td>
                <nuxt-link :to="'/spatial/ST001'">ST001</nuxt-link>
              </td>
              <td>Human</td>
              <td>Dorsolateral prefrontal cortex</td>
              <td>
                Transcriptome-scale spatial gene expression in the human
                dorsolateral prefrontal cortex
              </td>
              <td>GSE152506</td>
              <td>
                <ul>
                  <li>Disease</li>
                  <li>Brain disorder</li>
                  <li>Age</li>
                  <li>Sex</li>
                  <li>inferred cell type - authors labels</li>
                </ul>
              </td>
              <td>12</td>
            </tr>
          </template>
        </v-data-table>
      </v-card>
    </div>
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
      totalStudy: '1',
      computedDialogData: [],
      factor: '',
      factors: ['Disease', 'Brain disorder', 'Age'],
      headers: [
        {
          text: 'scREAD ID',
          align: 'start',
          sortable: false,
          value: 'data_id'
        },
        { text: 'Species', value: 'species' },
        { text: 'Region', value: 'gender' },
        { text: 'Publication', value: 'condition' },
        { text: 'GEO/synapse ID', value: 'public_id' },
        { text: 'Experimental factors', value: 'public_id' },
        { text: 'Number of samples', value: 'public_id' }
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
          values: [26],
          labels: ['Human'],
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
          values: [1],
          labels: ['Human-control'],
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
          values: [1],
          labels: ['Human_Entorhinal Cortex'],
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
          values: [1],
          labels: ['Human-male'],
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
      result = result.filter((row) => row.data_id === 'AD00101')
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
      this.$router.push('/spatial/ST001')
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
