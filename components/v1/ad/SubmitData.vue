<template>
  <div>
    <v-row no-gutters align="start" justify="center">
      <v-col xs="12" md="12" lg="8">
        <v-form ref="form" v-model="valid" lazy-validation>
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
                href="/scread/help/faq"
                target="_blank"
                >FAQ.</a
              ></v-card-text
            >
            <v-col cols="12" md="8">
              <span class="title">1. Upload disease gene expression file</span>
              <v-file-input
                v-model="diseaseFile"
                color="deep-purple accent-4"
                counter
                :rules="fileRules"
                label="Upload disease gene expression matrix:"
                prepend-icon="mdi-paperclip"
                outlined
                :show-size="1000"
                required
              ></v-file-input>
            </v-col>
            <v-col cols="12" md="8">
              <span class="title">2. Fill meta-data information</span>
              <v-row>
                <v-col md="6">
                  <v-select
                    v-model="speciesSelect"
                    :items="species"
                    label="Select species:"
                    :rules="fileRules"
                    required
                  ></v-select>
                </v-col>
                <v-col md="6">
                  <v-select
                    v-model="genderSelect"
                    :items="gender"
                    label="Select gender:"
                    :rules="fileRules"
                    required
                  ></v-select>
                </v-col>
              </v-row>
              <v-row>
                <v-col md="6">
                  <v-select
                    v-model="regionSelect"
                    :items="brainRegion"
                    label="Select brain region:"
                    :rules="fileRules"
                    required
                  ></v-select>
                </v-col>
                <v-col md="6">
                  <v-text-field
                    v-model="stage"
                    label="Braak stage"
                  ></v-text-field>
                </v-col>
              </v-row>
            </v-col>
            <v-col cols="12">
              <v-radio-group v-model="atlasType" :rules="nameRules">
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
                  v-model="controlSelect"
                  :items="reference"
                  label="Select control dataset from scREAD:"
                  :rules="selectRules"
                ></v-select>
              </v-col>

              <v-col v-if="atlasType === 'custom'" cols="12" md="8">
                <v-file-input
                  v-model="controlFile"
                  color="deep-purple accent-4"
                  counter
                  :rules="fileRules"
                  label="Upload control data:"
                  prepend-icon="mdi-paperclip"
                  outlined
                  :show-size="1000"
                  required
                ></v-file-input>
              </v-col>
            </v-col>

            <v-divider></v-divider>
            <v-col cols="12" md="8">
              <v-textarea
                v-model="comments"
                outlined
                label="Comments:"
                clearable
              >
              </v-textarea>
            </v-col>
            <v-col cols="12" md="8">
              <v-checkbox v-model="allowStorage">
                <template v-slot:label>
                  <div>
                    Allow permanent storage in scREAD.
                    <v-tooltip top>
                      <template v-slot:activator="{ on }">
                        <v-icon color="primary" dark v-on="on"
                          >mdi-help-circle-outline</v-icon
                        >
                      </template>
                      By checking this option, you allow us to store your data
                      in scREAD (both inputs and results) for the future
                      database construction. Be cautious if your data have not
                      been published.
                    </v-tooltip>
                  </div>
                </template>
              </v-checkbox>
              <v-text-field
                v-model="email"
                label="E-mail"
                hint="Optional: You will be notified by email when the job is done."
                persistent-hint
              ></v-text-field>
            </v-col>
            <v-card-actions
              ><v-btn text color="primary" @click.stop.prevent="submit">
                Submit
              </v-btn>
              <v-btn text color="primary" @click="reset">
                Reset
              </v-btn>
            </v-card-actions>
            <v-card-text
              v-if="uploadStatus === 'Upload complete'"
              class="mt-4 grey--text body-1 text--darken-3"
              ><p class="my-2">
                Your job ID is
                <strong class="grey--text text--darken-3">{{
                  dialogData
                }}</strong
                >, which can be used to retrieve the results in the searching
                section below.
              </p>
              <p class="my-2">
                Note: The data you uploaded will be processed by our analyst
                manually.
              </p>
              <p class="my-2">
                Please feel free to contact us at qin.ma@osumc.edu, if you might
                have any questions regarding your job.
              </p></v-card-text
            >
            <v-dialog v-model="dialog" max-width="700">
              <v-card>
                <v-card-title>{{ uploadStatus }}</v-card-title>
                <v-divider class="my-2 py-2"></v-divider>
                <v-card-text v-if="uploadStatus === 'Upload complete'">
                  <p class="my-2">
                    Your job ID is
                    <strong class="grey--text text--darken-3">{{
                      dialogData
                    }}</strong
                    >, which can be used to retrieve the results in the
                    searching section at
                    <a href="https://bmbls.bmi.osumc.edu/scread/submit"
                      >https://bmbls.bmi.osumc.edu/scread/submit</a
                    >
                  </p></v-card-text
                >
                <v-card-text v-else-if="uploadStatus === 'Upload error'">
                  <p class="my-2">
                    {{ dialogData }}
                  </p>
                </v-card-text>
                <v-card-text v-else-if="uploadStatus === 'Uploading ...'">
                  <p class="my-2">
                    Please wait while your files are uploading ...
                  </p>
                </v-card-text>
                <v-card-actions>
                  <v-btn
                    class="mx-2"
                    color="grey darken-1"
                    text
                    @click="dialog = false"
                  >
                    close
                  </v-btn>
                  <v-spacer></v-spacer>
                </v-card-actions>
              </v-card>
            </v-dialog>
          </v-card>
        </v-form>
      </v-col>
    </v-row>
    <v-row no-gutters align="start" justify="center">
      <v-col xs="12" md="12" lg="8">
        <v-card class="overflow-hidden">
          <v-card-title class="primary white--text"
            >Retrieve your job</v-card-title
          >
          <v-col cols="12" md="8">
            <v-text-field
              v-model="jobid"
              label="Job ID"
              hint=""
              persistent-hint
            ></v-text-field>
          </v-col>
          <v-card-actions
            ><v-btn text color="primary" @click="openJob(jobid)">
              Submit
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
  </div>
</template>

<script>
import FormData from 'form-data'
import AdService from '~/services/AdService.js'

export default {
  name: 'SubmitPredictionForm',
  data: () => ({
    valid: true,
    dialog: false,
    allowStorage: false,
    uploadStatus: 'Uploading ...',
    dialogData: 'Uploading files to scREAD server.',
    species: ['Human', 'Mouse', 'Other'],
    gender: ['Female', 'Male'],
    stage: '',
    brainRegion: [
      'All',
      'Cerebellum',
      'Cerebral cortex',
      'Cortex',
      'Entorhinal Cortex',
      'Hippocampus',
      'Prefrontal cortex',
      'Superior frontal gyrus'
    ],
    diseaseFile: null,
    controlFile: null,
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
    uploadType: 'upload',
    atlasType: 'scread',
    email: '',
    jobid: '',
    form: {},
    comments: '',
    controlSelect: '',
    genderSelect: '',
    speciesSelect: '',
    regionSelect: '',
    nameRules: [
      (v) => !!v || 'Field is required',
      (v) => (v && v.length <= 20) || 'Name must be less than 20 characters'
    ],
    fileRules: [(v) => !!v || 'Field is required'],
    selectRules: [(v) => !!v || 'Control data is required'],
    emailRules: [
      (v) => (/.+@.+\..+/.test(v) && v.length > 0) || 'E-mail must be valid'
    ]
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
    },
    async submit() {
      if (!this.$refs.form.validate()) return
      this.dialog = true
      this.uploadStatus = 'Uploading ...'
      const formData = new FormData()
      formData.append('method', 'post')
      formData.append('name', 'list')
      formData.append('Content-Type', 'multipart/form-data')
      formData.append('email', this.email)
      formData.append('species', this.speciesSelect)
      formData.append('gender', this.genderSelect)
      formData.append('region', this.regionSelect)
      formData.append('stage', this.stage)
      formData.append('atlasType', this.atlasType)
      formData.append('controlSelect', this.controlSelect)
      formData.append('comments', this.comments)
      formData.append('allowStorage', this.allowStorage)
      formData.append('diseaseFile', this.diseaseFile)
      formData.append('controlFile', this.controlFile)

      await AdService.uploadFiles(formData)
        .then((response) => {
          console.log({ response })
          this.uploadStatus = 'Upload complete'
          this.dialogData = response.data.jobid
          this.$refs.form.reset()
        })
        .catch((error) => {
          console.log({ error })
          this.uploadStatus = 'Upload error'
          this.dialogData = error
        })

      // this.form.submit()
    },
    openJob(id) {
      this.$router.push('submit/' + id)
    }
  }
}
</script>

<style lang="scss" scoped></style>
