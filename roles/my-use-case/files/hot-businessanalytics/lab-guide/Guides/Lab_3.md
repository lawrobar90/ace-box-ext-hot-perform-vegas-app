## Lab 3: Creating Business Solutions from Logs

In this hands-on, we’ll be setting up this process using some existing building blocks! You will be capturing cheat logs, then using automation you will reduce the risk and increase revenue for your casino. 
### 3.1 Capturing the logs
- [ ] Using the “**App drawer**” in the top-left of the screen (or the search) – *find* the **“Settings Classic”** app and *open* it.
- [ ] Navigate to "**Log Monitoring**" then "**Set up log ingest**".
- [ ] At the top of the page, make sure all "**Quick Start**" options are enabled and *click* "**Save changes**".

[Click to view screenshot](Lab3-SetupLogIngest.png)

- [ ] Navigate to your Dynatrace Notebook, add a new DQL widget, *copy*, *paste* and *run* the following:
```
fetch logs
| filter matchesPhrase(content, "CustomerName")
| sort timestamp desc
```
### You will see new container logs that are the output of all game activity. ###

[Click to view screenshot](Lab3-CheckLogIngest.png)

## Go back to your Vegas Application, *Enable Cheats*, and play some games #


### 3.2 Processing your logs to find the cheaters
- [ ] *Open* "**OpenPipeline**" 
- [ ] *Click* on "**Logs**" menu group
- [ ] *Click* on "**Pipelines**"
- [ ] *Create* a "**+ pipeline**"
- [ ] *Rename* the pipeline:
```
Vegas Cheat Logs to BizEvents
```

### 3.3 OpenPipeline Processing Rule Configuration

- [ ] *Access* the "**Processing**" tab
- [ ] From the processor dropdown menu, *Select* "**DQL**" 
- [ ] *Name* the new processor, *copy* and *paste*:
```
JSON Log parser
```
- [ ] For "**Matching condition**", leave set to **true**
- [ ] For "**DQL processor definition**", *copy* and *paste*:
```
parse content, "JSON:json"
| fieldsFlatten json
```

[Click to view screenshot](Lab3-ProcessingRule.png)

### 3.4 Create a Business Event
- [ ] *Access* the "**Data extraction**" tab
- [ ] From the processor dropdown menu, *Select* "**Business event**" 
- [ ] *Name* the new processor, *copy* and *paste*:
```
Cheating Attempt
```
- [ ] For "**Matching condition**", *copy* and *paste*:
```
matchesPhrase(content, "cheat_active\":true")
```
- [ ] For the "**Event Type**" select *Static string*, then *copy* and *paste*:
```
CheatFound
```
- [ ] For the "**Event provider**" select *Static string*, then *copy* and *paste*:
```
Vegas Casino Fraud Detection
```
- [ ] For "**Field extraction**" leave as *Extrace all fields*.
- [ ] *Click* "**Save**" so you don't lose this config

[Click to view screenshot](Lab3-DataExtraction.png)

### 3.5 Adding a Metric Extraction
- [ ] Go back into your "**Vegas Cheat Logs to BizEvents**"
- [ ] *Access* the "**Metric extraction**" tab
- [ ] From the processor dropdown menu, *Select* "**Value Metric**"
- [ ] *Name* the new processor, *copy* and *paste*:
```
Vegas Cheating - WinAmount
```
- [ ] For "**Matching condition**", leave set to **true**
- [ ] For the "**Field extraction**", then *copy* and *paste*:
```
json.winAmount
```
- [ ] For the "**Metric Key**", then *copy* and *paste*:
```
log.cheat_WinAmount
```
- [ ] For the "**Dimensions**", *select* "**custom**"
- [ ] In the *Field name on record*, *copy* and *paste*:
```
json.cheatType
```
- [ ] In the *Dimension name*, *copy* and *paste*:
```
cheatType
``` 
- [ ] *Click* on "**Add Dimension**"
- [ ] Do the same for these other 2 dimensions:
##### Field name on record:
```
json.game
```
##### Dimension name
```
Game
```
- [ ] *Click* on "**Add Dimension**"
##### Field name on record:
```
json.CustomerName
```
##### Dimension name
```
CustomerName
```
- [ ] *Click* on "**Add Dimension**"

[Click to view screenshot](Lab3-WinAmountMetric.png)


- [ ] Click the 3 vertical buttons on your "**Vegas Cheating - WinAmount**" metric, and select "**Duplicate**"
- [ ] Change the *Name*, *copy* and *paste*:
```
Vegas Cheating - BetAmount
```
- [ ] Change "**Field extraction**", *copy* and *paste*:
```
json.BetAmount
```
- [ ] Change the *Metric key*, *copy* and *paste*:
```
log.cheat_BetAmount
```
- [ ] *Click* "**Save**" so you don't lose this config

[Click to view screenshot](Lab3-BetAmountMetric.png)

### 3.6 OpenPipeline Dynamic Routing
- [ ] *Access* the "**Dynamic routing**" tab
- [ ] *Create* a *new Dynamic route*
- [ ] For "**Name**", *copy* and *paste*: 
```
Vegas Security Logs
```
- [ ] For "**Matching condition**", *copy* and *paste*:
```
matchesPhrase(content, "cheat_active\":true")
```
- [ ] For "**Pipeline**", *select* "**Vegas Cheat Logs to BizEvents**"
- [ ] *Click* "**Add**" and then "**Save**".

[Click to view screenshot](Lab3-DynamicRouting.png)

### Go back to your Vegas Application, *Enable Cheats*, and play some games ###

- [ ] Navigate to your Dynatrace Notebook, add *three* new DQL widgets, *copy*, *paste* and *run* the following in each of them:
```
fetch logs
| sort timestamp desc
| filter dt.openpipeline.pipelines != array("logs:default")
```

[Click to view screenshot](Lab3-FetchLogs.png)

```
fetch bizevents
| filter event.provider == "Vegas Casino Fraud Detection"
| sort timestamp desc
```

[Click to view screenshot](Lab3-BizEvent.png)

```
timeseries { sum(log.cheat_WinAmount), value.A = sum(log.cheat_WinAmount, scalar: true), sum(log.cheat_BetAmount), value.B = sum(log.cheat_BetAmount, scalar: true) }, union: TRUE
```
- [ ] Change *Visualization Type* to a "**Bar**" for the last *timeseries* query
[Click to view screenshot](Lab3-MetricGraph.png)
