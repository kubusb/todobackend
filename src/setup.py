from setuptools import setup, find_packages

setup (
  name                  = "todobackend",
  version               = "0.1.0",
  description           = "Todobackend Django REST service",
  packages              = find_packages(),
  include_package_data  = True,
  scripts               = [ "manage.py" ],
  install_requires      = [ "Django==3.2.25",
                            "django-cors-headers==1.1.0",
                            "djangorestframework==3.11.2",
                            "MySQL-python==1.2.5",
                            "uwsgi==2.0.22" ],
  extras_require        = {
                            "test": [
                                "colorama==0.4.4",
                                "coverage==5.3",
                                "django-nose==1.4.7",
                                "nose==1.3.7",
                                "pinocchio==0.4.2"
                            ]
                        }
)
