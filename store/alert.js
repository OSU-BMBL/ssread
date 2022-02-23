export const state = () => ({
  content: '',
  color: '',
  timeout: ''
})

export const mutations = {
  showAlert(state, payload) {
    state.content = payload.content
    state.color = payload.color
    state.timeout = payload.timeout
  }
}
