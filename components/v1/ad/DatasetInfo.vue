<template>
  <v-hover v-slot:default="{ hover }" open-delay="0">
    <v-card
      class="mx-auto"
      :elevation="hover ? 6 : 2"
      :class="{ 'on-hover': hover }"
    >
      <v-card-title class="primary white--text title-1"
        >General information</v-card-title
      >
      <v-card-text> </v-card-text>

      <v-layout row wrap>
        <v-flex xs12 md12 lg5
          ><v-card-title class="my-2 py-0 subtitle-1 font-weight-bold"
            >Overview<v-divider class="my-2 py-0"></v-divider
          ></v-card-title>

          <v-card-text>
            <p class="my-2">
              <span class="text--secondary">Data ID: </span>
              <span class="text--primary">{{ dataset[0].data_id }}</span>
            </p>
            <p class="my-2">
              <span class="text--secondary">Species: </span>
              <span class="text--primary">{{ dataset[0].species }}</span>
            </p>
            <p class="my-2">
              <span class="text--secondary">Region: </span>
              <span class="text--primary">{{ dataset[0].region }}</span>
            </p>
            <p class="my-2">
              <span class="text--secondary">Condition: </span>
              <span class="text--primary">{{ dataset[0].condition }}</span>
            </p>
            <p class="my-2">
              <span class="text--secondary">Braak stage: </span>
              <span class="text--primary">{{ dataset[0].stage }}</span>
            </p>
            <p class="my-2">
              <span class="text--secondary">Gender: </span>
              <span class="text--primary">{{ dataset[0].gender }}</span>
            </p>
            <p class="my-2">
              <span class="text--secondary">Age: </span>
              <span class="text--primary">{{ dataset[0].age }}</span>
            </p>
          </v-card-text>
          <v-card-title class="my-2 py-0 subtitle-1 font-weight-bold"
            >Datasets from the same experiment
            <v-divider class="my-2 py-0"></v-divider>
          </v-card-title>
          <v-card-text
            ><span v-for="item in related" :key="item.id">
              <a @click="handleClick(item.data_id)">{{ item.data_id }} </a>|
            </span>
          </v-card-text>
          <v-dialog v-model="dialog" max-width="300">
            <v-card>
              <v-card-title>Overview</v-card-title>
              <v-divider class="my-2 py-2"></v-divider>
              <v-card-text>
                <p class="my-2">
                  <span class="text--secondary">Data ID: </span>
                  <span class="text--primary">{{
                    computedDialogData.data_id
                  }}</span>
                </p>
                <p class="my-2">
                  <span class="text--secondary">Species: </span>
                  <span class="text--primary">{{
                    computedDialogData.species
                  }}</span>
                </p>
                <p class="my-2">
                  <span class="text--secondary">Region: </span>
                  <span class="text--primary">{{
                    computedDialogData.region
                  }}</span>
                </p>
                <p class="my-2">
                  <span class="text--secondary">Condition: </span>
                  <span class="text--primary">{{
                    computedDialogData.condition
                  }}</span>
                </p>
                <p class="my-2">
                  <span class="text--secondary">Braak stage: </span>
                  <span class="text--primary">{{
                    computedDialogData.stage
                  }}</span>
                </p>
                <p class="my-2">
                  <span class="text--secondary">Gender: </span>
                  <span class="text--primary">{{
                    computedDialogData.gender
                  }}</span>
                </p>
                <p class="my-2">
                  <span class="text--secondary">Age: </span>
                  <span class="text--primary">{{
                    computedDialogData.age
                  }}</span>
                </p>
              </v-card-text>
              <v-card-actions>
                <v-btn
                  class="mx-2"
                  color="primary "
                  text
                  @click="openDetailsPage()"
                >
                  details </v-btn
                ><v-btn color="grey darken-1" text @click="dialog = false">
                  cancel
                </v-btn>
                <v-spacer></v-spacer>
              </v-card-actions>
            </v-card>
          </v-dialog>
          <v-snackbar v-model="snackbar">
            {{ text }}
            <v-btn color="pink" text @click="snackbar = false">
              Close
            </v-btn>
          </v-snackbar>
        </v-flex>
        <v-flex xs12 md12 lg7
          ><v-card-title class="my-2 py-0 subtitle-1 font-weight-bold"
            >Dataset information
            <v-divider class="my-2 py-0"></v-divider>
          </v-card-title>
          <v-card-text>
            <div v-if="dataset[0].condition === 'Control'">
              <p class="my-2">
                <span class="text--secondary"
                  >Number of cells from source:
                </span>
                <span class="text--primary">{{
                  dataset[0].n_original_cell
                }}</span>
              </p>
              <p class="my-2">
                <span class="text--secondary"
                  >Number of cells after filtering:
                </span>
                <span class="text--primary">{{ dataset[0].n_cell }}</span>
              </p>
            </div>
            <div v-if="dataset[0].condition === 'Disease'">
              <p class="my-2">
                <span class="text--secondary"
                  >Number of AD associated cells:
                </span>
                <span class="text--primary">{{ dataset[0].n_cell }}</span>
              </p>
              <p class="my-2">
                <span class="text--secondary"
                  >Number of control-like cells:
                </span>
                <span class="text--primary">{{
                  dataset[0].n_original_cell - dataset[0].n_cell
                }}</span>
              </p>
            </div>
            <p class="my-2">
              <span class="text--secondary"
                >Number of identified cell types:
              </span>
              <span class="text--primary">{{ dataset[0].n_cluster }}</span>
            </p>

            <div v-for="(pub, index) in publication" :key="pub.id">
              <div v-if="publication.length === 1">
                <div class="my-2 py-0 subtitle-1 font-weight-bold">
                  Dataset source:
                  <v-divider class="my-2 py-0"></v-divider>
                </div>
              </div>
              <div v-else>
                <div class="my-2 py-0 subtitle-1 font-weight-bold">
                  Dataset source {{ index + 1 }}:
                  <v-divider class="my-2 py-0"></v-divider>
                </div>
              </div>

              <p class="my-2">
                <span class="text--secondary">Title: </span>
                <span class="text--primary">{{ pub.title }} </span>
              </p>
              <p class="my-2">
                <span class="text--secondary">Methodology: </span>
                <span class="text--primary">{{ pub.methodology }}</span>
              </p>
              <p class="my-2">
                <span class="text--secondary">Protocol: </span>
                <span class="text--primary">{{ pub.protocol }}</span>
              </p>
              <p class="my-2">
                <span class="text--secondary">GEO/synapse number: </span>
                <span class="text--primary">{{
                  pub.public_id.split(';')[index]
                }}</span>
              </p>
              <p class="my-2">
                <span class="text--secondary">Pubmed ID: </span>
                <span class="text--primary">
                  <a
                    :href="'https://pubmed.ncbi.nlm.nih.gov/' + pub.pmid"
                    target="_blank"
                    style="text-decoration:none;"
                    >{{ pub.pmid }}</a
                  ></span
                >
              </p>
              <p class="my-2">
                <span class="text--secondary">Citation: </span>
                <span class="text--primary">{{ pub.citation }} </span>
              </p>
            </div></v-card-text
          >
        </v-flex>
      </v-layout>
    </v-card>
  </v-hover>
</template>

<script>
import { mapState } from 'vuex'
export default {
  name: 'DasetInfo',
  props: {
    dataset: {
      type: Array,
      required: true
    },
    related: {
      type: Array,
      required: true
    },
    publication: {
      type: Array,
      required: true
    }
  },
  data() {
    return {
      dialog: false,
      computedDialogData: [],
      snackbar: false,
      text: "Hello, I'm a snackbar",
      search: '',
      headers: [
        {
          text: 'Data ID',
          align: 'start',
          sortable: false,
          value: 'data_id'
        },
        { text: 'Gender', value: 'gender' },
        { text: 'Condition', value: 'condition' },
        { text: 'Braak stage', value: 'stage' },
        { text: 'Age', value: 'age' },
        { text: 'Mice model', value: 'mice_model' },
        { text: 'GEO/synapse ID', value: 'public_id' },
        { text: '#Cells', value: 'n_cell' }
      ]
    }
  },
  computed: {
    ...mapState({
      dialogData: (state) => state.ad.dialogDataset
    })
  },
  methods: {
    openPage(id) {
      this.$router.push(id)
    },
    async handleClick(id) {
      // this.$router.push('/browse/' + dataset.data_id)
      // console.log(id)
      await this.$store.dispatch('ad/setDialog', id)
      this.computedDialogData = this.dialogData[0]
      this.dialog = true
    },
    openDetailsPage() {
      this.$router.push(this.computedDialogData.data_id)
    }
  }
}
</script>

<style lang="scss" scoped></style>
