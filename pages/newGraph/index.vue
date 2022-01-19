<template>
  <div>
    <v-layout column justify-center align-center>
      <p class="display-3 font-weight-regular" align-center>
        scREAD (dev)
      </p>
      <v-flex xs="12" md="6" lg="12">
        <p class="display-1">
          NewGraph Test
        </p>
      </v-flex>
    </v-layout>

    <client-only>
      <v-row>
        <v-col ref="pie" xs="6" md="6" lg="3">
          <vue-plotly
            :data="pieData1"
            :layout="layout1"
            :options="options"
            @click="clickSelectDatasetDialog()"
          /> </v-col
        ><v-col xs="6" md="6" lg="3">
          <vue-plotly
            :data="pieData2"
            :layout="layout2"
            :options="options"
            @click="clickSelectDatasetDialog()"
          /> </v-col
        ><v-col xs="6" md="6" lg="3">
          <vue-plotly
            :data="pieData3"
            :layout="layout3"
            :options="options"
            @click="clickSelectDatasetDialog()"
          /> </v-col
        ><v-col xs="6" md="6" lg="3">
          <vue-plotly
            :data="pieData4"
            :layout="layout4"
            :options="options"
            @click="clickSelectDatasetDialog()"
          /> </v-col
      ></v-row>
    </client-only>
    <Plotly :data="data1" :layout="layout1" :display-mode-bar="false"></Plotly>
    <Plotly :data="data2" :layout="layout2" :display-mode-bar="false"></Plotly>
  </div>
</template>
<script>
import { Plotly } from 'vue-plotly'
const x = []
for (let i = 0; i < 500; i++) {
  x[i] = Math.random()
}

export default {
  components: {
    Plotly
  },
  data() {
    return {
      data1: [
        {
          values: [41, 62],
          labels: ['Human', 'Mouse'],
          type: 'pie'
        }
      ],
      layout1: {
        title: {
          text: 'Species',
          font: {
            size: 20
          }
        },
        autosize: true,
        width: this.pieWidth,
        height: 500,
        margin: {
          l: 20,
          r: 20,
          b: 210,
          t: 50,
          pad: 4
        },
        legend: {
          font: {
            size: 14
          },
          orientation: 'h'
        }
      },
      data2: [
        {
          x,
          type: 'histogram'
        }
      ],
      layout2: {
        title: {
          text: 'Species',
          font: {
            size: 20
          }
        },
        autosize: true,
        width: this.pieWidth,
        height: 500,
        margin: {
          l: 20,
          r: 20,
          b: 210,
          t: 50,
          pad: 4
        },
        legend: {
          font: {
            size: 14
          },
          orientation: 'h'
        }
      }
    }
  }
}
</script>
>
<style></style>
