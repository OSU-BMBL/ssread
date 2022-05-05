<template>
  <client-only>
    <vue-plotly :data="violinData" :layout="layout" :display-mode-bar="true" />
  </client-only>
</template>

<script>
// Utilities

export default {
  name: 'DatasetViolinplot',
  props: {
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
    },
    result: {
      type: Object,
      required: true,
      default: () => ({
        x: [
          'Oligodendrocyte precursor cells',
          'Oligodendrocyte precursor cells',
          'Microglia',
          'Microglia',
          'Oligodendrocyte precursor cells',
          'Oligodendrocyte precursor cells',
          'Microglia',
          'Microglia',
          'Oligodendrocyte precursor cells',
          'Oligodendrocyte precursor cells',
          'Microglia',
          'Microglia',
          'Oligodendrocyte precursor cells',
          'Oligodendrocyte precursor cells',
          'Microglia',
          'Microglia'
        ],
        y: [
          10.34,
          21.01,
          23.68,
          24.59,
          25.29,
          8.77,
          26.88,
          15.04,
          14.78,
          10.27,
          35.26,
          15.42,
          18.43,
          14.83,
          21.58,
          10.33
        ]
      })
    }
  },
  data: () => ({ fab: false }),

  computed: {
    violinData() {
      const violinNames = [...new Set(this.result.names)]
      const violinWidth = violinNames.length > 3 ? 0 : 0.2
      const transformStyle = []
      for (const [idx, val] of violinNames.entries()) {
        transformStyle.push({
          target: val,
          value: { line: { color: this.colors[idx] } }
        })
      }
      return [
        {
          type: 'violin',
          x: this.result.names,
          y: this.result.expression,
          legendgroup: 'F',
          scalegroup: 'F',
          name: this.result.geneName,
          box: {
            visible: true,
            width: 0.2
          },
          points: 'none',
          width: violinWidth,
          line: {
            color: '#7E6148FE'
          },
          transforms: [
            {
              type: 'groupby',
              groups: this.result.names,
              styles: transformStyle
            }
          ],
          meanline: {
            visible: true
          }
        }
      ]
    },
    layout() {
      return {
        title: {
          text: this.result.geneName + ': ' + this.result.clusterName,
          font: {
            size: 20
          }
        },
        autosize: true,
        yaxis: {
          zeroline: false
        },
        violingap: 0,
        violingroupgap: 0,
        violinmode: 'overlay'
      }
    }
  },
  methods: {
    onScroll() {}
  }
}
</script>
