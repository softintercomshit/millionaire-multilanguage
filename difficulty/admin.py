from django.contrib import admin
from .models import Difficulty


class DifficultyModelAdmin(admin.ModelAdmin):
    list_display = (
        'level',
        'remuneration',
    )


admin.site.register(Difficulty, DifficultyModelAdmin)
