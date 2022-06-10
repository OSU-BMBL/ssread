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
                    >Spatial Transcriptomics and In Situ Sequencing to Study
                    Alzheimer's Disease</span
                  >
                </p>
                <p class="my-2">
                  <span class="text--secondary">Authors: </span>
                  <span class="text--primary"
                    >Wei-Ting Chen, Ashley Lu, Katleen Craessaerts, Benjamin
                    Pavie, Carlo Sala Frigerio, Nikky Corthout, Xiaoyan Qian,
                    Jana Laláková, Malte Kühnemund, Iryna Voytyuk, Leen Wolfs,
                    Renzo Mancuso, Evgenia Salta, Sriram Balusu, An Snellinx,
                    Sebastian Munck, Aleksandra Jurek, Jose Fernandez Navarro,
                    Takaomi C Saido, Inge Huitinga, Joakim Lundeberg, Mark
                    Fiers, Bart De Strooper<sup>$</sup></span
                  >
                </p>
                <p class="my-2">
                  <span class="text--secondary">Date published: </span>
                  <span class="text--primary">8-20-2020</span>
                </p>
                <p class="my-2">
                  <span class="text--secondary">Date added to scREAD:</span>
                  <span class="text--primary"> 5-1-2022</span>
                </p>
                <p class="my-2">
                  <span class="text--secondary">Full paper: </span>
                  <span class="text--primary"
                    ><a
                      href="https://pubmed.ncbi.nlm.nih.gov/33083725/"
                      target="_blank"
                      class="text-decoration-none"
                    >
                      iScience
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
                      href="https://data.mendeley.com/datasets/6s959w2zyr/2"
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

                  <span class="text--primary">Human, Mouse</span>
                </p>
                <p class="my-2">
                  <span class="text--secondary">Number of samples: </span>

                  <span class="text--primary">20</span>
                </p>
                <p class="my-2">
                  <span class="text--secondary">Region: </span>

                  <span class="text--primary"
                    >ventral cortex, thalamus, and hippocampus</span
                  >
                </p>
                <p class="my-2">
                  <span class="text--secondary">Experimental factors: </span>

                  <span class="text--primary"
                    ><ul>
                      <li>
                        Alzheimer's disease
                      </li>
                      <li>Disease</li>
                      <li>Brain disorder</li>
                      <li>Age</li>
                      <li>Sex</li>
                      <li>Inferred cell type - authors labels</li>
                    </ul></span
                  >
                </p>
                <p class="my-2">
                  <span class="text--secondary">Description: </span>

                  <span class="text--primary"
                    >As a quick overview, the data presented here is from
                    portion of the DLPFC that spans six neuronal layers plus
                    white matter (A) for a total of three subjects with two
                    pairs of spatially adjacent replicates (B). Each dissection
                    of DLPFC was designed to span all six layers plus white
                    matter (C). Using this web application you can explore the
                    expression of known genes such as SNAP25 (D, a neuronal
                    gene), MOBP (E, an oligodendrocyte gene), and known layer
                    markers from mouse studies such as PCP4 (F, a known layer 5
                    marker gene).</span
                  >
                </p>
                <v-row>
                  <v-col cols="5">
                    <span class="text--secondary"
                      >Figure: Graphical abstract.</span
                    >
                    <span class="text--primary"
                      ><v-img
                        src="https://ars.els-cdn.com/content/image/1-s2.0-S0092867420308151-fx1.jpg"
                        target="_blank"
                        class="text-decoration-none"
                        max-width="800px"
                      >
                      </v-img
                    ></span>
                  </v-col>
                  <v-col cols="5">
                    <span class="text--secondary"
                      >Figure1: Spatially Resolved Transcriptomics Profiles in
                      Adult Mouse Brain</span
                    >
                    <span class="text--primary"
                      ><v-img
                        src="https://ars.els-cdn.com/content/image/1-s2.0-S0092867420308151-gr1.jpg"
                        target="_blank"
                        class="text-decoration-none"
                        max-width="800px"
                      >
                      </v-img
                    ></span> </v-col
                ></v-row> </v-card-text
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

export default {
  components: {
    Fab,
    'dimension-info': DimensionInfo,
    'de-info': DeInfo,
    'svg-info': SvgInfo
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
        id: 'ST001'
      })

      await store.dispatch('ad_v2/fetchExpressionGenes', 'ST001')
      await store.dispatch('ad_v2/fetchDatasets')
      await store.dispatch('ad_v2/fetchDataset', tmpId)
      await store.dispatch('ad_v2/fetchCellType', tmpId)
      await store.dispatch('ad_v2/fetchPublication', tmpId)
      await store.dispatch('ad_v2/fetchDe', defaultDeParams)
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
          name: '151673',
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
