<template>
  <v-app id="keep">
    <v-app-bar app clipped-left clipped-right :color="appBarColor" dark>
      <v-app-bar-nav-icon @click="drawer = !drawer" />
      <v-toolbar-title width="300" class="ml-2 pl-4">
        <nuxt-link to="/">
          <span class="app-bar-title display-1 bold">{{ title }}</span>
        </nuxt-link>
        <span class="app-bar-title hidden-sm-and-down">{{ fullTitle }} </span>
      </v-toolbar-title>
      <v-spacer />
    </v-app-bar>
    <v-navigation-drawer
      v-model="drawer"
      app
      clipped
      relative
      hide-overlay
      class="grey lighten-4"
      width="325"
    >
      <v-list class="grey lighten-4 deep-purple--text" shaped>
        <template v-for="(item, i) in items">
          <v-list-item
            v-if="!item.sublinks"
            :key="i"
            :to="item.url"
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
            :key="i"
            :to="item.url"
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
              :to="sublink.url"
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
    <snackbar></snackbar>
  </v-app>
</template>
<script>
import Snackbar from '../components/utils/SnackBar'
export default {
  components: { snackbar: Snackbar },
  data() {
    return {
      drawer: null,
      title: 'scREAD',
      fullTitle: "A Single-cell RNA-Seq Database for Alzheimer's Disease",
      appBarColor: 'primary',
      appBarTextColor: '#ccccd6', // 远山紫
      items: [
        { icon: 'mdi-home', text: 'Home', url: '/' },

        {
          icon: 'mdi-table',
          text: 'Browse control atlas',
          url: '/browse_control_atlas'
        },
        {
          icon: 'mdi-help-box',
          text: 'Help',
          to: '/help',
          sublinks: [
            {
              icon: 'mdi-account-question',
              text: 'Usage',
              url: '/help/usage'
            },
            {
              icon: 'mdi-frequently-asked-questions',
              text: 'Frequently asked questions',
              url: '/help/faq'
            },
            {
              icon: 'mdi-account-box',
              text: 'Contact us',
              url: '/help/contact'
            },
            {
              icon: 'mdi-newspaper',
              text: 'News',
              url: '/help/news'
            }
          ]
        },
        { icon: 'mdi-download', text: 'Downloads', url: '/downloads' },
        { icon: 'mdi-home', text: 'newGraph', url: '/newGraph' },
        { icon: 'mdi-home', text: 'newGraph2', url: '/newGraph2' },
        { icon: 'mdi-home', text: 'newGraphTest', url: '/newGraphTest' },
        {
          icon: 'mdi-dev-to',
          text: 'Version 2 (in development)',
          url: '/v2'
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
