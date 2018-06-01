#!/usr/bin/env bash
echo "initial populate..."
echo "from initial_populate.populate import Populate; Populate().populate_languages(); Populate().populate_difficulty_levels(); Populate().populate_data();" | python manage.py shell