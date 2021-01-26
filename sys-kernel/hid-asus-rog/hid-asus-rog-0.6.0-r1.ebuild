# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 linux-mod toolchain-funcs

DESCRIPTION=""
HOMEPAGE="https://gitlab.com/asus-linux/hid-asus-rog"
SRC_URI="https://gitlab.com/asus-linux/hid-asus-rog"

EGIT_REPO_URI="https://gitlab.com/asus-linux/hid-asus-rog.git"
EGIT_COMMIT="${PV}"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

MODULE_NAMES="hid-asus-rog(misc:${S}:src)"
BUILD_TARGETS="all"

pkg_setup() {
	linux-mod_pkg_setup
}

src_prepare() {
	default
	eapply "${FILESDIR}/kernel-fix.patch"
}

src_compile() {
	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install
	insinto /etc/modprobe.d
	newins "${FILESDIR}"/asus-rog.conf asus-rog.conf

}
