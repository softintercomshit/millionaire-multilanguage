from django.contrib import admin
from .models import StatisticsModel, BugTypeModel, BugReportsModel


class StatisticsModelAdmin(admin.ModelAdmin):
    list_display = (
        'question',
        'difficulty',
        'answer',
        'game_play_id',
        'datetime',
    )


admin.site.register(StatisticsModel, StatisticsModelAdmin)


class BugTypeModelAdmin(admin.ModelAdmin):
    list_display = (
        'type',
    )


admin.site.register(BugTypeModel, BugTypeModelAdmin)


class BugReportsModelAdmin(admin.ModelAdmin):
    list_display = (
        'question',
        'bug_type',
        'device_token',
    )


admin.site.register(BugReportsModel, BugReportsModelAdmin)
