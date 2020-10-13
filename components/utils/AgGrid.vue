<template>
  <div>
    <ag-grid-vue
      style="width: 1000px; height: 800px;"
      class="ag-theme-alpine"
      :columnDefs="columnDefs"
      :rowData="rowData"
    >
    </ag-grid-vue>
  </div>
</template>

<script>
export default {
  data() {
    return {
      columnDefs: null,
      rowData: null
    }
  },
  beforeMount() {
    this.columnDefs = [
      { headerName: 'Make', field: 'make', sortable: true, filter: true },
      { headerName: 'Model', field: 'model', sortable: true, filter: true },
      { headerName: 'Price', field: 'price', sortable: true, filter: true }
    ]

    this.rowData = [
      { make: 'Toyota', model: 'Celica', price: 35000 },
      { make: 'Ford', model: 'Mondeo', price: 32000 },
      { make: 'Porsche', model: 'Boxter', price: 72000 }
    ]
  }
}
</script>

<style lang="scss" scoped></style>
