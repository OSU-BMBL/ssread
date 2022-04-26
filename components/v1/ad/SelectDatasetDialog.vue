<template>
  <v-dialog v-model="dialog" max-width="290">
    <v-card>
      <v-card-title class="headline">{{ dialog.id }}</v-card-title>

      <v-card-text>
        content
      </v-card-text>

      <v-card-actions>
        <v-spacer></v-spacer>

        <v-btn color="green darken-1" text @click="removeDialog()">
          Disagree
        </v-btn>

        <v-btn color="green darken-1" text @click="removeDialog()">
          Agree
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
import { mapState } from 'vuex'

export default {
  name: 'DatasetDialog',
  computed: {
    ...mapState({
      dialog: (state) => state.ad.dialog
    })
  },
  methods: {
    async removeDialog() {
      await this.$store.dispatch('ad/setDialog', {
        status: true,
        id: this.dialog.data_id
      })
    }
  }
}
</script>

<style lang="scss" scoped></style>
