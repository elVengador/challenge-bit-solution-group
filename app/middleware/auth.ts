export default defineNuxtRouteMiddleware(async (to, from) => {
    const user = useSupabaseUser()
    const client = useSupabaseClient()
    if (user.value) return

    const { data: { session } } = await client.auth.getSession()
    if (!session) return navigateTo('/login')
})