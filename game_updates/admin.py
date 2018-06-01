from django.contrib import admin
from .models import InsertsHistory, RemovesHistory, UpdatesHistory


class UpdatesHistoryModelAdmin(admin.ModelAdmin):
    list_display = (
        'db_version',
        'question_model',
        'question_lang',
        'bundle',
    )


class RemovesHistoryModelAdmin(admin.ModelAdmin):
    list_display = (
        'db_version',
        'question_model_id',
        'question_lang_id',
        'parent_id',
        'bundle',
    )


class InsertsHistoryModelAdmin(admin.ModelAdmin):
    list_display = (
        'db_version',
        'question_model',
        'bundle',
    )

admin.site.register(UpdatesHistory, UpdatesHistoryModelAdmin)
admin.site.register(InsertsHistory, InsertsHistoryModelAdmin)
admin.site.register(RemovesHistory, RemovesHistoryModelAdmin)
