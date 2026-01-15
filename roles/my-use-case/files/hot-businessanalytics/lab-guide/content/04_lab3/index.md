## Lab 3: getting value from automation

In this hands-on, we’ll be setting up this process using some existing building blocks! You will be capturing cheat logs, then using automation you will reduce the risk and increase revenue for your casino. 
### 3.1 Capturing the logs
1. Using the “**App drawer**” in the top-left of the screen (or the search) – *find* the **“Settings Classic”** app and *open* it.
2. Navigate to "**Log Monitoring**" then "**Set up log ingest**".
3. At the top of the page, make sure all "**Quick Start**" options are enabled and *click* "**Save changes**".
4.  Navigate to your Dynatrace Notebook, add a new DQL widget, *copy*, *paste* and *run* the following:
    ```
    fetch logs
     | filter matchesPhrase(content, "CustomerName")
     | sort timestamp desc
    ```
### You will see new container logs that are the output of all game activity. ###
## Go back to your Vegas Application, *Enable Cheats*, and play some games #


### 3.2 Processing your logs to find the cheaters
1. *Open* "**OpenPipeline**" 
2. *Click* on "**Logs**" menu group
3. *Click* on "**Pipelines**"
4. *Create* a "**+ pipeline**"
5. *Rename* the pipeline:
```
Vegas Cheat Logs to BizEvents
```

### 3.3 OpenPipeline Processing Rule Configuration

1.	*Access* the "**Processing**" tab
2.	From the processor dropdown menu, *Select* "**DQL**" 
3.	*Name* the new processor, *copy* and *paste*:
```
JSON Log parser
```
4.	For "**Matching condition**", leave set to **true**
5.	For "**DQL processor definition**", *copy* and *paste*:
```
parse content, "JSON:json"
| fieldsFlatten json
```

### 3.4 Create a Business Event
1.	*Access* the "**Data extraction**" tab
2.	From the processor dropdown menu, *Select* "**Business event**" 
3.	*Name* the new processor, *copy* and *paste*:
```
Cheating Attempt
```
4.	For "**Matching condition**", *copy* and *paste*:
```
matchesPhrase(content, "cheat_active\":true")
```
5.   For the "**Event Type**" select *Static string*, then *copy* and *paste*:
```
CheatFound
```
6.   For the "**Event provider**" select *Static string*, then *copy* and *paste*:
```
Vegas Casino Fraud Detection
```
7.   For "**Field extraction**" leave as *Extrace all fields*.
8.   *Click* "**Save**" so you don't lose this config

### 3.5 Adding a Metric Extraction
1.   Go back into your "**Vegas Cheat Logs to BizEvents**"
2.   *Access* the "**Metric extraction**" tab
3.   From the processor dropdown menu, *Select* "**Value Metric**"
4.   *Name* the new processor, *copy* and *paste*:
```
Vegas Cheating - WinAmount
```
5.   For "**Matching condition**", leave set to **true**
6.   For the "**Field extraction**", then *copy* and *paste*:
```
json.winAmount
```
7.   For the "**Metric Key**", then *copy* and *paste*:
```
log.cheat_WinAmount
```
8.   For the "**Dimensions**", *select* "**custom**"
9.   In the *Field name on record*,*copy* and *paste*:
```
json.cheatType
```
10.   In the *Dimension name*, *copy* and *paste*:
```
cheatType
``` 
11.   *Click* on "**Add Dimension**"
12.   Do the same for these other 2 dimensions:
##### Field name on record:
```
json.game
```
##### Dimension name
```
Game
```
##### *Click* on "**Add Dimension**"
##### Field name on record:
```
json.CustomerName
```
##### Dimension name
```
CustomerName
```
##### *Click* on "**Add Dimension**"
13.   Click the 3 vertical buttons on your "**Vegas Cheating - WinAmount**" metric, and select "**Duplicate**"
14.   Change the *Name*, *copy* and *paste*:
     ```
     Vegas Cheating - BetAmount
     ```
15.   Change "**Field extraction**", *copy* and *paste*:
```
json.BetAmount
```
16.   Change the *Metric key*, *copy* and *paste*:
     ```
     log.cheat_BetAmount
     ```
##### *Click* "**Save**" so you don't lose this config

### 3.6 OpenPipeline Dynamic Routing
1. *Access* the "**Dynamic routing**" tab
2. *Create* a *new Dynamic route*
3. For "**Name**", *copy* and *paste*: 
```
Vegas Security Logs
```
4. For "**Matching condition**", *copy* and *paste*:
```
matchesPhrase(content, "cheat_active\":true")
```
5.  For "**Pipeline**", *select* "**Vegas Cheat Logs to BizEvents**"
6. *Click* "**Add**" and then "**Save**".

### Go back to your Vegas Application, *Enable Cheats*, and play some games ###

7.  Navigate to your Dynatrace Notebook, add *three* new DQL widgets, *copy*, *paste* and *run* the following in each of them:
    ```
    fetch logs
    | sort timestamp desc
    | filter dt.openpipeline.pipelines != array("logs:default")
    ```
    ```
     fetch bizevents
    | filter event.provider == "Vegas Casino Fraud Detection"
    | sort timestamp desc
    ```
    ```
    timeseries { sum(log.cheat_winAmount), value.A = sum(log.cheat_winAmount, scalar: true), sum(log.cheat_BetAmount), value.B = sum(log.cheat_BetAmount, scalar: true) }, union: TRUE
    ```
1. Change *Visualization Type* to a "**Bar**" for the last *timeseries* query
