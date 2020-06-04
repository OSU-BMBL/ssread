import AdService from '~/services/AdService.js'
export const state = () => ({
  dataset: [],
  datasets: [],
  deMeta: [],
  de: [],
  dimension: [],
  expression: [],
  regulon: []
})
export const mutations = {
  SET_DATASETS(state, datasets) {
    state.datasets = datasets
  },
  SET_DATASET(state, dataset) {
    state.dataset = dataset
  },
  SET_DE_META(state, deMeta) {
    state.deMeta = deMeta
  },
  SET_DE(state, de) {
    state.de = de
  },
  SET_DIMENSION(state, dimension) {
    state.dimension = dimension
  },
  SET_EXPRESSION(state, expression) {
    state.expression = expression
  },
  SET_REGULON(state, regulon) {
    state.regulon = regulon
  }
}
export const actions = {
  fetchDatasets({ commit }) {
    return AdService.getDatasets().then((response) => {
      commit('SET_DATASETS', response.data)
    })
  },
  fetchDataset({ commit }, id) {
    return AdService.getDataset(id).then((response) => {
      commit('SET_DATASET', response.data)
    })
  },
  fetchDeMeta({ commit }, id) {
    return AdService.getDeMeta(id).then(function(response) {
      commit('SET_DE_META', response.data)
    })
  },

  fetchDe({ commit }, params) {
    return AdService.getDe(params).then(function(response) {
      commit('SET_DE', response.data)
    })
  },
  fetchRegulon({ commit }, id) {
    return AdService.getRegulon(id).then(function(response) {
      commit('SET_REGULON', response.data)
    })
  },
  fetchDimension({ commit }, id) {
    return AdService.getDimension(id).then(function(response) {
      commit('SET_DIMENSION', response.data)
    })
  },
  fetchExpression({ commit }, gene) {
    return AdService.getExpression(gene).then(function(response) {
      commit('SET_EXPRESSION', response.data)
    })
  }
}
