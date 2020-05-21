<template>
  <no-ssr>
    <v-hover v-slot:default="{ hover }" open-delay="0">
      <v-card
        class="mx-auto"
        :elevation="hover ? 10 : 2"
        :class="{ 'on-hover': hover }"
      >
        <v-card-title class="accent white--text subtitle-1"
          >Network</v-card-title
        >
        <div>
          <cytoscape
            ref="cyRef"
            :config="config"
            @mousedown="addNode"
            @cxttapstart="updateNode"
          >
            <cy-element
              v-for="def in elements"
              :key="`${def.data.id}`"
              :definition="def"
              @mousedown="deleteNode($event, def.data.id)"
            />
          </cytoscape>
        </div>

        <v-card-actions>
          <v-btn text color="secondary">
            Edit in new page
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-hover>
  </no-ssr>
</template>

<script>
const config = {
  elements: [
    {
      data: { id: 'a' },
      position: { x: 589, y: 182 },
      group: 'nodes'
    },
    {
      data: { id: 'b' },
      position: { x: 689, y: 282 },
      group: 'nodes'
    },
    {
      data: { id: 'c' },
      position: { x: 489, y: 282 },
      group: 'nodes'
    },
    {
      data: { id: 'ab', source: 'a', target: 'b' },
      group: 'edges'
    }
  ],
  style: [
    {
      selector: 'node',
      style: { 'background-color': '#666', label: 'data(id)' }
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
  layout: { name: 'grid', rows: 1 }
}

const elements = [...config.elements]
delete config.elements

export default {
  data() {
    return {
      config,
      elements
    }
  },
  methods: {
    addNode(event) {
      console.log(event.target, this.$refs.cyRef.instance)
      if (event.target === this.$refs.cyRef.instance)
        console.log('adding node', event.target)
    },
    deleteNode(id) {
      console.log('node clicked', id)
    },
    updateNode(event) {
      console.log('right click node', event)
    },
    preConfig(cytoscape) {
      console.log('calling pre-config', cytoscape)
    },
    afterCreated(cy) {
      // cy: this is the cytoscape instance
      console.log('after created', cy)
    }
  }
}
</script>
