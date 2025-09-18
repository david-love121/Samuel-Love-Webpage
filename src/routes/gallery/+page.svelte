<script>
	import GalleryCard from '../../lib/GalleryCard.svelte';

	export let data;
</script>

<main class="page-layout">
	<div class="page-container">
		<h1 class="page-title">Gallery</h1>
		<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
			{#each data.posts as post}
				<GalleryCard
					title={post.title}
					imageSrc={post.image}
					description={post.description}
				/>
			{/each}
		</div>
	</div>
</main>
