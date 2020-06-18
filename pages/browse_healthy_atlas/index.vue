<template>
  <div>
    <v-layout>
      <v-flex>
        <v-container fluid grid-list-md>
          <v-layout row wrap>
            <v-flex v-for="(n, i) in 9" :key="n" xs12 md6 lg4>
              <v-hover v-slot:default="{ hover }" open-delay="0">
                <v-card
                  class="mx-auto pa-2"
                  max-width="800"
                  tile
                  :elevation="hover ? 16 : 2"
                  :class="{ 'on-hover': hover }"
                >
                  <v-card-title primary-title> {{ assembly[i] }} </v-card-title>
                  <healthy-atlas :dimension="dimension"></healthy-atlas>
                  <v-card-actions>
                    <v-btn color="primary">
                      Details
                    </v-btn>
                  </v-card-actions>
                </v-card>
              </v-hover>
            </v-flex>
          </v-layout>
        </v-container>
      </v-flex>
    </v-layout>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import HealthyAtlas from '@/components/ad/HealthyAtlas'

export default {
  components: {
    'healthy-atlas': HealthyAtlas
  },

  async asyncData({ store, error, params }) {
    try {
      await store.dispatch('ad/fetchDimension', 'AD00103')
    } catch (e) {
      error({
        statusCode: 503,
        message: 'ERROR CODE 503,' + params.id
      })
    }
  },

  data() {
    return {
      assembly: [
        `Mouse-H-Cortex-Male-7m`,
        `Mouse-H-Cortex-Male-15m`,
        `Mouse-H-Cerebral cortex-Female-15m`,
        `Mouse-H-Cerebellum-Male-7m`,
        `Mouse-H-Hippocampus-Male-7m`,
        `Mouse-H-Hippocampus-Male-15m`,
        `Mouse-H-Hippocampus-Female-7m`,
        `Mouse-H-Hippocampus-Female-20m`,
        `Mouse-H-Prefrontal cortex-Male-7m`,
        `Mouse-H-Prefrontal cortex-Male-15m`,
        `Human-H-Entorhinal Cortex-Male`,
        `Human-H-Entorhinal Cortex-Female`,
        `Human-H-Prefrontal cortex-Male`,
        `Human-H-Prefrontal cortex-Female`,
        `Human-H-Superior frontal gyrus-Male`
      ]
    }
  },

  computed: {
    ...mapState({
      dimension: (state) => state.ad.dimension
    }),
    dataId() {
      return this.$route.params.id
    },
    relatedDatasets() {
      return this.datasets.filter(
        (row) => row.data_id.substr(0, 5) === this.dataId.substr(0, 5)
      )
    }
  }
}
</script>

<style lang="scss" scoped></style>
