<template>
  <v-card>
    <v-card-text>
      <v-row
        ><v-col xs="12" md="12" lg="12">
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
                label="Search differentially expressed gene"
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
            <p>
              Total Differentially expressed genes found: {{ results.count }}
            </p>
            <v-card-text
              ><p class="title">Select filters:</p>
              <v-row>
                <v-col xs="12" md="6" lg="2">
                  <p class="subtitle-1 font-weight-bold py-0 my-0">Species:</p>
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
                <v-col xs="12" md="6" lg="2">
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
                <v-col xs="12" md="6" lg="2">
                  <p class="subtitle-1 font-weight-bold py-0 my-0">Region:</p>
                  <v-select
                    v-model="searchDefault.region"
                    :items="searchItems.region"
                    item-text="value"
                    item-value="value"
                    return-object
                    single-line
                    multiple
                  ></v-select>
                </v-col>
                <v-col xs="12" md="6" lg="2">
                  <p class="subtitle-1 font-weight-bold  py-0 my-0">Gender:</p>
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
                <v-col xs="12" md="6" lg="2">
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
                ></v-card-actions
              ></v-card-text
            >
            <v-data-table
              dense
              :headers="headers"
              :items="filterResults"
              :items-per-page="10"
              class="elevation-1"
            >
            </v-data-table>
          </div> </v-col
      ></v-row>
    </v-card-text>
  </v-card>
</template>

<script>
import { mapState } from 'vuex' // <--- To map data from Vuex

export default {
  name: 'SearchGene',
  components: {},

  data() {
    return {
      searchGene: '',
      headers: [
        { text: 'Gene', value: 'gene' },
        { text: 'logFC', value: 'avg_logFC' },
        { text: 'Adj.Pval', value: 'p_val_adj' },

        { text: 'Comparison type', value: 'type' },
        { text: 'Cell type', value: 'ct' },
        { text: 'Cluster', value: 'cluster' },
        { text: 'Species', value: 'species' },
        { text: 'Region', value: 'region' },
        { text: 'Gender', value: 'gender' },
        { text: 'Condition', value: 'condition' },
        { text: 'Compared Data 1', value: 'a_data_id' },
        { text: 'Compared data 2', value: 'b_data_id' }
      ],
      searchDefault: {
        species: ['Human', 'Mouse'],
        condition: ['Control', 'Disease'],
        region: [
          'Cerebellum',
          'Cerebral cortex',
          'Cortex',
          'Entorhinal Cortex',
          'Hippocampus',
          'Prefrontal cortex',
          'Superior frontal gyrus (BA8)',
          'Cortex_and_hippocampus',
          'subventricular zone_and_hippocampus',
          'Superior parietal lobe'
        ],
        gender: ['Female', 'Male'],
        comparisonType: ['cell_type_specific', 'subcluster_specific', 'a_vs_b']
      },
      searchItems: {
        species: ['Human', 'Mouse'],
        condition: ['Control', 'Disease'],
        region: [
          'Cerebellum',
          'Cerebral cortex',
          'Cortex',
          'Entorhinal Cortex',
          'Hippocampus',
          'Prefrontal cortex',
          'Superior frontal gyrus (BA8)',
          'Cortex_and_hippocampus',
          'subventricular zone_and_hippocampus',
          'Superior parietal lobe'
        ],
        gender: ['Female', 'Male'],
        comparisonType: ['cell_type_specific', 'subcluster_specific', 'a_vs_b']
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
          const thisData = this.dataset.filter(
            (element) => element.data_id === row.a_data_id
          )
          const thisDeMeta = this.deMeta.filter(
            (meta) =>
              meta.data_id === row.a_data_id && meta.b_data_id === row.b_data_id
          )
          return {
            ...row,
            ...thisDeMeta[0],
            ...thisData[0]
          }
        })
        .filter((row) => {
          for (const species of this.searchDefault.species) {
            if (species === row.species) {
              return true
            }
          }
        })
        .filter((row) => {
          for (const region of this.searchDefault.region) {
            if (region === row.region) {
              return true
            }
          }
        })
        .filter((row) => {
          for (const gender of this.searchDefault.gender) {
            if (gender === row.gender) {
              return true
            }
          }
        })
        .filter((row) => {
          for (const comparisonType of this.searchDefault.comparisonType) {
            if (comparisonType === row.type) {
              return true
            }
          }
        })
        .filter((row) => {
          for (const condition of this.searchDefault.condition) {
            if (condition === row.condition) {
              return true
            }
          }
        })

      return res
    },
    displayResetFilter() {
      return 1
    }
  },
  methods: {
    async searchDeByGene(gene) {
      await this.$store.dispatch('ad/fetchDeGene', gene)
    },
    resetFilter() {
      this.searchDefault = {
        species: ['Human', 'Mouse'],
        condition: ['Control', 'Disease'],
        region: [
          'Cerebellum',
          'Cerebral cortex',
          'Cortex',
          'Entorhinal Cortex',
          'Hippocampus',
          'Prefrontal cortex',
          'Superior frontal gyrus (BA8)',
          'Cortex_and_hippocampus',
          'subventricular zone_and_hippocampus',
          'Superior parietal lobe'
        ],
        gender: ['Female', 'Male'],
        comparisonType: ['cell_type_specific', 'subcluster_specific', 'a_vs_b']
      }
    }
  }
}
</script>

<style lang="scss" scoped></style>
