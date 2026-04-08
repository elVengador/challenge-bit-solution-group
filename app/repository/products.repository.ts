import type { Database } from '~/types/supabase'
import type { ProductInsert } from '~/utils';

export const getProducts = async (search = '') => {
    const supabase = useSupabaseClient<Database>();

    let query = supabase
        .from('products')
        .select('*', { count: 'exact' })
        .order('created_at', { ascending: false })
        .order('id', { ascending: false });

    if (search) query = query.or(`name.ilike.%${search}%,description.ilike.%${search}%`);
    return await query;
};

export const addProduct = async (product: ProductInsert) => {
    const supabase = useSupabaseClient<Database>();
    const { error } = await supabase.from('products').insert(product);
    if (error) throw Error(error.message)
}

export const updateProduct = async (id: string, updates: Partial<ProductInsert>) => {
    const supabase = useSupabaseClient<Database>();
    const { error } = await supabase.from('products').update(updates).eq('id', id);

    if (error) throw Error(error.message);
}

export const deleteProduct = async (id: string) => {
    const supabase = useSupabaseClient<Database>();
    const { error } = await supabase.from('products').delete().eq('id', id);

    if (error) throw Error(error.message);
}