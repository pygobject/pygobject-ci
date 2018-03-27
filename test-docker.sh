#!/bin/bash

set -e

python --version

python -m pip install virtualenv
python -m virtualenv --python=python /tmp/venv
source /tmp/venv/bin/activate

python -m pip install git+https://github.com/pygobject/pycairo.git
python -m pip install flake8 pytest

export PKG_CONFIG_PATH=/tmp/venv/lib/pkgconfig
export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$((${RANDOM} % 255 + 1))
PYVER=$(python -c "import sys; sys.stdout.write(str(sys.version_info[0]))")

for branch in master;
do
    git clone -b "${branch}" --depth 1 https://gitlab.gnome.org/GNOME/pygobject.git "${branch}"
    cd "${branch}"

    xvfb-run -a python setup.py test
    LANG=C xvfb-run -a python setup.py test
    python -m flake8

    if [[ "${PYVER}" == "2" ]]; then
        python -m pip install sphinx sphinx_rtd_theme
        python -m sphinx -W -a -E -b html -n docs docs/_build
    fi;

    cd ..
done
