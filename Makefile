# -----------------------------------------------------------------------------
# Author : Edouard Richard                                  <edou4rd@gmail.com>
# -----------------------------------------------------------------------------
# License : GNU General Public License
# -----------------------------------------------------------------------------
# This file is part of Serious-Toolkit.
# 
#     Serious-Toolkit is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
# 
#     Serious-Toolkit is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
# 
#     You should have received a copy of the GNU General Public License
#     along with Serious-Toolkit.  If not, see <http://www.gnu.org/licenses/>.

PROJECT_NAME = "Serious-Toolkit"
PYC          = $(wildcard *.pyc */*.pyc sources/*/*.pyc sources/*/*/*.pyc sources/*/*/*/*.pyc sources/*/*/*/*/*.pyc)
CACHE        = $(wildcard static/.webassets-cache static/gen)
WEBAPP       = $(wildcard webapp.py)
RM           = rm -fr
VENV         = `pwd`/.env
VIRTUALENV   = virtualenv
PIP          = pip
PYTHON       = python

run: clean
	. `pwd`/.env ; python $(WEBAPP)

clean:
	$(RM) $(PYC)
	$(RM) $(CACHE)

install:
	virtualenv venv --no-site-packages --distribute --prompt=$(PROJECT_NAME)
	. `pwd`/.env ; pip install -r requirements.txt
	. `pwd`/.env ; npm install

freeze: clean
	-rm build -r
	. `pwd`/.env ; python -c "from webapp import app; from flask_frozen import Freezer; freezer = Freezer(app); freezer.freeze()"
	-rm build/static/.webassets-cache/ -r
	sed -i 's/href="\//href="/g' build/*.html
	sed -i 's/src="\//src="/g' build/*.html

update_i18n:
	pybabel extract -F babel.cfg -o translations/messages.pot .
	pybabel update -i translations/messages.pot -d translations

compile_i18n:
	pybabel compile -d translations

# EOF
