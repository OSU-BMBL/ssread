<template>
  <div>
    <div class="motif-header">
      <v-card>
        <v-card-title>
          Broswse all datasets:
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
          :items="dataset"
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
      await store.dispatch('ad/fetchDatasets')
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
          text: 'ID',
          align: 'start',
          sortable: false,
          value: 'data_id'
        },
        { text: 'Species', value: 'species' },
        { text: 'Gender', value: 'gender' },
        { text: 'Condition', value: 'condition' },
        { text: 'Region', value: 'region' },
        { text: 'Stage', value: 'stage' },
        { text: 'Age', value: 'age' },
        { text: 'Mice model', value: 'mice_model' },
        { text: 'GEO', value: 'geo_id' },
        { text: '#Cells', value: 'n_cell' },
        { text: '#DEGs', value: 'n_deg' },
        { text: '#Regulons', value: 'n_iris3_regulon' }
      ]
    }
  },
  computed: mapState({
    dataset: (state) => state.ad.datasets
  }),
  methods: {
    handleClick(dataset) {
      this.$router.push('/browse/' + dataset.data_id)
    }
  },
  head() {
    return {
      title: this.data_id,
      meta: [
        {
          hid: 'description',
          name: 'description',
          content: 'What you need to know'
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
