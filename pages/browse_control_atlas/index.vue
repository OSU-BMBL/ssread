<template>
  <div>
    <v-layout>
      <v-flex>
        <v-container fluid grid-list-md>
          <v-layout row wrap>
            <v-expansion-panels v-model="panelIndex">
              <v-expansion-panel v-for="(n, i) in assembly.length" :key="n">
                <v-expansion-panel-header @click="clearDimension(atlasId[i])">{{
                  atlasId[i] + ': ' + assembly[i]
                }}</v-expansion-panel-header>
                <v-expansion-panel-content>
                  <v-btn color="primary" @click="openDetailsPage(atlasId[i])">
                    Details
                  </v-btn>
                  <healthy-atlas
                    v-if="panelIndex === i"
                    :atlas-id="atlasId[i]"
                  ></healthy-atlas>
                </v-expansion-panel-content>
              </v-expansion-panel>
            </v-expansion-panels>
          </v-layout>
        </v-container>
      </v-flex>
    </v-layout>
  </div>
</template>

<script>
import HealthyAtlas from '@/components/ad/HealthyAtlas'

export default {
  components: {
    'healthy-atlas': HealthyAtlas
  },
  data() {
    return {
      panelIndex: [],
      assembly: [
        `Human-H-Prefrontal cortex-Male`,
        `Human-H-Prefrontal cortex-Female`,
        `Human-H-Entorhinal Cortex-Male`,
        `Human-H-Entorhinal Cortex-Female`,
        `Human-H-Superior frontal gyrus-Male`,
        `Mouse-H-Cortex-Male-7m`,
        `Mouse-H-Cortex-Male-15m`,
        `Mouse-H-Cerebral cortex-Female-15m`,
        `Mouse-H-CerebelluMouse-Male-7m`,
        `Mouse-H-Prefrontal cortex-Male-7m`,
        `Mouse-H-Prefrontal cortex-Male-15m`,
        `Mouse-H-Hippocampus-Male-7m`,
        `Mouse-H-Hippocampus-Male-15m`,
        `Mouse-H-Hippocampus-Female-7m`,
        `Mouse-H-Hippocampus-Female-20m`,
        `M-H-cortex_and_hippocampus-Female-7m_001`,
        `M-H-cortex_and_hippocampus-Female-7m_002`,
        `M-H-subventricular_zone_and_hippocampus-Female-7m_001`,
        `M-H-subventricular_zone_and_hippocampus-Female-7m_002`,
        `H-H-Prefrontal_cortex-Male_BA9`,
        `H-H-Prefrontal_cortex-Female_BA9`
      ],
      atlasId: [
        `AD00101`,
        `AD00106`,
        `AD00201`,
        `AD00202`,
        `AD00801`,
        `AD00301`,
        `AD00302`,
        `AD00401`,
        `AD00501`,
        `AD00601`,
        `AD00602`,
        `AD00702`,
        `AD00703`,
        `AD00704`,
        `AD00705`,
        `AD00901`,
        `AD00902`,
        `AD01001`,
        `AD01002`,
        `AD01101`,
        `AD01102`
      ]
    }
  },

  computed: {
    dataId() {
      return this.$route.params.id
    },
    relatedDatasets() {
      return this.datasets.filter(
        (row) => row.data_id.substr(0, 5) === this.dataId.substr(0, 5)
      )
    }
  },
  methods: {
    async clearDimension(currentId) {
      await this.$store.dispatch('ad/clearDimension')
      const params = {
        id: currentId,
        type: 'All cell types'
      }
      await this.$store.dispatch('ad/fetchDimension', params)
    },
    openDetailsPage(id) {
      this.$router.push(id)
    }
  },
  head() {
    return {
      title: 'Browse control atlas',
      meta: [
        {
          hid: 'scREAD Control page',
          name: 'scREAD Control page',
          content: `Controls Alzheimers disease dataset database analysis workflow pipeline, Differential expression and Gene set enrichment analysis,
            control atlases from different brain regions of human and mouse species,
            Interactive UMAP plot for cell types, subclusters, and specific gene expression,
            AD scRNA-Seq, snRNA-Seq datasets, single-cell RNA-seq, single-nucleus RNA-seq`
        }
      ]
    }
  }
}
</script>

<style lang="scss" scoped></style>
