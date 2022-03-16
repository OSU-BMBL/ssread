<template>
  <div>
    <div class="my-5"><search-gene></search-gene></div>
    <div class="my-5"><overlap-gene></overlap-gene></div>
  </div>
</template>
<script>
import SearchGene from '@/components/ad/SearchGene'
import OverlapGene from '@/components/ad/OverlapGene.vue'

export default {
  components: {
    'search-gene': SearchGene,
    'overlap-gene': OverlapGene
  },
  async asyncData({ store, error, params }) {
    try {
      await store.dispatch('ad/fetchDatasets')
      await store.dispatch('ad/fetchAllDeMeta')
      await store.dispatch('ad/clearExpression')
    } catch (e) {
      error({
        statusCode: 503,
        message: 'ERROR CODE 503'
      })
    }
  },

  data() {
    return {}
  },
  computed: {
    bannerMessage() {
      return `You are visiting scREAD's dev version. Please let us know for any issues or suggestions via qin.ma@osumc.edu.`
    }
  },
  mounted() {
    this.$notifier.showAlert({ content: this.bannerMessage, color: 'accent' })
  },
  methods: {},
  head() {
    return {
      title: 'Home',
      meta: [
        {
          hid: 'scREAD homepage',
          name: 'scREAD home page',
          content: `Alzheimers disease single-cell RNA-seq database, 
            Alzheimers disease AD single-cell datasets database analysis workflow pipeline,
            Search gene expression, DEG, , Differential expression and Gene set enrichment analysis,
            control atlases from different brain regions of human and mouse species,
            UMAP plot for cell types, subclusters, and specific gene expression,
            AD scRNA-Seq, snRNA-Seq datasets, single-cell RNA-seq, single-nucleus RNA-seq`
        }
      ]
    }
  }
}
</script>
<style></style>
