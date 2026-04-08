import type { FormResolverOptions } from "@primevue/forms";
import { CATEGORIES } from "~/constants";

export const AddProductValidator = ({ values }: FormResolverOptions) => {
    const errors: any = {};
    if (!values.name) errors.name = [{ message: 'Name is required' }]
    else if (values.name.length < 3) errors.name = [{ message: 'Minimum 3 characters' }]

    if (!values.price) errors.price = [{ message: 'Price is required' }]

    if (!values.stock) errors.stock = [{ message: 'Stock is required' }]

    if (values.category && !CATEGORIES.includes(values.category)) errors.category = [{ message: 'Invalid Category' }]
    return { errors };
};