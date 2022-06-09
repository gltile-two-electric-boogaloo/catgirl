<script context="module" lang="ts">
	import {browser} from "$app/env";
	import {grecaptcha_sitekey, base_url} from "../lib/env";
	import {load} from "recaptcha-v3";

	export const hydrate = true;
	export const router = browser;
	export const prerender = true;
</script>

<script lang="ts">
	async function submit() {
		// Submit.

		console.log("Hi!")

		const recaptcha = await load(grecaptcha_sitekey);
		const token = await recaptcha.execute("submit")

		fetch(`${base_url}/submit`, {
			method: 'POST',
			mode: 'cors',
			cache: 'no-cache',

			headers: {
				'Content-Type': 'application/json'
			},

			redirect: 'error',

			body: JSON.stringify({"token": token})
		}).then(response => {
			if (response.ok) {
				setTimeout(function() {
					window.location.href = '/voted'
				}, 50)
			}
		})
	}
</script>

<h1>
	catgirl?
</h1>

<section>
	<input type="radio" id="yes" name="catgirl" value="yes" checked>
	<label for="yes">Yes</label>
	<br>
	<input type="radio" id="no" name="catgirl" value="no" disabled>
	<label for="no">No</label>
	<br>
	<br>
	<button on:click|trusted={submit}>submit</button>
	<br>
	<br>
	<small class="recaptcha">This site is protected by reCAPTCHA and the Google
			<a href="https://policies.google.com/privacy">Privacy Policy</a> and
			<a href="https://policies.google.com/terms">Terms of Service</a> apply.</small>
</section>

<style>
	h1 {
		font-weight: 500;
	}

	:global(.grecaptcha-badge) {
		visibility: hidden;
	}

	.recaptcha, .recaptcha > a:visited, .recaptcha > * {
		color: grey;
	}
</style>
