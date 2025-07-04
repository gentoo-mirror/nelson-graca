# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11,12,13} )

inherit distutils-r1 git-r3

DESCRIPTION="Management utility to handle GPU switching for Optimus laptops"
HOMEPAGE="https://github.com/Askannz/optimus-manager"

EGIT_REPO_URI="${HOMEPAGE}"

LICENSE="MIT"
SLOT="0"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	$(python_gen_cond_dep '
		dev-python/dbus-python[${PYTHON_USEDEP}]
	')
	sys-apps/pciutils
	x11-apps/xrandr
	x11-apps/mesa-progs
"
RDEPEND="
	${DEPEND}
	"
BDEPEND="${PYTHON_DEPS}"

src_prepare() {
	sed -i "s#/sbin#/usr/bin#g" "${S}"/login_managers/sddm/20-"${PN}".conf || die
	sed -i "s#/sbin#/usr/bin#g" "${S}"/login_managers/lightdm/20-"${PN}".conf || die

	default
}
src_configure() {
	cat >> setup.cfg <<-EOF
	[options]
	optimize=1
	root="$D"
	EOF
}

python_install_all() {
	distutils-r1_python_install_all

	# config
	insinto /etc/${PN}
	doins config/*
	fperms 755 /etc/"${PN}"
	fperms 644 /etc/"${PN}"/optimus-manager.conf

	# login managers
	insinto /etc/sddm.conf.d
	doins login_managers/sddm/20-${PN}.conf
	insinto /etc/lightdm/lightdm.conf.d
	doins login_managers/lightdm/20-${PN}.conf

	#man
	doman optimus-manager.1

	# modules
	insinto /lib/modprobe.d
	doins modules/${PN}.conf

	#profile
	insinto /etc/profile.d
	doins profile.d/${PN}.sh

	# openrc
	doinitd ${FILESDIR}/optimus-manager.init

	# misc
	insinto /usr/share/${PN}
	doins ${PN}.conf

}

pkg_postinst() {
	echo
	elog "Default configuration can be found and /usr/share/${PN}.conf. Please do not edit it."
	elog "Use /etc/${PN}/${PN}.conf instead (if doesn't exist, create it)."
	elog
	elog "Also you can add options in /etc/${PN}/xorg-intel.conf and /etc/${PN}/xorg-nvidia.conf"
	elog "If you're using KDE Plasma or LXQt, you may require the optimus-manager-qt package."
	elog "If you're using Gnome, you can install the optimus-manager-argos Gnome Shell extension."
	ewarn "Only works with Xorg. Wayland is not supported yet."
	echo
	elog "If you are not using SDDM or LightDM, you need set it manually."
	elog "More info can be found at:"
	elog "https://github.com/Askannz/optimus-manager/wiki/FAQ,-common-issues,-troubleshooting#my-display-manager-is-not-sddm-lightdm-nor-sddm"
	echo
	ewarn "If you have installed bumblebee package, you need to disable the bumblebee daemon since both packages are trying to"
	ewarn "control the GPU power switching."
	echo
}

pkg_postrm() {
	elog "optimus-manager : cleaning up auto-generated Xorg conf"
	xorg_conf=/etc/X11/xorg.conf.d/10-optimus-manager.conf
	if [ -f "$xorg_conf" ]; then
	    rm $xorg_conf
	fi
}
