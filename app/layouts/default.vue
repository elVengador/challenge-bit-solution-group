<script setup lang="ts">
const user = useSupabaseUser()

</script>

<template>
    <div class="min-h-dvh grid grid-rows-[auto_1fr_auto]">
        <header class="w-full p-4 flex items-center justify-between">
            <NuxtLink to="/" class="flex items-center gap-2"><i class="pi pi-prime"></i>My Store</NuxtLink>
            <nav class="flex items-center gap-2">
                <NuxtLink v-if="!user" to="/login" class="hover:text-green-500">Login</NuxtLink>
                <NuxtLink v-if="!user" to="/signup" class="hover:text-green-500">Sign Up</NuxtLink>
            </nav>
        </header>

        <main class="w-full h-full p-4">
            <slot />
        </main>

        <footer class="w-full p-4 flex justify-center">
            <p class="w-full text-center">{{ new Date().getFullYear() }}</p>
        </footer>
    </div>
</template>