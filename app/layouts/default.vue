<script setup lang="ts">
const user = useSupabaseUser()
import { Button } from 'primevue';
const supabase = useSupabaseClient();

const onLogOut = async () => {
    try {
        const { error } = await supabase.auth.signOut();
        if (error) console.log({ error })
        else navigateTo("/")
    } catch (error) {
        console.error({ error })
    }
}

</script>

<template>
    <div class="min-h-dvh grid grid-rows-[auto_1fr_auto]">
        <header class="w-full p-4 flex items-center justify-between">
            <NuxtLink to="/" class="flex items-center gap-2"><i class="pi pi-prime"></i>My Store</NuxtLink>
            <nav class="flex items-center gap-2">
                <NuxtLink to="/admin" class="hover:text-green-500">Dashboard</NuxtLink>
                <!-- <NuxtLink to="/products">Products</NuxtLink> -->
                <!-- <NuxtLink to="/setup">Set Up</NuxtLink> -->
                <Button v-if="user" @click="onLogOut" link class="text-white">Log Out</Button>
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