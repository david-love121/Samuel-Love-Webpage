import type { PageLoad } from './$types';
import { getArtworks } from '$lib/artworks/data';

export const load: PageLoad = () => ({
	posts: getArtworks()
});
