import adapter from '@sveltejs/adapter-static';
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';
import { mdsvex } from 'mdsvex';

const dev = process.argv.includes('dev');
const base = process.env.BASE_PATH || '/Samuel-Love-Webpage';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	extensions: ['.svelte', '.md'],
	// Consult https://svelte.dev/docs/kit/integrations
	// for more information about preprocessors
	preprocess: [vitePreprocess(), mdsvex({ extensions: ['.md'] })],

	kit: {
		adapter: adapter({
			pages: 'build',
			assets: 'build',
			fallback: undefined,
			precompress: false,
			strict: true
		}),
		paths: {
			base: dev ? '' : base
		},
		prerender: {
			handleHttpError: ({ path, referrer, message }) => {
				// Ignore 404s for paths that don't start with base during prerendering
				if (message.includes('does not begin with `base`')) {
					return;
				}
				throw new Error(message);
			}
		}
	}
};

export default config;
