import axios from 'axios'

const apiClient = axios.create({
  baseURL: `${process.env.API_URL}/v1`,
  withCredentials: false,
  headers: {
    Accept: 'application/json',
    'Content-Type': 'application/json'
  }
})
const uploadClient = axios.create({
  baseURL: `${process.env.API_URL}/v1`,
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
  getAllDeMeta() {
    return apiClient.get('/de-type')
  },
  getDe(params) {
    return apiClient.get(
      `/de/${params.aDataId}?second_id=${params.bDataId}&ct=${params.ct}&type=${params.type}`
    )
  },
  getOverlap(params) {
    return apiClient.get(
      `/overlap?region=${params.region}&species=${params.species}&top=${params.top}&threshold=${params.threshold}&direction=${params.direction}`
    )
  },
  getRegulon(id) {
    return apiClient.get('/regulon/' + id)
  },
  getDimension(id, type) {
    return apiClient.get('/dimension/' + id + '/type/' + type)
  },
  getExpression(gene, id) {
    return apiClient.get('/expression/' + gene + '/id/' + id)
  },
  getExpressionGenes(id) {
    return apiClient.get('/expression_genes/' + id)
  },
  getDeGene(gene) {
    return apiClient.get('/de/gene/' + gene)
  }
}
