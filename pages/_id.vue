<template>
  <div>
    <v-layout>
      <v-container fluid grid-list-md>
        <v-layout row wrap>
          <v-flex xs12 md12 lg12>
            <dataset-info
              :dataset="dataset"
              :related="relatedDatasets"
              :publication="publication"
            ></dataset-info>
          </v-flex>
        </v-layout>
        <v-layout row wrap>
          <v-flex xs12 md12 lg12>
            <dimension-info
              :dimension="dimension"
              :ct="cellType"
            ></dimension-info>
          </v-flex>
        </v-layout>
        <v-layout row wrap>
          <v-flex xs12 md12 lg12>
            <de-info :data-id="dataId" :ct="cellType"></de-info>
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
import DeInfo from '@/components/ad/DeInfo'
import DimensionInfo from '@/components/ad/DimensionInfo'
import DatasetInfo from '@/components/ad/DatasetInfo'
export default {
  components: {
    'de-info': DeInfo,
    'dimension-info': DimensionInfo,
    'dataset-info': DatasetInfo,
    Fab
  },
  async asyncData({ store, error, params }) {
    const defaultDeParams = {
      aDataId: params.id,
      bDataId: params.id,
      type: 'cell_type_specific',
      ct: 'Astrocytes'
    }
    try {
      await store.dispatch('ad/fetchDatasets')
      await store.dispatch('ad/fetchDataset', params.id)
      await store.dispatch('ad/fetchCellType', params.id)
      await store.dispatch('ad/fetchPublication', params.id)
      await store.dispatch('ad/fetchDimension', {
        id: params.id,
        type: 'All cell types'
      })
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
      datasets: (state) => state.ad.datasets,
      dimension: (state) => state.ad.dimension,
      publication: (state) => state.ad.publication,
      cellType: (state) => state.ad.cellType
    }),
    dataId() {
      return this.$route.params.id
    },
    relatedDatasets() {
      return this.datasets.filter((row) =>
        row.public_id.split('; ').includes(this.dataset[0].public_id)
      )
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
