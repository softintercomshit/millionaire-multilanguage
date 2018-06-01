import coreapi
import coreschema

game_updates_documentation = {
    'getinserts': coreapi.Link(
        url='/api/getinserts/{db_version}/{bundle}/',
        action='get',
        description='Get inserts fields changes.',
        fields=[
            coreapi.Field(
                name='db_version',
                required=True,
                location='path',
                schema=coreschema.String(description='iOS db version')
            ),
            coreapi.Field(
                name='bundle',
                required=True,
                location='path',
                schema=coreschema.String(description='bundle identifier')
            ),
        ]
    ),
    'getupdates': coreapi.Link(
        url='/api/getupdates/{db_version}/{bundle}/',
        action='get',
        description='Get updates fields changes.',
        fields=[
            coreapi.Field(
                name='db_version',
                required=True,
                location='path',
                schema=coreschema.String(description='iOS db version')
            ),
            coreapi.Field(
                name='bundle',
                required=True,
                location='path',
                schema=coreschema.String(description='bundle identifier')
            ),
        ]
    ),
    'getremoves': coreapi.Link(
        url='/api/getremoves/{db_version}/{bundle}/',
        action='get',
        description='Get removes fields changes.',
        fields=[
            coreapi.Field(
                name='db_version',
                required=True,
                location='path',
                schema=coreschema.String(description='iOS db version')
            ),
            coreapi.Field(
                name='bundle',
                required=True,
                location='path',
                schema=coreschema.String(description='bundle identifier')
            ),
        ]
    ),
}
