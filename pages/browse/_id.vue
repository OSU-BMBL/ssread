<template>
  <div>
    <v-layout>
      <v-container fluid grid-list-md>
        <v-layout row wrap>
          <v-flex xs12 md12 lg4>
            <tf-info :tf="motif[0]"></tf-info>
          </v-flex>
          <v-flex xs12 md12 lg4>
            <motif-circos></motif-circos>
          </v-flex>
          <v-flex xs12 md12 lg4>
            <motif-network></motif-network>
          </v-flex>
        </v-layout>
        <v-layout row wrap>
          <v-flex v-for="(n, i) in motif.length" :key="n" xs12 md6 lg3>
            <motif-info :motif="motif[i]"></motif-info>
          </v-flex>
        </v-layout>
        <Fab></Fab>
      </v-container>
    </v-layout>
  </div>
</template>
<script>
import { mapState } from 'vuex' // <--- To map motif
import Fab from '@/components/utils/Fab'
import TFInfo from '@/components/motif/TFInfo'
import MotifInfo from '@/components/motif/MotifInfo'
import MotifNetwork from '@/components/motif/TestNetwork'
import MotifCircos from '@/components/motif/MotifCircos'
export default {
  components: {
    'tf-info': TFInfo,
    'motif-info': MotifInfo,
    'motif-network': MotifNetwork,
    'motif-circos': MotifCircos,
    Fab
  },
  async asyncData({ store, error, params }) {
    try {
      await store.dispatch('motifs/fetchMotif', params.id)
    } catch (e) {
      error({
        statusCode: 503,
        message: 'ERROR CODE 503, using async await single motif' + params.id
      })
    }
  },
  computed: mapState({
    motif: (state) => state.motifs.motif
  }),
  head() {
    return {
      title: this.motif.data_id,
      meta: [
        {
          hid: 'description',
          name: 'description',
          content: 'What you need to know about motif #' + this.motif.data_id
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
