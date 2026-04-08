<script setup lang="ts">
import type { Product } from '~/utils';
import { DEFAULT_IMAGE } from '../constants'
import { formatMoney } from '../utils'

const props = defineProps<{ product: Product }>();
</script>
<template>
    <Card class="bg-neutral-800">
        <template #header>
            <img alt="product preview" :src="props.product.image || DEFAULT_IMAGE" }}
                class="h-[300px] w-full object-cover rounded-t-xl bg-black" />
        </template>
        <template #title>{{ props.product.name }}</template>
        <template #content>
            <div class="text-4xl">
                {{ formatMoney(product.price) }}
            </div>
        </template>
        <template #footer>
            <div class="flex justify-between items-center gap-4 mt-1">
                <Badge :value="`Stock: ${props.product.stock}`"></Badge>
                <Chip v-if="props.product.category" :label="props.product.category" />
            </div>
        </template>
    </Card>
</template>