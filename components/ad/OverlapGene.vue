<template>
  <v-hover v-slot:default="{ hover }" open-delay="0">
    <v-card
      class="mx-auto"
      :elevation="hover ? 6 : 2"
      :class="{ 'on-hover': hover }"
    >
      <v-card-title>
        <p class="title">
          Search Overlapping Genes
        </p>
        <v-spacer></v-spacer>
      </v-card-title>
      <v-card-text>
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
          <v-col xs="4" md="2" lg="1">
            <p class="subtitle-1 font-weight-bold py-0 my-0">Threshold:</p>
            <v-text-field
              v-model="threshold"
              type="number"
              label="Number"
            ></v-text-field>
          </v-col>
          <v-col xs="4" md="2" lg="1">
            <p class="subtitle-1 font-weight-bold py-0 my-0">Top:</p>
            <v-text-field
              v-model="top"
              type="number"
              label="Number"
            ></v-text-field>
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
        <v-data-table
          dense
          :headers="headers"
          :items="filterResults"
          :items-per-page="10"
          class="elevation-1"
        >
        </v-data-table>
      </v-card-text>
    </v-card>
  </v-hover>
</template>

<script>
import { mapState } from 'vuex'
export default {
  name: 'SearchGene',
  components: {},
  data() {
    return {
      species: '',
      region: '',
      threshold: 1,
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
        { text: 'Cell type', value: 'ct' },
        { text: 'Gene', value: 'gene' },
        { text: 'logFC', value: 'avg_logFC' },
        { text: 'Disease ID', value: 'disease_id' },
        { text: 'Control ID', value: 'control_id' },
        { text: 'Rank', value: 'rank' },
        { text: 'Total Comparison', value: 'total_comparison' },
        { text: 'Overlapping Comparison', value: 'overlapping_comparison' },
        { text: 'Mean Rank', value: 'mean_rank' }
      ]
    }
  },
  computed: {
    ...mapState({
      dataset: (state) => state.ad.overlaptable
    }),
    filterResults() {
      const res = this.dataset
      return res
    }
  },
  methods: {
    async searchOverlap(species, region, top, threshold, direction) {
      const params = {
        species,
        region,
        top,
        threshold,
        direction
      }

      await this.$store.dispatch('ad/fetchOverlapGene', params)
    }
  }
}
</script>
<style lang="scss" scoped></style>
