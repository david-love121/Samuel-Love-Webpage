import { base } from '$app/paths';

interface ArtworkModule {
	metadata: {
		title: string;
		image: string;
		description: string;
	};
	// eslint-disable-next-line @typescript-eslint/no-explicit-any
	[key: string]: any;
}

/** @type {import('./$types').PageLoad} */
export function load() {
	const modules = import.meta.glob('/src/lib/artworks/*.md', { eager: true });

	const posts = Object.values(modules).map((module) => {
		const artworkModule = module as ArtworkModule;
		const { metadata } = artworkModule;
		return {
			...metadata,
			// Ensure the image path is relative to the base path
			image: `${base}${metadata.image}`
		};
	});

	return {
		posts
	};
}
