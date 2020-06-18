<template>
  <div>
    <no-ssr><submit-form></submit-form></no-ssr>
  </div>
</template>
<script>
import SubmitData from '@/components/ad/SubmitData.vue'
export default {
  components: {
    'submit-form': SubmitData
  },
  data() {
    return {
      search: ''
    }
  },
  methods: {},
  head() {
    return {
      title: 'Job submission',
      meta: [
        {
          hid: 'description',
          name: 'description',
          content: 'What you need to know about motif #' + this.motifs
        }
      ]
    }
  }
}
</script>
<style></style>
