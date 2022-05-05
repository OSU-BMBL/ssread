<template>
  <div>
    <v-layout>
      <v-flex>
        <v-container fluid grid-list-md>
          <v-layout row wrap>
            <v-flex xs12 md12 lg12>
              <v-card>
                <v-card-title class="primary white--text">
                  Job ID: {{ dataId }}
                  <v-spacer></v-spacer>
                </v-card-title>
                <v-card-text class="mt-4 grey--text body-1 text--darken-3"
                  >Job ID not exist.
                </v-card-text>
              </v-card>
            </v-flex>
          </v-layout>
        </v-container>
      </v-flex>
    </v-layout>
  </div>
</template>
<script>
export default {
  data() {
    return {
      search: ''
    }
  },
  computed: {
    dataId() {
      return this.$route.params.id
    }
  },
  head() {
    return {
      title: '1',
      meta: [
        {
          hid: 'description',
          name: 'description',
          content: 'What you need to know about motif #'
        }
      ]
    }
  }
}
</script>
<style scoped>
.prompt-box {
  position: relative;
  overflow: hidden;
  padding: 1em;
  margin-bottom: 24px;
  transform: scaleY(1);
}
.prompt-box > .title {
  margin: 0 0 0.5em;
}
.prompt-box > .title > .meta {
  margin-left: 10px;
}
.prompt-box > .actions {
  display: flex;
  align-items: center;
}
.prompt-box > button {
  margin-right: 0.5em;
}
.prompt-box > button:last-of-type {
  margin-right: 0;
}
.location {
  margin-bottom: 0;
}
.location > .icon {
  margin-left: 10px;
}
.motif-header > .title {
  margin: 0;
}
.list-group {
  margin: 0;
  padding: 0;
  list-style: none;
}
.list-group > .list-item {
  padding: 1em 0;
  border-bottom: solid 1px #e5e5e5;
}
</style>
