import Vue from 'vue'
import { Plotly } from 'vue-plotly'
import JsonExcel from 'vue-json-excel'
const VuePlotly = {
  install(Vue) {
    Vue.component('vue-plotly', Plotly)
  }
}
Vue.use(VuePlotly)
Vue.component('downloadExcel', JsonExcel)

export default { VuePlotly, JsonExcel }
