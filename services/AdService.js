import axios from 'axios'

const apiClient = axios.create({
  // baseURL: `https://bmbls.bmi.osumc.edu/api/scread`,
  baseURL: `http://127.0.0.1:8889/api/scread`,
  withCredentials: false,
  headers: {
    Accept: 'application/json',
    'Content-Type': 'application/json'
  }
})
const uploadClient = axios.create({
  // baseURL: `https://bmbls.bmi.osumc.edu/api/scread`,
  baseURL: `http://127.0.0.1:8889/api/scread`,
  method: 'post',
  headers: {
    'Content-Type': 'multipart/form-data'
  }
})

export default {
  uploadFiles(formData) {
    return uploadClient.post('/upload', formData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    })
  },
  getDatasets() {
    return apiClient.get('/dataset')
  },
  getDataset(id) {
    return apiClient.get('/dataset/' + id)
  },
  getCellType(id) {
    return apiClient.get('/celltype/' + id)
  },
  getPublication(id) {
    return apiClient.get('/publication/' + id)
  },
  getDeMeta(id) {
    return apiClient.get('/de/' + id + '/meta')
  },
  getDe(params) {
    return apiClient.get(
      '/de/' +
        params.aDataId +
        '?second_id=' +
        params.bDataId +
        '&ct=' +
        params.ct +
        '&type=' +
        params.type
    )
  },
  getRegulon(id) {
    return apiClient.get('/regulon/' + id)
  },
  getDimension(id, type) {
    return apiClient.get('/dimension/' + id + '/type/' + type)
  },
  getExpression(gene) {
    return apiClient.get('/expression/' + gene)
  },
  getExpressionGenes(id) {
    return apiClient.get('/expression_genes/' + id)
  }
}
