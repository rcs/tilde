#!/bin/bash

TILDE_DIR="$HOME/.tilde"
if ! which git > /dev/null; then
	echo "Git's required to bootstrap tilde"
	exit 2
fi

dl_gh_tarball () {
	local path; path="$1"
	local repo; repo="$2"
	TARBALL=$(mktemp -t tilde.XXXXXXX)
	if which curl >/dev/null; then
		curl -o "$TARBALL" -L "https://github.com/$path/tarball/master"
	elif which wget >/dev/null; then
		wget "https://github.com/$path/tarball/master" -O "$TARBALL"
	else
		echo "You need wget or curl to download tarballs"
		exit 2
	fi
	
	EXTRACT_DIR=$(mktemp -d -t tilde.XXXXXXX)
	tar -xzf $TARBALL -C "$EXTRACT_DIR"
	mv "$EXTRACT_DIR/$(tar -tf $TARBALL | sed -e 's@/.*@@' | uniq | head -n1)" "$repo"
}   
gh_rw_or_tarball_checkout () {
	local path; path="$1"
	local repo; repo="$2"
	if which git >/dev/null; then
	if ! git clone "git@github.com:${path}.git" "$repo"; then
		git clone "git://github.com/${path}.git" "$repo"
	fi
	else
		dl_gh_tarball "$path" "$repo"
	fi
}

gh_rw_or_tarball_checkout "rcs/tilde" "$TILDE_DIR"

$TILDE_DIR/bin/tilde init

echo "Tilde initialized. Add $TILDE_DIR/bin to your path."
echo "($ echo 'export PATH=\"\$HOME/.tilde/bin:\$PATH\"' >> .bash_profile )"
