<script setup lang="ts">
const user = useSupabaseUser()
import { Button } from 'primevue';
const supabase = useSupabaseClient();

import { ref } from "vue";

const navigation = ref([
    {
        label: 'Dashboard',
        icon: 'pi pi-home',
        route: "/dashboard"
    },
    {
        label: 'Products',
        icon: 'pi pi-home',
        route: "/admin"
    },
    {
        label: 'Settings',
        icon: 'pi pi-home',
        route: "/settings"
    }
]);

const onLogOut = async () => {
    try {
        console.log("logout")
        const { error } = await supabase.auth.signOut();
        if (error) console.log({ error })
        else navigateTo("/")
    } catch (error) {
        console.error({ error })
    }
}

const UserOptions = ref([
    { label: 'Log Out', icon: 'pi pi-sign-out', command: () => onLogOut() },
]);

const menu = ref();

const toggle = (event: any) => menu.value.toggle(event);

</script>

<template>
    <div class="min-h-dvh grid grid-rows-[auto_1fr_auto]">
        <header class="card">
            <Menubar :model="navigation">
                <template #start>
                    <NuxtLink to="/" class="flex items-center gap-2 mr-6 no-underline">
                        <i class="pi pi-prime text-green-500" style="font-size: 1.5rem"></i>
                        <span class="text-xl font-bold text-gray-900 dark:text-white tracking-tight">
                            Investep
                        </span>
                    </NuxtLink>
                </template>
                <template #item="{ item }">
                    <NuxtLink :to="item.route" class="text-sm md:text-base hover:text-green-500 hover:underline"
                        active-class="text-green-500">
                        {{ item.label }}</NuxtLink>
                </template>
                <template #end>
                    <div class="flex items-center gap-2">
                        <Button v-if="user" type="button" icon="pi pi-angle-down" icon-pos="right" label="user"
                            @click="toggle" aria-haspopup="true" aria-controls="overlay_menu" variant="text" />
                        <Menu ref="menu" :model="UserOptions" :popup="true" />
                        <NuxtLink v-if="!user" to="/login"
                            class="text-sm md:text-base hover:text-green-500 hover:underline"
                            active-class="text-green-500">Login</NuxtLink>
                        <NuxtLink v-if="!user" to="/signup"
                            class="text-sm md:text-base hover:text-green-500 hover:underline"
                            active-class="text-green-500">
                            Sign Up</NuxtLink>

                    </div>
                </template>
            </Menubar>
        </header>
        <main class="w-full h-full p-4">
            <slot />
        </main>

        <footer class="w-full p-4 flex justify-center">
            <p class="w-full text-center">{{ new Date().getFullYear() }}</p>
        </footer>
    </div>
</template>
