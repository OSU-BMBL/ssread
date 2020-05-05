<template>
  <div>
    <h1>Events</h1>
    <EventCard
      v-for="(event, index) in events"
      :key="index"
      :event="event"
      :data-index="index"
    >
      {{ event }}
    </EventCard>
  </div>
</template>

<script>
import { mapState } from 'vuex' // <--- To map event
import EventCard from '@/components/EventCard'

export default {
  components: {
    EventCard
  },

  async fetch({ store, error }) {
    try {
      await store.dispatch('events/fetchEvents')
    } catch (e) {
      error({
        statusCode: 503,
        message: 'ERROR CODE 503, using async await'
      })
    }
  },
  computed: mapState({
    events: (state) => state.events.events
  }),
  head() {
    return {
      title: 'Event Listing'
    }
  }
}
</script>
