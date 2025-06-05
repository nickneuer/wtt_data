import requests

BASE_URL = "https://wttcmsapigateway-new.azure-api.net/ttu"
ENTITY_ACTIONS = {
    # "Players": ["GetPlayers", "GetPlayerById", "GetPlayerStats", "GetPlayerMatches", "GetPlayerRankings"],
    # "Events": ["GetEvents", "GetEventById", "GetEventMatches", "GetEventParticipants"],
    # "Matches": ["GetMatches", "GetMatchById", "GetMatchStats", "GetMatchHighlights"],
    # "Tournaments": ["GetTournaments", "GetTournamentById", "GetTournamentEvents"],
    # "Rankings": ["GetRankings", "GetRankingsByCategory"],
    # "Teams": ["GetTeams", "GetTeamById", "GetTeamPlayers"],
    # "Venues": ["GetVenues", "GetVenueById"],
    # "Stats": ["GetStats"],
    # "PlayerStats": ["GetPlayerStats"],
    # "PlayerRanking": ["GetPlayerRankings"]
    "Games": ["GetGames"],
    "OfficialResult": ["GetOfficialResult"],
    "LiveResult": ["GetLiveResult"],
}

def probe_endpoints():
    for entity, actions in ENTITY_ACTIONS.items():
        for action in actions:
            url = f"{BASE_URL}/{entity}/{action}"
            try:
                response = requests.get(url, timeout=5)
                print(f"{url} => {response.status_code}")
                if response.status_code == 200:
                    print(f"SUCCESS: {url}")
                elif response.status_code == 400:
                    print(f"Needs parameters: {url}")
            except Exception as e:
                print(f"ERROR: {url} => {e}")

if __name__ == "__main__":
    probe_endpoints()
