import axios from 'axios'

const apiClient = axios.create({
  baseURL: process.env.API_URL,
  withCredentials: false,
  headers: {
    Accept: 'application/json',
    'Content-Type': 'application/json'
  }
})
const uploadClient = axios.create({
  baseURL: process.env.API_URL,
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
    return apiClient.get('/v2/dataset')
  },
  getDataset(id) {
    return apiClient.get('/v2/dataset/' + id)
  },
  getPublication(id) {
    return apiClient.get('/v2/publication/' + id)
  },
  getCellType(id) {
    const num = parseInt(id.substring(3, 5))
    const sendId = num < 13 ? id : `AD0010${(num % 5) + 1}`
    return apiClient.get('/celltype/' + sendId)
  },

  getDeMeta(id) {
    const num = parseInt(id.substring(3, 5))
    const sendId = num < 13 ? id : `AD0010${(num % 5) + 1}`
    return apiClient.get('/de/' + sendId + '/meta')
  },
  getAllDeMeta() {
    return apiClient.get('/de-type')
  },
  getDe(params) {
    const num = parseInt(params.aDataId.substring(3, 5))
    const sendId1 = num < 13 ? params.aDataId : 'AD00102'
    const sendId2 = num < 13 ? params.bDataId : 'AD00103'

    return apiClient.get(
      `/de/${sendId1}?second_id=${sendId2}&ct=${params.ct}&type=${params.type}`
    )
  },
  getOverlap(params) {
    return apiClient.get(
      `/overlap?region=${params.region}&species=${params.species}&top=${params.top}&threshold=${params.threshold}&direction=${params.direction}`
    )
  },
  getRegulon(id) {
    const num = parseInt(id.substring(3, 5))
    const sendId = num < 13 ? id : `AD0010${(num % 5) + 1}`
    return apiClient.get('/regulon/' + sendId)
  },
  getDimension(id, type) {
    const num = parseInt(id.substring(3, 5))
    const sendId = num < 13 ? id : `AD0010${(num % 5) + 1}`
    return apiClient.get('/dimension/' + sendId + '/type/' + type)
  },
  getSpatialDimension(id) {
    return apiClient.get('/spatial-dimension/' + id)
  },
  getExpression(gene, id) {
    const num = parseInt(id.substring(3, 5))
    const sendId = num < 13 ? id : `AD0010${(num % 5) + 1}`
    return apiClient.get('/expression/' + gene + '/id/' + sendId)
  },
  getExpressionGenes(id) {
    const num = parseInt(id.substring(3, 5))
    const sendId = num < 13 ? id : `AD0010${(num % 5) + 1}`
    return apiClient.get('/expression_genes/' + sendId)
  },
  getDeGene(gene) {
    return apiClient.get('/de/gene/' + gene)
  }
}
