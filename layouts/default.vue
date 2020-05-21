<template>
  <v-app id="keep">
    <v-app-bar app clipped-left clipped-right :color="appBarColor" dark>
      <v-app-bar-nav-icon class="hidden-lg-and-up" @click="drawer = !drawer" />
      <v-toolbar-title style="width: 300px" class="ml-2 pl-4">
        <nuxt-link to="/">
          <span class="app-bar-title hidden-sm-and-down">{{ title }}</span>
        </nuxt-link>
      </v-toolbar-title>
      <v-spacer />
    </v-app-bar>
    <v-navigation-drawer
      v-model="drawer"
      app
      clipped
      hide-overlay
      class="grey lighten-4"
      width="325"
    >
      <v-list dense class="grey lighten-4" shaped>
        <template v-for="(item, i) in items">
          <v-list-item
            v-if="!item.sublinks"
            :key="i"
            :to="item.url"
            active-class="blue lighten-4"
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
            active-class="blue lighten-5"
          >
            <template v-slot:activator>
              <v-list-item-action active-class="blue lighten-4">
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
              active-class="blue lighten-4"
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
    </v-navigation-drawer>

    <v-content>
      <v-container class="px-6">
        <nuxt />
      </v-container>
    </v-content>

    <v-footer
      app
      inset
      absolute
      class="font-weight-light"
      heigth="200"
      width="auto"
    >
      <v-col class="text-center caption" cols="12">
        scREAD is developed by <a href="https://u.osu.edu/bmbl/">BMBL</a> and it
        is licensed under
        <a href="https://creativecommons.org/licenses/by/4.0/"
          ><v-icon>mdi-creative-commons</v-icon> Creative Commons Attribution
          4.0 International License</a
        >. | {{ new Date().getFullYear() }}
      </v-col>
    </v-footer>
  </v-app>
</template>
<script>
export default {
  components: {},
  data() {
    return {
      drawer: null,
      title: 'scREAD',
      appBarColor: 'primary',
      appBarTextColor: '#ccccd6', // 远山紫
      items: [
        { icon: 'mdi-home', text: 'Home', url: '/' },
        { icon: 'mdi-table', text: 'Browse', url: '/browse' },
        {
          icon: 'mdi-file-find-outline',
          text: 'Submit',
          url: '/submit'
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
              icon: 'mdi-book-open-page-variant',
              text: 'Background information',
              url: '/help/background'
            },
            {
              icon: 'mdi-frequently-asked-questions',
              text: 'Frequently asked questions',
              url: '/help/faq'
            },
            {
              icon: 'mdi-api',
              text: 'API documentation',
              url: '/help/api'
            }
          ]
        },
        { icon: 'mdi-download', text: 'Downloads', url: '/downloads' },
        { icon: 'mdi-information', text: 'About us', url: '/about' }
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
