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
              <v-card-title class="my-2 py-2 subtitle-1 font-weight-medium"
                >Manuscript<v-divider class="my-2 py-0"></v-divider
              ></v-card-title>
              <v-card-text>
                <p class="my-2">
                  <span class="text--secondary">Title: </span>
                  <span class="text--primary font-weight-medium"
                    >Spatially resolved transcriptomics reveals gene signatures
                    underlying the vulnerability of 2 human middle temporal
                    gyrus in Alzheimer's disease</span
                  >
                </p>
                <p class="my-2">
                  <span class="text--secondary">Authors: </span>
                  <span class="text--primary"
                    >Shuo Chen<sup>†</sup>, Yuzhou Chang<sup>†</sup>, Liangping
                    Li, Diana Acosta, Yang Li, Qi Guo, Cankun Wang, Cody
                    Morrison, Dominic Julian, Mark E. Hester, Douglas W.
                    Scharre, Chintda Santiskulvong, Sarah XueYing Song, Jasmine
                    T. Plummer, Geidy E. Serrano, Thomas G. Beach, Qin
                    Ma<sup>$</sup>, Hongjun Fu<sup>$</sup></span
                  >
                </p>
                <p class="my-2">
                  <span class="text--secondary">Abstract: </span>
                  <span class="text--primary"
                    ><a
                      href="https://www.biorxiv.org/content/10.1101/2021.07.07.451554v1?rss=1"
                      target="_blank"
                      class="text-decoration-none"
                    >
                      bioRxiv
                      <v-icon color="primary" size="1.2em"
                        >mdi-open-in-new</v-icon
                      >
                    </a></span
                  >
                </p>
                <p class="my-2">
                  <span class="text--secondary">Code: </span>
                  <span class="text--primary"
                    ><a
                      href="https://github.com/OSU-BMBL/AD-spatial-code"
                      target="_blank"
                      class="text-decoration-none"
                    >
                      Download
                      <v-icon color="primary" size="1.2em"
                        >mdi-open-in-new</v-icon
                      >
                    </a></span
                  >
                </p>
              </v-card-text></v-col
            >
            <v-col
              v-for="(data, key) in sampleInfo"
              :key="key"
              xl="4"
              lg="4"
              md="6"
              sm="6"
              xs="12"
            >
              <v-card-title class="my-2 py-0 subtitle-1 font-weight-medium"
                >{{ data.title }}<v-divider class="my-2 py-0"></v-divider
              ></v-card-title>

              <v-card-text>
                <p class="my-2">
                  <span class="text--secondary">Name: </span>
                  <span class="text--primary">{{ data.name }}</span>
                </p>
                <p class="my-2">
                  <span class="text--secondary">Loupe file: </span>
                  <span class="text--primary"
                    ><a
                      :href="data.loupeLink"
                      target="_blank"
                      class="text-decoration-none"
                    >
                      Download {{ data.size }}
                      <v-icon color="primary" size="1.2em"
                        >mdi-cloud-download-outline</v-icon
                      >
                    </a></span
                  >
                </p>
              </v-card-text>
            </v-col>
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
          <v-card-actions>
            <v-col cols="6">
              <v-select
                v-model="selectedSampleClustering"
                label="Spatial map"
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
                  Download (PNG)
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
                  Download (TIFF)<v-icon color="primary " size="1.5em"
                    >mdi-cloud-download-outline</v-icon
                  ></v-btn
                >
              </a>
            </v-col>
          </v-card-actions>
          <v-row>
            <v-col class="ma-4" xl="6" lg="8" md="10" sm="11" xs="11">
              <v-img contain :src="selectedSampleClustering.pngLink"></v-img>
            </v-col>
          </v-row>
        </v-card>
      </v-col>
    </v-row>
    <v-row class="mb-4">
      <v-col cols="12">
        <v-card>
          <v-card-title class="primary white--text text-no-wrap  py-2">{{
            titles[3]
          }}</v-card-title>

          <v-card-actions>
            <v-col cols="4">
              <v-select
                v-model="selectedPathology"
                label="AD pathology"
                :items="allPathology"
              ></v-select>
            </v-col>
            <v-col cols="4">
              <v-select
                v-model="selectedSampleCircos"
                label="Circos plots"
                :items="circosDataDisplay"
                item-text="name"
                item-value="name"
                return-object
                placeholder="Name"
              ></v-select>
            </v-col>
            <v-col cols="4">
              <a
                :href="selectedSampleCircos.pngLink"
                class="text-decoration-none"
                target="_blank"
              >
                <v-btn small>
                  Download (PNG)
                  <v-icon color="primary" size="1.5em"
                    >mdi-cloud-download-outline</v-icon
                  ></v-btn
                >
              </a>
            </v-col>
          </v-card-actions>
          <v-row>
            <v-col class="ma-4" xl="6" lg="8" md="10" sm="11" xs="11">
              <v-img contain :src="selectedSampleCircos.pngLink"></v-img>
            </v-col>
          </v-row>
        </v-card>
      </v-col>
    </v-row>

    <v-row class="mb-4">
      <v-col cols="12">
        <v-card>
          <v-card-title class="primary white--text text-no-wrap  py-2">{{
            titles[4]
          }}</v-card-title>

          <v-card-actions>
            <v-col cols="6">
              <v-select
                v-model="selectedSampleModule"
                label="Module figures"
                :items="moduleData"
                item-text="name"
                item-value="name"
                return-object
                placeholder="Name"
              ></v-select>
            </v-col>
            <v-col cols="6">
              <a
                :href="selectedSampleModule.pngLink"
                class="text-decoration-none"
                target="_blank"
              >
                <v-btn small>
                  Download (PNG)
                  <v-icon color="primary" size="1.5em"
                    >mdi-cloud-download-outline</v-icon
                  ></v-btn
                >
              </a>
              <a
                :href="selectedSampleModule.tiffLink"
                class="text-decoration-none"
                download
              >
                <v-btn small>
                  Download (TIFF)<v-icon color="primary " size="1.5em"
                    >mdi-cloud-download-outline</v-icon
                  ></v-btn
                >
              </a>
            </v-col>
          </v-card-actions>
          <v-row>
            <v-col class="ma-4" xl="6" lg="8" md="10" sm="11" xs="11">
              <v-img contain :src="selectedSampleModule.pngLink"></v-img>
              <v-img contain :src="moduleLegend"></v-img>
            </v-col>
          </v-row>
        </v-card>
      </v-col>
    </v-row>
    <v-row class="mb-4">
      <v-col cols="12">
        <v-card>
          <v-card-title class="primary white--text text-no-wrap  py-2">{{
            titles[5]
          }}</v-card-title>

          <v-card-actions
            ><v-col cols="2">
              <a
                :href="tableData[0].link"
                class="text-decoration-none"
                target="_blank"
              >
                <v-btn small class="my-2">
                  {{ tableData[0].name }}
                  <v-icon color="primary" size="1.5em"
                    >mdi-cloud-download-outline</v-icon
                  ></v-btn
                >
              </a>
              <a
                :href="tableData[1].link"
                class="text-decoration-none "
                target="_blank"
              >
                <v-btn small class="my-2">
                  {{ tableData[1].name }}
                  <v-icon color="primary" size="1.5em"
                    >mdi-cloud-download-outline</v-icon
                  ></v-btn
                >
              </a>
            </v-col></v-card-actions
          >
        </v-card>
      </v-col>
    </v-row>

    <Fab></Fab>
  </div>
</template>

<script>
import Fab from '@/components/utils/Fab'
export default {
  components: {
    Fab
  },
  data() {
    return {
      baseUrl: 'https://cloud.osubmi.com/downloadFiles/stofad-2',
      titles: [
        'Summary',
        'Spatial map (gene modules)',
        '',
        'Circos plot',
        'RNA scope',
        'Deconvolution table'
      ],

      // Component variables
      selectedSampleClustering: '',
      selectedSampleAnnotation: '',
      selectedSampleModule: '',
      selectedSampleCircos: '',
      selectedSampleHeatmap: '',
      selectedPathology: 'Ab',
      allPathology: ['Ab', 'AT8', 'Ab_AT8']
    }
  },
  computed: {
    sampleInfo() {
      return [
        {
          title: 'Sample 1',
          name: 'CT-1',
          loupeLink: `${this.baseUrl}/1.Cloupe files/CT-1_cloupe.cloupe`,
          size: '(0.82 GB)'
        },
        {
          title: 'Sample 2',
          name: 'CT-2',
          loupeLink: `${this.baseUrl}/1.Cloupe files/CT-2_cloupe.cloupe`,
          size: '(1.4 GB)'
        },
        {
          title: 'Sample 3',
          name: 'CT-3',
          loupeLink: `${this.baseUrl}/1.Cloupe files/CT-3_cloupe.cloupe`,
          size: '(1.3 GB)'
        },
        {
          title: 'Sample 4',
          name: 'AD-1',
          loupeLink: `${this.baseUrl}/1.Cloupe files/AD-1_cloupe.cloupe`,
          size: '(1.02 GB)'
        },
        {
          title: 'Sample 5',
          name: 'AD-2',
          loupeLink: `${this.baseUrl}/1.Cloupe files/AD-2_cloupe.cloupe`,
          size: '(1.1 GB)'
        },
        {
          title: 'Sample 6',
          name: 'AD-3',
          loupeLink: `${this.baseUrl}/1.Cloupe files/AD-3_cloupe.cloupe`,
          size: '(1.5 GB)'
        }
      ]
    },
    clusterData() {
      const names = [
        '151673_Layer 1',
        '151673_Layer 2',
        '151673_Layer 4',
        '151673_Layer 5',
        '151673_Layer 6',
        '151673_White Matter',
        '151674_Layer 1',
        '151674_Layer 2',
        '151674_Layer 4',
        '151674_Layer 5',
        '151674_Layer 6',
        '151674_White Matter',
        'AdultHumanBrain_1_Layer 1',
        'AdultHumanBrain_1_Layer 2',
        'AdultHumanBrain_1_Layer 4',
        'AdultHumanBrain_1_Layer 5',
        'AdultHumanBrain_1_Layer 6',
        'AdultHumanBrain_1_White Matter',
        'AdultHumanBrain_2_Layer 1',
        'AdultHumanBrain_2_Layer 2',
        'AdultHumanBrain_2_Layer 4',
        'AdultHumanBrain_2_Layer 5',
        'AdultHumanBrain_2_Layer 6',
        'AdultHumanBrain_2_White Matter'
      ]
      const result = []
      for (const i of names) {
        result.push({
          name: i,
          pngLink: `${this.baseUrl}/2.Spatial map/${i}.png`,
          tiffLink: `${this.baseUrl}/2.Spatial map/${i}.tiff`
        })
      }
      return result
    },

    moduleLegend() {
      return `${this.baseUrl}/5.RNAscope/legend.png`
    },
    moduleData() {
      const names = [
        'AD WM CD9,C1QB,RBFOX3,SPP1,CD63,CRYAB,YWHAH,GFAP,MBP',
        'AD WM SLC1A3,P2RY12,KIF5A,RBFOX3,SNCG,STMN2,CSRP1,PLP1,GLUL,GFAP,PAQR6,MBP',
        'AD layer 1 CD9,C1QB,RBFOX3,SPP1,CD63,CRYAB,YWHAH,GFAP,MBP',
        'AD layer 1 SLC1A3,P2RY12,KIF5A,RBFOX3,SNCG,STMN2,CSRP1,PLP1,GLUL,GFAP,PAQR6,MBP',
        'AD layer 2 CD9,C1QB,RBFOX3,SPP1,CD63,CRYAB,YWHAH,GFAP,MBP',
        'AD layer 2 SLC1A3,P2RY12,KIF5A,RBFOX3,SNCG,STMN2,CSRP1,PLP1,GLUL,GFAP,PAQR6,MBP',
        'AD layer 3 CD9,C1QB,RBFOX3,SPP1,CD63,CRYAB,YWHAH,GFAP,MBP',
        'AD layer 3 SLC1A3,P2RY12,KIF5A,RBFOX3,SNCG,STMN2,CSRP1,PLP1,GLUL,GFAP,PAQR6,MBP',
        'AD layer 4 CD9,C1QB,RBFOX3,SPP1,CD63,CRYAB,YWHAH,GFAP,MBP',
        'AD layer 4 SLC1A3,P2RY12,KIF5A,RBFOX3,SNCG,STMN2,CSRP1,PLP1,GLUL,GFAP,PAQR6,MBP',
        'AD layer 5 CD9,C1QB,RBFOX3,SPP1,CD63,CRYAB,YWHAH,GFAP,MBP',
        'AD layer 5 SLC1A3,P2RY12,KIF5A,RBFOX3,SNCG,STMN2,CSRP1,PLP1,GLUL,GFAP,PAQR6,MBP',
        'AD layer 6 CD9,C1QB,RBFOX3,SPP1,CD63,CRYAB,YWHAH,GFAP,MBP',
        'AD layer 6 SLC1A3,P2RY12,KIF5A,RBFOX3,SNCG,STMN2,CSRP1,PLP1,GLUL,GFAP,PAQR6,MBP',
        'CT WM CD9,C1QB,RBFOX3,SPP1,CD63,CRYAB,YWHAH,GFAP,MBP',
        'CT WM SLC1A3,P2RY12,KIF5A,RBFOX3,SNCG,STMN2,CSRP1,PLP1,GLUL,GFAP,PAQR6,MBP',
        'CT layer 1 CD9,C1QB,RBFOX3,SPP1,CD63,CRYAB,YWHAH,GFAP,MBP',
        'CT layer 1 SLC1A3,P2RY12,KIF5A,RBFOX3,SNCG,STMN2,CSRP1,PLP1,GLUL,GFAP,PAQR6,MBP',
        'CT layer 2 CD9,C1QB,RBFOX3,SPP1,CD63,CRYAB,YWHAH,GFAP,MBP',
        'CT layer 2 SLC1A3,P2RY12,KIF5A,RBFOX3,SNCG,STMN2,CSRP1,PLP1,GLUL,GFAP,PAQR6,MBP',
        'CT layer 3 CD9,C1QB,RBFOX3,SPP1,CD63,CRYAB,YWHAH,GFAP,MBP',
        'CT layer 3 SLC1A3,P2RY12,KIF5A,RBFOX3,SNCG,STMN2,CSRP1,PLP1,GLUL,GFAP,PAQR6,MBP',
        'CT layer 4 CD9,C1QB,RBFOX3,SPP1,CD63,CRYAB,YWHAH,GFAP,MBP',
        'CT layer 4 SLC1A3,P2RY12,KIF5A,RBFOX3,SNCG,STMN2,CSRP1,PLP1,GLUL,GFAP,PAQR6,MBP',
        'CT layer 5 CD9,C1QB,RBFOX3,SPP1,CD63,CRYAB,YWHAH,GFAP,MBP',
        'CT layer 5 SLC1A3,P2RY12,KIF5A,RBFOX3,SNCG,STMN2,CSRP1,PLP1,GLUL,GFAP,PAQR6,MBP',
        'CT layer 6 CD9,C1QB,RBFOX3,SPP1,CD63,CRYAB,YWHAH,GFAP,MBP',
        'CT layer 6 SLC1A3,P2RY12,KIF5A,RBFOX3,SNCG,STMN2,CSRP1,PLP1,GLUL,GFAP,PAQR6,MBP'
      ]
      const result = []
      for (const i of names) {
        result.push({
          name: i,
          pngLink: `${this.baseUrl}/5.RNAscope/${i}.png`,
          tiffLink: `${this.baseUrl}/5.RNAscope/${i}.tif`
        })
      }
      return result
    },
    circosData() {
      return [
        {
          pathology: 'Ab',
          name: 'Ab_sp_Ab',
          pngLink: `${this.baseUrl}/3.Ciros plot/Ab/Ab_sp_Ab.png`
        },
        {
          pathology: 'Ab',
          name: 'Ab_sp_level1',
          pngLink: `${this.baseUrl}/3.Ciros plot/Ab/Ab_sp_level1.png`
        },
        {
          pathology: 'Ab',
          name: 'Ab_sp_level2',
          pngLink: `${this.baseUrl}/3.Ciros plot/Ab/Ab_sp_level2.png`
        },
        {
          pathology: 'Ab',
          name: 'Ab_sp_level3',
          pngLink: `${this.baseUrl}/3.Ciros plot/Ab/Ab_sp_level3.png`
        },
        {
          pathology: 'AT8',
          name: 'AT8_sp_AT8',
          pngLink: `${this.baseUrl}/3.Ciros plot/AT8/AT8_sp_AT8.png`
        },
        {
          pathology: 'AT8',
          name: 'AT8_sp_level1',
          pngLink: `${this.baseUrl}/3.Ciros plot/AT8/AT8_sp_level1.png`
        },
        {
          pathology: 'AT8',
          name: 'AT8_sp_level2',
          pngLink: `${this.baseUrl}/3.Ciros plot/AT8/AT8_sp_level2.png`
        },
        {
          pathology: 'AT8',
          name: 'AT8_sp_level3',
          pngLink: `${this.baseUrl}/3.Ciros plot/AT8/AT8_sp_level3.png`
        },
        {
          pathology: 'Ab_AT8',
          name: 'AT8_Ab_sp_Ab_AT8',
          pngLink: `${this.baseUrl}/3.Ciros plot/Ab_AT8/AT8_Ab_sp_Ab_AT8.png`
        },
        {
          pathology: 'Ab_AT8',
          name: 'AT8_Ab_sp_level1',
          pngLink: `${this.baseUrl}/3.Ciros plot/Ab_AT8/AT8_Ab_sp_level1.png`
        },
        {
          pathology: 'Ab_AT8',
          name: 'AT8_Ab_sp_level2',
          pngLink: `${this.baseUrl}/3.Ciros plot/Ab_AT8/AT8_Ab_sp_level2.png`
        },
        {
          pathology: 'Ab_AT8',
          name: 'AT8_Ab_sp_level3',
          pngLink: `${this.baseUrl}/3.Ciros plot/Ab_AT8/AT8_Ab_sp_level3.png`
        }
      ]
    },
    tableData() {
      return [
        {
          name: 'Deconvolution statistics (xlsx)',
          link: `${this.baseUrl}/4.Deconvolution Table/Deconvolution statistics.xlsx`
        },
        {
          name: 'Deconvolution celly type probability (xlsx)',
          link: `${this.baseUrl}/4.Deconvolution Table/Deconvolution celly type probability.xlsx`
        }
      ]
    },
    circosDataDisplay() {
      return this.circosData.filter(
        (item) => item.pathology === this.selectedPathology
      )
    }
  },
  watch: {
    circosDataDisplay() {
      this.selectedSampleCircos = this.circosDataDisplay[0]
    }
  },
  mounted() {
    this.selectedSampleClustering = this.clusterData[0]
    this.selectedSampleModule = this.moduleData[0]
    this.selectedSampleCircos = this.circosDataDisplay[0]
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
