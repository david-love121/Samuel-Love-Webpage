### Art Dropbox
This directory is where you can upload new works and add them to the site. The flow is:

1. Drop the original image file into the `images/` folder in this directory.
2. From WSL2 or any Linux/macOS terminal, run the script:
	```bash
	./publish-art.sh
	```
	> If the script is not executable yet, run `chmod +x publish-art.sh` once and try again.

The script will prompt you for some variables about the file and use defaults if nothing is inputted. 
Title: the title to be displayed 
Slug: a unique identifer for the backend, filename
Caption: a caption displayed underneath the image before it's focused
Description: a longer description of the work
Display Carousel: yes/no if you want this image on the carousel, or only on the gallery page
The script guides you through everything else:

- **Image selection** – it lists the files in `images/` and lets you pick which one to publish.
- **Artwork details** – answer prompts for the title, slug (auto-suggested from the title), caption, and a multi-line description. You’ll also choose whether the piece should appear in the home page carousel (`displayCarousel`).
- **File management** – the script renames/moves the selected image into `static/gallery_images/` (using the slug) and creates a matching Markdown file in `src/lib/artworks/` with all of the frontmatter filled out.
- **Git automation** – changes are staged automatically. You can then let the script commit them (it will suggest a message) and optionally push straight to `origin/main`.

When you want to preview the site before pushing, go to the project root and run:
```bash
npm run dev
```
This starts the local development server so you can confirm the new artwork looks correct. 