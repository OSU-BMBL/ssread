<template>
  <div>
    <v-layout>
      <v-container fluid grid-list-md>
        <v-layout row wrap>
          <v-flex xs12 md12 lg12>
            <dataset-info :dataset="dataset"></dataset-info>
          </v-flex>
        </v-layout>
        <v-layout row wrap>
          <v-flex xs12 md12 lg12>
            <dimension-info :dimension="dimension"></dimension-info>
          </v-flex>
        </v-layout>
        <v-layout row wrap>
          <v-flex xs12 md12 lg12>
            <de-info :data-id="dataId"></de-info>
          </v-flex>
        </v-layout>
        <v-layout row wrap>
          <v-flex xs12 md12 lg12>
            <regulon-info :data-id="dataId"></regulon-info>
          </v-flex>
        </v-layout>
        <Fab></Fab>
      </v-container>
    </v-layout>
  </div>
</template>
<script>
import { mapState } from 'vuex' // <--- To map data from Vuex
import Fab from '@/components/utils/Fab'
import DeInfo from '@/components/v1/ad/DeInfo'
import DimensionInfo from '@/components/v1/ad/DimensionInfo'
import DatasetInfo from '@/components/v1/ad/DatasetInfo'
import RegulonInfo from '@/components/v1/ad/RegulonInfo'
export default {
  components: {
    'de-info': DeInfo,
    'dimension-info': DimensionInfo,
    'dataset-info': DatasetInfo,
    'regulon-info': RegulonInfo,
    Fab
  },
  async asyncData({ store, error, params }) {
    const defaultDeParams = {
      aDataId: params.id,
      bDataId: params.id,
      type: 'cell_type_specific',
      ct: 'ast'
    }
    try {
      await store.dispatch('ad/fetchDataset', params.id)
      await store.dispatch('ad/fetchDimension', params.id)
      await store.dispatch('ad/fetchDe', defaultDeParams)
      await store.dispatch('ad/fetchDeMeta', params.id)
      await store.dispatch('ad/fetchRegulon', params.id)
    } catch (e) {
      error({
        statusCode: 503,
        message: 'ERROR CODE 503,' + params.id
      })
    }
  },
  computed: {
    ...mapState({
      dataset: (state) => state.ad.dataset,
      dimension: (state) => state.ad.dimension
    }),
    dataId() {
      return this.$route.params.id
    }
  },
  head() {
    return {
      title: 'Details',
      meta: [
        {
          hid: 'description',
          name: 'description',
          content: 'What you need to know about motif #'
        }
      ]
    }
  }
}
</script>
<style scoped></style>
