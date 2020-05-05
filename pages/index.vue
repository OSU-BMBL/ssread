<template>
  <div>
    <v-layout column justify-center align-center>
      <v-flex xs12 sm8 md6 lg12>
        <p class="display-2">Scread</p>
        <p class="title">
          Single-cell RNA-seq Alzheimer's Disease Database
        </p>
      </v-flex>
    </v-layout>
    <ais-instant-search-ssr class="px-6 ">
      <ais-search-box v-slot="{ refine }">
        <v-row align="baseline" justify="start">
          <v-text-field
            v-model="currentSearchText"
            class="mt-2 mb-0"
            type="search"
            clearable
            solo
            hide-details
            autofocus
            label="Search"
            height="70"
            style="font-size:1.6em !important"
            prepend-inner-icon="mdi-magnify"
            @input="refine(currentSearchText)"
          />
        </v-row>
        <v-row align="baseline" justify="start">
          <p>Examples:</p>
          <v-btn color="primary" text @click="searchByText(refine, 'apple')">
            Apple
          </v-btn>
          <v-btn
            color="primary"
            text
            @click="searchByText(refine, 'google chrome')"
          >
            google
          </v-btn>
          <v-btn color="primary" text @click="searchByText(refine, 'verizon')">
            verizon
          </v-btn>
          <!--<v-img
            class="ml-auto"
            max-width="120px"
            src="https://www.algolia.com/gatsby-images/search/search-by-algolia.svg"
          ></v-img>-->
        </v-row>
      </ais-search-box>

      <div v-show="currentSearchText">
        <ais-stats></ais-stats>
        <ais-hits>
          <template slot-scope="{ items }">
            <v-layout>
              <v-flex>
                <v-container fluid grid-list-md>
                  <v-layout row wrap>
                    <v-flex
                      v-for="(n, i) in items.length"
                      :key="n"
                      xs12
                      md6
                      lg3
                    >
                      <v-hover v-slot:default="{ hover }" open-delay="0">
                        <v-card
                          class="mx-auto pa-2"
                          max-width="400"
                          tile
                          :elevation="hover ? 16 : 2"
                          :class="{ 'on-hover': hover }"
                        >
                          <v-card-title primary-title>
                            <ais-highlight attribute="brand" :hit="items[i]" />
                          </v-card-title>
                          <v-card-text>
                            <ais-highlight attribute="name" :hit="items[i]" />
                          </v-card-text>
                          <v-card-actions>
                            <v-btn color="secondary" text>
                              Open
                            </v-btn>

                            <v-btn color="secondary" text>
                              Explore
                            </v-btn>
                          </v-card-actions>
                        </v-card>
                      </v-hover>
                    </v-flex>
                  </v-layout>
                </v-container>
              </v-flex>
            </v-layout>
          </template>
        </ais-hits>
        <ais-pagination class="pa-md-4 mx-lg-auto">
          <template slot-scope="{ currentRefinement, pages, nbPages, refine }">
            <div class="text-center">
              <v-pagination
                v-model="currentSelectedPage"
                :length="nbPages"
                total-visible="10"
                @input="refine(currentSelectedPage - 1)"
              >
              </v-pagination>
            </div>
          </template>
        </ais-pagination>
      </div>
    </ais-instant-search-ssr>
    <v-row align="baseline" justify="start">
      <dependency-wheel
        class="d-flex flex-row mb-6"
        :content="cancerTypeAndTfs"
      ></dependency-wheel>
      <dependency-wheel
        class="d-flex flex-row mb-6"
        :content="cancerTypeAndTfs"
      ></dependency-wheel>
    </v-row>
    <carousel></carousel>
  </div>
</template>

<script>
import {
  AisInstantSearchSsr,
  AisHits,
  AisHighlight,
  AisSearchBox,
  AisPagination,
  AisStats,
  createInstantSearch
} from 'vue-instantsearch'
import algoliasearch from 'algoliasearch/lite'
import carousel from '@/components/utils/Carousel'
import dependencywheel from '@/components/utils/DependencyWheel.vue'
import { cancerTypeAndTfs } from '~/static/highchartsData.js'

const searchClient = algoliasearch(
  'latency',
  '6be0576ff61c053d5f9a3225e2a90f76'
)

const { instantsearch, rootMixin } = createInstantSearch({
  searchClient,
  indexName: 'instant_search'
})

export default {
  components: {
    AisInstantSearchSsr,
    AisHits,
    AisHighlight,
    AisSearchBox,
    AisStats,
    AisPagination,
    carousel,
    'dependency-wheel': dependencywheel
  },
  mixins: [rootMixin],
  // eslint-disable-next-line require-await
  async asyncData() {
    return instantsearch
      .findResultsState({
        // find out which parameters to use here using ais-state-results
        query: null,
        hitsPerPage: 12,
        disjunctiveFacets: ['brand']
      })
      .then(() => ({
        instantSearchState: instantsearch.getState()
      }))
  },
  data() {
    return {
      currentSearchText: null,
      currentSelectedPage: 1,
      colors: [
        'indigo',
        'warning',
        'pink darken-2',
        'red lighten-1',
        'deep-purple accent-4'
      ],
      slides: ['First', 'Second', 'Third', 'Fourth', 'Fifth'],
      cancerTypeAndTfs: cancerTypeAndTfs.data
    }
  },
  computed: {
    processingTimeMS() {
      return this.$state.processingTimeMS
    }
  },
  beforeMount() {
    instantsearch.hydrate(this.instantSearchState)
  },
  methods: {
    searchByText(refine, text) {
      this.currentSearchText = text
      this.currentSelectedPage = 1
      refine(text)
    }
  },
  head() {
    return {
      title: 'Home',
      meta: [
        {
          hid: 'description',
          name: 'DEep Sequence and Shape mOtif',
          content:
            'DESSO is a database that provides all identified sequence and shape motifs from a homonymous framework. This framework contains a deep learning model for DNA motif pattern learning and a novel statistical model for motif instance/ transcription factor binding sites identification. The DESSO database records 690 human ENCODE ChIP-seq datasets, 185 transcription factors datasets related to 20 cancer types, and 3 Single-cell ChIP-seq datasets.'
        }
      ]
    }
  }
}
</script>

<style>
.ais-Highlight-highlighted {
  color: var(--v-primary-base);
  background-color: white;
}

.ais-Hits-list {
  list-style-type: none;
}
</style>
