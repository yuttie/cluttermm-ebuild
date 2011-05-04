# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
GCONF_DEBUG="no"

inherit gnome2 git-2 eutils

DESCRIPTION="C++ bindings for Clutter"
HOMEPAGE="http://wiki.clutter-project.org/wiki/Cluttermm"

SRC_URI=""
EGIT_REPO_URI="
	git://git.gnome.org/${PN}
	http://git.gnome.org/browse/${PN}"
EGIT_BOOTSTRAP="env NOCONFIGURE=true ${S}/autogen.sh"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="doc examples test"

RDEPEND="
	>=media-libs/clutter-1.3.8
	>=dev-cpp/pangomm-2.27.1
	>=dev-cpp/atkmm-2.22.2"
DEPEND="${RDEPEND}
	sys-devel/autoconf
	dev-cpp/mm-common
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )"

src_prepare() {
	DOCS="AUTHORS ChangeLog NEWS README TODO"
	G2CONF="${G2CONF}
		--enable-maintainer-mode
		$(use_enable doc documentation)"

	gnome2_src_prepare

	if ! use test; then
		# don't waste time building tests
		sed 's/^\(SUBDIRS =.*\)tests\(.*\)$/\1\2/' -i Makefile.am Makefile.in \
			|| die "sed 1 failed"
	fi

	if ! use examples; then
		# don't waste time building examples
		sed 's/^\(SUBDIRS =.*\)examples\(.*\)$/\1\2/' -i Makefile.am Makefile.in \
			|| die "sed 2 failed"
	fi
}

src_test() {
	cd "${S}/tests/"
	emake check || die "emake check failed"

	for i in *.cc; do
		${i%.cc} || die "Running tests failed at ${i}"
	done
}

src_install() {
	gnome2_src_install

	# Remove useless .la files
	find "${D}" -name '*.la' -exec rm -f {} + || die
}
