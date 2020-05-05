<template>
  <ais-instant-search-ssr>
    <ais-search-box v-slot="{ currentRefinement, refine }">
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
        <v-img
          class="ml-auto"
          max-width="120px"
          src="https://www.algolia.com/gatsby-images/search/search-by-algolia.svg"
        ></v-img>
      </v-row>

      <div class="mt-12 text-center">Value: {{ currentSearchText }}</div>
      <div v-show="currentSearchText">
        <ais-hits>
          <template slot="item" slot-scope="{ item }">
            <v-card class="mx-auto" max-width="400" tile>
              <v-list-item shaped three-line>
                <v-list-item-content>
                  <v-list-item-title>
                    <p><ais-highlight attribute="brand" :hit="item" /></p>
                  </v-list-item-title>
                  <v-list-item-subtitle
                    ><ais-highlight attribute="name" :hit="item"
                  /></v-list-item-subtitle>
                </v-list-item-content>
              </v-list-item>
            </v-card>
          </template>
        </ais-hits>
        <ais-pagination />
      </div>
    </ais-search-box>
  </ais-instant-search-ssr>
</template>

<script>
import {
  AisInstantSearchSsr,
  AisHits,
  AisHighlight,
  AisSearchBox,
  AisPagination,
  createInstantSearch
} from 'vue-instantsearch'
import algoliasearch from 'algoliasearch/lite'

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
    AisPagination
  },
  mixins: [rootMixin],
  // eslint-disable-next-line require-await
  async asyncData() {
    return instantsearch
      .findResultsState({
        // find out which parameters to use here using ais-state-results
        query: null,
        hitsPerPage: 5,
        disjunctiveFacets: ['brand']
      })
      .then(() => ({
        instantSearchState: instantsearch.getState()
      }))
  },
  data() {
    return {
      currentSearchText: null
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
      refine(text)
    }
  },
  head() {
    return {
      /*
      link: [
        {
          rel: 'stylesheet',
          href:
            'https://cdn.jsdelivr.net/npm/instantsearch.css@7.3.1/themes/algolia-min.css'
          // 'https://cdn.jsdelivr.net/npm/instantsearch.css@7.3.1/themes/reset-min.css'
        }
      ] */
    }
  }
}
</script>

<style scoped>
.ais-Highlight-highlighted {
  color: var(--v-primary-base);
  background-color: white;
}

.v-text-field {
  font-size: 1.6em;
}
</style>
