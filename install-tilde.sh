#!/bin/bash

TILDE_DIR="$HOME/.tilde"
if ! which git > /dev/null; then
	echo "Git's required to bootstrap tilde"
	exit 2
fi

if ! git clone "git@github.com:rcs/tilde.git" "$TILDE_DIR"; then
	git clone "git://github.com/rcs/tilde.git" "$TILDE_DIR"
fi

$TILDE_DIR/bin/tilde init

echo "Tilde initialized. Add $TILDE_DIR/bin to your path."
echo "($ echo 'export PATH=\"\$HOME/.tilde/bin:\$PATH\"' >> .bash_profile )"
