<script lang="ts">
	import '../app.css';
</script>

<main>
	<slot />
</main>

<style>
	main {
		position: absolute;
		width: 400px;
		min-height: 500px;
		left: 50%;
		top: 50%;
		transform: translate(-50%, -50%);

		border: 1px solid black;
		padding: 24px;
		box-sizing: border-box;
		border-radius: 4px;
	}

	main > :global(*:first-child) {
		margin-top: 0;
	}
</style>