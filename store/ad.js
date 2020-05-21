import AdService from '~/services/AdService.js'
export const state = () => ({
  motifs: [],
  de: [],
  tfbs: []
})
export const mutations = {
  SET_MOTIFS(state, motifs) {
    state.motifs = motifs
  },
  SET_DE(state, de) {
    state.de = de
  },
  SET_TFBS(state, tfbs) {
    state.tfbs = tfbs
  }
}
export const actions = {
  fetchMotifs({ commit }) {
    return AdService.getMotifs().then((response) => {
      commit('SET_MOTIFS', response.data)
    })
  },
  fetchDe({ commit }, id) {
    return AdService.getDe(id).then(function(response) {
      commit('SET_DE', response.data)
    })
  },
  fetchTfbs({ commit }, id) {
    return AdService.getTfbs(id).then(function(response) {
      commit('SET_TFBS', response.data)
    })
  }
}
