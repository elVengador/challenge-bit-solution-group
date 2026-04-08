<script setup lang="ts">
import { ref } from 'vue';
import type { FormResolverOptions, FormSubmitEvent } from '@primevue/forms';
import { RE_EMAIL } from '~/constants';
import type { SignUpForm } from '~/types/types';

const supabase = useSupabaseClient();
const loading = ref(false);
const initialValues = ref<SignUpForm>({ username: '', email: '', password: '' });
const toast = useToast();

const resolver = ({ values }: FormResolverOptions) => {
    const errors: any = {};
    if (!values.username) errors.username = [{ message: 'Username is required' }]

    if (!values.email) errors.email = [{ message: 'Email is required' }]
    else if (!RE_EMAIL.test(values.email)) errors.email = [{ message: 'Invalid Email' }]

    if (!values.password) errors.password = [{ message: 'Password is required' }]
    else if (values.password.length < 6) errors.password = [{ message: 'Minimum 6 characters' }]

    return { errors };
};

const onFormSubmit = async (e: FormSubmitEvent) => {
    try {
        if (!e.valid) return;

        const { username, email, password } = e.states;
        if (!username || !email || !password) return

        loading.value = true;
        const { error } = await supabase.auth.signUp({ email: email.value, password: password.value, options: { data: { username: username.value, } } });
        loading.value = false;

        if (error) toast.add({ severity: 'error', summary: error.message, life: 3000 });
        else {
            toast.add({ severity: 'success', summary: 'User created', life: 3000 });
            navigateTo('/admin')
        }
    } catch (error) {
        toast.add({ severity: 'error', summary: 'Oops, something went wrong. Try again later', life: 3000 });
    }
};
</script>

<template>
    <div class="grid place-items-center">
        <div class="w-full">
            <h1 class="text-2xl text-center mb-4">Sign Up</h1>
            <Form v-slot="$form" :initialValues="initialValues" :resolver="resolver" @submit="onFormSubmit"
                class="w-full max-w-[500px] mx-auto flex flex-col gap-4">
                <div class="flex flex-col gap-1">
                    <InputText name="username" type="text" placeholder="Username" fluid />
                    <Message v-if="$form.username?.invalid" severity="error" size="small">
                        {{ $form.username.error?.message }}
                    </Message>
                </div>

                <div class="flex flex-col gap-1">
                    <InputText name="email" type="text" placeholder="Email" fluid />
                    <Message v-if="$form.email?.invalid" severity="error" size="small">
                        {{ $form.email.error?.message }}
                    </Message>
                </div>

                <div class="flex flex-col gap-1">
                    <Password name="password" placeholder="Password" :feedback="false" autocomplete="current-password"
                        toggleMask fluid />
                    <Message v-if="$form.password?.invalid" severity="error" size="small">
                        {{ $form.password.error?.message }}
                    </Message>
                </div>

                <Button type="submit" label="Register" :loading="loading" />
            </Form>
        </div>
    </div>
</template>
