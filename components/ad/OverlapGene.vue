<template>
  <v-card class="mx-auto" :loading="loading">
    <template slot="progress">
      <v-progress-linear
        :active="loading"
        :indeterminate="loading"
        absolute
        top
        color="primary"
      ></v-progress-linear>
    </template>
    <v-card-title>
      <p class="title">
        Find overlapping DEGs from multiple comparisons
        <v-tooltip top max-width="500px">
          <template v-slot:activator="{ on, attrs }">
            <v-icon color="primary" dark v-bind="attrs" v-on="on"
              >mdi-help-circle-outline</v-icon
            >
          </template>
          <span
            >Suppose we have AD vs control comparisons from a cell type of
            interest in a specific brain region. For each comparison, we select
            top t DEGs based on the ranked log FC. We define an "overlapping
            gene" as the gene that appears at least n times in m comparisons.
            The Species, brain regions, minimal number of comparisons, number of
            top DEGs are the parameters set by the users.</span
          >
        </v-tooltip>
      </p>
      <v-spacer></v-spacer>
    </v-card-title>
    <v-card-text>
      <v-row
        ><v-col
          ><v-btn depressed color="primary" @click="fillExample">
            Example
          </v-btn></v-col
        ></v-row
      >
      <v-row>
        <v-col xs="6" md="4" lg="2">
          <p class="subtitle-1 font-weight-bold py-0 my-0">Species:</p>
          <v-select
            v-model="species"
            :items="browseItems.species"
            item-text="value"
            item-value="value"
            return-object
            single-line
          ></v-select>
        </v-col>
        <v-col xs="6" md="4" lg="2">
          <p class="subtitle-1 font-weight-bold py-0 my-0">Region:</p>
          <v-select
            v-model="region"
            :items="browseItems.regions"
            item-text="value"
            item-value="value"
            return-object
            single-line
          ></v-select>
        </v-col>
        <v-col xs="4" md="2" lg="2">
          <p class="subtitle-1 font-weight-bold py-0 my-0">
            # comparisons threshold:
          </p>
          <v-text-field
            v-model="threshold"
            type="number"
            min="1"
          ></v-text-field>
        </v-col>
        <v-col xs="4" md="2" lg="2">
          <p class="subtitle-1 font-weight-bold py-0 my-0">
            # top DEGs:
          </p>
          <v-text-field v-model="top" type="number"></v-text-field>
        </v-col>
        <v-col xs="4" md="4" lg="2">
          <p class="subtitle-1 font-weight-bold py-0 my-0">Direction:</p>
          <v-radio-group v-model="direction" row>
            <v-radio label="UP" value="up"></v-radio>
            <v-radio label="Down" value="down"></v-radio>
          </v-radio-group>
        </v-col>
        <v-col xs="4" md="2" lg="1">
          <v-btn
            x-large
            depressed
            color="primary"
            @click="searchOverlap(species, region, top, threshold, direction)"
          >
            Search
          </v-btn>
        </v-col>
      </v-row>
      <div v-if="loaded">
        <div v-if="dataset.length > 0">
          <p>Found {{ dataset.length }} records</p>
          <v-row>
            <v-col xs="6" md="6" lg="4">
              <v-text-field
                v-model="filter"
                placeholder="Search cell type or gene or id in results"
                append-icon="mdi-magnify"
                single-line
                hide-details
              ></v-text-field>
            </v-col>
            <v-col xs="4" md="2" lg="1">
              <download-excel class="mr-4" :data="filterResults" type="csv">
                <v-btn color="primary"> Download current table</v-btn>
              </download-excel>
            </v-col>
          </v-row>
          <v-data-table
            dense
            :headers="headers"
            :items="filterResults"
            :search="filter"
            :items-per-page="10"
            class="elevation-1"
          >
          </v-data-table>
        </div>
        <div v-else>
          <p class="mt-2 font-weight-bold text-body-1">
            No record found
          </p>
        </div>
      </div>
    </v-card-text>
  </v-card>
</template>

<script>
import { mapState } from 'vuex'
import _ from 'lodash'
export default {
  name: 'SearchGene',
  components: {},
  data() {
    return {
      species: '',
      region: '',
      threshold: 3,
      top: 100,
      direction: 'up',
      browseItems: {
        species: ['Human', 'Mouse'],
        regions: [
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
        ]
      },
      headers: [
        { text: 'Cell type', value: 'cluster' },
        { text: 'Gene', value: 'gene' },
        { text: 'logFC', value: 'avg_logFC', filterable: false },
        { text: 'Adj P-Value', value: 'p_val_adj', filterable: false },
        { text: 'Pct 1', value: 'pct_1', filterable: false },
        { text: 'Pct 2', value: 'pct_2', filterable: false },
        { text: 'Disease ID', value: 'disease_id' },
        { text: 'Control ID', value: 'control_id' },
        { text: 'Rank', value: 'rank', filterable: false },
        {
          text: 'Total Comparisons',
          value: 'total_comparison',
          filterable: false
        },
        {
          text: 'Overlapping Comparisons',
          value: 'overlapping_comparison',
          filterable: false
        },
        { text: 'Mean Rank', value: 'mean_rank', filterable: false }
      ],
      filter: '',
      loading: false,
      loaded: false
    }
  },
  computed: {
    ...mapState({
      dataset: (state) => _.cloneDeep(state.ad.overlaptable),
      gctMaps: (state) => _.cloneDeep(state.ad.overlapmap)
    }),
    filterResults() {
      const res = this.dataset.map((row) => {
        const clone = {
          ...row,
          p_val_adj: row.p_val_adj.toExponential(2),
          mean_rank: row.mean_rank.toFixed(1)
        }
        return clone
      })
      return res
    }
  },
  methods: {
    fillExample() {
      this.species = 'Human'
      this.region = 'Entorhinal Cortex'
      this.top = 100
      this.threshold = 3
      this.direction = 'up'
      this.searchOverlap(
        this.species,
        this.region,
        this.top,
        this.threshold,
        this.direction
      )
    },
    async searchOverlap(species, region, top, threshold, direction) {
      const params = {
        species,
        region,
        top,
        threshold,
        direction
      }
      this.loading = true
      this.loaded = false
      await this.$store.dispatch('ad/fetchOverlapGene', params)
      this.loading = false
      this.loaded = true
    }
  }
}
</script>
<style lang="scss" scoped></style>
