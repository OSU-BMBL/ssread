<template>
  <v-row>
    <v-col cols="3">
      <v-card class="mx-auto" tile height="100%"
        ><v-card-title>List filters</v-card-title
        ><v-card-actions
          ><v-treeview
            selectable
            open-all
            :items="selections"
          ></v-treeview></v-card-actions></v-card></v-col
    ><v-col cols="9"
      ><v-card tile>
        <v-list>
          <v-card-title>Dataset</v-card-title>

          <v-list-item-content v-model="selectedItem" color="primary">
            <v-list-item
              v-for="(item, i) in items"
              :key="i"
              style="border-bottom: solid 1px rgba(0, 0, 0, 0.12)"
            >
              <v-list-item-icon>
                {{ item.id }}
              </v-list-item-icon>
              <v-list-item-content>
                <v-list-item-title
                  class="font-weight-medium title"
                  v-text="item.title"
                ></v-list-item-title>
                <v-col cols="12" class="py-0 my-0 px-0">
                  <v-card-text class="px-0">
                    <p class="my-0 mx-0">
                      <span class="text--secondary">Authors: </span>
                      <span class="text--primary"
                        >Kristen R. Maynard, Leonardo Collado-Torres, Lukas M.
                        Weber, Cedric Uytingco, Brianna K. Barry, Stephen R.
                        Williams, Joseph L. Catallini II, Matthew N. Tran,
                        Zachary Besich, Madhavi Tippani, Jennifer Chew, Yifeng
                        Yin, Joel E. Kleinman, Thomas M. Hyde, Nikhil Rao,
                        Stephanie C. Hicks, Keri Martinowich & Andrew E. Jaffe
                        <sup>$</sup></span
                      >
                    </p>
                    <p class="my-2">
                      <span class="text--secondary">Date published: </span>
                      <span class="text--primary">2-21-2021</span>
                    </p>
                    <p class="my-2">
                      <span class="text--secondary">Date added to scREAD:</span>
                      <span class="text--primary"> 4-14-2022</span>
                    </p>
                    <p class="my-2">
                      <span class="text--secondary">Abstract: </span>
                      <span class="text--primary"
                        ><a
                          href="https://www.nature.com/articles/s41593-020-00787-0"
                          target="_blank"
                          class="text-decoration-none"
                        >
                          Nature Neuroscience
                          <v-icon color="primary" size="1.2em"
                            >mdi-open-in-new</v-icon
                          >
                        </a></span
                      >
                    </p>
                    <p class="my-2">
                      <span class="text--secondary">Protocol: </span>
                      <span class="text--primary">10x Genomics Visium</span>
                    </p>
                    <p class="my-2">
                      <v-btn
                        ><span class="text--primary"
                          ><a
                            href="/scread/spatial/ST001"
                            target="_blank"
                            class="text-decoration-none"
                          >
                            Explore
                            <v-icon color="primary" size="1.2em"
                              >mdi-open-in-new</v-icon
                            >
                          </a></span
                        ></v-btn
                      >
                    </p>
                  </v-card-text></v-col
                >
              </v-list-item-content>
            </v-list-item>
          </v-list-item-content>
        </v-list>
      </v-card></v-col
    ></v-row
  >
</template>

<script>
export default {
  data: () => ({
    selectedItem: 1,
    items: [
      {
        title: 'Transcriptome-scale spatial gene expression in the human',
        id: 'ST001'
      },
      {
        title:
          "Spatial Transcriptomics and In Situ Sequencing to Study Alzheimer's Disease",
        id: 'ST002'
      },
      {
        title:
          'Spatial Transcriptomics Reveals Genes Associated with Dysregulated Mitochondrial Functions and Stress Signaling in Alzheimer Disease',
        id: 'ST003'
      }
    ],
    selections: [
      {
        id: 1,
        name: 'Species :',
        children: [
          { id: 2, name: 'Human' },
          { id: 3, name: 'Mouse' }
        ]
      },

      {
        id: 4,
        name: 'Gender:',
        children: [
          { id: 5, name: 'Male' },
          { id: 6, name: 'Female' }
        ]
      },
      {
        id: 7,
        name: 'Condition:',
        children: [
          { id: 8, name: 'Disease' },
          { id: 9, name: 'Control' }
        ]
      },
      {
        id: 15,
        name: 'Brain region :',
        children: [
          { id: 16, name: 'Prefrontal cortex' },
          { id: 17, name: 'Entorhinal Cortex' },
          { id: 18, name: 'Superior parietal lobe' }
        ]
      }
    ]
  })
}
</script>

<style lang="scss"></style>
