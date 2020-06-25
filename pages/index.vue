<template>
  <div>
    <v-layout column justify-center align-center>
      <p class="display-3 font-weight-regular" align-center>scREAD</p>
      <v-flex xs="12" md="6" lg="12">
        <p class="display-1">
          A single-cell RNA-Seq database for Alzheimer's Disease
        </p>
      </v-flex>
    </v-layout>
    <v-row
      ><v-col xs="6" md="6" lg="3">
        <vue-plotly :data="pieData1" :layout="layout1" /> </v-col
      ><v-col xs="6" md="6" lg="3">
        <vue-plotly :data="pieData2" :layout="layout2" /> </v-col
      ><v-col xs="6" md="6" lg="3">
        <vue-plotly :data="pieData3" :layout="layout3" /> </v-col
      ><v-col xs="6" md="6" lg="3">
        <vue-plotly :data="pieData4" :layout="layout4" /> </v-col
    ></v-row>
    <div class="motif-header">
      <v-card>
        <v-card-title>
          scREAD covers 55 datasets from 11 studies, eight brain regions,
          {{ totalCells }}
          cells.
          <v-spacer></v-spacer>
        </v-card-title>
        <v-card-text
          ><v-row>
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
              <p class="subtitle-1 font-weight-bold py-0 my-0">Condition:</p>
              <v-select
                v-model="browseDefault.condition"
                :items="browseItems.condition"
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
            <v-col xs="12" md="6" lg="2">
              <p class="subtitle-1 font-weight-bold  py-0 my-0">Gender:</p>
              <v-select
                v-model="browseDefault.gender"
                :items="browseItems.gender"
                item-text="value"
                item-value="value"
                return-object
                single-line
              ></v-select>
            </v-col>
          </v-row>
          <v-card-actions>
            <download-excel class="mr-4" :data="filterDataset" type="csv">
              <v-btn color="primary"> Download</v-btn>
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
        <v-dialog v-model="dialog" max-width="300">
          <v-card>
            <v-card-title>Overview</v-card-title>
            <v-divider class="my-2 py-2"></v-divider>
            <v-card-text>
              <p class="my-2">
                <span class="text--secondary">scREAD Data ID: </span>
                <span class="text--primary">{{
                  computedDialogData.data_id
                }}</span>
              </p>
              <p class="my-2">
                <span class="text--secondary">Species: </span>
                <span class="text--primary">{{
                  computedDialogData.species
                }}</span>
              </p>
              <p class="my-2">
                <span class="text--secondary">Region: </span>
                <span class="text--primary">{{
                  computedDialogData.region
                }}</span>
              </p>
              <p class="my-2">
                <span class="text--secondary">Condition: </span>
                <span class="text--primary">{{
                  computedDialogData.condition
                }}</span>
              </p>
              <p class="my-2">
                <span class="text--secondary">Stage: </span>
                <span class="text--primary">{{
                  computedDialogData.stage
                }}</span>
              </p>
              <p class="my-2">
                <span class="text--secondary">Gender: </span>
                <span class="text--primary">{{
                  computedDialogData.gender
                }}</span>
              </p>
              <p class="my-2">
                <span class="text--secondary">Age: </span>
                <span class="text--primary">{{ computedDialogData.age }}</span>
              </p>
            </v-card-text>
            <v-card-actions>
              <v-btn
                class="mx-2"
                color="primary "
                text
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
        <v-data-table
          :headers="headers"
          :items="filterDataset"
          :items-per-page="15"
          class="elevation-1"
          @click:row="handleClick"
        ></v-data-table>
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
    } catch (e) {
      error({
        statusCode: 503,
        message: 'ERROR CODE 503, using async await for single motif'
      })
    }
  },
  data() {
    return {
      dialog: false,
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
          'Entorhinal Cortex',
          'Hippocampus',
          'Prefrontal cortex',
          'Superior frontal gyrus'
        ],
        gender: ['All', 'Female', 'Male']
      },
      pieData1: [
        {
          values: [19, 36],
          labels: ['Human', 'Mouse'],
          type: 'pie'
        }
      ],
      layout1: {
        title: {
          text: 'Species'
        },
        autosize: false,
        width: 400,
        height: 500,
        legend: {
          font: {
            size: 14
          },
          orientation: 'h'
        }
      },
      pieData2: [
        {
          values: [5, 14, 10, 26],
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
          text: 'Condition'
        },
        autosize: false,
        width: 400,
        height: 500,
        legend: {
          font: {
            size: 14
          },
          orientation: 'h'
        }
      },
      pieData3: [
        {
          values: [6, 10, 3, 9, 2, 5, 16, 4],
          labels: [
            'Human_Entorhinal Cortex',
            'Human_Prefrontal cortex',
            'Human_Superior frontal gyrus',
            'Mouse_Cortex',
            'Mouse_Cerebellum',
            'Mouse_Cerebral cortex	',
            'Mouse_Hippocampus',
            'Mouse_Prefrontal cortex'
          ],
          type: 'pie'
        }
      ],
      layout3: {
        title: {
          text: 'Region'
        },
        autosize: false,
        width: 400,
        height: 500,
        legend: {
          font: {
            size: 14
          },
          orientation: 'h'
        }
      },
      pieData4: [
        {
          values: [12, 7, 29, 7],
          labels: ['Human-male', 'Human-female', 'Mouse-male', 'Mouse-female'],
          type: 'pie'
        }
      ],
      layout4: {
        title: {
          text: 'Gender'
        },
        autosize: false,
        width: 400,
        height: 400,
        legend: {
          font: {
            size: 14
          },
          orientation: 'h'
        }
      }
    }
  },
  computed: {
    ...mapState({
      dataset: (state) => state.ad.datasets,
      dialogData: (state) => state.ad.dialogDataset
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
          hid: 'description',
          name: 'description',
          content: 'What you need to know'
        }
      ]
    }
  }
}
</script>
<style>
.v-messages__message {
  line-height: 18px;
  font-size: 14px;
}

.v-card__text {
  font-size: 1em;
}
.v-data-table th {
  font-size: 1.2em;
}
.v-data-table td {
  font-size: 1em;
}

.v-data-table td {
  font-size: 1em;
}

.v-expansion-panel-header {
  font-size: 1.2em;
}
</style>
