<template>
  <v-hover v-slot:default="{ hover }" open-delay="0">
    <v-card
      class="mx-auto"
      :elevation="hover ? 6 : 2"
      :class="{ 'on-hover': hover }"
    >
      <v-card-title>
        <p class="title">
          Search differentially expressed genes
        </p>
        <v-spacer></v-spacer>
      </v-card-title>
      <v-card-text>
        <v-row>
          <v-col xs="12" md="12" lg="12">
            <v-row>
              <v-col cols="3"
                ><v-text-field
                  v-model="searchGene"
                  class=""
                  type="search"
                  clearable
                  solo
                  hide-details
                  autofocus
                  label="Search"
                  height="50"
                  style="font-size:1.6em !important"
                  prepend-inner-icon="mdi-magnify"
              /></v-col>
              <v-col cols="3">
                <v-btn
                  x-large
                  class="mx-2"
                  color="primary"
                  height="50"
                  @click="searchDeByGene(searchGene)"
                >
                  Search</v-btn
                ></v-col
              >
            </v-row>

            <div v-if="results.rows">
              <p>Found {{ results.count }} records</p>
              <v-card-text
                ><p class="title">Select filters:</p>
                <v-row>
                  <v-col xs="12" md="6" lg="4">
                    <p class="subtitle-1 font-weight-bold py-0 my-0">
                      Species:
                    </p>
                    <v-select
                      v-model="searchDefault.species"
                      :items="searchItems.species"
                      item-text="value"
                      item-value="value"
                      return-object
                      single-line
                      multiple
                    ></v-select>
                  </v-col>
                  <v-col xs="12" md="6" lg="4">
                    <p class="subtitle-1 font-weight-bold py-0 my-0">
                      Condition:
                    </p>
                    <v-select
                      v-model="searchDefault.condition"
                      :items="searchItems.condition"
                      item-text="value"
                      item-value="value"
                      return-object
                      single-line
                      multiple
                    ></v-select>
                  </v-col>
                  <v-col xs="12" md="6" lg="4">
                    <p class="subtitle-1 font-weight-bold  py-0 my-0">
                      Comparison type:
                    </p>
                    <v-select
                      v-model="searchDefault.comparisonType"
                      :items="searchItems.comparisonType"
                      item-text="value"
                      item-value="value"
                      return-object
                      single-line
                      multiple
                    ></v-select>
                  </v-col>

                  <v-col xs="12" md="6" lg="4">
                    <p class="subtitle-1 font-weight-bold  py-0 my-0">
                      Gender:
                    </p>
                    <v-select
                      v-model="searchDefault.gender"
                      :items="searchItems.gender"
                      item-text="value"
                      item-value="value"
                      return-object
                      single-line
                      multiple
                    ></v-select>
                  </v-col>
                  <v-col xs="12" md="6" lg="4">
                    <p class="subtitle-1 font-weight-bold  py-0 my-0">
                      Cell type:
                    </p>
                    <v-select
                      v-model="searchDefault.cellType"
                      :items="searchItems.cellType"
                      item-text="value"
                      item-value="value"
                      return-object
                      single-line
                      multiple
                    >
                      <template v-slot:selection="{ item, index }">
                        <v-chip v-if="index === 0">
                          <span>{{ item }}</span>
                        </v-chip>
                        <span v-if="index === 1" class="grey--text caption">
                          (+{{ searchDefault.cellType.length - 1 }} others)
                        </span>
                      </template>
                      <template v-slot:prepend-item>
                        <v-list-item ripple @click="toggleSelectCellType">
                          <v-list-item-action>
                            <v-icon
                              :color="
                                searchDefault.cellType.length > 0
                                  ? 'indigo darken-4'
                                  : ''
                              "
                            >
                              {{ iconSelectCellType }}
                            </v-icon>
                          </v-list-item-action>
                          <v-list-item-content>
                            <v-list-item-title>
                              Select All
                            </v-list-item-title>
                          </v-list-item-content>
                        </v-list-item>
                        <v-divider class="mt-2"></v-divider>
                      </template>
                    </v-select> </v-col
                  ><v-col xs="12" md="6" lg="4">
                    <p class="subtitle-1 font-weight-bold py-0 my-0">Region:</p>
                    <v-select
                      v-model="searchDefault.region"
                      :items="searchItems.region"
                      item-text="value"
                      item-value="value"
                      return-object
                      single-line
                      multiple
                      ><template v-slot:selection="{ item, index }">
                        <v-chip v-if="index === 0">
                          <span>{{ item }}</span>
                        </v-chip>
                        <span v-if="index === 1" class="grey--text caption">
                          (+{{ searchDefault.region.length - 1 }} others)
                        </span>
                      </template>
                      <template v-slot:prepend-item>
                        <v-list-item ripple @click="toggleSelectRegion">
                          <v-list-item-action>
                            <v-icon
                              :color="
                                searchDefault.region.length > 0
                                  ? 'indigo darken-4'
                                  : ''
                              "
                            >
                              {{ iconSelectRegion }}
                            </v-icon>
                          </v-list-item-action>
                          <v-list-item-content>
                            <v-list-item-title>
                              Select All
                            </v-list-item-title>
                          </v-list-item-content>
                        </v-list-item>
                        <v-divider class="mt-2"></v-divider> </template
                    ></v-select>
                  </v-col>
                </v-row>
                <v-card-actions>
                  <download-excel class="mr-4" :data="filterResults" type="csv">
                    <v-btn color="primary"> Download current table</v-btn>
                  </download-excel>

                  <v-btn
                    v-show="displayResetFilter"
                    color="primary"
                    dark
                    @click="resetFilter"
                    >RESET FILTER</v-btn
                  >
                  <v-tooltip top>
                    <template v-slot:activator="{ on, attrs }">
                      <v-icon color="primary" dark v-bind="attrs" v-on="on"
                        >mdi-help-circle-outline</v-icon
                      >
                    </template>
                    <p>
                      Log fold-change : log fold-chage of the average expression
                      between the two groups. Positive values indicate that the
                      feature is more highly expressed in the first group.
                    </p>
                    <p>
                      Pct.1 : The percentage of cells where the feature is
                      detected in the first group
                    </p>
                    <p>
                      Pct.2 : The percentage of cells where the feature is
                      detected in the second group
                    </p>
                    <p>
                      Adjusted p-value : Adjusted p-value, based on bonferroni
                      correction using all features in the dataset.
                    </p>
                  </v-tooltip>
                </v-card-actions></v-card-text
              >
              <v-data-table
                dense
                :headers="searchGeneHeaders"
                :items="filterResults"
                :items-per-page="10"
                class="elevation-1"
              >
              </v-data-table>
            </div> </v-col
        ></v-row>
      </v-card-text>
    </v-card>
  </v-hover>
</template>

<script>
import { mapState } from 'vuex' // <--- To map data from Vuex
import _ from 'lodash'
export default {
  name: 'SearchGene',
  components: {},

  data() {
    return {
      searchGene: '',
      searchGeneHeaders: [
        { text: 'Gene', value: 'gene' },
        { text: 'logFC', value: 'avg_logFC' },
        { text: 'Adjusted p-value', value: 'p_val_adj' },
        { text: 'Pct.1', value: 'pct_1' },
        { text: 'Pct.2', value: 'pct_2' },
        { text: 'Cell type', value: 'ct' },
        { text: 'Cluster', value: 'cluster' },
        { text: 'Species', value: 'b_species' },
        { text: 'Region', value: 'b_region' },
        { text: 'Gender', value: 'b_gender' },
        { text: 'Condition', value: 'b_condition' },
        { text: 'Comparison', value: 'description' },
        { text: 'Description', value: 'desc' }
      ],
      searchDefault: {
        species: ['Human', 'Mouse'],
        condition: ['Control', 'Disease'],
        region: [
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
        gender: ['Female', 'Male'],
        cellType: [
          'Astrocytes',
          'Microglia',
          'Endothelial cells',
          'Excitatory neurons',
          'Inhibitory neurons',
          'Oligodendrocytes',
          'Oligodendrocyte precursor cells',
          'Pericytes',
          'NK cells'
        ],
        comparisonType: [
          'Cell type specific',
          'Subcluster specific',
          'Cross dataset comparison'
        ]
      },
      searchItems: {
        species: ['Human', 'Mouse'],
        condition: ['Control', 'Disease'],
        region: [
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
        gender: ['Female', 'Male'],
        cellType: [
          'Astrocytes',
          'Microglia',
          'Endothelial cells',
          'Excitatory neurons',
          'Inhibitory neurons',
          'Oligodendrocytes',
          'Oligodendrocyte precursor cells',
          'Pericytes',
          'NK cells'
        ],
        comparisonType: [
          'Cell type specific',
          'Subcluster specific',
          'Cross dataset comparison'
        ]
      }
    }
  },
  computed: {
    ...mapState({
      dataset: (state) => state.ad.datasets,
      deMeta: (state) => state.ad.deAllMeta,
      results: (state) => state.ad.deGene
    }),
    filterResults() {
      const res = this.results.rows
        .map((row) => {
          const thisDeMeta = this.deMeta.filter(
            (meta) =>
              meta.data_id === row.b_data_id && meta.b_data_id === row.a_data_id
          )[0]
          const desc = _.pick(thisDeMeta, ['description', 'hint', 'value'])

          const aInfo = this.dataset
            .filter((element) => element.data_id === row.a_data_id)
            .map(({ species, condition, region, gender }) => ({
              a_species: species,
              a_condition: condition,
              a_region: region,
              a_gender: gender
            }))[0]
          const bInfo = this.dataset
            .filter((element) => element.data_id === row.b_data_id)
            .map(({ species, condition, region, gender }) => ({
              b_species: species,
              b_condition: condition,
              b_region: region,
              b_gender: gender
            }))[0]
          // console.log(aInfo)
          return {
            ...row,
            ...aInfo,
            ...bInfo,
            ...desc
          }
        })
        .map((row) => {
          // Some text conversion for display
          row.p_val_adj = row.p_val_adj.toExponential(2)
          if (row.type === 'subcluster') {
            row.description = 'Subcluster specific'
          }
          if (row.ct === 'exc') {
            row.ct = 'Excitatory neurons'
          }
          if (row.ct === 'opc') {
            row.ct = 'Oligodendrocyte precursor cells'
          }
          if (row.ct === 'inh') {
            row.ct = 'Inhibitory neurons'
          }
          if (row.ct === 'oli') {
            row.ct = 'Oligodendrocytes'
          }
          if (row.ct === 'mic') {
            row.ct = 'Microglia'
          }
          if (row.ct === 'ast') {
            row.ct = 'Astrocytes'
          }
          if (row.ct === 'end') {
            row.ct = 'Endothelial cells'
          }
          if (row.ct === 'nk ') {
            row.ct = 'NK cells'
          }
          if (row.ct === 'per') {
            row.ct = 'Pericytes'
          }

          return row
        })
        .filter((row) => {
          for (const species of this.searchDefault.species) {
            if (species === row.b_species) {
              return true
            }
          }
        })
        .filter((row) => {
          for (const region of this.searchDefault.region) {
            if (region === row.b_region) {
              return true
            }
          }
        })
        .filter((row) => {
          for (const gender of this.searchDefault.gender) {
            if (gender === row.b_gender) {
              return true
            }
          }
        })
        .filter((row) => {
          for (const cellType of this.searchDefault.cellType) {
            if (cellType === row.ct) {
              return true
            }
          }
        })
        .filter((row) => {
          for (let comparisonType of this.searchDefault.comparisonType) {
            if (comparisonType === 'Subcluster specific') {
              comparisonType = 'subcluster'
            }
            if (comparisonType === 'Cell type specific') {
              comparisonType = 'cell_type_specific'
            }

            if (comparisonType === 'Cross dataset comparison') {
              comparisonType = 'a_vs_b'
            }
            if (comparisonType === row.type) {
              return true
            }
          }
        })
        .filter((row) => {
          for (const condition of this.searchDefault.condition) {
            if (condition === row.b_condition) {
              return true
            }
          }
        })
        .map((row) =>
          // Custom description example: AD00101(Male, Disease) vs  AD00103(Male, control)
          {
            if (row.type === 'subcluster') {
              row.desc = `${row.a_data_id} ${row.ct} (subcluster ${row.cluster} vs other subclusters) `
            }
            if (row.type === 'cell_type_specific') {
              row.desc = `${row.a_data_id}(${row.ct} vs others)`
            }
            if (row.type === 'a_vs_b') {
              row.desc = `${row.a_data_id}(${row.a_gender},${row.a_condition},${row.a_region}) vs ${row.b_data_id}(${row.b_gender},${row.b_condition},${row.b_region}) `
            }
            return row
          }
        )
      return res
    },
    displayResetFilter() {
      return 1
    },
    selectAllCellType() {
      return (
        this.searchDefault.cellType.length === this.searchItems.cellType.length
      )
    },
    selectSomeCellType() {
      return this.searchDefault.cellType.length > 0 && !this.selectAllCellType
    },
    selectAllRegion() {
      return this.searchDefault.region.length === this.searchItems.region.length
    },
    selectSomeRegion() {
      return this.searchDefault.region.length > 0 && !this.selectAllRegion
    },
    iconSelectCellType() {
      if (this.selectAllCellType) return 'mdi-close-box'
      if (this.selectSomeCellType) return 'mdi-minus-box'
      return 'mdi-checkbox-blank-outline'
    },
    iconSelectRegion() {
      if (this.selectAllRegion) return 'mdi-close-box'
      if (this.selectSomeRegion) return 'mdi-minus-box'
      return 'mdi-checkbox-blank-outline'
    }
  },
  methods: {
    async searchDeByGene(gene) {
      await this.$store.dispatch('ad/fetchDeGene', gene)
    },
    resetFilter() {
      // Prevent copy reference
      this.searchDefault = { ...this.searchItems }
    },
    toggleSelectCellType() {
      this.$nextTick(() => {
        if (this.selectAllCellType) {
          this.searchDefault.cellType = []
        } else {
          this.searchDefault.cellType = this.searchItems.cellType
        }
      })
    },
    toggleSelectRegion() {
      this.$nextTick(() => {
        if (this.selectAllRegion) {
          this.searchDefault.region = []
        } else {
          this.searchDefault.region = this.searchItems.region
        }
      })
    }
  }
}
</script>

<style lang="scss" scoped></style>
