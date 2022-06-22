/* eslint-disable vue/no-v-html */

<template>
  <v-responsive class="mx-auto overflow-visible" max-width="1024">
    <v-container class="markdown-body">
      <v-app-bar-nav-icon class="hidden-lg-and-up" @click="drawer = !drawer" />
      <v-card class="mx-auto overflow-hidden"> </v-card>
      <div v-html="post"></div>
      <toc :content="navContent"></toc>
      <div v-if="dataId === 'contact'" style="width:50%;">
        <script
          type="text/javascript"
          src="//rf.revolvermaps.com/0/0/7.js?i=5x6a4rp6wz3&amp;m=0&amp;c=ff0000&amp;cr1=ffffff&amp;sx=0"
          async="async"
        ></script>
      </div>

      <Fab></Fab>
    </v-container>
  </v-responsive>
</template>

<script>
import Fab from '@/components/utils/Fab'
import toc from '@/components/utils/Toc'
export default {
  components: {
    Fab,
    toc
  },
  async asyncData({ store, error, params }) {
    try {
      const post = await import(`~/static/docs/downloads.md`)
      const navStart = post.default.lastIndexOf('<nav')
      const navEnd = post.default.lastIndexOf('nav>') + 4
      const navContent = post.default
        .substring(navStart, navEnd)
        .replace(/href="([^\\'\\"]+)/g, function(m, s) {
          return 'href="/scread/downloads/' + s + '"'
        })
      // await store.dispatch('docs/commitToc', navContent)
      return {
        post: post.default.slice(navEnd),
        navContent
      }
    } catch (err) {
      error({
        statusCode: 404,
        message: 'This page could not be found'
      })
    }
  },
  data() {
    return {
      drawer: null,
      post: null,
      navContent: null
    }
  },
  computed: {
    dataId() {
      return this.$route.params.id
    },
    renderedMd() {
      // eslint-disable-next-line vue/no-side-effects-in-computed-properties
      this.$md.renderer.rules.link_open = function(
        tokens,
        idx,
        options,
        env,
        slf
      ) {
        const token = tokens[idx]
        token.attrs = token.attrs.map((attr) => {
          if (attr[0] === 'href') attr[0] = 'to'
          return attr
        })
        return '<nuxt-link' + slf.renderAttrs(token) + '>'
      }
      // eslint-disable-next-line vue/no-side-effects-in-computed-properties
      this.$md.renderer.rules.link_close = function() {
        return '</nuxt-link>'
      }
      return this.$md.render(this.markdown)
    }
  },
  methods: {
    toLink(pos) {
      this.$vuetify.goTo(0)
    }
  },
  head() {
    return {
      title: 'Downloads',
      meta: [
        {
          hid: 'scREAD download',
          name: 'scREAD download',
          content: `Download Alzheimers disease analysis workflow pipeline, Differential expression and Gene set enrichment analysis,
            control atlases from different brain regions of human and mouse species,
            Interactive UMAP plot for cell types, subclusters, and specific gene expression,
            AD scRNA-Seq, snRNA-Seq datasets, single-cell RNA-seq, single-nucleus RNA-seq`
        }
      ]
    }
  }
}
</script>

<style>
.v-application code {
  box-shadow: none;
}
.v-application code::after,
.v-application code::before {
  content: none;
}
.table-of-contents {
  display: table;
  font-size: 95%;
  margin-bottom: 1em;
  padding: 32px 0 0;
  margin: 0;
  width: 100%;
}
.header-anchor {
  position: absolute;
  left: -0.5em;
  opacity: 0;

  \-webkit-transition: opacity 0.2s ease-in-out 0.1s;
  \-moz-transition: opacity 0.2s ease-in-out 0.1s;
  \-ms-transition: opacity 0.2s ease-in-out 0.1s;
}
h1:hover .header-anchor,
h2:hover .header-anchor,
h3:hover .header-anchor,
h4:hover .header-anchor,
h5:hover .header-anchor,
h6:hover .header-anchor {
  opacity: 1;
}
</style>
