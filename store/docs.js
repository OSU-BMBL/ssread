export const state = () => ({
  toc: ''
})
export const mutations = {
  SET_TOC(state, toc) {
    state.toc = toc
  }
}
export const actions = {
  commitToc(context, data) {
    context.commit('SET_TOC', data)
  }
}
