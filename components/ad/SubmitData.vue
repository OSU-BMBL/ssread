<template>
  <div>
    <v-row no-gutters align="start" justify="center">
      <v-col xs="12" md="12" lg="8">
        <v-form ref="form">
          <v-card class="overflow-hidden">
            <v-card-title class="primary white--text"
              >Job Submission</v-card-title
            >
            <v-card-text class="mt-4 grey--text body-1 text--darken-3"
              >Submit your Single-cell RNA-seq disease dataset using scREAD
              analysis workflow. Note: The data you uploaded will be processed
              by our analyst manually. Please leave your email here, and you
              will be noticed by email when the job is done. For more
              information visit our
              <a
                class="grey--text text--darken-3"
                href="/help/faq"
                target="_blank"
                >FAQ.</a
              ></v-card-text
            >
            <v-col cols="12" md="8">
              <span class="title">1. Upload disease gene expression file</span>
              <v-file-input
                color="deep-purple accent-4"
                counter
                label="Upload disease gene expression matrix:"
                prepend-icon="mdi-paperclip"
                outlined
                :show-size="1000"
              ></v-file-input>
            </v-col>
            <v-col cols="12" md="8">
              <span class="title">2. Fill meta-data information</span>
              <v-row>
                <v-col md="6">
                  <v-text-field
                    :items="species"
                    label="Species"
                    required
                  ></v-text-field>
                </v-col>
                <v-col md="6">
                  <v-text-field
                    :items="gender"
                    label="Gender"
                    required
                  ></v-text-field>
                </v-col>
              </v-row>
              <v-row>
                <v-col md="6">
                  <v-text-field
                    :items="brainRegion"
                    label="Brain region"
                    required
                  ></v-text-field>
                </v-col>
                <v-col md="6">
                  <v-text-field
                    :items="stage"
                    label="Braak stage"
                    required
                  ></v-text-field>
                </v-col>
              </v-row>
            </v-col>
            <v-col cols="12">
              <v-radio-group v-model="atlasType">
                <span class="title">3. Choose control data</span>
                <v-radio
                  label="Select from scREAD controls"
                  value="scread"
                ></v-radio>
                <v-radio label="Upload control data" value="custom"></v-radio>
              </v-radio-group>
              <v-col
                v-if="atlasType === 'scread'"
                xs="12"
                md="8"
                lg="8"
                class="py-0 my-0"
              >
                <v-select
                  :items="reference"
                  label="Select control dataset from scREAD:"
                ></v-select>
              </v-col>

              <v-col v-if="atlasType === 'custom'" cols="12" md="8">
                <v-file-input
                  color="deep-purple accent-4"
                  counter
                  label="Upload control data:"
                  prepend-icon="mdi-paperclip"
                  outlined
                  :show-size="1000"
                ></v-file-input>
              </v-col>
            </v-col>

            <v-divider></v-divider>
            <v-col cols="12" md="8">
              <v-textarea outlined label="Comments:" value="" clearable>
                ></v-textarea
              >
            </v-col>
            <v-col cols="12" md="8">
              <v-text-field
                v-model="email"
                :rules="emailRules"
                label="E-mail"
                hint="Optional: You will be notified by email when the job is done."
                persistent-hint
              ></v-text-field>
            </v-col>
            <v-card-actions
              ><v-btn text color="primary">
                Submit
              </v-btn>
              <v-btn text color="primary" @click="reset">
                Reset
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-form>
      </v-col>
    </v-row>
  </div>
</template>

<script>
export default {
  name: 'SubmitPredictionForm',
  data: () => ({
    species: '',
    gender: '',
    stage: '',
    brainRegion: '',
    reference: [
      `Mouse-H-Cortex-Male-7m`,
      `Mouse-H-Cortex-Male-15m`,
      `Mouse-H-Cerebral cortex-Female-15m`,
      `Mouse-H-Cerebellum-Male-7m`,
      `Mouse-H-Hippocampus-Male-7m`,
      `Mouse-H-Hippocampus-Male-15m`,
      `Mouse-H-Hippocampus-Female-7m`,
      `Mouse-H-Hippocampus-Female-20m`,
      `Mouse-H-Prefrontal cortex-Male-7m`,
      `Mouse-H-Prefrontal cortex-Male-15m`,
      `Human-H-Entorhinal Cortex-Male`,
      `Human-H-Entorhinal Cortex-Female`,
      `Human-H-Prefrontal cortex-Male`,
      `Human-H-Prefrontal cortex-Female`,
      `Human-H-Superior frontal gyrus-Male`
    ],
    tf: ['ARID1A', 'BPTF', 'BACG1', 'MAFB', 'NF2L2', 'FOXA1'],
    uploadType: 'upload',
    atlasType: 'scread',
    email: '',
    form: {},
    emailRules: [(v) => /.+@.+\..+/.test(v) || 'E-mail must be valid']
  }),
  methods: {
    validate() {
      this.$refs.form.validate()
    },
    reset() {
      this.$refs.form.reset()
    },
    resetValidation() {
      this.$refs.form.resetValidation()
    }
  }
}
</script>

<style lang="scss" scoped></style>
