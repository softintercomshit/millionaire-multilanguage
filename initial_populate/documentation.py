import coreapi


populate_documentation = {
    'populate': coreapi.Link(
        url='/appadmin/populate/',
        action='get',
        description='Populate initial data from old db. Requires base auth as admin.',
        )}