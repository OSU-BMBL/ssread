<template>
  <v-app id="keep">
    <v-app-bar app clipped-left clipped-right :color="appBarColor" dark>
      <v-app-bar-nav-icon @click="drawer = !drawer" />
      <v-toolbar-title class="ml-2 pl-4">
        <nuxt-link to="/">
          <span class="app-bar-title display-1 bold">{{ title }}</span>
        </nuxt-link>
      </v-toolbar-title>

      <v-toolbar-items class="hidden-xs-only mx-1">
        <v-btn to="/" text> Home </v-btn>
        <v-menu open-on-hover bottom offset-y>
          <template v-slot:activator="{ on, attrs }">
            <v-btn v-bind="attrs" text v-on="on">Browse</v-btn>
          </template>
          <v-list>
            <v-list-item
              v-for="item in browseMenu"
              :key="item.text"
              :to="item.path"
              link
            >
              <v-list-item-title>{{ item.text }}</v-list-item-title
              ><v-list-item-action>
                <v-icon>{{ item.icon }}</v-icon>
              </v-list-item-action>
            </v-list-item>
          </v-list>
        </v-menu>
        <v-btn to="/query" text> Query </v-btn>
        <v-menu open-on-hover bottom offset-y>
          <template v-slot:activator="{ on, attrs }">
            <v-btn v-bind="attrs" text v-on="on">Help</v-btn>
          </template>
          <v-list>
            <v-list-item
              v-for="item in helpMenu"
              :key="item.text"
              :to="item.path"
              link
            >
              <v-list-item-title>{{ item.text }}</v-list-item-title
              ><v-list-item-action>
                <v-icon>{{ item.icon }}</v-icon>
              </v-list-item-action>
            </v-list-item>
          </v-list>
        </v-menu>
        <v-btn to="/downloads" text> Download </v-btn>
        <v-menu open-on-hover bottom offset-y>
          <template v-slot:activator="{ on, attrs }">
            <v-btn v-bind="attrs" text v-on="on">Version 1 (archived)</v-btn>
          </template>
          <v-list>
            <v-list-item
              v-for="item in v1Menu"
              :key="item.text"
              :to="item.path"
              link
            >
              <v-list-item-title>{{ item.text }}</v-list-item-title
              ><v-list-item-action>
                <v-icon>{{ item.icon }}</v-icon>
              </v-list-item-action>
            </v-list-item>
          </v-list>
        </v-menu>
      </v-toolbar-items>
    </v-app-bar>
    <v-navigation-drawer
      v-model="drawer"
      app
      clipped
      relative
      hide-overlay
      temporary
      class="grey lighten-4"
      width="325"
    >
      <v-list class="grey lighten-4 deep-purple--text" shaped>
        <template v-for="(item, idx) in items">
          <v-list-item
            v-if="!item.sublinks"
            :key="idx"
            :to="item.path"
            active-class="purple lighten-4"
          >
            <v-list-item-action>
              <v-icon>{{ item.icon }}</v-icon>
            </v-list-item-action>
            <v-list-item-title class="black--text">
              {{ item.text }}
            </v-list-item-title>
          </v-list-item>
          <v-list-group
            v-else
            :key="idx"
            :to="item.path"
            active-class="deep-purple--text"
          >
            <template v-slot:activator>
              <v-list-item-action>
                <v-icon>{{ item.icon }}</v-icon>
              </v-list-item-action>
              <v-list-item-title class="black--text">
                {{ item.text }}
              </v-list-item-title>
            </template>
            <v-list-item
              v-for="sublink in item.sublinks"
              :key="sublink.text"
              class="px-8"
              :to="sublink.path"
              active-class="purple lighten-4"
            >
              <v-list-item-action>
                <v-icon>{{ sublink.icon }}</v-icon>
              </v-list-item-action>
              <v-list-item-title class="black--text">
                {{ sublink.text }}
              </v-list-item-title>
            </v-list-item>
          </v-list-group>
        </template>
      </v-list>

      <template v-slot:append>
        <v-card class="grey lighten-4 my-0 ">
          <v-card-title class="subtitle-1 black--text font-weight-bold"
            >Cite Us</v-card-title
          >
          <v-card-text
            >Jiang, Jing, Cankun Wang, Ren Qi, Hongjun Fu, and Qin Ma. “ScREAD:
            A Single-Cell RNA-Seq Database for Alzheimer’s Disease.” IScience
            23, no. 11 (November 20, 2020): 101769.
            <a
              class="text-decoration-none"
              href="https://doi.org/10.1016/j.isci.2020.101769"
              >https://doi.org/10.1016/j.isci.2020.101769</a
            >
          </v-card-text>
        </v-card>
        <client-only>
          <v-card class="grey lighten-4 my-0">
            <v-card-title class="subtitle-1 black--text font-weight-bold"
              >Visitors</v-card-title
            >
            <v-card-text
              ><a href="https://clustrmaps.com/site/1ba7j" title="Visit tracker"
                ><img
                  width="100%"
                  src="//clustrmaps.com/map_v2.png?cl=ffffff&w=600&t=n&d=lo_dyJKzzEyHLmqSLO7k38JNTEzZg7BQaNQuc3EyqgM"
              /></a>
            </v-card-text>
          </v-card>
        </client-only>
      </template>
    </v-navigation-drawer>

    <v-main>
      <v-container class="px-6" fluid>
        <alert top></alert>
        <nuxt />
      </v-container>
    </v-main>

    <v-footer
      app
      inset
      absolute
      class="font-weight-light"
      heigth="200"
      width="auto"
    >
      <v-col class="text-center caption" cols="12">
        scREAD is developed by <a href="https://u.osu.edu/bmbl/">BMBL</a>, it is
        free and open to all users and there is no login requirement. |
        {{ new Date().getFullYear() }}
      </v-col>
    </v-footer>
    <fab></fab>
    <snackbar></snackbar>
  </v-app>
</template>
<script>
import fab from '../components/utils/Fab'
import Snackbar from '../components/utils/SnackBar'
import Alert from '../components/utils/Alert'
export default {
  components: { alert: Alert, snackbar: Snackbar, fab },
  data() {
    return {
      drawer: null,
      title: 'scREAD',
      fullTitle:
        "A Single-cell and Spatial RNA-Seq Database for Alzheimer's Disease",
      appBarColor: 'primary',
      appBarTextColor: '#ccccd6',
      items: [
        { icon: 'mdi-home', text: 'Home', path: '/' },

        { icon: 'mdi-database-search', text: 'scRNA-seq', path: '/singlecell' },
        {
          icon: 'mdi-database-search',
          text: 'spatial RNA-seq',
          path: '/spatial'
        },
        { icon: 'mdi-database-search', text: 'Query', path: '/query' },

        {
          icon: 'mdi-help-box',
          text: 'Help',
          to: '/help',
          sublinks: [
            {
              icon: 'mdi-account-question',
              text: 'Usage',
              path: '/help/usage'
            },
            {
              icon: 'mdi-frequently-asked-questions',
              text: 'Frequently asked questions',
              path: '/help/faq'
            },
            {
              icon: 'mdi-account-box',
              text: 'Contact us',
              path: '/help/contact'
            },
            {
              icon: 'mdi-newspaper',
              text: 'News',
              path: '/help/news'
            }
          ]
        },
        { icon: 'mdi-download', text: 'Downloads', path: '/downloads' },
        {
          icon: 'mdi-table',
          text: 'Version 1 (archived)',
          path: '/v1'
        }
      ],
      browseMenu: [
        {
          text: 'scRNA-seq',
          icon: 'mdi-database-search',
          path: '/singlecell'
        },
        {
          text: 'Spatial transcriptomics',
          icon: 'mdi-database-search',
          path: '/spatial'
        }
      ],
      helpMenu: [
        {
          icon: 'mdi-account-question',
          text: 'Usage',
          path: '/help/usage'
        },
        {
          icon: 'mdi-frequently-asked-questions',
          text: 'Frequently asked questions',
          path: '/help/faq'
        },
        {
          icon: 'mdi-account-box',
          text: 'Contact us',
          path: '/help/contact'
        },
        {
          icon: 'mdi-newspaper',
          text: 'News',
          path: '/help/news'
        }
      ],
      v1Menu: [
        { icon: 'mdi-home', text: 'Home', path: '/v1/home' },
        {
          icon: 'mdi-table',
          text: 'Browse control atlas',
          path: '/v1/browse_control_atlas'
        },
        {
          icon: 'mdi-account-question',
          text: 'Usage',
          path: '/v1/help/usage'
        },
        {
          icon: 'mdi-frequently-asked-questions',
          text: 'Frequently asked questions',
          path: '/v1/help/faq'
        },
        {
          icon: 'mdi-account-box',
          text: 'Contact us',
          path: '/v1/help/contact'
        },
        {
          icon: 'mdi-newspaper',
          text: 'News',
          path: '/v1/help/news'
        },
        {
          icon: 'mdi-download',
          text: 'Downloads',
          path: '/v1/downloads'
        }
      ]
    }
  },
  head() {
    return {
      titleTemplate: '%s - scREAD',
      meta: [
        {
          hid: 'default description',
          name: 'default description',
          content: 'default content here'
        }
      ]
    }
  }
}
</script>

<style>
.app-bar-title {
  color: white;
}
#keep .v-navigation-drawer__border {
  display: none;
}
.v-footer a {
  text-decoration: none;
}
</style>
