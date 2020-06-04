<template>
  <v-hover v-slot:default="{ hover }" open-delay="0">
    <v-card
      class="mx-auto"
      :elevation="hover ? 10 : 2"
      :class="{ 'on-hover': hover }"
    >
      <v-card-title class="primary white--text subtitle-1"
        >Dataset information</v-card-title
      >
      <v-card-text> </v-card-text>

      <v-layout row wrap>
        <v-flex xs12 md12 lg7
          ><v-card-title class="my-0 py-0"
            >Overview<v-divider class="my-0 py-0"></v-divider
          ></v-card-title>

          <v-card-text>
            <p class="my-0">
              <span class="text--secondary">scREAD Data ID: </span>
              <span class="text--primary">{{ dataset[0].data_id }}</span>
            </p>
            <p class="my-0">
              <span class="text--secondary">Species: </span>
              <span class="text--primary">{{ dataset[0].species }}</span>
            </p>
            <p class="my-0">
              <span class="text--secondary">Region: </span>
              <span class="text--primary">{{ dataset[0].region }}</span>
            </p>
            <p class="my-0">
              <span class="text--secondary">Condition: </span>
              <span class="text--primary">{{ dataset[0].condition }}</span>
            </p>
            <p class="my-0">
              <span class="text--secondary">Stage: </span>
              <span class="text--primary">{{ dataset[0].stage }}</span>
            </p>
            <p class="my-0">
              <span class="text--secondary">Gender: </span>
              <span class="text--primary">{{ dataset[0].gender }}</span>
            </p>
            <p class="my-0">
              <span class="text--secondary">Age: </span>
              <span class="text--primary">{{ dataset[0].age }}</span>
            </p>
          </v-card-text>
          <v-card-title class="my-0 py-0"
            >Dataset information
            <v-divider class="my-0 py-0"></v-divider>
          </v-card-title>
          <v-card-text>
            <p class="my-0">
              <span class="text--secondary"
                >Number of AD associated cells:
              </span>
              <span class="text--primary">6377</span>
            </p>
            <p class="my-0">
              <span class="text--secondary"
                >Number of cells from original dataset:
              </span>
              <span class="text--primary">6769</span>
            </p>
            <p class="my-0">
              <span class="text--secondary">Dataset source: </span>
              <span class="text--primary"
                >https://pubmed.ncbi.nlm.nih.gov/31042697/</span
              >
            </p>
            <p class="my-0">
              <span class="text--secondary">GSE number: </span>
              <span class="text--primary">{{ dataset[0].geo_id }}</span>
            </p>
            <p class="my-0">
              <span class="text--secondary">Pubmed ID: </span>
              <span class="text--primary">31042697</span>
            </p>
            <p class="my-0">
              <span class="text--secondary">Citation: </span>
              <span class="text--primary"
                >Mathys, H., Davila-Velderrain, J., Peng, Z. et al. Single-cell
                transcriptomic analysis of Alzheimer’s disease. Nature 570,
                332–337 (2019). https://doi.org/10.1038/s41586-019-1195-2
              </span>
            </p>
          </v-card-text></v-flex
        >
        <v-flex xs12 md12 lg5
          ><v-card-title class="my-0 py-0"
            >Related dataset
            <v-divider class="my-0 py-0"></v-divider>
          </v-card-title>
          <p class="my-0">
            <span class="text--secondary">Same region: </span>
            <span class="text--primary"
              >AD00101: H-H-Prefrontal cortex-Male; AD00106: H-H-Prefrontal
              cortex-Female</span
            >
          </p>
          <p class="my-0">
            <span class="text--secondary">Same stage: </span>
            <span class="text--primary"
              >AD00104: H-AD.early-Prefrontal cortex-Male_001</span
            >
          </p>
          <p class="my-0">
            <span class="text--secondary">Same gender: </span>
            <span class="text--primary"
              >AD00105: H-AD.early-Prefrontal cortex-Female_001</span
            >
          </p>
        </v-flex>
      </v-layout>
    </v-card>
  </v-hover>
</template>

<script>
export default {
  name: 'DasetInfo',
  props: {
    dataset: {
      type: Array,
      required: true
    }
  }
}
</script>

<style lang="scss" scoped></style>
