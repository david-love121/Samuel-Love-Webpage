import { artworks } from '$lib/artworks/data';

export const images = artworks.map((artwork) => ({
	src: artwork.image,
	caption: artwork.caption,
	aspectRatio: artwork.aspectRatio
}));
