<template>
  <div>
    <div class="motif-header">
      <v-card>
        <v-card-title>
          Broswse all motifs:
          <v-spacer></v-spacer>
          <v-text-field
            v-model="search"
            append-icon="mdi-magnify"
            label="Search"
            single-line
            hide-details
          ></v-text-field>
        </v-card-title>
        <v-data-table
          :headers="headers"
          :items="motifs"
          :items-per-page="15"
          :search="search"
          class="elevation-1"
          @click:row="handleClick"
        ></v-data-table>
      </v-card>
    </div>
  </div>
</template>
<script>
import { mapState } from 'vuex' // <--- To map motif

export default {
  async asyncData({ store, error, params }) {
    try {
      await store.dispatch('motifs/fetchMotifs')
    } catch (e) {
      error({
        statusCode: 503,
        message: 'ERROR CODE 503, using async await for single motif'
      })
    }
  },
  data() {
    return {
      search: '',
      headers: [
        {
          text: 'Motif ID',
          align: 'start',
          sortable: false,
          value: 'base_id'
        },
        { text: 'TF target name', value: 'tf_name' },
        { text: 'TF target class', value: 'tf_class' },
        { text: 'TF target family', value: 'tf_family' },
        { text: 'Motif name (JASPAR)', value: 'tf_name_jaspar' },
        { text: 'Motif name (HOCOMOCO)', value: 'tf_name_hocomoco' },
        { text: 'Motif name (Transfac)', value: 'tf_name_transfac' }
      ]
    }
  },
  computed: mapState({
    motifs: (state) => state.motifs.motifs
  }),
  methods: {
    handleClick(motif) {
      this.$router.push('/browse/' + motif.data_id)
    }
  },
  head() {
    return {
      title: this.motif,
      meta: [
        {
          hid: 'description',
          name: 'description',
          content: 'What you need to know about motif #' + this.motifs
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
