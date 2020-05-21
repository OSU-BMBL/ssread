<template>
  <div>
    <v-layout column justify-center align-center>
      <v-flex xs12 sm8 md6 lg12>
        <p class="display-2">scREAD</p>
        <p class="title">
          A single-cell RNA-Seq database for Alzheimer's Disease.
        </p>
      </v-flex>
    </v-layout>
  </div>
</template>

<script>
import { createInstantSearch } from 'vue-instantsearch'
import algoliasearch from 'algoliasearch/lite'

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
  components: {},
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
          content: "Single-cell RNA-seq Alzheimer's Disease Database."
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
