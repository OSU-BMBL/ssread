<template>
  <div>
    <v-row>
      <v-col xs="12" md="8" lg="6" class="px-4 py-0 my-0">
        <p class="subtitle-1 font-weight-bold text--primary">
          Clusters to plot:
          <v-tooltip top>
            <template v-slot:activator="{ on, attrs }">
              <v-icon color="primary" dark v-bind="attrs" v-on="on"
                >mdi-help-circle-outline</v-icon
              >
            </template>
            <span>Select UMAP coordinates source or spots coordinates.</span>
          </v-tooltip>
        </p>

        <v-autocomplete
          v-model="clusterCoordinatesSelect"
          :items="clusterCoordinatesItems"
          item-text="cell_type"
          item-value="cell_type"
          label=""
          return-object
          @change="updateCluster()"
        ></v-autocomplete>
        <v-switch
          v-model="toggleImage"
          :label="`Show raw image: ${toggleImage.toString()}`"
        ></v-switch>
      </v-col>
    </v-row>
    <v-row>
      <v-col xs="12" md="6" lg="3" class="px-4 py-0 my-0">
        <p class="subtitle-1 font-weight-bold">
          Point size:
          <v-tooltip top>
            <template v-slot:activator="{ on, attrs }">
              <v-icon color="primary" dark v-bind="attrs" v-on="on"
                >mdi-help-circle-outline</v-icon
              >
            </template>
            <span
              >Limit testing to genes which show, on average, at least X-fold
              difference (log-scale) between the two groups of cells.</span
            >
          </v-tooltip>
        </p>
        <v-slider
          v-model="pointSize"
          max="10"
          min="1"
          hide-details
          :thumb-size="24"
          thumb-label="always"
          class="align-center"
          step="1"
          ticks="always"
          tick-size="4"
        >
        </v-slider>
      </v-col>
    </v-row>
    <v-row>
      <v-col xs="12" md="12" lg="6" class="px-4 py-0 my-0">
        <div v-show="!toggleImage">
          <client-only>
            <vue-plotly
              :data="allCellDim"
              :layout="layout"
              :options="options"
            />
          </client-only>
        </div>
        <div v-show="toggleImage" class="mx-6 mt-16">
          <v-img contain :src="image"></v-img>
        </div>
      </v-col>
      <v-col xs="12" md="12" lg="6" class="px-4 py-0 my-0">
        <client-only>
          <vue-plotly
            :data="allSpatialDim"
            :layout="spatialLayout"
            :options="options"
          />
        </client-only>
      </v-col>
      <v-col xs="12" md="12" lg="6" class="px-4 py-0 my-0"
        ><dataset-barplot
          :freq="dimensionFreq"
          :colors="allColors"
        ></dataset-barplot>
      </v-col>
    </v-row>
    <v-row>
      <v-col xs="12" md="8" lg="5" class="px-4 py-0 my-0">
        <p class="subtitle-1 font-weight-bold text--primary">
          Gene expression<v-tooltip top>
            <template v-slot:activator="{ on, attrs }">
              <v-icon color="primary" dark v-bind="attrs" v-on="on"
                >mdi-help-circle-outline</v-icon
              >
            </template>
            <span
              >Select or search gene of interest to plot gene expression value
              on the UMAP plot, darker points indicate higher expression
              values.</span
            >
          </v-tooltip>
        </p>
        <v-switch
          v-model="toggleSvg"
          :label="
            `Only include spatially variable genes: ${toggleSvg.toString()}`
          "
        ></v-switch>
        <v-autocomplete
          v-model="gene"
          :items="selectedAllGenes"
          :label="'Select or search: (' + selectedAllGenes.length + ' genes)'"
          @change="updateExpression()"
        ></v-autocomplete>
      </v-col>
    </v-row>

    <v-row>
      <v-col xs="12" md="12" lg="6" class="px-4 py-0 my-0">
        <div v-if="showPlot">
          <client-only>
            <vue-plotly
              :data="expressionUmapDim"
              :layout="layout"
              :options="options"
            />
          </client-only>
        </div>
        <div v-else>
          <p>Please enter a gene symbol.</p>
        </div>
      </v-col>
      <v-col xs="12" md="12" lg="6" class="px-4 py-0 my-0">
        <div v-if="showPlot">
          <client-only>
            <vue-plotly
              :data="expressionSpatialDim"
              :layout="spatialLayout"
              :options="options"
            />
          </client-only>
        </div>
        <div v-else>
          <p>Please enter a gene symbol.</p>
        </div>
      </v-col>
      <v-col xs="12" md="12" lg="6" class="px-4 py-0 my-0"
        ><div v-if="showPlot">
          <dataset-violin
            :result="dimensionViolin"
            :colors="allColors"
          ></dataset-violin>
        </div>
      </v-col>
    </v-row>
  </div>
</template>

<script>
import _ from 'lodash'
import { mapState } from 'vuex'
import DatasetBarplot from '../figures/DimensionBarplot.vue'
import DatasetViolinplot from '../figures/DimensionViolinplot.vue'
export default {
  name: 'DimensionInfo',
  components: {
    'dataset-barplot': DatasetBarplot,
    'dataset-violin': DatasetViolinplot
  },
  props: {
    dataId: {
      type: String,
      required: false,
      default: () => 'ST001'
    },
    image: {
      type: String,
      required: false,
      default: () => 'ST001'
    },
    dimension: {
      type: Array,
      required: true
    }
  },

  data() {
    return {
      gene: null,
      toggleImage: false,
      toggleSvg: false,
      pointSize: 6,
      headers: [
        { text: 'Gene name', value: 'gene' },
        { text: 'Log fold-change', value: 'avg_logFC' },
        { text: 'Adjusted p-value', value: 'p_val_adj' }
      ],
      clusterCoordinatesSelect: 'layer',
      colors: [
        '#E64B35FF',
        '#4DBBD5FF',
        '#00A087FF',
        '#3C5488FF',
        '#F39B7FFF',
        '#8491B499',
        '#91D1C2FF',
        '#7E6148FF',
        '#7E6148FE'
      ],

      layout: {
        autosize: true,
        height: 800,
        legend: {
          font: {
            size: 14
          },
          orientation: 'h',
          marker: {
            size: 20
          }
        },
        xaxis: {
          showgrid: true,
          zeroline: false,
          showline: false,
          showticklabels: false,
          tickfont: {
            size: 16,
            color: 'black'
          },
          title: {
            text: 'UMAP_1',
            font: {
              size: 18
            }
          }
        },
        yaxis: {
          showgrid: true,
          zeroline: false,
          showline: false,
          showticklabels: false,
          tickfont: {
            size: 16,
            color: 'black'
          },
          title: {
            text: 'UMAP_2',
            font: {
              size: 18
            }
          }
        }
      },
      spatialLayout: {
        images: [
          {
            source:
              'https://spatial-dlpfc.s3.us-east-2.amazonaws.com/images/151673_tissue_lowres_image.png',
            xref: 'paper',
            yref: 'paper',
            x: 0,
            y: 1,
            sizex: 0.2,
            sizey: 0.2,
            xanchor: 'right',
            yanchor: 'bottom'
          }
        ],
        autosize: true,
        height: 800,
        legend: {
          font: {
            size: 14
          },
          orientation: 'h',
          marker: {
            size: 20
          }
        },
        xaxis: {
          showgrid: true,
          zeroline: false,
          showline: false,
          showticklabels: false,
          tickfont: {
            size: 16,
            color: 'black'
          },
          title: {
            text: '',
            font: {
              size: 18
            }
          }
        },
        yaxis: {
          showgrid: true,
          zeroline: false,
          showline: false,
          showticklabels: false,
          tickfont: {
            size: 16,
            color: 'black'
          },
          title: {
            text: '',
            font: {
              size: 18
            }
          }
        }
      },
      options: {
        toImageButtonOptions: {
          format: 'png', // one of png, svg, jpeg, webp
          filename: 'download_umap' + new Date().toISOString(),
          height: 1000,
          width: 800,
          scale: 1 // Multiply title/legend/axis/canvas sizes by this factor
        },
        showLink: false,
        displaylogo: false,
        modeBarButtonsToRemove: [
          'hoverCompareCartesian',
          'hoverClosestCartesian'
        ]
      },
      svg: [
        'NPY',
        'PLP1',
        'IGKC',
        'HBB',
        'HBA2',
        'MBP',
        'SST',
        'IGHG3',
        'CNP',
        'CRYAB',
        'CRHBP',
        'TF',
        'IGHM',
        'GFAP',
        'IGHG4',
        'SCGB2A2',
        'CARTPT',
        'IGLC2',
        'MOBP',
        'MAG',
        'IGLC3',
        'PPP1R14A',
        'HBA1',
        'MGP',
        'SAA1',
        'S100B',
        'IGHA1',
        'SPP1',
        'CORT',
        'CLDN11',
        'CLDND1',
        'GPR17',
        'ERMN',
        'FABP4',
        'PCP4',
        'RNASE1',
        'CNR1',
        'JCHAIN',
        'NOS1',
        'ENC1',
        'NEFM',
        'MOG',
        'NEFH',
        'NEFL',
        'TMEM144',
        'HSPA2',
        'SCGB1D2',
        'CARNS1',
        'MAL',
        'TAC1',
        'CXCL14',
        'CCK',
        'CHODL',
        'SELENOP',
        'TNFRSF11B',
        'ENPP2',
        'HPCAL1',
        'NME7',
        'MARCKSL1',
        'FDCSP',
        'LINC00844',
        'PTGDS',
        'SNAP25',
        'IGHG1',
        'SCD',
        'PLLP',
        'ATP1B1',
        'IGHA2',
        'VGLL3',
        'OPALIN',
        'ANKRD7',
        'CPB1',
        'VSNL1',
        'PACRG-AS3',
        'AC048382.5',
        'AC008080.4',
        'AQP1',
        'PLEKHH1',
        'AL136141.1',
        'MYRF',
        'PVALB',
        'KLK6',
        'ELOVL1',
        'TTYH2',
        'LAMP2',
        'CMTM5',
        'CERCAM',
        'PMP22',
        'TMSB10',
        'PPIAL4G',
        'AC147067.1',
        'RELN',
        'NKX6-2',
        'G0S2',
        'ALB',
        'DNAH11',
        'DNAH10OS',
        'LINC02359',
        'AC009093.1',
        'AL359555.4',
        'SIGLEC7',
        'AP000550.1',
        'SIX3-AS1',
        'LINC01118',
        'ANKRD53',
        'COX7B2',
        'AC034228.1',
        'AL157938.3',
        'BCAS1',
        'ACTA2',
        'APOD',
        'HOPX',
        'RTN1',
        'PTGFR',
        'CNDP1',
        'SEPT4',
        'UGT8',
        'SNCG',
        'VIP',
        'GPRC5B',
        'CNTN2',
        'HAPLN2',
        'NRGN',
        'EVI2A',
        'IGSF22',
        'AC007336.1',
        'PAQR6',
        'SAA2',
        'AC008780.1',
        'MALAT1',
        'PLA2G16',
        'YWHAH',
        'OLFM1',
        'TNC',
        'MATN1',
        'LEMD1',
        'GLDN',
        'GAD1',
        'GDF9',
        'QKI',
        'UCHL1',
        'MCM3AP-AS1',
        'HPGD',
        'FANCB',
        'ATP1A1',
        'AL359091.1',
        'CHN1',
        'CPS1',
        'KIT',
        'AL357079.1',
        'AC018467.1',
        'LEKR1',
        'LINC02082',
        'TERC',
        'LINC01513',
        'AC008629.1',
        'HCRTR2',
        'FAM180A',
        'MORF4L2-AS1',
        'RLN1',
        'LINC01219',
        'AP002893.1',
        'RNF31',
        'AL161756.1',
        'AC021739.2',
        'AC104532.2',
        'AC005759.1',
        'MYH11',
        'FA2H',
        'LURAP1L-AS1',
        'AC139795.2',
        'LINC00836',
        'OSR1',
        'SYT1',
        'SUSD2',
        'GSN',
        'CDKN1C',
        'TFF1',
        'TUBB2A',
        'SYNPR',
        'GPR37',
        'LHPP',
        'LINC01579',
        'NR4A2',
        'MYL9',
        'EFHD1',
        'ZNF829',
        'CALB2',
        'LINC01134',
        'AL450992.2',
        'AC008164.1',
        'CTLA4',
        'AC016708.1',
        'MPIG6B',
        'AC092447.5',
        'ZNF157',
        'AL353626.1',
        'C9orf135',
        'LBX1',
        'AC084782.3',
        'AC090907.2',
        'AC133919.1',
        'AC068234.3',
        'LINC02073',
        'AC022809.1',
        'AC068408.1',
        'AL391095.1',
        'OR7A5',
        'PENK',
        'LINC01748',
        'AC021683.1',
        'FOLH1',
        'HDDC3',
        'EDIL3',
        'SYNC',
        'KRT17',
        'COL4A5',
        'CALB1',
        'ADAMTS4',
        'FGF18',
        'COL13A1',
        'PAQR5',
        'HAS3',
        'FGFR2',
        'C1QL2',
        'ANLN',
        'SLCO4C1',
        'AC105760.2',
        'CPA2',
        'EN2',
        'LINC01508',
        'AC068831.6',
        'AC022706.1',
        'LINC01639',
        'BX324167.1',
        'LINC01562',
        'CERKL',
        'POU5F1',
        'MICB',
        'AC007349.4',
        'LINC01505',
        'LINC00562',
        'AL158058.1',
        'AC023908.3',
        'AC100830.3',
        'FSD2',
        'CCL3L1',
        'OR4D1',
        'CDH26',
        'Z93241.1',
        'ZDBF2',
        'STMN2',
        'TAC3',
        'NDUFA4',
        'SYT2',
        'LRRC75A',
        'GEMIN7-AS1',
        'TAGLN',
        'AL022323.1',
        'AC005944.1',
        'FAM107B',
        'SLC44A1',
        'TENT5A',
        'AC090502.1',
        'CLEC9A',
        'LPAR1',
        'ABCA2',
        'BOK',
        'NPAS4',
        'GPX3',
        'HSPA8',
        'IQCK',
        'TMEM63A',
        'PRR18',
        'RTN3',
        'CRH',
        'ADARB2-AS1',
        'AC011603.3',
        'CCL19',
        'GLTP',
        'TMEM98',
        'MEPE',
        'GJB1',
        'JAM3',
        'TPPP3',
        'LINC00463',
        'CAB39L',
        'NINJ2',
        'MDH1',
        'ATP2B1',
        'RASSF2',
        'SLC10A7',
        'SLAIN1',
        'HCRTR1',
        'AL590434.1',
        'LINC01353',
        'TBC1D8-AS1',
        'AC007405.1',
        'LINC00471',
        'LINC01266',
        'FBXW12',
        'AC097634.1',
        'TEC',
        'AC017007.5',
        'ANKDD1B',
        'LINC00336',
        'TFPI2',
        'XRCC2',
        'VSIG1',
        'GFI1B',
        'AC034102.4',
        'SKA3',
        'AC025580.3',
        'LINC00052',
        'AC026471.1',
        'AC009118.2',
        'TTC39C-AS1',
        'AL121890.3',
        'ZNF564',
        'ZNF665',
        'AL008582.1',
        'AP000251.1',
        'C21orf62-AS1',
        'LRRTM1',
        'PADI2',
        'VAMP1',
        'THRSP',
        'YWHAG',
        'C15orf40',
        'WDHD1',
        'SP8',
        'ZNF236-DT',
        'SEMA3B',
        'ADH1B',
        'SUN2',
        'WISP2',
        'PLIN1',
        'PLPPR1',
        'LMO4',
        'PLEKHB1',
        'USF1',
        'SERPINE2',
        'CD44',
        'TSC22D4',
        'CSRP1',
        'OLIG1',
        'SLC17A8',
        'ITPKA',
        'NSF',
        'CD9',
        'AC011603.2',
        'CBLN4',
        'PARM1',
        'MEG3',
        'NPTN',
        'PHLDB1',
        'PCDH8',
        'SMPX',
        'SMIM32',
        'AC093503.2',
        'CRACR2A',
        'PLAC8L1',
        'PAXIP1-AS2',
        'FPR1',
        'ADCYAP1',
        'SLC5A11',
        'S1PR5',
        'TMEM125',
        'AC023510.2',
        'TUBA1B',
        'ARPP19',
        'LYVE1',
        'PIP4K2A',
        'AC093330.1',
        'LINC00507',
        'CRYM',
        'UST',
        'SFXN2',
        'MUCL1',
        'TEX26',
        'SLC2A4',
        'B3GNT5',
        'RHOU',
        'CNGA3',
        'ZBTB9',
        'OSTM1-AS1',
        'AC002451.1',
        'AC104051.2',
        'CYP7B1',
        'AC024896.1',
        'AL121821.1',
        'AC009133.4',
        'AC009053.2',
        'AC006213.2',
        'CUX2',
        'FAM218A',
        'CAMK2N1',
        'NUDT4',
        'AL356417.1',
        'KCP',
        'SCIN',
        'TEKT5',
        'GPM6A',
        'CLIC4',
        'NPTXR',
        'DUSP10',
        'SOX10',
        'THY1',
        'CA10',
        'AQP4',
        'SERPINI1',
        'PIEZO2',
        'GJB2',
        'INA',
        'VWA1',
        'LRRN1',
        'DCLK1',
        'AC026691.1',
        'BASP1',
        'PPP3CA',
        'CABP1',
        'CALM2',
        'BCLAF3',
        'LRP2',
        'SEMA4D',
        'AC004982.1',
        'XKR6',
        'DEPDC7',
        'RNF139-AS1',
        'PAQR9',
        'MMP25-AS1',
        'TNFRSF14-AS1',
        'IDH1-AS1',
        'AL031963.3',
        'AMDHD1',
        'CALD1',
        'ATP2B2',
        'PCP4L1',
        'PDCL',
        'ADAMTS1',
        'DNAAF2',
        'CALM1',
        'ZSWIM4',
        'SHISA8',
        'PIP',
        'BEX1',
        'AIF1L',
        'GAD2',
        'AL360012.1',
        'TMEM56-RWDD3',
        'NOTCH2NL',
        'AC092667.1',
        'AC097359.3',
        'AC107204.1',
        'AC090425.2',
        'AL133351.1',
        'LPA',
        'PON3',
        'LINC00630',
        'GLYATL1',
        'ANKRD30A',
        'FZD10',
        'MAB21L1',
        'AC145343.1',
        'PPP4R1-AS1',
        'PARAL1',
        'ZNF792',
        'MIA',
        'SPIN3',
        'CCDC110',
        'RNF215',
        'RGS4',
        'CDK18',
        'RGS1',
        'NRN1',
        'SLC31A2',
        'LRRC8D',
        'DNAH17',
        'ST18',
        'CDC42EP1',
        'CAMK2A',
        'AL596257.1',
        'LIPT2',
        'RND3',
        'WIF1',
        'MEF2C',
        'LDB3',
        'KCNN2',
        'ALYREF',
        'IL12A-AS1',
        'NPY5R',
        'SMAD6',
        'PRIMA1',
        'SATB2',
        'ADIPOQ',
        'PLCH1',
        'PRKCI',
        'HTR2C',
        'TREM2',
        'CCSER1',
        'LRIF1',
        'LAMP5',
        'FKBP1A',
        'PPP3R1',
        'MAP1B',
        'VSTM2A',
        'HHIP',
        'GAP43',
        'WNK3',
        'DAAM2',
        'EGLN3',
        'MOB1B',
        'USP54',
        'SLC12A2',
        'CRISP3',
        'EPDR1',
        'KDR',
        'LINC02447',
        'HMCN2',
        'AP003068.2',
        'AC099518.5',
        'ZMYND15',
        'AP001830.1',
        'CCDC152',
        'CCDC65',
        'GABRB2',
        'GJC2',
        'NDRG1',
        'SUCLG2',
        'SLC30A3',
        'SHOC2',
        'FGFR1OP2',
        'AL589740.1',
        'EMP1',
        'AL031275.1',
        'CCNT2-AS1',
        'KIAA2012',
        'AC009955.4',
        'U73166.1',
        'ANKRD31',
        'LINC02115',
        'C5orf47',
        'ZNF454',
        'RBAK-RBAKDN',
        'GABRQ',
        'RLN2',
        'AL159169.3',
        'GZMB',
        'AC015722.2',
        'PGPEP1L',
        'AC145207.3',
        'AL031665.2',
        'AC007666.1',
        'SIK1B',
        'LRRC3',
        'FABP3',
        'USH1C',
        'AC092803.2',
        'CHIC2',
        'AC018647.1',
        'SLCO1A2',
        'KCNIP4',
        'AL805961.2',
        'PDGFD',
        'CRYGD',
        'IL12RB2',
        'WNT16',
        'PRLHR'
      ]
    }
  },
  computed: {
    ...mapState({
      expression: (state) => state.ad.expression,
      allGenes: (state) => state.ad.expressionGenes
    }),
    dimensionFreq() {
      const names = _.map(this.dimension, this.clusterCoordinatesSelect).sort()
      const counts = {}
      for (const num of names) {
        counts[num] = counts[num] ? counts[num] + 1 : 1
      }
      return counts
    },
    dimensionViolin() {
      const names = _.map(this.dimension, this.clusterCoordinatesSelect).sort()
      const expression = this.expression
      const geneName = this.gene
      const clusterName = this.clusterCoordinatesSelect
      return { names, expression, geneName, clusterName }
    },
    selectedAllGenes() {
      if (this.toggleSvg) {
        return this.svg
      } else {
        return this.allGenes
      }
    },
    allColors() {
      return this.colors
    },

    showPlot() {
      return this.gene !== null
    },

    clusterCoordinatesItems() {
      return ['layer', 'cluster']
    },
    allCellDim() {
      if (this.clusterCoordinatesSelect === 'cluster') {
        const clusterNames = [
          ...new Set(this.dimension.map((row) => row.cluster))
        ].sort()

        const traces = new Array([])
        for (const [i, clusterName] of clusterNames.entries()) {
          const X = this.dimension
            .filter((row) => row.cluster === clusterName)
            .map((row) => row.umap_1)
          const Y = this.dimension
            .filter((row) => row.cluster === clusterName)
            .map((row) => row.umap_2)
          const cellNames = this.dimension
            .filter((row) => row.cluster === clusterName)
            .map((row) => row.cell_name)
          const trace = {
            x: X,
            y: Y,
            mode: 'markers',
            text: cellNames,
            marker: {
              size: this.pointSize,
              color: this.colors[i]
            },
            colorscale: 'YlOrRd',
            name: clusterName
          }
          traces.push(trace)
        }
        return traces
      } else {
        const clusterNames = [
          ...new Set(this.dimension.map((row) => row.layer))
        ].sort()
        const traces = new Array([])
        for (const [i, clusterName] of clusterNames.entries()) {
          const X = this.dimension
            .filter((row) => row.layer === clusterName)
            .map((row) => row.umap_1)
          const Y = this.dimension
            .filter((row) => row.layer === clusterName)
            .map((row) => row.umap_2)
          const cellNames = this.dimension
            .filter((row) => row.layer === clusterName)
            .map((row) => row.cell_name)
          const trace = {
            x: X,
            y: Y,
            mode: 'markers',
            text: cellNames,
            marker: {
              size: this.pointSize,
              color: this.colors[i]
            },
            colorscale: 'YlOrRd',
            name: clusterName
          }
          traces.push(trace)
        }
        return traces
      }
    },
    allSpatialDim() {
      if (this.clusterCoordinatesSelect === 'cluster') {
        const clusterNames = [
          ...new Set(this.dimension.map((row) => row.cluster))
        ].sort()

        const traces = new Array([])
        for (const [i, clusterName] of clusterNames.entries()) {
          const X = this.dimension
            .filter((row) => row.cluster === clusterName)
            .map((row) => row.row * -1)
          const Y = this.dimension
            .filter((row) => row.cluster === clusterName)
            .map((row) => row.col)
          const cellNames = this.dimension
            .filter((row) => row.cluster === clusterName)
            .map((row) => row.cell_name)
          const trace = {
            x: X,
            y: Y,
            mode: 'markers',
            text: cellNames,
            marker: {
              size: this.pointSize,
              color: this.colors[i]
            },
            colorscale: 'YlOrRd',
            name: clusterName
          }
          traces.push(trace)
        }
        return traces
      } else {
        const clusterNames = [
          ...new Set(this.dimension.map((row) => row.layer))
        ].sort()
        const traces = new Array([])
        for (const [i, clusterName] of clusterNames.entries()) {
          const X = this.dimension
            .filter((row) => row.layer === clusterName)
            .map((row) => row.row * -1)
          const Y = this.dimension
            .filter((row) => row.layer === clusterName)
            .map((row) => row.col)
          const cellNames = this.dimension
            .filter((row) => row.layer === clusterName)
            .map((row) => row.cell_name)
          const trace = {
            x: X,
            y: Y,
            mode: 'markers',
            text: cellNames,
            marker: {
              size: this.pointSize,
              color: this.colors[i]
            },
            colorscale: 'YlOrRd',
            name: clusterName
          }
          traces.push(trace)
        }
        return traces
      }
    },

    expressionUmapDim() {
      const X = _.map(this.dimension, 'umap_1')
      const Y = _.map(this.dimension, 'umap_2')
      const cellNames = _.map(this.dimension, 'cell_name')
      // merge actualExpression and tmpExpression, overwrite 0 with actual expression values
      const trace = {
        x: X,
        y: Y,
        mode: 'markers',
        text: cellNames,
        marker: {
          size: this.pointSize,
          color: this.expression
        },
        colorscale: 'YlOrRd'
      }
      return [trace]
    },
    expressionSpatialDim() {
      const X = this.dimension.map((row) => row.row * -1)

      const Y = _.map(this.dimension, 'col')
      const cellNames = _.map(this.dimension, 'cell_name')
      // merge actualExpression and tmpExpression, overwrite 0 with actual expression values
      const trace = {
        x: X,
        y: Y,
        mode: 'markers',
        text: cellNames,
        marker: {
          size: this.pointSize,
          color: this.expression
        },
        colorscale: 'YlOrRd'
      }
      return [trace]
    }
  },
  methods: {
    async updateCluster() {
      const params = {
        id: this.$route.params.id,
        type: this.clusterCoordinatesSelect
      }
      await this.$store.dispatch('ad/fetchDimension', params)
    },
    async updateExpression() {
      await this.$store.dispatch('ad/fetchExpression', {
        gene: this.gene,
        id: this.dataId
      })
    }
  }
}
</script>

<style lang="scss" scoped></style>
