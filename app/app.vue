<script setup>
import Toast from 'primevue/toast';
</script>

<template>
  <NuxtRouteAnnouncer />
  <NuxtLayout>
    <NuxtPage />
  </NuxtLayout>
  <Toast position="bottom-right" />
</template>
