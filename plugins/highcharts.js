import Vue from 'vue'
import Highcharts from 'highcharts'
import HighchartsVue from 'highcharts-vue'
import Sankey from 'highcharts/modules/sankey'
import DependencyWheel from 'highcharts/modules/dependency-wheel'
if (typeof Highcharts === 'object') {
  Sankey(Highcharts)
  DependencyWheel(Highcharts)
}

Vue.use(HighchartsVue)
