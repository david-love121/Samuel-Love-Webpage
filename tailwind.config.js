/** @type {import('tailwindcss').Config} */
export default {
	content: ['./src/**/*.{html,js,svelte,ts}'],
	darkMode: 'class', // Enable class-based dark mode
	theme: {
		extend: {
			fontFamily: {
				'sans': ['Noto Sans', 'sans-serif'],
			}
		}
	},
	plugins: []
};
