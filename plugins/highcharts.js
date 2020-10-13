import Vue from 'vue'
import vPlotly from '@statnett/vue-plotly'
import JsonExcel from 'vue-json-excel'
// import { AgGridVue } from 'ag-grid-vue'
const VuePlotly = {
  install(Vue) {
    Vue.component('vue-plotly', vPlotly)
  }
}
Vue.use(VuePlotly)
Vue.component('downloadExcel', JsonExcel)
// Vue.component('ag-grid-vue', AgGridVue)

export default { VuePlotly, JsonExcel }
