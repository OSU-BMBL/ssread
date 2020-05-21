<template>
  <div>
    <v-layout>
      <v-container fluid grid-list-md>
        <v-layout row wrap>
          <v-flex xs12 md12 lg12>
            <dataset-info :de="de"></dataset-info>
          </v-flex>
        </v-layout>
        <v-layout row wrap>
          <v-flex xs12 md12 lg12>
            <de-info :de="de"></de-info>
          </v-flex>
        </v-layout>
        <v-layout row wrap>
          <v-flex xs12 md12 lg12>
            <dimension-info :de="de"></dimension-info>
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
    try {
      await store.dispatch('ad/fetchDe', params.id)
    } catch (e) {
      error({
        statusCode: 503,
        message: 'ERROR CODE 503,' + params.id
      })
    }
  },
  computed: mapState({
    de: (state) => state.ad.de
  }),
  head() {
    return {
      title: this.de.data_id,
      meta: [
        {
          hid: 'description',
          name: 'description',
          content: 'What you need to know about motif #' + this.de.data_id
        }
      ]
    }
  }
}
</script>
<style scoped>
.prompt-box {
  position: relative;
  overflow: hidden;
  padding: 1em;
  margin-bottom: 24px;
  transform: scaleY(1);
}
.prompt-box > .title {
  margin: 0 0 0.5em;
}
.prompt-box > .title > .meta {
  margin-left: 10px;
}
.prompt-box > .actions {
  display: flex;
  align-items: center;
}
.prompt-box > button {
  margin-right: 0.5em;
}
.prompt-box > button:last-of-type {
  margin-right: 0;
}
.location {
  margin-bottom: 0;
}
.location > .icon {
  margin-left: 10px;
}
.motif-header > .title {
  margin: 0;
}
.list-group {
  margin: 0;
  padding: 0;
  list-style: none;
}
.list-group > .list-item {
  padding: 1em 0;
  border-bottom: solid 1px #e5e5e5;
}
</style>
