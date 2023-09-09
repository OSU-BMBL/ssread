<template>
  <div>
    <v-row class="mb-4">
      <v-col cols="12">
        <p class="my-2 py-0 text-h3 font-weight-medium"></p>
        <v-card>
          <v-card-title class="primary white--text text-no-wrap py-2">{{
            titles[0]
          }}</v-card-title>
          <v-row>
            <v-col cols="12" class="py-0 my-0">
              <v-card-title class="my-2 py-0 subtitle-1 font-weight-medium"
                >Publication<v-divider class="my-2 py-0"></v-divider
              ></v-card-title>
              <v-card-text>
                <p class="my-2">
                  <span class="text--secondary">Title: </span>
                  <span class="text--primary font-weight-medium"
                    >Spatially resolved transcriptomics reveals genes associated
                    with the vulnerability of middle temporal gyrus in
                    Alzheimer’s disease</span
                  >
                </p>
                <p class="my-2">
                  <span class="text--secondary">Authors: </span>
                  <span class="text--primary"
                    >Shuo Chen, Yuzhou Chang, Liangping Li, Diana Acosta, Yang
                    Li, Qi Guo, Cankun Wang, Emir Turkes, Cody Morrison, Dominic
                    Julian, Mark E. Hester, Douglas W. Scharre, Chintda
                    Santiskulvong, Sarah XueYing Song, Jasmine T. Plummer, Geidy
                    E. Serrano, Thomas G. Beach, Karen E. Duff, Qin Ma & Hongjun
                    Fu <sup>$</sup></span
                  >
                </p>
                <p class="my-2">
                  <span class="text--secondary">Date published: </span>
                  <span class="text--primary">12-21-2022</span>
                </p>
                <p class="my-2">
                  <span class="text--secondary">Date added:</span>
                  <span class="text--primary"> 1-1-2023</span>
                </p>
                <p class="my-2">
                  <span class="text--secondary">Full paper: </span>
                  <span class="text--primary"
                    ><a
                      href="https://actaneurocomms.biomedcentral.com/articles/10.1186/s40478-022-01494-6"
                      target="_blank"
                      class="text-decoration-none"
                    >
                      Acta Neuropathologica Communications
                      <v-icon color="primary" size="1.2em"
                        >mdi-open-in-new</v-icon
                      >
                    </a></span
                  >
                </p>
                <p class="my-2">
                  <span class="text--secondary">Protocol: </span>
                  <span class="text--primary">10x Genomics Visium</span>
                </p>
                <p class="my-2">
                  <span class="text--secondary">Data: </span>
                  <span class="text--primary"
                    ><a
                      href="https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE44220"
                      target="_blank"
                      class="text-decoration-none"
                    >
                      Download data
                      <v-icon color="primary" size="1.2em"
                        >mdi-open-in-new</v-icon
                      >
                    </a></span
                  >
                </p>
              </v-card-text></v-col
            >
            <v-col cols="12" class="py-0 my-0">
              <v-card-title class="my-2 py-0 subtitle-1 font-weight-medium"
                >Study design<v-divider class="my-2 py-0"></v-divider
              ></v-card-title>
              <v-card-text>
                <p class="my-2">
                  <span class="text--secondary">Species: </span>

                  <span class="text--primary">Human</span>
                </p>
                <p class="my-2">
                  <span class="text--secondary">Number of samples: </span>

                  <span class="text--primary">6</span>
                </p>
                <p class="my-2">
                  <span class="text--secondary">Region: </span>

                  <span class="text--primary">middle temporal gyrus</span>
                </p>
                <p class="my-2">
                  <span class="text--secondary">Experimental factors: </span>

                  <span class="text--primary"
                    ><ul>
                      <li>Disease</li>
                      <li>Brain disorder</li>
                      <li>
                        Brain atlas
                      </li>
                      <li>Age</li>
                      <li>Sex</li>
                      <li>Inferred layers - authors labels</li>
                    </ul></span
                  >
                </p>
                <v-row>
                  <v-col cols="8">
                    <span class="text--secondary"
                      >Figure 1: Spatial transcriptomics (SRT) of the human
                      middle temporal gyrus (MTG)..</span
                    >
                    <span class="text--primary"
                      ><v-img
                        src="https://media.springernature.com/lw685/springer-static/image/art%3A10.1186%2Fs40478-022-01494-6/MediaObjects/40478_2022_1494_Fig1_HTML.png"
                        target="_blank"
                        class="text-decoration-none"
                        max-width="800px"
                      >
                      </v-img
                    ></span>
                  </v-col>
                </v-row> </v-card-text
            ></v-col>
          </v-row>
        </v-card>
      </v-col>
    </v-row>
    <v-row class="mb-4">
      <v-col cols="12">
        <v-card>
          <v-card-title class="primary white--text text-no-wrap py-2">{{
            titles[1]
          }}</v-card-title>

          <v-card-title class="my-2 py-0 subtitle-1 font-weight-normal">
          </v-card-title>
          <v-divider />
          <v-card-actions>
            <v-col cols="6">
              <v-select
                v-model="selectedSampleClustering"
                label="Sample"
                :items="clusterData"
                item-text="name"
                item-value="name"
                return-object
                placeholder="Name"
              ></v-select>
            </v-col>
            <v-col cols="6">
              <a
                :href="selectedSampleClustering.pngLink"
                class="text-decoration-none"
                target="_blank"
              >
                <v-btn small>
                  Download image (low-resolution)
                  <v-icon color="primary" size="1.5em"
                    >mdi-cloud-download-outline</v-icon
                  ></v-btn
                >
              </a>
              <a
                :href="selectedSampleClustering.tiffLink"
                class="text-decoration-none"
                download
              >
                <v-btn small>
                  Download image (high-resolution)<v-icon
                    color="primary "
                    size="1.5em"
                    >mdi-cloud-download-outline</v-icon
                  ></v-btn
                >
              </a>
            </v-col>
          </v-card-actions>
          <v-row>
            <v-col class="mx-4" cols="12">
              <dimension-info
                :dimension="spatialDimension"
                :image="selectedSampleClustering.pngLink"
              ></dimension-info
            ></v-col>
          </v-row>
        </v-card>
        <v-row>
          <v-col class="mx-4" cols="12">
            <svg-info
              :data-id="dataId"
              :dataset="dataset"
              :ct="cellType"
            ></svg-info
          ></v-col>
        </v-row>
        <v-row>
          <v-col class="mx-4" cols="12">
            <de-info
              :data-id="dataId"
              :dataset="dataset"
              :ct="cellType"
            ></de-info
          ></v-col>
        </v-row>
        <v-row>
          <v-col class="mx-4" cols="12"> <deconv></deconv></v-col>
        </v-row>
      </v-col>
    </v-row>
    <Fab></Fab>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import Fab from '@/components/utils/Fab'
import DimensionInfo from '@/components/spatial/DimensionInfo'
import DeInfo from '@/components/spatial/DeInfo'
import SvgInfo from '@/components/spatial/SvgInfo'
import Deconv from '@/components/spatial/Deconv2'
export default {
  components: {
    Fab,
    'dimension-info': DimensionInfo,
    'de-info': DeInfo,
    'svg-info': SvgInfo,
    deconv: Deconv
  },
  async asyncData({ store, error, params }) {
    const tmpId = 'AD00102'
    const defaultDeParams = {
      aDataId: tmpId,
      bDataId: tmpId,
      type: 'cell_type_specific',
      ct: 'Astrocytes'
    }
    try {
      await store.dispatch('ad_v2/fetchSpatialDimension', {
        id: 'ST00101'
      })
      await store.dispatch('ad_v2/fetchDatasets')
      await store.dispatch('ad_v2/fetchAllDeMeta')
      await store.dispatch('ad_v2/clearExpression')
      await store.dispatch('ad_v2/fetchExpressionGenes', 'ST00101')
      await store.dispatch('ad_v2/fetchDatasets')
      await store.dispatch('ad_v2/fetchDataset', tmpId)
      await store.dispatch('ad_v2/fetchCellType', tmpId)
      await store.dispatch('ad_v2/fetchPublication', tmpId)
      await store.dispatch('ad_v2/fetchDe', defaultDeParams)
      await store.dispatch('ad_v2/fetchSvg', defaultDeParams)
      await store.dispatch('ad_v2/fetchDeMeta', tmpId)
    } catch (e) {
      error({
        statusCode: 503,
        message: 'ERROR CODE 503,' + 'ST001'
      })
    }
  },
  data() {
    return {
      titles: [
        'Summary',
        'Spot-level data',
        'Manual annotation',
        'Circos plot',
        'Module score',
        'Heatmap'
      ],

      // Component variables
      selectedSampleClustering: '',
      selectedSampleAnnotation: '',
      selectedSampleModule: '',
      selectedSampleCircos: '',
      selectedSampleHeatmap: '',
      selectedPathology: 'Abeta',
      allPathology: [
        'Abeta',
        'AT8',
        'AT8 Abeta',
        'GFAP AT8 Abeta',
        'P2RY12_AT8_Ab'
      ]
    }
  },
  computed: {
    ...mapState({
      spatialDimension: (state) => state.ad_v2.spatialDimension,
      dataset: (state) => state.ad_v2.dataset,
      datasets: (state) => state.ad_v2.datasets,
      publication: (state) => state.ad_v2.publication,
      cellType: (state) => state.ad_v2.cellType
    }),
    dataId() {
      return 'AD00102'
    },
    clusterData() {
      return [
        {
          name: 'NULL',
          pngLink: `https://spatial-dlpfc.s3.us-east-2.amazonaws.com/images/151673_tissue_lowres_image.png`,
          tiffLink: `${this.baseUrl}/cluster/Seurat-Figue-unsupervised-clustering.tiff`
        }
      ]
    }
  },
  watch: {},
  mounted() {},
  methods: {
    downloadPNG(src) {
      const link = document.createElement('a')
      link.href = src
      const filename = `${this.selectedSampleClustering.name}_cluster.png`
      link.setAttribute('download', filename)
      document.body.appendChild(link)
      link.click()
    },
    downloadTIFF(src) {
      const link = document.createElement('a')
      link.href = src
      const filename = `${this.selectedSampleClustering.name}_cluster.tiff`
      link.setAttribute('download', filename)
      document.body.appendChild(link)
      link.click()
    }
  }
}
</script>

<style lang="scss" scoped></style>
