import _ from 'lodash'
import AdService from '~/services/AdService.js'

export const state = () => ({
  dialog: [],
  dataset: [],
  datasets: [],
  dialogDataset: [],
  publication: [],
  deMeta: [],
  deAllMeta: [],
  cellType: [],
  de: [],
  deGene: [],
  dimension: [],
  expression: [],
  expressionGenes: [],
  regulon: []
})
export const mutations = {
  SET_DATASETS(state, datasets) {
    state.datasets = datasets
  },
  SET_DATASET(state, dataset) {
    state.dataset = dataset
  },
  SET_CELL_TYPE(state, cellType) {
    state.cellType = cellType
  },
  SET_DIALOG_DATASET(state, dialogDataset) {
    state.dialogDataset = dialogDataset
  },
  SET_PUBLICATION(state, publication) {
    state.publication = publication
  },
  SET_DE_META(state, deMeta) {
    state.deMeta = deMeta
  },
  SET_ALL_DE_META(state, deAllMeta) {
    state.deAllMeta = deAllMeta
  },

  SET_DE_GENE(state, deGene) {
    state.deGene = deGene
  },
  SET_DE(state, de) {
    state.de = de
  },
  RESET_DE(state) {
    state.de = { count: 0, rows: [] }
  },
  SET_DIMENSION(state, dimension) {
    state.dimension = dimension
  },
  RESET_DIMENSION(state) {
    state.dimension = []
  },
  SET_EXPRESSION(state, expression) {
    state.expression = expression.slice(1)
  },
  SET_EXPRESSION_GENES(state, genes) {
    state.expressionGenes = genes
  },
  SET_REGULON(state, regulon) {
    state.regulon = regulon
  },
  SET_DIALOG(state, dialog) {
    state.dialog = dialog
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
  fetchCellType({ commit }, id) {
    return AdService.getCellType(id).then((response) => {
      commit('SET_CELL_TYPE', response.data)
    })
  },
  fetchPublication({ commit }, id) {
    return AdService.getPublication(id).then((response) => {
      commit('SET_PUBLICATION', response.data)
    })
  },
  fetchDeMeta({ commit }, id) {
    return AdService.getDeMeta(id).then(function(response) {
      commit('SET_DE_META', response.data)
    })
  },
  fetchAllDeMeta({ commit }) {
    return AdService.getAllDeMeta().then(function(response) {
      commit('SET_ALL_DE_META', response.data)
    })
  },
  fetchDeGene({ commit }, id) {
    return AdService.getDeGene(id).then(function(response) {
      commit('SET_DE_GENE', response.data)
    })
  },
  fetchDe({ commit }, params) {
    return AdService.getDe(params).then(function(response) {
      commit('SET_DE', response.data)
    })
  },
  clearDE({ commit }) {
    return commit('RESET_DE')
  },
  fetchRegulon({ commit }, id) {
    return AdService.getRegulon(id).then(function(response) {
      commit('SET_REGULON', response.data)
    })
  },
  fetchDimension({ commit }, params) {
    return AdService.getDimension(params.id, params.type).then(function(
      response
    ) {
      commit('SET_DIMENSION', response.data)
    })
  },
  clearDimension({ commit }) {
    return commit('RESET_DIMENSION')
  },
  fetchExpression({ commit }, params) {
    return AdService.getExpression(params.gene, params.id).then(function(
      response
    ) {
      commit('SET_EXPRESSION', response.data)
    })
  },
  fetchExpressionGenes({ commit }, id) {
    return AdService.getExpressionGenes(id).then(function(response) {
      commit('SET_EXPRESSION_GENES', _.map(response.data, 'gene'))
    })
  },
  setDialog(context, id) {
    context.commit('SET_DIALOG', id)
    return AdService.getDataset(id).then((response) => {
      context.commit('SET_DIALOG_DATASET', response.data)
    })
  }
}
