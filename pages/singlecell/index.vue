<template>
  <div>
    <v-layout column justify-center align-center>
      <v-flex xs="12" md="6" lg="12">
        <p class="display-1">
          scRNA-seq datasets
        </p>
      </v-flex>
    </v-layout>

    <v-card class="mx-auto">
      <v-card-title>
        <p class="title">
          ssREAD covers {{ totalDatasets }} datasets from 34 studies, 18 brain
          regions, and 2,194,144 cells.
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
            <p class="subtitle-1 font-weight-bold py-0 my-0">Gender:</p>
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
      <v-dialog v-model="dialog" max-width="300">
        <v-card>
          <v-card-title>Dataset overview</v-card-title>
          <v-divider class="my-2 py-2"></v-divider>
          <v-card-text>
            <p class="my-2">
              <span class="text--secondary">Data ID: </span>
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
              <span class="text--primary">{{ computedDialogData.region }}</span>
            </p>
            <p class="my-2">
              <span class="text--secondary">Condition: </span>
              <span class="text--primary">{{
                computedDialogData.condition
              }}</span>
            </p>
            <p class="my-2">
              <span class="text--secondary">Braak stage: </span>
              <span class="text--primary">{{ computedDialogData.stage }}</span>
            </p>
            <p class="my-2">
              <span class="text--secondary">Gender: </span>
              <span class="text--primary">{{ computedDialogData.gender }}</span>
            </p>
            <p class="my-2">
              <span class="text--secondary">Age: </span>
              <span class="text--primary">{{ computedDialogData.age }}</span>
            </p>
          </v-card-text>
          <v-card-actions>
            <v-btn class="mx-2" color="primary" dark @click="openDetailsPage()">
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
              <nuxt-link :to="'/' + row.item.data_id">{{
                row.item.data_id
              }}</nuxt-link>
            </td>
            <td>{{ row.item.species }}</td>
            <td>{{ row.item.gender }}</td>
            <td>{{ row.item.condition }}</td>
            <td>{{ row.item.region }}</td>
            <td>{{ row.item.stage }}</td>
            <td>{{ row.item.age }}</td>
            <td>{{ row.item.mice_model }}</td>
            <td>
              <a
                v-if="row.item.public_id.startsWith('GSE')"
                :href="
                  'https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=' +
                    row.item.public_id
                "
                target="_blank"
                >{{ row.item.public_id }}</a
              >
              <a
                v-else
                :href="
                  'https://www.synapse.org/#!Synapse:' + row.item.public_id
                "
                target="_blank"
                >{{ row.item.public_id }}</a
              >
            </td>
            <td>{{ row.item.n_cell }}</td>
          </tr>
        </template>
      </v-data-table>
    </v-card>
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
        const data = state.ad_v2.datasets
        delete data.silhouette_score
        delete data.ari_score
        return data
      },
      dialogData: (state) => state.ad_v2.dialogDataset,
      selectDatasetDialogData: (state) => state.ad_v2.SelectDatasetDialogData
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
          hid: 'ssREAD homepage',
          name: 'ssREAD home page',
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
