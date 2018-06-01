import coreapi
import coreschema

game_api_documentation = {
    'difficulties': coreapi.Link(
        url='/api/difficulties/',
        action='get',
        description='Get all difficulties.',
    ),
    'languages': coreapi.Link(
        url='/api/languages/',
        action='get',
        description='Get all languages.',
    ),
    'bundle': coreapi.Link(
        url='/api/bundle/{identifier}/',
        action='get',
        description='Get bundle info by identifier.',
        fields=[
            coreapi.Field(
                name='identifier',
                required=True,
                location='path',
                schema=coreschema.String(description='bundle identifier')
            ),
        ],
    ),
    'questions': coreapi.Link(
        url='/api/questions/',
        action='get',
        description='Get all questions models.',
    ),
    'questionslang': coreapi.Link(
        url='/api/questions/langs/',
        action='get',
        description='Get all questions with languages models.',
    ),
}
