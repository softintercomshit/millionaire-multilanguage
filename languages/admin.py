from django.contrib import admin
from .models import Language


class LanguageModelAdmin(admin.ModelAdmin):
    list_display = (
        'lang_code',
        'name',
    )


admin.site.register(Language, LanguageModelAdmin)