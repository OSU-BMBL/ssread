<template>
  <v-hover v-slot:default="{ hover }" open-delay="0">
    <v-card
      class="mx-auto"
      :elevation="hover ? 10 : 2"
      :class="{ 'on-hover': hover }"
    >
      <v-card-title class="primary white--text subtitle-1"
        >Differential expression / Gene set enrichment</v-card-title
      >

      <v-card-text>
        <p class="my-3 text--primary">Data ID: {{ de[0].data_id }}</p>
        <p class="display-1 text--primary"></p>
      </v-card-text>

      <v-row wrap> </v-row>
      <v-col xs="12" md="8" lg="4">
        <v-select :items="comparison" label="Comparison:"></v-select>
      </v-col>
      <v-col xs="12" md="8" lg="4">
        <v-select :items="cellType" label="Cell type of Interest:"></v-select>
      </v-col>
      <p class="my-3 text--primary">Log fold-change cutoff:</p>
      <v-row>
        <v-col class="px-4" xs="12" md="8" lg="4">
          <v-range-slider
            v-model="range"
            :max="max"
            :min="min"
            hide-details
            class="align-center"
            step="0.05"
          >
            <template v-slot:prepend>
              <v-text-field
                :value="range[0]"
                class="mt-0 pt-0"
                hide-details
                single-line
                type="number"
                style="width: 60px"
                @change="$set(range, 0, $event)"
              ></v-text-field>
            </template>
            <template v-slot:append>
              <v-text-field
                :value="range[1]"
                class="mt-0 pt-0"
                hide-details
                single-line
                type="number"
                style="width: 60px"
                @change="$set(range, 1, $event)"
              ></v-text-field>
            </template>
          </v-range-slider>
        </v-col>
      </v-row>
      <p class="my-3 text--primary">Adjusted p-value cutoff:</p>
      <v-row>
        <v-col class="px-4" xs="12" md="8" lg="4">
          <v-range-slider
            v-model="range"
            :max="max"
            :min="min"
            hide-details
            class="align-center"
            step="0.05"
          >
            <template v-slot:prepend>
              <v-text-field
                :value="range[0]"
                class="mt-0 pt-0"
                hide-details
                single-line
                type="number"
                style="width: 60px"
                @change="$set(range, 0, $event)"
              ></v-text-field>
            </template>
            <template v-slot:append>
              <v-text-field
                :value="range[1]"
                class="mt-0 pt-0"
                hide-details
                single-line
                type="number"
                style="width: 60px"
                @change="$set(range, 1, $event)"
              ></v-text-field>
            </template>
          </v-range-slider>
        </v-col>
      </v-row>
      <v-col cols="12" md="8">
        <v-radio-group v-model="uploadType">
          <span class="title">DE direction</span>
          <v-radio label="All" value="all"></v-radio>
          <v-radio label="UP" value="up"></v-radio>
          <v-radio label="Down" value="down"></v-radio>
        </v-radio-group>
      </v-col>
      <v-col cols="md-6 lg-4">
        <v-text-field
          v-model="search"
          prepend-icon="mdi-magnify"
          label="Search"
          single-line
          hide-details
        ></v-text-field
        ><v-data-table
          :search="search"
          :headers="headers"
          :items="de"
          :items-per-page="15"
          class="elevation-1"
          @click:row="handleClick"
        ></v-data-table>
        <v-divider inset></v-divider>
      </v-col>
      <v-card-actions>
        <v-btn text color="secondary">
          Enrichment analysis
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-hover>
</template>

<script>
import axios from 'axios'
export default {
  name: 'DeInfo',
  props: {
    de: {
      type: Array,
      required: true
    }
  },
  data() {
    return {
      search: '',
      headers: [
        { text: 'Gene name', value: 'gene' },
        { text: 'Log fold-change', value: 'avg_logFC' },
        { text: 'Adjusted p-value', value: 'p_val_adj' }
        /* ,
        { text: 'Cell type', value: 'ct' },
        { text: 'Comparison type', value: 'type' } */
      ],
      enrich: [],
      comparison: [
        'Cell type specific genes',
        'AD vs Control',
        'Comparison between sex',
        'Comparison between stage',
        'Comparison between age',
        'Sub-cluster specific genes'
      ],
      cellType: [
        'Microglia',
        'Astrocytes',
        'Excitatory neurons',
        'Inhibitory neurons',
        'Oligodendrocytes',
        'Oligodendrocyte precursor cells',
        'Pericytes'
      ],
      min: -4,
      max: 4,
      slider: 1.5,
      range: [-4, 4]
    }
  },
  computed: {
    genes() {
      return [
        'PHF14',
        'RBM3',
        'MSL1',
        'PHF21A',
        'ARL10',
        'INSR',
        'JADE2',
        'P2RX7',
        'LINC00662',
        'CCDC101',
        'PPM1B',
        'KANSL1L',
        'CRYZL1',
        'ANAPC16',
        'TMCC1',
        'CDH8',
        'RBM11',
        'CNPY2',
        'HSPA1L',
        'CUL2',
        'PLBD2',
        'LARP7',
        'TECPR2',
        'ZNF302',
        'CUX1',
        'MOB2',
        'CYTH2',
        'SEC22C',
        'EIF4E3',
        'ROBO2',
        'ADAMTS9-AS2',
        'CXXC1',
        'LINC01314',
        'ATF7',
        'ATP5F1'
      ]
    }
  },
  methods: {
    async handleClick(genes) {
      // const ENRICHR_URL = 'http://amp.pharm.mssm.edu/Enrichr/addList'
      // const description = 'Example gene list'
      const payload = {
        list: this.genes,
        description: 'description'
      }

      const enrich = await axios.post(
        'http://amp.pharm.mssm.edu/Enrichr/addList',
        payload
      )
      console.log(enrich)
    }
  }
}
</script>

<style lang="scss" scoped></style>
