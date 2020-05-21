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
      <v-card-text>
        <p class="my-3 text--primary">Data ID: {{ de[0].data_id }}</p>
        <p class="display-1 text--primary"></p>
      </v-card-text>

      <v-layout row wrap>
        <v-flex xs12 md12 lg7
          ><v-card-title class="my-0 py-0"
            >Overview<v-divider class="my-0 py-0"></v-divider
          ></v-card-title>

          <v-card-text>
            <p class="my-0">
              <span class="text--secondary">Species: </span>
              <span class="text--primary">Human</span>
            </p>
            <p class="my-0">
              <span class="text--secondary">Region: </span>
              <span class="text--primary"></span>
            </p>
            <p class="my-0">
              <span class="text--secondary">Condition: </span>
              <span class="text--primary"></span>
            </p>
            <p class="my-0">
              <span class="text--secondary">Gender: </span>
              <span class="text--primary"></span>
            </p>
            <p class="my-0">
              <span class="text--secondary">Age: </span>
              <span class="text--primary"></span>
            </p>
            <p class="my-0">
              <span class="text--secondary">GSE number: </span>
              <span class="text--primary"></span>
            </p>
          </v-card-text>
          <v-card-title class="my-0 py-0"
            >Dataset information
            <v-divider class="my-0 py-0"></v-divider>
          </v-card-title>
          <v-card-text>
            <p class="my-0">
              <span class="text--secondary">Dataset source:: </span>
              <span class="text--primary">source link</span>
            </p>

            <p class="my-0">
              <span class="text--secondary">Experiment: </span>
              <span class="text--primary">experiment link</span>
            </p>
            <p class="my-0">
              <span class="text--secondary">Lab: </span>
              <span class="text--primary">Lab</span>
            </p>
            <p class="my-0">
              <span class="text--secondary">Pubmed ID: </span>
              <span class="text--primary">PMED00000001</span>
            </p>
            <p class="my-0">
              <span class="text--secondary">Citation: </span>
              <span class="text--primary">111</span>
            </p>
          </v-card-text></v-flex
        >
        <v-flex xs12 md12 lg5
          ><v-card-title class="my-0 py-0"
            >Related dataset
            <v-divider class="my-0 py-0"></v-divider>
          </v-card-title>
        </v-flex>
      </v-layout>
    </v-card>
  </v-hover>
</template>

<script>
export default {
  name: 'DeInfo',
  props: {
    de: {
      type: Array,
      required: true
    }
  }
}
</script>

<style lang="scss" scoped></style>
