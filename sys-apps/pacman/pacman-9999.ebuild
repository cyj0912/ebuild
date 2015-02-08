# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit autotools autotools-utils eutils git-r3

DESCRIPTION="Archlinux's binary package manager"
HOMEPAGE="http://archlinux.org/pacman/"
EGIT_REPO_URI="git://projects.archlinux.org/pacman.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="curl debug doc gpg test"

COMMON_DEPEND="app-arch/libarchive
	dev-libs/openssl
	virtual/libiconv
	virtual/libintl
	sys-devel/gettext
	curl? ( net-misc/curl )
	gpg? ( app-crypt/gpgme )"
RDEPEND="${COMMON_DEPEND}
	app-arch/xz-utils"
# autoconf macros from gpgme requied unconditionally
# makepkg collision with old bash-completion
DEPEND="${COMMON_DEPEND}
	app-crypt/gpgme
	doc? ( app-doc/doxygen
		app-text/asciidoc )
	test? ( dev-lang/python )"

RESTRICT="test"

src_configure() {
	local myeconfargs=(
		--localstatedir=/var
		--disable-git-version
		--with-openssl
		# Help protect user from shooting his/her Gentoo installation in
		# its foot.
		--with-root-dir="${EPREFIX}"/var/chroot/archlinux
		$(use_enable debug)
		$(use_enable doc)
		$(use_enable doc doxygen)
		$(use_with curl libcurl)
		$(use_with gpg gpgme)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	dodir /etc/pacman.d
}

pkg_postinst() {
	einfo "Please see http://ohnopub.net/~ohnobinki/gentoo/arch/ for information"
	einfo "about setting up an archlinux chroot."
}
