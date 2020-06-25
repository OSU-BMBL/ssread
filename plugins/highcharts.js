import Vue from 'vue'
import vPlotly from '@statnett/vue-plotly'
import Highcharts from 'highcharts'
import HighchartsVue from 'highcharts-vue'
import Sankey from 'highcharts/modules/sankey'
import Dotplot from 'highcharts/modules/dotplot'
import DependencyWheel from 'highcharts/modules/dependency-wheel'
import JsonExcel from 'vue-json-excel'

if (typeof Highcharts === 'object') {
  Sankey(Highcharts)
  DependencyWheel(Highcharts)
  Dotplot(Highcharts)
}
const VuePlotly = {
  install(Vue) {
    Vue.component('vue-plotly', vPlotly)
  }
}
Vue.use(VuePlotly)
Vue.use(HighchartsVue)
Vue.component('downloadExcel', JsonExcel)

export default { VuePlotly, JsonExcel }
