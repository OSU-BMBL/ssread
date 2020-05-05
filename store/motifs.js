import MotifService from '@/services/MotifService.js'
export const state = () => ({
  motifs: [],
  motif: [],
  tfbs: []
})
export const mutations = {
  SET_MOTIFS(state, motifs) {
    state.motifs = motifs
  },
  SET_MOTIF(state, motif) {
    state.motif = motif
  },
  SET_TFBS(state, tfbs) {
    state.tfbs = tfbs
  }
}
export const actions = {
  fetchMotifs({ commit }) {
    return MotifService.getMotifs().then((response) => {
      commit('SET_MOTIFS', response.data)
    })
  },
  fetchMotif({ commit }, id) {
    return MotifService.getMotif(id).then(function(response) {
      commit('SET_MOTIF', response.data)
    })
  },
  fetchTfbs({ commit }, id) {
    return MotifService.getTfbs(id).then(function(response) {
      commit('SET_TFBS', response.data)
    })
  }
}
