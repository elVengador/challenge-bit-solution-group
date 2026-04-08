<script setup lang="ts">
import { AddProductValidator } from '../validators/product.validator'
import type { FormSubmitEvent } from '@primevue/forms';
import { CATEGORIES } from '~/constants';
import { addProduct, updateProduct } from '~/repository/products.repository';
import { newProduct, type Product, type ProductInsert } from '~/utils';

const props = defineProps<{ product: Product | null }>();
const categories = ref(CATEGORIES);
const submitted = ref(false)
const productForm = reactive<Product>(props.product ?? newProduct());

const emit = defineEmits<{
    'postSubmit': [data: ProductInsert]
    'closeForm': []
}>();

const toast = useToast();

const onFormSubmit = async ({ valid, states, reset }: FormSubmitEvent) => {
    try {
        submitted.value = true
        if (!valid) return
        const product: ProductInsert = {
            name: states.name?.value,
            description: states.description?.value ?? '',
            category: states.category?.value,
            image: states.image?.value ?? "",
            price: states.price?.value,
            status: states.status?.value,
            stock: states.stock?.value ?? 0,
        }
        props.product?.id ? await updateProduct(props.product?.id, product) : await addProduct(product)
        Object.assign(productForm, newProduct());
        reset()
        submitted.value = false
        toast.add({ severity: 'success', summary: props.product?.id ? 'Product Updated' : 'Product added', life: 3000 });
        emit('postSubmit', product)
    } catch (error) {
        console.error({ error })
        toast.add({ severity: 'error', summary: 'Failed to add product', life: 3000 });
    }
};

const search = (event: any) => {
    categories.value = CATEGORIES.filter(c => c.toLowerCase().includes(event.query.trim().toLowerCase()))
}
</script>

<template>
    <Form v-slot="$form" :initialValues="productForm" :resolver="AddProductValidator" @submit="onFormSubmit"
        class="flex flex-col gap-4">
        <div class="flex flex-col gap-1">
            <label for="name" class="w-full font-semibold">Name *</label>
            <InputText id="name" name="name" class="w-full" autocomplete="off" />
            <small v-if="$form.name?.invalid" class="text-red-500">
                {{ $form.name.error?.message }}
            </small>
        </div>
        <div class="flex flex-col gap-1">
            <label for="description" class="w-full font-semibold">Description</label>
            <Textarea id="description" name="description" class="w-full" autocomplete="off" />
        </div>
        <div class="grid grid-cols-2 gap-2">
            <div class="flex flex-col gap-1">
                <label for="price" class="w-full font-bold">Price *</label>
                <InputNumber id="price" name="price" class="w-full" v-model="productForm.price" mode="currency"
                    currency="USD" locale="en-US" :minFractionDigits="2" :min="0"
                    :invalid="submitted && !productForm.price" />
                <small v-if="$form.price?.invalid" class="text-red-500">{{ $form.price.error?.message }}</small>
            </div>
            <div class="flex flex-col gap-1">
                <label for="stock" class="w-full font-bold">Stock *</label>
                <InputNumber id="stock" name="stock" class="w-full" v-model="productForm.stock" mode="decimal" :min="0"
                    :invalid="submitted && !productForm.stock" />
                <small v-if="$form.stock?.invalid" class="text-red-500">{{ $form.stock.error?.message }}</small>
            </div>
        </div>
        <div class="flex flex-col gap-1">
            <label for="category" class="w-full font-bold">Category</label>
            <AutoComplete name="category" v-model="productForm.category" :suggestions="categories" dropdown
                class="w-full" input-class="w-full" @complete="search" />
            <small v-if="$form.category?.invalid" class="text-red-500">{{ $form.category.error?.message }}</small>
        </div>
        <div class="flex flex-col gap-1">
            <label for="image" class="w-full font-bold">Image Url</label>
            <InputText id="image" name="image" v-model="productForm.image" class="w-full" autocomplete="off" />
        </div>
        <div class="flex gap-2">
            <label for="status" class="font-bold">Status</label>
            <ToggleSwitch id="status" name="status" v-model="productForm.status" />
        </div>
        <div class="flex justify-end gap-2">
            <Button label="Cancel" text severity="secondary" @click="() => emit('closeForm')" autofocus />
            <Button label="Save" severity="contrast" type="submit" autofocus />
        </div>
    </Form>
</template>