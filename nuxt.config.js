export default {
  mode: 'universal',
  /*
   ** Headers of the page
   */
  head: {
    title: process.env.npm_package_name || '',
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      {
        hid: 'description',
        name: 'description',
        content: process.env.npm_package_description || ''
      }
    ],
    link: [{ rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }]
  },
  router: {
    base: '/scread',
    linkActiveClass: 'active-link'
  },
  publicRuntimeConfig: {
    apiURL: process.env.API_URL
  },

  // loading: { color: '#5698c3', height: '5px' },
  loadingIndicator: {
    name: 'circle',
    color: '#3B8070',
    background: 'white'
  },
  loading: '@/components/utils/Loading.vue',
  /*
   ** Global CSS
   */
  css: ['github-markdown-css', '~/assets/css/main.css'],
  /*
   ** Plugins to load before mounting the App
   */
  plugins: [
    '@/plugins/plugin.js',
    { src: '@/plugins/highcharts.js', mode: 'client' }
  ],
  /*
   ** Nuxt.js dev-modules
   */
  buildModules: [
    // Doc: https://github.com/nuxt-community/eslint-module
    '@nuxtjs/eslint-module',
    '@nuxtjs/vuetify',
    '@nuxtjs/dotenv'
  ],
  /*
   ** Nuxt.js modules
   */
  modules: [
    // Doc: https://axios.nuxtjs.org/usage
    '@nuxtjs/axios',
    '@nuxtjs/markdownit',
    '@nuxtjs/google-gtag',
    'nuxt-clipboard'
  ],
  clipboard: {
    autoSetContainer: true
  },
  'google-gtag': {
    id: 'G-JV49C34BHG',
    debug: true
  },
  markdownit: {
    preset: 'default',
    linkify: true,
    breaks: true,
    typographer: true,
    html: false,
    use: [
      [
        'markdown-it-anchor',
        {
          level: 1,
          // slugify: string => string,
          permalink: true,
          // renderPermalink: (slug, opts, state, permalink) => {},
          permalinkClass: 'header-anchor',
          permalinkSymbol: '#',
          permalinkBefore: false,
          permalinkAttrs: (slug) => ({ style: 'display:none' })
        }
      ],
      'markdown-it-attrs',
      'markdown-it-div',
      'markdown-it-toc-done-right',
      'markdown-it-emoji'
    ]
  },
  vuetify: {
    theme: {
      options: {
        customProperties: true
      },
      light: true,
      // Traditional chinese color 传统中国色
      // http://zhongguose.com/
      // Traditional nippon colors 传统日本色
      // https://nipponcolors.com/
      themes: {
        light: {
          primary: '#6A4C9C', // 桔梗紫
          secondary: '#CA7853', // 远州茶
          tertiary: '#F17C67', // 珊瑚朱
          accent: '#5698c3', // 晴蓝
          error: '#ec2b24', // 秋海棠红
          info: '#2775b6', // 景泰蓝
          success: '#68b88e', // 田园绿
          warning: '#fecc11' // 向日葵黄
        }
      }
    }
  },
  /*
   ** Axios module configuration
   ** See https://axios.nuxtjs.org/options
   */

  axios: {},
  /*
   ** Build configuration
   */
  build: {
    /*
     ** You can extend webpack config here
     */
  }

  /*
  generate: {
    routes: () => {
      return EventService.getEvents().then((response) => {
        return response.data.map((event) => {
          return '/event/' + event.id
        })
      })
    }
  }
  */
}
