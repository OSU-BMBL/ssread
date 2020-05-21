import axios from 'axios'

const apiClient = axios.create({
  // baseURL: `http://10.82.14.183:9001/api/scread`,

  baseURL: `http://127.0.0.1:8889/api/scread`,
  withCredentials: false,
  headers: {
    Accept: 'application/json',
    'Content-Type': 'application/json'
  }
})

export default {
  getMotifs() {
    return apiClient.get('/info')
  },
  getDe(id) {
    return apiClient.get('/de/' + id)
  },
  getTfbs(id) {
    return apiClient.get('/sites/' + id)
  }
}
