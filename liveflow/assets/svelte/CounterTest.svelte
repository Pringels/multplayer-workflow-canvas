<script>
	let {counter = 0, live} = $props()
	function increase() {
        live.pushEvent("increment", {number: counter + 1})
    }
</script>

<button onclick={increase}>clicks: {counter}</button>
<h1>test!</h1>

<style>
	button {
		font-size: 2em;
	}
</style>