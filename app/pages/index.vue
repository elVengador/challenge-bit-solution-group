<script setup lang="ts">
import { getProducts } from '~/repository/products.repository';

const { data: products } = await useAsyncData('products', getProducts);
</script>
<template>
    <main class="max-w-[1000px] mx-auto p-2">
        <h1 class="text-6xl text-center mb-10">Product List</h1>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
            <ProductCard v-for="product in products" :key="product.id" :product="product" />
        </div>
    </main>
</template>