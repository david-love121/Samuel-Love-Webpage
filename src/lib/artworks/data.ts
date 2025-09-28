import { base } from '$app/paths';

export interface ArtworkMetadata {
	title: string;
	image: string;
	description: string;
	caption?: string;
	aspectRatio?: number;
	displayCarousel?: boolean;
}

interface ArtworkModule {
	metadata: ArtworkMetadata;
	// eslint-disable-next-line @typescript-eslint/no-explicit-any
	[key: string]: any;
}

export interface Artwork {
	slug: string;
	title: string;
	description: string;
	caption: string;
	image: string;
	aspectRatio: number;
	displayCarousel: boolean;
}

const normalizeImagePath = (imagePath: string): string => {
	if (/^(?:https?:)?\/\//.test(imagePath)) {
		return imagePath;
	}

	const normalized = imagePath.startsWith('/') ? imagePath : `/${imagePath}`;

	return `${base}${normalized}`;
};

const modules = import.meta.glob<ArtworkModule>('./*.md', { eager: true });

const allArtworks: Artwork[] = Object.entries(modules).map(([path, module]) => {
	const { metadata } = module;
	const slug = path.split('/').pop()?.replace(/\.md$/, '') ?? path;

	return {
		slug,
		title: metadata.title,
		description: metadata.description,
		caption: metadata.caption ?? metadata.title,
		image: normalizeImagePath(metadata.image),
		aspectRatio: metadata.aspectRatio ?? 4 / 3,
		displayCarousel: metadata.displayCarousel ?? false
	};
});

export const artworks: Artwork[] = allArtworks;

export const getArtworks = (): Artwork[] => artworks;
