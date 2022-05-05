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
              :data-id="dataId"
              :dataset="dataset"
              :dimension="dimension"
              :ct="cellType"
            ></dimension-info>
          </v-flex>
        </v-layout>
        <v-layout row wrap>
          <v-flex xs12 md12 lg12>
            <de-info
              :data-id="dataId"
              :dataset="dataset"
              :ct="cellType"
            ></de-info>
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
      await store.dispatch('ad_v2/fetchDatasets')
      await store.dispatch('ad_v2/fetchDataset', params.id)
      await store.dispatch('ad_v2/fetchCellType', params.id)
      await store.dispatch('ad_v2/fetchPublication', params.id)
      await store.dispatch('ad_v2/fetchDimension', {
        id: params.id,
        type: 'All cell types'
      })
      await store.dispatch('ad_v2/fetchExpressionGenes', params.id)
      await store.dispatch('ad_v2/fetchDe', defaultDeParams)
      await store.dispatch('ad_v2/fetchDeMeta', params.id)
      await store.dispatch('ad_v2/fetchRegulon', params.id)
    } catch (e) {
      error({
        statusCode: 503,
        message: 'ERROR CODE 503,' + params.id
      })
    }
  },
  computed: {
    ...mapState({
      dataset: (state) => state.ad_v2.dataset,
      datasets: (state) => state.ad_v2.datasets,
      dimension: (state) => state.ad_v2.dimension,
      publication: (state) => state.ad_v2.publication,
      cellType: (state) => state.ad_v2.cellType
    }),
    dataId() {
      return this.$route.params.id
    },
    relatedDatasets() {
      return this.datasets.filter((row) => {
        return row.public_id
          .replace(/[(.+?)]/g, ';')
          .split(';')
          .map((el) => el.trim())
          .some((r) =>
            this.dataset[0].public_id
              .replace(/[(.+?)]/g, ';')
              .split(';')
              .map((el) => el.trim())
              .includes(r)
          )
      })
    }
  },
  head() {
    return {
      title: 'Details',
      meta: [
        {
          hid: 'scREAD details page',
          name: 'scREAD details page',
          content: `scREAD details page, cell type specific regulon, Alzheimers disease, Differential expression and Gene set enrichment analysis,
            control atlases from different brain regions of human and mouse species,
            Interactive UMAP plot for cell types, subclusters, and specific gene expression,
             AD scRNA-Seq, snRNA-Seq datasets, single-cell RNA-seq, single-nucleus RNA-seq`
        }
      ]
    }
  }
}
</script>
<style scoped></style>
