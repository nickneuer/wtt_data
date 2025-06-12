import dlt
from dlt.sources.helpers.rest_client import RESTClient
from dlt.sources.helpers.rest_client.paginators import PageNumberPaginator
import time
from requests.exceptions import ReadTimeout

# PageNumberPaginator works by incrementing the page number for each request.

# Parameters:

# base_page: The index of the initial page from the API perspective. Normally, it's 0-based or 1-based (e.g., 1, 2, 3, ...) indexing for the pages. Defaults to 0.
# page: The page number for the first request. If not provided, the initial value will be set to base_page.
# page_param: The query parameter name for the page number. Defaults to "page".
# total_path: A JSONPath expression for the total number of pages. If not provided, pagination is controlled by maximum_page and stop_after_empty_page.
# maximum_page: Optional maximum page number. Stops pagination once this page is reached.
# stop_after_empty_page: Whether pagination should stop when a page contains no result items. Defaults to True.

# Initialize the REST client with the base URL
def make_wtt_client(max_pages=None):
    wtt_client = RESTClient(
        base_url="https://wttcmsapigateway-new.azure-api.net/ttu",
        paginator=PageNumberPaginator(
            base_page=1,
            page_param="Page",
            total_path=None,
            maximum_page=max_pages,
            stop_after_empty_page=True
        ),
        data_selector="Result"
    )
    return wtt_client

@dlt.resource(name="wtt_events", write_disposition="append", parallelized=True)
def wtt_events(limit=1000, timeout=90):
    client = make_wtt_client()
    for page_data in client.paginate(
            "/Events/GetEvents",
            method="GET",
            params={"Limit": limit},
            timeout=timeout
        ):
        print(f"yielding list of {len(list(page_data))} events")
        yield list(page_data)

# TODO: it sounds like from the docs it already retries automatically with sane logic
# but I probably need to do some kind of exception handling when the response isn't valid JSON
# which did happen a few times -- alternatively i could write my own retry logic per the very
# bottom of this page https://dlthub.com/docs/general-usage/http/requests

# see docs https://dlthub.com/docs/general-usage/resource#process-resources-with-dlttransformer 
match_client = make_wtt_client()
@dlt.transformer(data_from=wtt_events, name="wtt_matches", parallelized=True)
def wtt_matches(event_list, timeout=None):
    for event_item in event_list:
        event_id = event_item["EventId"]
        payload = {"EventId": event_id}

        r = match_client.get("/Matches/GetMatches", params=payload, timeout=timeout)
        try:
            match_resp = r.json()
            yield match_resp["Result"]

        except:
            print(f"no valid matches json for event_id={event_id}")

match_stats_client = make_wtt_client()
@dlt.transformer(data_from=wtt_events, name="wtt_match_stats", parallelized=True)
def wtt_match_stats(event_list, timeout=None):
    for event_item in event_list:
        event_id = event_item["EventId"]
        payload = {"EventId": event_id}

        r = match_stats_client.get(
            "/EventStats/Players/GetEventMatchStats",
            params=payload,
            timeout=timeout
        )
        try:
            match_stats_resp = r.json()
            yield match_stats_resp["Result"]

        except:
            print(f"no valid match_stats json for event_id={event_id}")

@dlt.resource(name="wtt_players", write_disposition="append", parallelized=True)
def wtt_players(limit=1000, timeout=90):
    client = make_wtt_client()
    for page_data in client.paginate(
            "/Players/GetPlayers",
            method="GET",
            params={"Limit": limit},
            timeout=timeout
        ):
        print(f"yielding list of {len(list(page_data))} players")
        yield list(page_data)

# other ideas:
#
# ALL PLAYER RANKINGS -- https://wttcmsapigateway-new.azure-api.net/ttu/Rankings/GetRankingIndividuals?SubEventCode=MS&AgeCategoryCode=SEN
# 

@dlt.source(name="wtt_source")
def wtt_source():
    resources =  [
        wtt_players,
        wtt_events,
        wtt_matches, 
        wtt_match_stats
    ]
    return resources

