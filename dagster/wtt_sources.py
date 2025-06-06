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
def make_wtt_client():
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
    return wtt_client


@dlt.resource(name="wtt_events", write_disposition="append")
def wtt_events():
    client = make_wtt_client()
    for page_data in client.paginate("/Events/GetEvents", method="GET"):
        for result in page_data:

            yield result

# see docs https://dlthub.com/docs/general-usage/resource#process-resources-with-dlttransformer 
@dlt.transformer(data_from=wtt_events, name="wtt_matches")
def wtt_matches(event_item):
    client = make_wtt_client()
    event_id = event_item["EventId"]
    payload = {"EventId": event_id}
    r = client.get("/Matches/GetMatches", params=payload)
    match_resp = r.json()
    for match in match_resp["Result"]:
        yield match


@dlt.resource(name="wtt_players", write_disposition="append")
def wtt_players():
    client = make_wtt_client()
    for page_data in client.paginate("/Players/GetPlayers", method="GET"):
        for result in page_data:
            yield result

@dlt.source(name="wtt_source")
def wtt_source():
    return wtt_events, wtt_matches, wtt_players
