import Vue from 'vue'
import vPlotly from '@statnett/vue-plotly'
import JsonExcel from 'vue-json-excel'

const VuePlotly = {
  install(Vue) {
    Vue.component('vue-plotly', vPlotly)
  }
}
Vue.use(VuePlotly)
Vue.component('downloadExcel', JsonExcel)

export default { VuePlotly, JsonExcel }
