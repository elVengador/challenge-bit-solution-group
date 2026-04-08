import type { Database } from "./types/supabase"

export type Product = Database['public']['Tables']['products']['Row']
export type ProductInsert = Database['public']['Tables']['products']['Insert']


export const newProduct = (): Product => ({
    id: crypto.randomUUID(),
    name: "",
    description: "",
    price: 0,
    stock: 0,
    category: "",
    image: '',
    status: true,
    created_at: ''
})