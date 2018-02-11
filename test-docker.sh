#!/bin/bash

set -e

virtualenv --python="${PYTHON}" /tmp/venv
source /tmp/venv/bin/activate

pip install git+https://github.com/pygobject/pycairo.git
pip install flake8 pytest

export PKG_CONFIG_PATH=/tmp/venv/lib/pkgconfig
export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$((${RANDOM} % 255 + 1))
PYVER=$(python -c "import sys; sys.stdout.write(str(sys.version_info[0]))")

for repo in pygobject-master pygobject-3-26;
do
    cd "${repo}"

    ./autogen.sh --with-python=python
    make -j8
    xvfb-run -a make check
    if [[ "${repo}" == "pygobject-master" ]]; then
        LANG=C xvfb-run -a make check
    fi;
    make check.quality

    if [[ "${PYVER}" == "2" ]] && [[ "${repo}" == "pygobject-master" ]]; then
        python -m pip install sphinx sphinx_rtd_theme
        python -m sphinx -W -a -E -b html -n docs docs/_build
    fi;

    cd ..
done
