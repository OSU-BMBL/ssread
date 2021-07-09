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
                >Manuscript<v-divider class="my-2 py-0"></v-divider
              ></v-card-title>
              <v-card-text>
                <p class="my-2">
                  <span class="text--secondary">Title: </span>
                  <span class="text--primary font-weight-medium"
                    >Spatially resolved transcriptomics reveals unique gene
                    signatures associated with human temporal cortical
                    architecture and Alzheimer's pathology.</span
                  >
                </p>
                <p class="my-2">
                  <span class="text--secondary">Authors: </span>
                  <span class="text--primary"
                    >Shuo Chen<sup>†</sup>, Yuzhou Chang<sup>†</sup>, Liangping
                    Li, Diana Acosta, Cody Morrison, Cankun Wang, Dominic
                    Julian, Mark E. Hester, Geidy E. Serrano, Thomas G. Beach,
                    Qin Ma<sup>$</sup>, Hongjun Fu<sup>$</sup></span
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
              </v-card-text></v-col
            >
            <v-col
              v-for="(data, key) in sampleInfo"
              :key="key"
              xl="3"
              lg="3"
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
                <!--<p class="my-2">
                  <span class="text--secondary"
                    >Space Ranger web summary:
                  </span>
                  <span class="text--primary"
                    ><a
                      :href="data.webSummaryLink"
                      target="_blank"
                      class="text-decoration-none"
                    >
                      Open
                      <v-icon color="primary" size="1.2em"
                        >mdi-open-in-new</v-icon
                      >
                    </a></span
                  >
                </p>-->
                <p class="my-2">
                  <span class="text--secondary">Loupe file: </span>
                  <span class="text--primary"
                    ><a
                      :href="data.loupeLink"
                      target="_blank"
                      class="text-decoration-none"
                    >
                      Download (100 MB)
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
            Clustering results for four samples are displayed based on Seurat
            integration method.
          </v-card-title>
          <v-divider />
          <v-card-actions>
            <v-col cols="6">
              <v-select
                v-model="selectedSampleClustering"
                label="Unsupervised clustering figures"
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
            titles[2]
          }}</v-card-title>

          <v-card-title class="my-2 py-0 subtitle-1 font-weight-normal">
            Spatial maps of the eight clusters for each individual sample from
            unsupervised clustering.
          </v-card-title>
          <v-divider />
          <v-card-actions>
            <v-col cols="6">
              <v-select
                v-model="selectedSampleAnnotation"
                label="Manual annotation figures"
                :items="annoData"
                item-text="name"
                item-value="name"
                return-object
                placeholder="Name"
              ></v-select>
            </v-col>
            <v-col cols="6">
              <a
                :href="selectedSampleAnnotation.pngLink"
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
                :href="selectedSampleAnnotation.tiffLink"
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
              <v-img contain :src="selectedSampleAnnotation.pngLink"></v-img>
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

          <v-card-title class="mt-2 mb-0 py-0 subtitle-1 font-weight-normal">
            Circos plots of the connectivity strength within and across modules
            for ST spots in control (CT) human MTG, and with specific AD
            pathologies (Aβ, AT8, Aβ/AT8, GFAP/Aβ/AT8, and P2RY12/Aβ/AT8).
          </v-card-title>
          <v-card-title class="mb-0 py-0 subtitle-1 font-weight-normal">
            Circos plots are composed of four different modules M1-4 (top 15 hub
            genes each module); nodes which represent highly deregulated genes
            from each module; and edges (green lines) which indicate degrees of
            co-expression (high: dark green, low: light green).
          </v-card-title>
          <v-divider />
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

          <v-card-title class="my-2 py-0 subtitle-1 font-weight-normal">
            Public available 10x Visium ST data and Kristen R. Maynard' paper
            (PMID:
            <a
              href="https://pubmed.ncbi.nlm.nih.gov/33558695/"
              target="_blank"
              class="text-decoration-none"
            >
              33558695
              <v-icon color="primary" size="1.2em">mdi-open-in-new</v-icon> </a
            >) of the human frontal cortex is annotated by our layer-specific
            marker genes.
          </v-card-title>
          <v-divider />
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

          <v-card-title class="my-2 py-0 subtitle-1 font-weight-normal">
            Heatmap of Z-scores for upregulated and downregulated differentially
            expressed genes (DEGs) specific to ST spots localized with and
            withoutdifferent AD pathologies Aβ, AT8, Aβ/AT8, GFAP/Aβ/AT8, and
            P2RY12/Aβ/AT8.
          </v-card-title>
          <v-divider />
          <v-card-actions>
            <v-col cols="6">
              <v-select
                v-model="selectedSampleHeatmap"
                label="Heatmap figures"
                :items="heatmapData"
                item-text="name"
                item-value="name"
                return-object
                placeholder="Name"
              ></v-select>
            </v-col>
            <v-col cols="6">
              <a
                :href="selectedSampleHeatmap.pngLink"
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
                :href="selectedSampleHeatmap.tiffLink"
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
              <v-img contain :src="selectedSampleHeatmap.pngLink"></v-img>
            </v-col>
          </v-row>
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
      baseUrl: 'https://bmbl.bmi.osumc.edu/downloadFiles/stofad',
      titles: [
        'Summary',
        'Unsupervised clustering',
        'Manual annotation',
        'Circos plot',
        'Module score',
        'Heatmap'
      ],
      sampleInfo: [
        {
          title: 'Sample 1',
          name: 'CT-1',
          webSummaryLink: 'https://google.com/',
          loupeLink: 'https://google.com/'
        },
        {
          title: 'Sample 2',
          name: 'CT-2',
          webSummaryLink: 'https://google.com/',
          loupeLink: 'https://google.com/'
        },
        {
          title: 'Sample 3',
          name: 'AD-1',
          webSummaryLink: 'https://google.com/',
          loupeLink: 'https://google.com/'
        },
        {
          title: 'Sample 4',
          name: 'AD-2',
          webSummaryLink: 'https://google.com/',
          loupeLink: 'https://google.com/'
        }
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
    clusterData() {
      return [
        {
          name: 'CT-1',
          pngLink: `${this.baseUrl}/cluster/CT-1.png`,
          tiffLink: `${this.baseUrl}/cluster/CT-1.tiff`
        },
        {
          name: 'CT-2',
          pngLink: `${this.baseUrl}/cluster/CT-2.png`,
          tiffLink: `${this.baseUrl}/cluster/CT-2.tiff`
        },
        {
          name: 'AD-1',
          pngLink: `${this.baseUrl}/cluster/AD-1.png`,
          tiffLink: `${this.baseUrl}/cluster/AD-1.tiff`
        },
        {
          name: 'AD-2',
          pngLink: `${this.baseUrl}/cluster/AD-2.png`,
          tiffLink: `${this.baseUrl}/cluster/AD-2.tiff`
        }
      ]
    },
    annoData() {
      return [
        {
          name: 'CT-1',
          pngLink: `${this.baseUrl}/annotation/CT-1.png`,
          tiffLink: `${this.baseUrl}/annotation/CT-1.tiff`
        },
        {
          name: 'CT-2',
          pngLink: `${this.baseUrl}/annotation/CT-2.png`,
          tiffLink: `${this.baseUrl}/annotation/CT-2.tiff`
        },
        {
          name: 'AD-1',
          pngLink: `${this.baseUrl}/annotation/AD-1.png`,
          tiffLink: `${this.baseUrl}/annotation/AD-1.tiff`
        },
        {
          name: 'AD-2',
          pngLink: `${this.baseUrl}/annotation/AD-2.png`,
          tiffLink: `${this.baseUrl}/annotation/AD-2.tiff`
        }
      ]
    },

    moduleData() {
      return [
        {
          name: '151674-WM',
          pngLink: `${this.baseUrl}/module/151674-WM.png`,
          tiffLink: `${this.baseUrl}/module/151674-WM.tiff`
        },
        {
          name: '151674-Layer.2',
          pngLink: `${this.baseUrl}/module/151674-Layer.2.png`,
          tiffLink: `${this.baseUrl}/module/151674-Layer.2tiff`
        },
        {
          name: '151674-Layer.3',
          pngLink: `${this.baseUrl}/module/151674-Layer.3.png`,
          tiffLink: `${this.baseUrl}/module/151674-Layer.3.tiff`
        },
        {
          name: '151674-Layer.4',
          pngLink: `${this.baseUrl}/module/151674-Layer.4.png`,
          tiffLink: `${this.baseUrl}/module/151674-Layer.4.tiff`
        },
        {
          name: '151674-Layer.5',
          pngLink: `${this.baseUrl}/module/151674-Layer.5.png`,
          tiffLink: `${this.baseUrl}/module/151674-Layer.5.tiff`
        },
        {
          name: '151674-Layer.6',
          pngLink: `${this.baseUrl}/module/151674-Layer.6.png`,
          tiffLink: `${this.baseUrl}/module/151674-Layer.6.tiff`
        },
        {
          name: '151673-WM',
          pngLink: `${this.baseUrl}/module/151673-WM.png`,
          tiffLink: `${this.baseUrl}/module/151673-WM.tiff`
        },
        {
          name: '151673-Layer.2',
          pngLink: `${this.baseUrl}/module/151673-Layer.2.png`,
          tiffLink: `${this.baseUrl}/module/151673-Layer.2tiff`
        },
        {
          name: '151673-Layer.3',
          pngLink: `${this.baseUrl}/module/151673-Layer.3.png`,
          tiffLink: `${this.baseUrl}/module/151673-Layer.3.tiff`
        },
        {
          name: '151673-Layer.4',
          pngLink: `${this.baseUrl}/module/151673-Layer.4.png`,
          tiffLink: `${this.baseUrl}/module/151673-Layer.4.tiff`
        },
        {
          name: '151673-Layer.5',
          pngLink: `${this.baseUrl}/module/151673-Layer.5.png`,
          tiffLink: `${this.baseUrl}/module/151673-Layer.5.tiff`
        },
        {
          name: '151673-Layer.6',
          pngLink: `${this.baseUrl}/module/151673-Layer.6.png`,
          tiffLink: `${this.baseUrl}/module/151673-Layer.6.tiff`
        },
        {
          name: 'Adult Human Brain 1-WM',
          pngLink: `${this.baseUrl}/module/Adult Human Brain 1-WM.png`,
          tiffLink: `${this.baseUrl}/module/Adult Human Brain 1-WM.tiff`
        },
        {
          name: 'Adult Human Brain 1-Layer.2',
          pngLink: `${this.baseUrl}/module/Adult Human Brain 1-Layer.2.png`,
          tiffLink: `${this.baseUrl}/module/Adult Human Brain 1-Layer.2tiff`
        },
        {
          name: 'Adult Human Brain 1-Layer.3',
          pngLink: `${this.baseUrl}/module/Adult Human Brain 1-Layer.3.png`,
          tiffLink: `${this.baseUrl}/module/Adult Human Brain 1-Layer.3.tiff`
        },
        {
          name: 'Adult Human Brain 1-Layer.4',
          pngLink: `${this.baseUrl}/module/Adult Human Brain 1-Layer.4.png`,
          tiffLink: `${this.baseUrl}/module/Adult Human Brain 1-Layer.4.tiff`
        },
        {
          name: 'Adult Human Brain 1-Layer.5',
          pngLink: `${this.baseUrl}/module/Adult Human Brain 1-Layer.5.png`,
          tiffLink: `${this.baseUrl}/module/Adult Human Brain 1-Layer.5.tiff`
        },
        {
          name: 'Adult Human Brain 1-Layer.6',
          pngLink: `${this.baseUrl}/module/Adult Human Brain 1-Layer.6.png`,
          tiffLink: `${this.baseUrl}/module/Adult Human Brain 1-Layer.6.tiff`
        },
        {
          name: 'Adult Human Brain 2-WM',
          pngLink: `${this.baseUrl}/module/Adult Human Brain 2-WM.png`,
          tiffLink: `${this.baseUrl}/module/Adult Human Brain 2-WM.tiff`
        },
        {
          name: 'Adult Human Brain 2-Layer.2',
          pngLink: `${this.baseUrl}/module/Adult Human Brain 2-Layer.2.png`,
          tiffLink: `${this.baseUrl}/module/Adult Human Brain 2-Layer.2tiff`
        },
        {
          name: 'Adult Human Brain 2-Layer.3',
          pngLink: `${this.baseUrl}/module/Adult Human Brain 2-Layer.3.png`,
          tiffLink: `${this.baseUrl}/module/Adult Human Brain 2-Layer.3.tiff`
        },
        {
          name: 'Adult Human Brain 2-Layer.4',
          pngLink: `${this.baseUrl}/module/Adult Human Brain 2-Layer.4.png`,
          tiffLink: `${this.baseUrl}/module/Adult Human Brain 2-Layer.4.tiff`
        },
        {
          name: 'Adult Human Brain 2-Layer.5',
          pngLink: `${this.baseUrl}/module/Adult Human Brain 2-Layer.5.png`,
          tiffLink: `${this.baseUrl}/module/Adult Human Brain 2-Layer.5.tiff`
        },
        {
          name: 'Adult Human Brain 2-Layer.6',
          pngLink: `${this.baseUrl}/module/Adult Human Brain 2-Layer.6.png`,
          tiffLink: `${this.baseUrl}/module/Adult Human Brain 2-Layer.6.tiff`
        }
      ]
    },
    heatmapData() {
      return [
        {
          name: 'Layer_heatmap',
          pngLink: `${this.baseUrl}/heatmap/Layer_heatmap.png`,
          tiffLink: `${this.baseUrl}/heatmap/Layer_heatmap.tiff`
        },
        {
          name: 'level2-distance-pathway-for-upregualted-genes',
          pngLink: `${this.baseUrl}/heatmap/level2-distance-pathway-for-upregualted-genes.png`,
          tiffLink: `${this.baseUrl}/heatmap/level2-distance-pathway-for-upregualted-genes.tiff`
        },
        {
          name: 'level2-distance-pathway-for-downregualted-genes',
          pngLink: `${this.baseUrl}/heatmap/level2-distance-pathway-for-downregualted-genes.png`,
          tiffLink: `${this.baseUrl}/heatmap/level2-distance-pathway-for-downregualted-genes.tiff`
        },
        {
          name: 'level3-distance-pathway-for-upregualted-genes',
          pngLink: `${this.baseUrl}/heatmap/level3-distance-pathway-for-upregualted-genes.png`,
          tiffLink: `${this.baseUrl}/heatmap/level3-distance-pathway-for-upregualted-genes.tiff`
        },
        {
          name: 'level3-distance-pathway-for-downregualted-genes',
          pngLink: `${this.baseUrl}/heatmap/level3-distance-pathway-for-downregualted-genes.png`,
          tiffLink: `${this.baseUrl}/heatmap/level3-distance-pathway-for-downregualted-genes.tiff`
        }
      ]
    },
    circosData() {
      return [
        {
          pathology: 'Abeta',
          name: 'Abeta',
          pngLink: `${this.baseUrl}/circos/Abeta/Abeta.png`
        },
        {
          pathology: 'Abeta',
          name: 'Abeta-lvl1',
          pngLink: `${this.baseUrl}/circos/Abeta/Abeta-lvl1.png`
        },
        {
          pathology: 'Abeta',
          name: 'Abeta-lvl2',
          pngLink: `${this.baseUrl}/circos/Abeta/Abeta-lvl2.png`
        },
        {
          pathology: 'Abeta',
          name: 'Abeta-lvl3',
          pngLink: `${this.baseUrl}/circos/Abeta/Abeta-lvl3.png`
        },
        {
          pathology: 'Abeta',
          name: 'Abeta-negative-control',
          pngLink: `${this.baseUrl}/circos/Abeta/Abeta-negative-control.png`
        },
        {
          pathology: 'AT8',
          name: 'AT8',
          pngLink: `${this.baseUrl}/circos/AT8/AT8.png`
        },
        {
          pathology: 'AT8',
          name: 'AT8-lvl1',
          pngLink: `${this.baseUrl}/circos/AT8/AT8-lvl1.png`
        },
        {
          pathology: 'AT8',
          name: 'AT8-lvl2',
          pngLink: `${this.baseUrl}/circos/AT8/AT8-lvl2.png`
        },
        {
          pathology: 'AT8',
          name: 'AT8-lvl3',
          pngLink: `${this.baseUrl}/circos/AT8/AT8-lvl3.png`
        },
        {
          pathology: 'AT8',
          name: 'AT8-negative-control',
          pngLink: `${this.baseUrl}/circos/AT8/AT8-negative-control.png`
        },
        {
          pathology: 'AT8 Abeta',
          name: 'AT8 Abeta',
          pngLink: `${this.baseUrl}/circos/AT8 Abeta/AT8_Abeta.png`
        },
        {
          pathology: 'AT8 Abeta',
          name: 'AT8 Abeta-lvl1',
          pngLink: `${this.baseUrl}/circos/AT8 Abeta/AT8_Abeta-lvl1.png`
        },
        {
          pathology: 'AT8 Abeta',
          name: 'AT8 Abeta-lvl2',
          pngLink: `${this.baseUrl}/circos/AT8 Abeta/AT8_Abeta-lvl2.png`
        },
        {
          pathology: 'AT8 Abeta',
          name: 'AT8 Abeta-lvl3',
          pngLink: `${this.baseUrl}/circos/AT8 Abeta/AT8_Abeta-lvl3.png`
        },
        {
          pathology: 'AT8 Abeta',
          name: 'AT8 Abeta-negative-control',
          pngLink: `${this.baseUrl}/circos/AT8 Abeta/AT8_Abeta-negative-control.png`
        },
        {
          pathology: 'GFAP AT8 Abeta',
          name: 'GFAP AT8 Abeta',
          pngLink: `${this.baseUrl}/circos/GFAP AT8 Abeta/GFAP_AT8_Ab.png`
        },
        {
          pathology: 'GFAP AT8 Abeta',
          name: 'GFAP AT8 Abeta-lvl1',
          pngLink: `${this.baseUrl}/circos/GFAP AT8 Abeta/GFAP_AT8_Ab-lvl1.png`
        },
        {
          pathology: 'GFAP AT8 Abeta',
          name: 'GFAP AT8 Abeta-lvl2',
          pngLink: `${this.baseUrl}/circos/GFAP AT8 Abeta/GFAP_AT8_Ab-lvl2.png`
        },
        {
          pathology: 'GFAP AT8 Abeta',
          name: 'GFAP AT8 Abeta-lvl3',
          pngLink: `${this.baseUrl}/circos/GFAP AT8 Abeta/GFAP_AT8_Ab-lvl3.png`
        },
        {
          pathology: 'GFAP AT8 Abeta',
          name: 'GFAP AT8 Abeta-negative-control',
          pngLink: `${this.baseUrl}/circos/GFAP AT8 Abeta/GFAP_AT8_Ab-negative-control.png`
        },
        {
          pathology: 'P2RY12_AT8_Ab',
          name: 'P2RY12_AT8_Ab',
          pngLink: `${this.baseUrl}/circos/P2RY12_AT8_Ab/P2RY12_AT8_Ab.png`
        },
        {
          pathology: 'P2RY12_AT8_Ab',
          name: 'P2RY12_AT8_Ab-lvl1',
          pngLink: `${this.baseUrl}/circos/P2RY12_AT8_Ab/P2RY12_AT8_Ab-lvl1.png`
        },
        {
          pathology: 'P2RY12_AT8_Ab',
          name: 'P2RY12_AT8_Ab-lvl2',
          pngLink: `${this.baseUrl}/circos/P2RY12_AT8_Ab/P2RY12_AT8_Ab-lvl2.png`
        },
        {
          pathology: 'P2RY12_AT8_Ab',
          name: 'P2RY12_AT8_Ab-lvl3',
          pngLink: `${this.baseUrl}/circos/P2RY12_AT8_Ab/P2RY12_AT8_Ab-lvl3.png`
        },
        {
          pathology: 'P2RY12_AT8_Ab',
          name: 'P2RY12_AT8_Ab-negative-control',
          pngLink: `${this.baseUrl}/circos/P2RY12_AT8_Ab/P2RY12_AT8_Ab-negative-control.png`
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
    this.selectedSampleAnnotation = this.annoData[0]
    this.selectedSampleModule = this.moduleData[0]
    this.selectedSampleCircos = this.circosDataDisplay[0]
    this.selectedSampleHeatmap = this.heatmapData[0]
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
