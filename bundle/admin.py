from django.contrib import admin
from .models import BundleModel


class BundleModelAdmin(admin.ModelAdmin):
    list_display = (
        'display_name',
        'db_version',
        'update_info',
        'identifier',
    )

admin.site.register(BundleModel, BundleModelAdmin)