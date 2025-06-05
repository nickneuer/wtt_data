import requests

url = "https://wttcmsapigateway-new.azure-api.net/ttu/Events/GetEvents"
test_params = [
    "EventId", "EventShortName", "EventCity", "EventCountryCode",
    "EventStartDate", "RankingYear", "RankingMonth", "EventContinent"
]

for param in test_params:
    full_url = f"{url}?{param}=test"
    response = requests.get(full_url)
    print(f"{param}=test => {response.status_code}")
    if response.status_code == 200:
        print(f"✅ Possible valid param: {param}")
    elif response.status_code == 400 and "missing" not in response.text.lower():
        print(f"⚠️ Interesting error for: {param} => {response.text[:200]}")
