from django.conf.urls import url, include
from django.contrib import admin
from .schema_document import schema_doc
from rest_framework.permissions import IsAuthenticated
from rest_framework.views import APIView
from rest_framework_swagger import renderers
from rest_framework.response import Response

admin.site.site_header = "Millionaire"
admin.site.site_title = "Admin"
admin.site.index_title = "Millionaire"


class SwaggerSchemaView(APIView):
    permission_classes = [IsAuthenticated]
    renderer_classes = [
        renderers.OpenAPIRenderer,
        renderers.SwaggerUIRenderer
    ]

    def get(self, request):
        return Response(schema_doc)


urlpatterns = [
    url(r'^adminsecret/', admin.site.urls),
    url(r'^docs/', SwaggerSchemaView.as_view()),
    url(r'^', include('appadmin.urls', namespace='appadmin')),
    url(r'^api/', include('game_statistics.api.urls', namespace='statistics_api')),
    url(r'^api/', include('game_api.urls', namespace='game_api')),
    url(r'^api/', include('game_updates.api.urls', namespace='game_updates')),
    url(r'^.*/', include('appadmin.urls')),
]
