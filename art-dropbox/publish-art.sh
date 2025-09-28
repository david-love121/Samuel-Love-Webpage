#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
IMAGES_DIR="$SCRIPT_DIR/images"
STATIC_IMAGES_DIR="$REPO_ROOT/static/gallery_images"
ARTWORKS_DIR="$REPO_ROOT/src/lib/artworks"

if ! command -v git >/dev/null 2>&1; then
	echo "❌ git is required but not installed."
	exit 1
fi

mkdir -p "$IMAGES_DIR" "$STATIC_IMAGES_DIR" "$ARTWORKS_DIR"

mapfile -t IMAGE_FILES < <(find "$IMAGES_DIR" -maxdepth 1 -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' -o -iname '*.gif' \) | sort)

if [[ ${#IMAGE_FILES[@]} -eq 0 ]]; then
	cat <<EOF
No images found in "$IMAGES_DIR".

Add image files to that folder, then run this script again.
EOF
	exit 1
fi

echo "📁 Images found in $IMAGES_DIR"
for i in "${!IMAGE_FILES[@]}"; do
	printf ' [%d] %s\n' "$((i + 1))" "$(basename "${IMAGE_FILES[$i]}")"
done

while true; do
	read -r -p "Select the image to publish by number: " selection
	if [[ ! $selection =~ ^[0-9]+$ ]]; then
		echo "Please enter a valid number."
		continue
	fi

	index=$((selection - 1))
	if (( index < 0 || index >= ${#IMAGE_FILES[@]} )); then
		echo "Selection out of range."
		continue
	fi
	break
done

IMAGE_PATH="${IMAGE_FILES[$index]}"
IMAGE_BASENAME="$(basename "$IMAGE_PATH")"
IMAGE_EXT="${IMAGE_BASENAME##*.}"
IMAGE_EXT_LOWER="$(echo "$IMAGE_EXT" | tr '[:upper:]' '[:lower:]')"

escape_yaml_string() {
	printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

echo
read -r -p "Title (e.g. 'Sunset in Red'): " TITLE
while [[ -z "$TITLE" ]]; do
	echo "Title cannot be empty."
	read -r -p "Title: " TITLE
done

DEFAULT_SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')
read -r -p "Slug [$DEFAULT_SLUG]: " SLUG_INPUT
SLUG=${SLUG_INPUT:-$DEFAULT_SLUG}
while [[ -z "$SLUG" ]]; do
	echo "Slug cannot be empty."
	read -r -p "Slug: " SLUG
done

ARTWORK_FILE="$ARTWORKS_DIR/$SLUG.md"
if [[ -e "$ARTWORK_FILE" ]]; then
	read -r -p "Artwork markdown '$SLUG.md' already exists. Overwrite? (y/N): " overwrite
	case "${overwrite,,}" in
		y|yes) ;;
		*)
			echo "Aborting to avoid overwriting existing artwork."
			exit 1
			;;
	esac
fi

read -r -p "Caption [default: Title]: " CAPTION
CAPTION=${CAPTION:-$TITLE}

echo "Enter description (finish with an empty line):"
DESCRIPTION_RAW=""
while IFS= read -r line; do
	[[ -z "$line" ]] && break
	DESCRIPTION_RAW+="$line"$'\n'
done

while [[ -z "$DESCRIPTION_RAW" ]]; do
	echo "Description cannot be empty."
	echo "Enter description (finish with an empty line):"
	while IFS= read -r line; do
		[[ -z "$line" ]] && break
		DESCRIPTION_RAW+="$line"$'\n'
	done
done

DESCRIPTION_BLOCK=$(printf '%s' "$DESCRIPTION_RAW" | tr -d $'\r' | sed 's/^/  /')
DESCRIPTION_BLOCK=${DESCRIPTION_BLOCK%\n}

read -r -p "Display on home carousel? (y/N): " DISPLAY_INPUT
case "${DISPLAY_INPUT,,}" in
	y|yes) DISPLAY_CAROUSEL=true ;;
	*) DISPLAY_CAROUSEL=false ;;
esac

DEST_FILENAME="$SLUG.${IMAGE_EXT_LOWER}"
DEST_IMAGE_PATH="$STATIC_IMAGES_DIR/$DEST_FILENAME"

if [[ -e "$DEST_IMAGE_PATH" ]]; then
	read -r -p "Image '$DEST_FILENAME' already exists in gallery. Overwrite? (y/N): " overwrite
	case "${overwrite,,}" in
		y|yes) ;;
		*)
			echo "Aborting to avoid overwriting existing image."
			exit 1
			;;
	esac
fi

echo "Moving image to static/gallery_images/$DEST_FILENAME"
mv "$IMAGE_PATH" "$DEST_IMAGE_PATH"

TITLE_ESC=$(escape_yaml_string "$TITLE")
CAPTION_ESC=$(escape_yaml_string "$CAPTION")

cat <<EOF > "$ARTWORK_FILE"
---
title: "$TITLE_ESC"
image: "/gallery_images/$DEST_FILENAME"
caption: "$CAPTION_ESC"
description: |-
$DESCRIPTION_BLOCK
displayCarousel: $DISPLAY_CAROUSEL
---
EOF

echo "Created $ARTWORK_FILE"

cd "$REPO_ROOT"
git add "$ARTWORK_FILE" "static/gallery_images/$DEST_FILENAME"

git status --short

read -r -p "Commit these changes now? (y/N): " COMMIT_INPUT
if [[ "${COMMIT_INPUT,,}" =~ ^(y|yes)$ ]]; then
	DEFAULT_MESSAGE="Add artwork $TITLE"
	read -r -p "Commit message [$DEFAULT_MESSAGE]: " COMMIT_MESSAGE
	COMMIT_MESSAGE=${COMMIT_MESSAGE:-$DEFAULT_MESSAGE}
	git commit -m "$COMMIT_MESSAGE"

	read -r -p "Push to origin main? (y/N): " PUSH_INPUT
	if [[ "${PUSH_INPUT,,}" =~ ^(y|yes)$ ]]; then
		git push origin main
	else
		echo "Skipping push."
	fi
else
	echo "Skipping commit. Changes are staged."
fi

echo "✅ Artwork publishing process complete."
