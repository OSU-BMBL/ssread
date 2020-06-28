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
                  <healthy-atlas
                    v-if="panelIndex === i"
                    :atlas-id="atlasId[i]"
                  ></healthy-atlas>
                  <v-btn color="primary" @click="openDetailsPage(atlasId[i])">
                    Details
                  </v-btn>
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
        `Mouse-H-Hippocampus-Female-20m`
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
        `AD00705`
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
  }
}
</script>

<style lang="scss" scoped></style>
