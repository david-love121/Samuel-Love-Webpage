<script lang="ts">
	import { onMount, onDestroy } from 'svelte';
	import { browser } from '$app/environment';

	export let title: string;
	export let imageSrc: string;
	export let description: string;

	let modalOpen = false;

	function openModal() {
		modalOpen = true;
	}

	function closeModal() {
		modalOpen = false;
	}

	function handleKeydown(event: KeyboardEvent) {
		if (event.key === 'Enter' || event.key === ' ') {
			event.preventDefault();
			openModal();
		}
	}

	function handleModalKeydown(event: KeyboardEvent) {
		if (event.key === 'Escape') {
			closeModal();
		}
	}

	onMount(() => {
		if (browser) {
			window.addEventListener('keydown', handleModalKeydown);
		}
	});

	onDestroy(() => {
		if (browser) {
			window.removeEventListener('keydown', handleModalKeydown);
		}
	});
</script>

<button
	class="group text-left"
	on:click={openModal}
	aria-haspopup="dialog"
>
	<figure
		class="relative w-full h-64 overflow-hidden rounded-lg shadow-lg transition-transform duration-300 ease-in-out group-hover:scale-105"
	>
		<img src={imageSrc} alt={title} class="w-full h-full object-cover" />
		<figcaption
			class="absolute bottom-0 left-0 w-full p-4 bg-black text-stone-300 text-lg font-bold transition-opacity duration-300 ease-in-out opacity-0 group-hover:opacity-100"
		>
			{title}
		</figcaption>
	</figure>
</button>

{#if modalOpen}
	<div
		class="fixed inset-0 z-50 flex items-center justify-center bg-black/50"
		on:click={closeModal}
		role="dialog"
		aria-modal="true"
		aria-labelledby="modal-title"
		tabindex="-1"
		on:keydown={handleModalKeydown}
	>
		<!-- svelte-ignore a11y_click_events_have_key_events -->
		<!-- svelte-ignore a11y_no_noninteractive_element_interactions -->
		<div
			class="relative bg-white rounded-lg shadow-xl max-w-3xl w-full m-4"
			on:click|stopPropagation
			role="document"
		>
			<img src={imageSrc} alt={title} class="w-full h-auto object-contain rounded-t-lg max-h-[80vh]" />
			<div class="p-6">
				<h2 id="modal-title" class="text-2xl font-bold mb-2 text-gray-800">{title}</h2>
				<p class="text-gray-600 whitespace-pre-wrap">{description}</p>
			</div>
			<button
				class="absolute top-2 right-2 text-gray-600 hover:text-gray-900"
				on:click={closeModal}
				aria-label="Close modal"
			>
				<svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
					<path
						stroke-linecap="round"
						stroke-linejoin="round"
						stroke-width="2"
						d="M6 18L18 6M6 6l12 12"
					/>
				</svg>
			</button>
		</div>
	</div>
{/if}
