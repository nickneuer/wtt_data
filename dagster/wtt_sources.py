import dlt
from dlt.sources.helpers.rest_client import RESTClient
from dlt.sources.helpers.rest_client.paginators import PageNumberPaginator
import time

# PageNumberPaginator works by incrementing the page number for each request.

# Parameters:

# base_page: The index of the initial page from the API perspective. Normally, it's 0-based or 1-based (e.g., 1, 2, 3, ...) indexing for the pages. Defaults to 0.
# page: The page number for the first request. If not provided, the initial value will be set to base_page.
# page_param: The query parameter name for the page number. Defaults to "page".
# total_path: A JSONPath expression for the total number of pages. If not provided, pagination is controlled by maximum_page and stop_after_empty_page.
# maximum_page: Optional maximum page number. Stops pagination once this page is reached.
# stop_after_empty_page: Whether pagination should stop when a page contains no result items. Defaults to True.

# Initialize the REST client with the base URL
def make_wtt_client():
    wtt_client = RESTClient(
        base_url="https://wttcmsapigateway-new.azure-api.net/ttu",
        paginator=PageNumberPaginator(
            base_page=1,
            page_param="Page",
            total_path=None,
            maximum_page=None,
            stop_after_empty_page=True
        ),
        data_selector="Result"
    )
    return wtt_client


@dlt.resource(name="wtt_events", write_disposition="append")
def wtt_events(limit=20):
    client = make_wtt_client()
    for page_data in client.paginate(
            "/Events/GetEvents",
            method="GET",
            params={"Limit": limit},
            timeout=90
        ):
        for result in page_data:
            yield result

# see docs https://dlthub.com/docs/general-usage/resource#process-resources-with-dlttransformer 
match_client = make_wtt_client()
@dlt.transformer(data_from=wtt_events, name="wtt_matches")
def wtt_matches(event_item):
    event_id = event_item["EventId"]
    payload = {"EventId": event_id}
    r = match_client.get("/Matches/GetMatches", params=payload, timeout=90)
    try:
        match_resp = r.json()
        for match in match_resp["Result"]:
            yield match
    except:
        print(f"no valid matches json for event_id={event_id}")

match_stats_client = make_wtt_client()
@dlt.transformer(data_from=wtt_events, name="wtt_match_stats")
def wtt_match_stats(event_item):
    event_id = event_item["EventId"]
    payload = {"EventId": event_id}
    r = match_client.get("/EventStats/Players/GetEventMatchStats", params=payload, timeout=90)
    try:
        match_resp = r.json()
        for match_stat_data in match_resp["Result"]:
            yield match_stat_data
    except:
        print(f"no valid match_stats json for event_id={event_id}")

@dlt.resource(name="wtt_players", write_disposition="append")
def wtt_players(limit=20):
    client = make_wtt_client()
    for page_data in client.paginate(
            "/Players/GetPlayers",
            method="GET",
            params={"Limit": limit},
            timeout=90
        ):
        for result in page_data:
            yield result

@dlt.source(name="wtt_source")
def wtt_source():
    return wtt_events, wtt_matches, wtt_players, wtt_match_stats
