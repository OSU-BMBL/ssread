export default ({ app, store }, inject) => {
  inject('notifier', {
    showAlert({ content = '', color = '' }) {
      store.commit('alert/showAlert', { content, color })
    },
    showMessage({ content = '', color = '' }) {
      store.commit('snackbar/showMessage', { content, color })
    }
  })
}
