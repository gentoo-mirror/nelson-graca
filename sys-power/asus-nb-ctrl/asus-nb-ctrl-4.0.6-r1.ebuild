# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION=""
HOMEPAGE="https://gitlab.com/asus-linux/asusctl"
SRC_URI="https://gitlab.com/asus-linux/asusctl"

EGIT_REPO_URI="https://gitlab.com/asus-linux/asusctl.git"
EGIT_COMMIT="${PV}"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="network-sandbox"
IUSE=""

DEPEND="dev-lang/rust"
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
	default
	newinitd "${FILESDIR}"/asusd-v2.initd asusd
}

