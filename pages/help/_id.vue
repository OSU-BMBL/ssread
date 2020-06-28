/* eslint-disable vue/no-v-html */

<template>
  <v-responsive class="mx-auto overflow-visible" max-width="1024">
    <v-container class="markdown-body">
      <v-app-bar-nav-icon class="hidden-lg-and-up" @click="drawer = !drawer" />
      <v-card class="mx-auto overflow-hidden"> </v-card>
      <div v-html="post"></div>
      <toc :content="navContent"></toc>
      <client-only placeholder="Loading...">
        <div v-show="dataId === 'contact'" style="width:100%;">
          <a href="https://clustrmaps.com/site/1ba7j" title="Visit tracker"
            ><img
              src="//www.clustrmaps.com/map_v2.png?d=lo_dyJKzzEyHLmqSLO7k38JNTEzZg7BQaNQuc3EyqgM&cl=ffffff"
          /></a>
        </div>
      </client-only>
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
      const post = await import(`~/static/docs/${params.id}.md`)
      const navStart = post.default.lastIndexOf('<nav')
      const navEnd = post.default.lastIndexOf('nav>') + 4
      const navContent = post.default
        .substring(navStart, navEnd)
        .replace(/href="([^\\'\\"]+)/g, function(m, s) {
          return 'href="/scread/help/' + params.id + s + '"'
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
    test() {
      return this.$md
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
      title: 'Help',
      script: [
        {
          src:
            'https://cdnjs.cloudflare.com/ajax/libs/jquery/3.1.1/jquery.min.js'
        }
      ],
      meta: [
        {
          name: 'name',
          content: 'content'
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
