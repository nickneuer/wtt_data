import dlt
from dlt.sources.helpers.rest_client import RESTClient
from dlt.sources.helpers.rest_client.paginators import OffsetPaginator

# limit: The maximum number of items to retrieve in each request.
# offset: The initial offset for the first request. Defaults to 0.
# offset_param: The name of the query parameter used to specify the offset. Defaults to "offset".
# limit_param: The name of the query parameter used to specify the limit. Defaults to "limit".
# total_path: A JSONPath expression for the total number of items. If not provided, pagination is controlled by maximum_offset and stop_after_empty_page.
# maximum_offset: Optional maximum offset value. Limits pagination even without a total count.
# stop_after_empty_page: Whether pagination should stop when a page contains no result items. Defaults to True.

# Initialize the REST client with the base URL
wtt_client = RESTClient(
    base_url="https://wttcmsapigateway-new.azure-api.net/ttu",
    paginator=OffsetPaginator(
        limit=10,
        offset=1,
        offset_param="Page",
        limit_param="Limit",
        maximum_offset=100,
        total_path=None
    ),
    data_selector="Result"
)

@dlt.resource(name="wtt_events_source", write_disposition="append")
def wtt_events():

    # Use paginate to handle offset-based pagination
    for page_data in wtt_client.paginate(
        "/Events/GetEvents",
        method="GET"
    ):
        print("page", page_data)
        for result in page_data:
            yield result


@dlt.source(name="wtt_source")
def wtt_source():
    return wtt_events()
