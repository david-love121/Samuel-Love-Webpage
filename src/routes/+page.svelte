<script lang="ts">
	import '../app.css';
	import Name from '$lib/Name.svelte';
	import CarouselCard from '$lib/CarouselCard.svelte';
	import { onMount } from 'svelte';
	import { browser } from '$app/environment';
	import { images } from '$lib/carouselImageData';
	let { children } = $props();
	
	let visibleWords = $state(0);
    let animationsDone = $state(false);
	let currentImageIndex = $state(0);
	const adjectives = ['PAINTER', 'VIDEOGRAPHER', 'LOOKER', 'THINKER', 'CONVERSATIONALIST'];
	const totalImages = images.length;

	function nextImage() {
		currentImageIndex = (currentImageIndex + 1) % totalImages;
	}

	function prevImage() {
		currentImageIndex = currentImageIndex === 0 ? totalImages - 1 : currentImageIndex - 1;
	}

	function goToImage(index: number) {
		currentImageIndex = index;
	}

	onMount(() => {
		// Start animation after a short delay
		const timer = setTimeout(() => {
			const interval = setInterval(() => {
				visibleWords++;
				if (visibleWords >= adjectives.length) {
					clearInterval(interval);
					// Set animationsDone to true after all words have appeared
					setTimeout(() => {
						animationsDone = true;
					}, 500); // Small delay after last word appears
				}
			}, 200); // 300ms delay between each word
		}, 800); // Initial delay before starting
        
		return () => clearTimeout(timer);
	});
</script>


	<div class="mx-auto">
		<div class="mx-auto max-w-4xl">
            <Name />
		</div>
		<!-- Animated subtitle -->
		<div class="flex justify-center items-center flex-wrap gap-2 my-8 font-light text-lg tracking-wider text-stone-400 ">
			{#each adjectives as adjective, index}
				<span 
					class="adjective opacity-0 translate-y-2 transition-all duration-500 ease-out"
					class:visible={index < visibleWords}
                    >
					{adjective}
				</span>
				{#if index < adjectives.length - 1}
					<span class="separator opacity-0 translate-y-2 transition-all duration-500 ease-out" class:visible={index < visibleWords}>-</span>
				{/if}
			{/each}
		</div>

    <div class="mx-auto text-lg opacity-0 transition-opacity duration-1000 ease-in-out" class:opacity-100={animationsDone}>
        
        <!-- Placeholder Carousel -->
        <div class="opacity-0 transition-opacity duration-1000 ease-in-out" class:opacity-100={animationsDone}>
            <div class="mx-auto">
                <h3 class="text-2xl font-light mb-6 text-center">Recent Works</h3>
                <div class="rounded-lg p-8 text-center">
                    <div class="relative flex justify-center items-center mb-6 h-[30vw] min-h-[200px]">
                        <button 
                            class="absolute left-[2rem] z-10 text-stone-400 hover:text-white transition-colors" 
                            aria-label="Previous image"
                            onclick={prevImage}
                        >
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/>
                            </svg>
                        </button>
                        
                        <!-- Carousel container -->
                        <div class="relative w-full mx-auto">
                            {#each images as image, index}
                                {@const offset = index - currentImageIndex}
                                {@const isCenter = offset === 0}
                                {@const isAdjacent = Math.abs(offset) === 1}
                                {@const isVisible = Math.abs(offset) <= 1}
                                
                                {#if isVisible}
                                    <div 
										class=" absolute top-1/2 left-1/2 transition-all duration-500 ease-in-out"
										style="
											transform: translate(-50%, -50%) translateX({offset * (browser && window?.innerWidth > 768 ? 50 : 30)}vw) scale({isCenter ? 1 : 0.7});
											opacity: {isCenter ? 1 : 0.4};
											z-index: {isCenter ? 1 : 0};
										"
									>
										<div class="max-w-4xl rounded flex items-center justify-center">
											<CarouselCard imagePath={image.src} caption={image.caption} aspectRatio={image.aspectRatio} />
										</div>
									</div>
                                {/if}
                            {/each}
                        </div>
                        
                        <button 
                            class="absolute right-[2rem] z-10 text-stone-400 hover:text-white transition-colors" 
                            aria-label="Next image"
                            onclick={nextImage}
                        >
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                            </svg>
                        </button>
                    </div>
                    <div class="relative flex justify-center space-x-2 mt-8 z-20">
                        {#each Array(totalImages) as _, index}
                            <button 
                                class="w-2 h-2 rounded-full transition-colors z-25"
                                class:bg-white={index === currentImageIndex}
                                class:bg-stone-500={index !== currentImageIndex}
                                onclick={() => goToImage(index)}
                                aria-label="Go to image {index + 1}"
                            ></button>
                        {/each}
                    </div>
                </div>
            </div>

        </div>
        <p class="indent-8 mx-32">Sam Love is a painter with too many hobbies. Growing up in depressed middle America, he tried his hand at anything hoping it would make life click. Feeling surrounded by sheer nothingness, Love struggled to make something worth his efforts. he had began drawing before he could remember, and playing piano soon after. It wasn’t until his junior year of high school he decided creating art was all he wanted to do. This resolution was guided by Sartre’s Being and Nothingness. “Man presents himself at least in this instance as a being who causes nothingness to arise in the world, inasmuch as he himself is affected with non-being to this end.”
        Surrounded by nothingness, Love found solace in being-in-itself. While objects may generate nothingess, they serve as empty containers for significance. Practicing active living, ritual, meditation, and consistent creative pursuit, Love carves meaning out of life. He explores ritual and significance in the face of mundanity. Through dream-like scenes, dimly lit streets, fields in places unknown, Love mythicizes the ordinary we all experience. He walks along the lines between reality and fantasy. All lines converge, nothing leads to everything.</p>
        
        <div class="text-right mt-4 mr-8">
            <span class="italic font-light">-Abby Sullivan, Dear Roommate</span>
        </div>
	</div>
    </div>


<style>
	.adjective.visible,
	.separator.visible {
		opacity: 1;
		transform: translateY(0);
	}
</style>
