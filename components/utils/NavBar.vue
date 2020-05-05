<template>
  <div class="nav">
    <!--<nuxt-link to="/" class="brand">
      DESSO database
    </nuxt-link>
    <nav>
      <nuxt-link to="/">
        List
      </nuxt-link>
      |
      <nuxt-link to="/event/create">
        Create
      </nuxt-link>
    </nav>-->

    <v-app-bar app clipped-left color="blue">
      <v-app-bar-nav-icon @click="drawer = !drawer" />
      <span class="title ml-3 mr-5">DESSO database</span>

      <v-text-field
        flat
        solo-inverted
        placeholder="Search"
        class="d-sm-none-and-down"
        prepend-inner-icon="mdi-magnify"
      ></v-text-field>
      <v-spacer />
    </v-app-bar>

    <v-navigation-drawer v-model="drawer" app clipped color="grey lighten-4">
      <v-list dense class="grey lighten-4">
        <template v-for="(item, i) in items">
          <v-row v-if="item.heading" :key="i" align="center">
            <v-col cols="6">
              <v-subheader v-if="item.heading">
                {{ item.heading }}
              </v-subheader>
            </v-col>
            <v-col cols="6" class="text-right">
              <v-btn small text>edit</v-btn>
            </v-col>
          </v-row>
          <v-divider v-else-if="item.divider" :key="i" dark class="my-4" />
          <v-list-item v-else :key="i" link :to="item.url">
            <v-list-item-action>
              <v-icon>{{ item.icon }}</v-icon>
            </v-list-item-action>
            <v-list-item-content>
              <v-list-item-title class="black--text">
                {{ item.text }}
              </v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </template>
      </v-list>
    </v-navigation-drawer>
  </div>
</template>

<style scoped></style>
