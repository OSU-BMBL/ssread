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
        <div v-if="dataset.length > 0">
          <p>Found {{ dataset.length }} records</p>
          <v-row>
            <v-col xs="4" md="4" lg="2">
              <p class="subtitle-1 font-weight-bold py-0 my-0">Cell Type:</p>
              <v-select
                v-model="celltypes"
                :items="sub_cts"
                item-text="value"
                item-value="value"
                return-object
                multiple
                single-line
                ><template v-slot:selection="{ item, index }">
                  <v-chip v-if="index === 0">
                    <span>{{ item }}</span>
                  </v-chip>
                  <span v-if="index === 1" class="grey--text caption">
                    (+{{ sub_cts.length - 1 }} others)
                  </span>
                </template>
                <template v-slot:prepend-item>
                  <v-list-item ripple @click="toggleSelectedCTs">
                    <v-list-item-action>
                      <v-icon
                        :color="sub_cts.length > 0 ? 'indigo darken-4' : ''"
                      >
                        {{ iconSelectedCTs }}
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
              </v-select>
            </v-col>
            <v-col xs="4" md="4" lg="2">
              <p class="subtitle-1 font-weight-bold py-0 my-0">Gene:</p>
              <v-select
                v-model="genes"
                :items="sub_genes"
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
                    (+{{ sub_genes.length - 1 }} others)
                  </span>
                </template>
                <template v-slot:prepend-item>
                  <v-list-item ripple @click="toggleSelectedGenes">
                    <v-list-item-action>
                      <v-icon
                        :color="sub_genes.length > 0 ? 'indigo darken-4' : ''"
                      >
                        {{ iconSelectedGenes }}
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
              </v-select>
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
            :items-per-page="10"
            class="elevation-1"
          >
          </v-data-table>
        </div>
        <div v-else>
          <p>No Overlapping Found</p>
        </div>
      </v-card-text>
    </v-card>
  </v-hover>
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
        { text: 'Cell type', value: 'cluster' },
        { text: 'Gene', value: 'gene' },
        { text: 'logFC', value: 'avg_logFC', filterable: false },
        { text: 'Adj P-Value', value: 'p_val_adj', filterable: false },
        { text: 'Pct 1', value: 'pct_1', filterable: false },
        { text: 'Pct 2', value: 'pct_2', filterable: false },
        { text: 'Disease ID', value: 'disease_id', filterable: false },
        { text: 'Control ID', value: 'control_id', filterable: false },
        { text: 'Rank', value: 'rank', filterable: false },
        {
          text: 'Total Comparison',
          value: 'total_comparison',
          filterable: false
        },
        {
          text: 'Overlapping Comparison',
          value: 'overlapping_comparison',
          filterable: false
        },
        { text: 'Mean Rank', value: 'mean_rank', filterable: false }
      ],
      sub_genes: [],
      sub_cts: [],
      genes: [],
      celltypes: []
    }
  },
  computed: {
    ...mapState({
      dataset: (state) => _.cloneDeep(state.ad.overlaptable),
      gctMaps: (state) => _.cloneDeep(state.ad.overlapmap)
    }),
    filterResults() {
      const res = this.dataset
        .map((row) => {
          const clone = {
            ...row,
            p_val_adj: row.p_val_adj.toExponential(2),
            mean_rank: row.mean_rank.toFixed(1)
          }
          return clone
        })
        .filter((row) => {
          for (const g of this.sub_genes) {
            if (g === row.gene) {
              return true
            }
          }
        })
      // res.forEach((row) => {
      //   row.mean_rank = row.mean_rank.toFixed(1)
      // })
      // let res2 = res
      // res2 = res.filter((row) => {
      //   return this.sub_genes.includes(row.gene)
      // })
      return res
    },
    selectedAllCTs() {
      return this.celltypes.length === this.sub_cts.length
    },
    selectedSomeCTs() {
      return this.sub_cts.length > 0 && !this.selectedAllCTs
    },
    iconSelectedCTs() {
      if (this.selectedAllCTs) return 'mdi-close-box'
      if (this.selectedSomeCTs) return 'mdi-minus-box'
      return 'mdi-checkbox-blank-outline'
    },
    selectedAllGenes() {
      return this.genes.length === this.sub_genes.length
    },
    selectedSomeGenes() {
      return this.sub_genes.length > 0 && !this.selectedAllGenes
    },
    iconSelectedGenes() {
      if (this.selectedAllGenes) return 'mdi-close-box'
      if (this.selectedSomeGenes) return 'mdi-minus-box'
      return 'mdi-checkbox-blank-outline'
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
      this.genes = Object.keys(this.gctMaps)
      this.sub_genes = _.cloneDeep(this.genes)
      const cts = Object.values(this.gctMaps).reduce((ret, curr) => {
        return new Set([...ret, ...curr])
      }, new Set())
      this.celltypes = [...cts]
      this.sub_cts = _.cloneDeep(this.celltypes)
    },
    toggleSelectedGenes() {
      this.$nextTick(() => {
        if (this.selectedAllGenes) {
          this.sub_genes = []
        } else {
          this.sub_genes = [...this.genes]
        }
      })
    },
    toggleSelectedCTs() {
      this.$nextTick(() => {
        if (this.selectedAllCTs) {
          this.sub_cts = []
        } else {
          this.sub_cts = [...this.celltypes]
        }
      })
    }
  }
}
</script>
<style lang="scss" scoped></style>
