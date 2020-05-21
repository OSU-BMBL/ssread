<template>
  <v-hover v-slot:default="{ hover }" open-delay="0">
    <v-card
      class="mx-auto"
      :elevation="hover ? 10 : 2"
      :class="{ 'on-hover': hover }"
    >
      <v-card-title class="accent white--text subtitle-1">Network</v-card-title>
      <v-card-text>
        <cytoscape
          ref="cy"
          :config="config"
          v-on:mousedown="addNode"
          v-on:cxttapstart="updateNode"
        >
          <cy-element
            v-for="def in elements"
            :key="`${def.data.id}`"
            :definition="def"
            v-on:mousedown="deleteNode($event, def.data.id)"
          />
        </cytoscape>
      </v-card-text>

      <v-card-actions>
        <v-btn text color="secondary">
          Edit in new page
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-hover>
</template>

<script>
import VueCytoscape from 'vue-cytoscape'

const config = {
  style: [
    {
      selector: 'node',
      style: {
        'background-color': '#666',
        label: 'data(id)'
      }
    },
    {
      selector: 'edge',
      style: {
        width: 3,
        'line-color': '#ccc',
        'target-arrow-color': '#ccc',
        'target-arrow-shape': 'triangle'
      }
    }
  ],
  layout: {
    name: 'grid',
    rows: 1
  }
}
const elements = [
  {
    // node a
    data: { id: 'a' }
  },
  {
    // node b
    data: { id: 'b' }
  },
  {
    // edge ab
    data: { id: 'ab', source: 'a', target: 'b' }
  }
]
export default {
  name: 'MotifNetwork',
  props: {
    network: {
      type: Object,
      required: false,
      default() {
        return { message: 'hello' }
      }
    }
  }
}
</script>

<style lang="scss" scoped></style>
