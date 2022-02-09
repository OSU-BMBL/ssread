<template>
  <div>
    <v-layout column justify-center align-center>
      <p class="display-3 font-weight-regular" align-center>
        scREAD (dev) NewGraph2
      </p>
      <v-flex xs="12" md="6" lg="12">
        <p class="display-1">
          NewGraph2 Test
        </p>
      </v-flex>
    </v-layout>

    <client-only>
      <vue-plotly
        :data="parallelData"
        :layout="layout1"
        :display-mode-bar="false"
      />
      <vue-plotly
        :data="splomData"
        :layout="layout2"
        :display-mode-bar="false"
      />
      <vue-plotly
        :data="heatmapData"
        :layout="layout3"
        :display-mode-bar="false"
      />
    </client-only>
  </div>
</template>

<script>
export default {
  data() {
    return {
      parallelData: [
        {
          type: 'parcats',
          dimensions: [
            {
              label: 'Dataset',
              values: ['Data1', 'Data1', 'Data1', 'Data2', 'Data2', 'Data3']
            },
            {
              label: 'Cell Type',
              values: [
                'Endothelial cells',
                'Astrocytes',
                'Oligodendrocytes',
                'Inhibitory neurons',
                'Excitatory neurons',
                'Microglia'
              ]
            }
          ],
          counts: [8, 19, 2, 5, 25]
        }
      ],
      layout1: {
        title: {
          text: 'Sankey Diagram',
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
      splomData: [
        {
          x: [
            'Oligodendrocyte precursor cells',
            'Microglia',
            'Endothelial cells',
            'Astrocytes',
            'Oligodendrocytes',
            'Inhibitory neurons',
            'Excitatory neurons'
          ],
          y: [1874, 3692, 4145, 4281, 7370, 2412, 1162],
          name: 'dataset1',
          type: 'bar'
        }
      ],
      layout2: {
        title: {
          text: 'Condition',
          font: {
            size: 20
          }
        },
        height: 1000,
        width: 1000,
        autosize: false,
        hovermode: 'closest',
        dragmode: 'select',
        plot_bgcolor: 'rgba(240,240,240, 0.95)'
      },
      heatmapData: [
        {
          z: [
            [1, null, 30, 45, 65, 78, 11],
            [20, 1, 36, 50, 30, 92, 7],
            [30, 60, 1, -10, 20, -8, 52]
          ],
          x: [
            'Oligodendrocyte precursor cells',
            'Microglia',
            'Endothelial cells',
            'Astrocytes',
            'Oligodendrocytes',
            'Inhibitory neurons',
            'Excitatory neurons'
          ],
          y: ['GPR98', 'SLC1A2', 'AQP4'],
          type: 'heatmap',
          hoverongaps: false
        }
      ],
      layout3: {
        title: {
          text: 'HeatMap',
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
<style></style>
