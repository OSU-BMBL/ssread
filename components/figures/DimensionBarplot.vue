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
    source: {
      type: String,
      required: true,
      default: () => 'single-cell'
    },
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
    },
    colors: {
      type: Array,
      required: true,
      default: () => [
        '#E64B35FF',
        '#4DBBD5FF',
        '#00A087FF',
        '#3C5488FF',
        '#F39B7FFF',
        '#8491B499',
        '#91D1C2FF',
        '#7E6148FF',
        '#7E6148FE'
      ]
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
          type: 'bar',
          marker: {
            color: this.colors
          }
        }
      ]
    },
    layout() {
      const datasetType = this.source === 'spatial' ? 'Spots' : 'Cells'
      return {
        title: {
          text: 'Number of ' + datasetType,
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
