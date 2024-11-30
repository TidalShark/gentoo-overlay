# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

DESCRIPTION="Qt library to start applications only once per user"
HOMEPAGE="https://code.qt.io/cgit/qt-solutions/qt-solutions.git/"
SRC_URI="https://github.com/qtproject/qt-solutions/archive/777e95ba69952f11eaec0adfb0cb987fabcdecb3.tar.gz"
S="${WORKDIR}/qt-solutions-777e95ba69952f11eaec0adfb0cb987fabcdecb3/qtsingleapplication"

LICENSE="|| ( LGPL-2.1 GPL-3 )"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv x86"
IUSE="doc X"

src_prepare() {
	default

	echo 'SOLUTIONS_LIBRARY = yes' > config.pri
	use X || echo 'QTSA_NO_GUI = yes' >> config.pri

	sed -i -e "s/-head/-${PV%.*}/" common.pri || die
	sed -i -e '/SUBDIRS+=examples/d' ${PN}.pro || die

	# to ensure unbundling
	# rm src/qtlockedfile* || die
}

src_configure() {
	eqmake6
}

src_install() {
	use doc && local HTML_DOCS=( doc/html/. )
	einstalldocs

	# libraries
	dolib.so lib/*

	# headers
	insinto "$(qt6_get_headerdir)"/QtSolutions
	doins src/qtsinglecoreapplication.h
	use X && doins src/{QtSingleApplication,${PN}.h}

	# .prf files
	insinto "$(qt6_get_mkspecsdir)"/features
	doins "${FILESDIR}"/qtsinglecoreapplication.prf
	use X && doins "${FILESDIR}"/${PN}.prf
}
