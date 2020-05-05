<template>
  <div>
    <highcharts ref="lineCharts" :options="options"></highcharts>
  </div>
</template>

<script>
import { Chart } from 'highcharts-vue'

export default {
  components: {
    highcharts: Chart
  },
  props: {
    content: {
      type: Array,
      required: true
    }
  },
  data() {
    return {
      options: {
        title: {
          text: 'Cancer type and TFs'
        },
        series: [
          {
            keys: ['from', 'to', 'weight'],
            data: this.content,
            name: 'Cancer type and TFs',
            type: 'dependencywheel',
            dataLabels: {
              color: '#333',
              textPath: {
                enabled: true,
                attributes: {
                  dy: 5,
                  startOffset: '0%',
                  textAnchor: 'start'
                }
              },
              distance: 10
            },
            size: '100%'
          }
        ]
      }
    }
  },
  mounted() {},
  methods: {
    load() {}
  }
}
</script>
