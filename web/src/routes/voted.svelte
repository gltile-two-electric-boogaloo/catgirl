<script context="module" lang="ts">
	import {browser} from "$app/env";
	import {base_url} from "../lib/env";

	export const hydrate = true;
	export const router = browser;
	export const prerender = true;
</script>

<script lang="ts">
	async function get_submissions() {
		const res = await fetch(`${base_url}/submit`, {
			method: 'GET',
			mode: 'cors',
			cache: 'no-cache',

			headers: {
				'Accept': 'application/json'
			},

			redirect: 'error'
		})

		if (!res.ok) {
			throw res.status
		} else {
			return parseInt(await res.json())
		}
	}

	const promise = get_submissions()
</script>

<h1>
	thank you for submitting
</h1>

<section>
	{#await promise}
		<p>did you know? 100% of people submitted.</p>
	{:then submissions}
		<p>did you know? 100% of people ({submissions}) submitted.</p>
	{:catch error}
		<p>did you know? you're not connected to the internet.</p>
	{/await}
</section>

<style>
	h1 {
		font-weight: 500;
	}
</style>
