<script setup lang="ts">
import { ref } from "vue";
import { deleteProduct, getProducts } from '~/repository/products.repository';
import type { Product } from "~/utils";

definePageMeta({ middleware: 'auth' })


const showForm = ref(false);
const selectedProduct = ref<Product | null>(null)
const toast = useToast();
const confirm = useConfirm();
const { data: products, refresh } = await useAsyncData('products', getProducts);


const onPostSubmit = () => {
    try {
        refresh()
        showForm.value = false
    } catch (error) {
        console.error({ error })
    }
};

const onDelete = async (id: string) => {
    try {
        await deleteProduct(id)
        refresh()
        toast.add({ severity: 'success', summary: 'Product deleted', life: 3000 });
    } catch (error) {
        console.error({ error })
    }
}

const onCloseForm = () => showForm.value = false

const onConfirmDelete = (id: string) => {
    confirm.require({
        message: 'Are you sure you want to delete the product?',
        header: 'Confirmation',
        icon: 'pi pi-exclamation-triangle',
        rejectProps: {
            label: 'Cancel',
            severity: 'secondary',
            outlined: true
        },
        acceptProps: { label: 'Save' },
        accept: () => onDelete(id)
    });
};

const onOpenAddProductForm = () => {
    selectedProduct.value = null
    showForm.value = true
}
const onOpenEditProduct = (product: Product) => {
    selectedProduct.value = product
    showForm.value = true
}

</script>

<template>
    <main class="p-2">
        <div class="flex justify-between items-center mb-4">
            <h1 class="text-2xl text-center mb-4">Products</h1>
            <Button @click="onOpenAddProductForm" label="New Product" icon="pi pi-plus" size="small" />
        </div>
        <div class="card">
            <DataTable :value="products" tableStyle="min-width: 50rem" stripedRows>
                <Column field="id" header="Id"></Column>
                <Column header="Image">
                    <template #body="slotProps">
                        <img :src="slotProps.data.image || 'https://placehold.co/400x400?text=No+Image'"
                            :alt="slotProps.data.name" class="w-16 shadow-md rounded" />
                    </template>
                </Column>
                <Column field="name" header="Name"></Column>
                <Column field="category" header="Category"></Column>
                <Column field="price" header="Price">
                    <template #body="slotProps">
                        {{ '$' + slotProps.data.price }}
                    </template>
                </Column>
                <Column field="stock" header="Stock"></Column>
                <Column field="status" header="Status">
                    <template #body="slotProps">
                        <Tag :value="slotProps.data.status ? 'ACTIVE' : 'INACTIVE'"
                            :severity="slotProps.data.status ? 'success' : 'danger'" />
                    </template>
                </Column>
                <Column header="Actions">
                    <template #body="slotProps">
                        <div class="flex gap-2">
                            <Button icon="pi pi-pencil" @click="() => onOpenEditProduct(slotProps.data)" outlined rounded
                                severity="success" />
                            <Button icon="pi pi-trash" @click="() => onConfirmDelete(slotProps.data.id)" outlined rounded
                                severity="danger" />
                        </div>
                    </template>
                </Column>
            </DataTable>
        </div>
    </main>

    <Dialog v-model:visible="showForm" modal header="Add Product" class="max-w-[600px] w-full">
        <template #header>
            <div class="inline-flex items-center justify-center gap-2">
                <h2>{{ selectedProduct ? "Edit Product" : "Add Product" }}</h2>
            </div>
        </template>
        <ProductForm :product="selectedProduct" @postSubmit="onPostSubmit" @closeForm="onCloseForm" />
    </Dialog>
</template>