from rest_framework.generics import (
    RetrieveAPIView,
)
from rest_framework.permissions import (
    IsAdminUser,
)
from rest_framework.response import Response
from rest_framework.status import HTTP_200_OK

from initial_populate import Populate


class PopulateAPIView(RetrieveAPIView):
    permission_classes = (
        IsAdminUser,
    )

    def get(self, request, *args, **kwargs):
        populate_obj = Populate()
        populate_obj.populate_languages() # setp 1
        populate_obj.populate_difficulty_levels() # step 2
        populate_obj.populate_data() #step 3

        return Response('succes', HTTP_200_OK)