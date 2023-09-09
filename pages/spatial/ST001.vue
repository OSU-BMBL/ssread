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
                    >Transcriptome-scale spatial gene expression in the human
                    dorsolateral prefrontal cortex.</span
                  >
                </p>
                <p class="my-2">
                  <span class="text--secondary">Authors: </span>
                  <span class="text--primary"
                    >Kristen R. Maynard, Leonardo Collado-Torres, Lukas M.
                    Weber, Cedric Uytingco, Brianna K. Barry, Stephen R.
                    Williams, Joseph L. Catallini II, Matthew N. Tran, Zachary
                    Besich, Madhavi Tippani, Jennifer Chew, Yifeng Yin, Joel E.
                    Kleinman, Thomas M. Hyde, Nikhil Rao, Stephanie C. Hicks,
                    Keri Martinowich & Andrew E. Jaffe <sup>$</sup></span
                  >
                </p>
                <p class="my-2">
                  <span class="text--secondary">Date published: </span>
                  <span class="text--primary">2-21-2021</span>
                </p>
                <p class="my-2">
                  <span class="text--secondary">Date added:</span>
                  <span class="text--primary"> 5-1-2022</span>
                </p>
                <p class="my-2">
                  <span class="text--secondary">Abstract: </span>
                  <span class="text--primary"
                    ><a
                      href="https://www.nature.com/articles/s41593-020-00787-0"
                      target="_blank"
                      class="text-decoration-none"
                    >
                      Nature Neuroscience
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
                      href="http://research.libd.org/spatialLIBD/"
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

                  <span class="text--primary">12</span>
                </p>
                <p class="my-2">
                  <span class="text--secondary">Region: </span>

                  <span class="text--primary"
                    >Dorsolateral prefrontal cortex</span
                  >
                </p>
                <p class="my-2">
                  <span class="text--secondary">Experimental factors: </span>

                  <span class="text--primary"
                    ><ul>
                      <li>Disease</li>
                      <li>Brain disorder</li>
                      <li>Age</li>
                      <li>Sex</li>
                      <li>Inferred cell type - authors labels</li>
                    </ul></span
                  >
                </p>

                <p class="my-2">
                  <span class="text--secondary"
                    >Figure: Spatial transcriptomics in DLPFC using
                    Visium.</span
                  >
                  <span class="text--primary"
                    ><v-img
                      src="http://research.libd.org/spatialLIBD/reference/figures/paper_figure1.jpg"
                      target="_blank"
                      class="text-decoration-none"
                      max-width="800px"
                    >
                    </v-img
                  ></span>
                </p> </v-card-text
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
                target="_blank"
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
                class="my-2"
                :data-id="selectedSampleClustering.id"
                :raw="selectedSampleClustering.raw"
                :dimension="spatialDimension"
                :image="selectedSampleClustering.pngLink"
              ></dimension-info
            ></v-col>
          </v-row>
        </v-card>
        <svg-info
          :data-id="selectedSampleClustering.id"
          class="my-2"
          :dataset="dataset"
          :ct="cellType"
        ></svg-info>

        <de-info
          :data-id="selectedSampleClustering.id"
          class="my-2"
          :dataset="dataset"
          :ct="cellType"
        ></de-info>
        <deconv :data-id="selectedSampleClustering.id"></deconv>
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
import Deconv from '@/components/spatial/Deconv'

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
      selectedSampleClustering: 'ST00109 (original sample name: 151673)',
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
    items() {
      return Array.from({ length: 12 }, (k, v) => v + 1)
    },
    clusterData() {
      const names = [
        '151507',
        '151508',
        '151509',
        '151510',
        '151669',
        '151670',
        '151671',
        '151672',
        '151673',
        '151674',
        '151675',
        '151676'
      ]
      const ids = [
        'ST00101',
        'ST00102',
        'ST00103',
        'ST00104',
        'ST00105',
        'ST00106',
        'ST00107',
        'ST00108',
        'ST00109',
        'ST00110',
        'ST00111',
        'ST00112'
      ]
      const result = []
      for (const [idx, value] of names.entries()) {
        result.push({
          id: ids[idx],
          raw: `${value}`,
          name: `${ids[idx]} (original sample name: ${value})`,
          tiffLink: `https://spatial-dlpfc.s3.us-east-2.amazonaws.com/images/${value}_tissue_hires_image.png`,
          pngLink: `https://spatial-dlpfc.s3.us-east-2.amazonaws.com/images/${value}_tissue_lowres_image.png`
        })
      }

      return result
    }
  },
  watch: {
    selectedSampleClustering() {
      this.$store.dispatch('ad_v2/fetchSpatialDimension', {
        id: this.selectedSampleClustering.id
      })
      this.$store.dispatch(
        'ad_v2/fetchExpressionGenes',
        this.selectedSampleClustering.id
      )
    }
  },
  mounted() {
    this.selectedSampleClustering = this.clusterData[8]
  },
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
