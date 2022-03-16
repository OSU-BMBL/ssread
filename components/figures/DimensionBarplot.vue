<template>
  <client-only>
    <vue-plotly :data="barData" :layout="layout" :display-mode-bar="false" />
  </client-only>
</template>

<script>
// Utilities

export default {
  name: 'DatasetBarplot',
  props: {
    freq: {
      type: Object,
      required: true,
      default: () => ({
        Astrocytes: 172,
        'Inhibitory neurons': 61,
        Microglia: 60,
        'Oligodendrocyte precursor cells': 96,
        Oligodendrocytes: 722,
        Pericytes: 11
      })
    }
  },
  data: () => ({ fab: false }),

  computed: {
    barData() {
      return [
        {
          x: Object.keys(this.freq),
          y: Object.values(this.freq),
          name: 'dataset1',
          type: 'bar'
        }
      ]
    },
    layout() {
      return {
        title: {
          text: 'Number of Cells',
          font: {
            size: 20
          }
        },
        autosize: true,
        barmode: 'stack'
      }
    }
  },
  methods: {
    onScroll() {}
  }
}
</script>
