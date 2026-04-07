<script setup lang="ts">
import { ref } from 'vue';
import type { FormResolverOptions, FormSubmitEvent } from '@primevue/forms';
import { RE_EMAIL } from '~/constants';
import type { AuthForm } from '~/types';

const supabase = useSupabaseClient();
const loading = ref(false);
const initialValues = ref<AuthForm>({ email: '', password: '' });

const resolver = ({ values }: FormResolverOptions) => {
    const errors: any = {};
    if (!values.email) errors.email = [{ message: 'Email is required' }]
    else if (!RE_EMAIL.test(values.email)) errors.email = [{ message: 'Invalid Email' }]

    if (!values.password) errors.password = [{ message: 'Password is required' }]
    else if (values.password.length < 6) errors.password = [{ message: 'Minimum 6 characters' }]

    return { errors };
};

const onFormSubmit = async (e: FormSubmitEvent) => {
    if (!e.valid) return;

    loading.value = true;
    const { email, password } = e.states;
    if (!email || !password) return
    const { error } = await supabase.auth.signUp({ email: email.value, password: password.value });
    loading.value = false;

    if (error) alert(error.message)
    else navigateTo('/admin')
};
</script>

<template>
    <div class="grid place-items-center">
        <div class="w-full">
            <h1 class="text-2xl text-center mb-4">Sign Up</h1>
            <Form v-slot="$form" :initialValues="initialValues" :resolver="resolver" @submit="onFormSubmit"
                class="w-full max-w-[500px] mx-auto flex flex-col gap-4">
                <div class="flex flex-col gap-1">
                    <InputText name="email" type="text" placeholder="Email" fluid />
                    <Message v-if="$form.email?.invalid" severity="error" size="small">
                        {{ $form.email.error?.message }}
                    </Message>
                </div>

                <div class="flex flex-col gap-1">
                    <Password name="password" placeholder="Contraseña" :feedback="false" autocomplete="current-password"
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
