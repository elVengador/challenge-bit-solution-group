<script setup lang="ts">
import { getProducts } from '~/repository/products.repository';

const search = ref('');

const { data, pending } = await useAsyncData('products',
    () => getProducts(search.value),
    { watch: [search], transform: (input) => input });

const skeletons = Array.from({ length: 10 }, (_, i) => i);

</script>

<template>
    <main class="max-w-[1000px] mx-auto p-2">
        <h1 class="text-4xl md:text-6xl text-center mb-10">Product List</h1>
        <InputText v-model="search" placeholder="search..." class="w-full mb-4" />
        <div v-if="pending" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
            <div v-for="i in skeletons" :key="i" class="flex flex-col gap-4 bg-neutral-800 rounded-2xl p-4">
                <Skeleton class="w-full" height="14rem"></Skeleton>
                <Skeleton height="1rem"></Skeleton>
                <Skeleton height="2rem"></Skeleton>
                <div class="flex justify-between gap-[40px]">
                    <Skeleton height="1rem"></Skeleton>
                    <Skeleton height="1rem"></Skeleton>
                </div>
            </div>
        </div>
        <div v-else>
            <div v-if="!data?.count" class="py-8 text-center text-2xl text-neutral-300">
                No products found
            </div>
            <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
                <ProductCard v-for="product in data?.data" :key="product.id" :product="product" />
            </div>
        </div>
    </main>
</template>