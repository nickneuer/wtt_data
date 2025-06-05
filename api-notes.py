
# WTT Info 

# Event URL
# https://worldtabletennis.com/eventInfo?eventId=3042

# Player info API
# https://wttcmsapigateway-new.azure-api.net/ttu/Players/GetPlayers?IttfId=203040

# Player JSON
{
  "Version": "0.1.0",
  "Source": "ITTF/WTT",
  "System": "Table tennis Sports Data API",
  "StatusCode": 200,
  "RequestId": "21ecccdd-ee8e-4349-a9b5-46aeafe776ff",
  "ResponseDate": "05/31/2025",
  "ResponseTime": "21:25:23",
  "Result": [
    {
      "IttfId": "203040",
      "PlayerName": "Shahbozbek GULOMIDDINOV",
      "PlayerGivenName": "Shahbozbek",
      "PlayerFamilyName": "GULOMIDDINOV",
      "PlayerFamilyNameFirst": "GULOMIDDINOV Shahbozbek",
      "CountryCode": "UZB",
      "CountryName": "Uzbekistan",
      "NationalityCode": "UZB",
      "NationalityName": "Uzbekistan",
      "OrganizationCode": "UZB",
      "OrganizationName": "UZBEKISTAN",
      "Gender": "M",
      "Age": "16",
      "DOB": "02/11/2009 00:00:00",
      "Handedness": null,
      "Grip": null,
      "Style": null,
      "EquipmentSponsor": null,
      "BladeType": null,
      "RacketColoringA": null,
      "RacketColoringB": null,
      "RacketCoveringA": null,
      "RacketCoveringB": null,
      "ActiveSince": null,
      "EarningsCareer": null,
      "EarningsYTD": null,
      "LastMatch": null,
      "NextMatch": null,
      "HeadShot": null,
      "Bio": null,
      "HeadshotR": null,
      "HeadshotL": null
    }
  ]
}



https://wtt-website-live-events-api-prod-cmfzgabgbzhphabb.eastasia-01.azurewebsites.net/api/cms/GetLiveResult?EventId=3042



https://wttapigateway-new.azure-api.net/prod/api/cms/event_related_docs/all_list



https://wttapigateway-new.azure-api.net/prod/api/cms/override/tablenames?EventId=3042

# Gets all players? Yes!
https://wttcmsapigateway-new.azure-api.net/ttu/Players/GetPlayers

# Guessing others -- this works!
https://wttcmsapigateway-new.azure-api.net/ttu/Events/GetEvents?offset=0&limit=10

# what about matches? 
# it says I need to supply EventId parameter!
# trying with 01
https://wttcmsapigateway-new.azure-api.net/ttu/Matches/GetMatches?EventId=01

# Pagination guessing
https://wttcmsapigateway-new.azure-api.net/ttu/Players/GetPlayers?offset=0&limit=10


# HIS_1_759955_MS_GP07_U21_114838_118843

# might actually result in something?
https://wttcmsapigateway-new.azure-api.net/ttu/Games/GetGames?EventId=3042&MatchId=TTEMSINGLES--------U19FNL-000100----------&offset=0&limit=10

# Found the swagger schema!
# https://wttcmsapigateway-new.azure-api.net/ttu/swagger/v1.6/swagger.json

