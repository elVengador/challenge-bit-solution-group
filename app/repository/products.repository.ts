import type { Database } from '~/types/supabase'
import type { ProductInsert } from '~/utils';


export const getProducts = async () => {
    const supabase = useSupabaseClient<Database>();
    const { data } = await supabase.from('products').select('*').order('created_at', { ascending: false });
    return data;
}

export const addProduct = async (product: ProductInsert) => {
    const supabase = useSupabaseClient<Database>();
    const { error } = await supabase.from('products').insert(product);
    if (error) throw Error(error.message)
}