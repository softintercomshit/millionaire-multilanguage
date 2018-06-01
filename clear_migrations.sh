#!/usr/bin/env bash

rm -f db.sqlite3

find . -path "*/migrations/*.py" -not -name "__init__.py" -delete
find . -path "*/migrations/*.pyc"  -delete
echo "delete migrations done..."

echo "makemigrations..."
python3 manage.py makemigrations

echo "migrate..."
python3 manage.py migrate

echo "creating super user..."
echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'ivan.postolaki@gmail.com', 'password123')" | python manage.py shell