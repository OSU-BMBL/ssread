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
        '#7E6148FE',
        '#222222',
        '#f3c300',
        '#875692',
        '#f38400',
        '#a1caf1',
        '#be0032',
        '#c2b280',
        '#848482',
        '#008856',
        '#e68fac',
        '#0067a5',
        '#f99379',
        '#604e97',
        '#f6a600',
        '#b3446c',
        '#dcd300',
        '#882d17',
        '#8db600',
        '#654522',
        '#e25822',
        '#2b3d26'
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
