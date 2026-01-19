## Lab 2: Processing and Contextualizing your data

This lab will show you how to "**Process**" and "**Extract**" your business data to help increase revenue and reduce risk.

## 2.10 OpenPipeline Pipeline Configuration

- [ ] *Click* on the "**Application Drawer**" on your Dynatrace tenant, and search for "**Settings**" and open
- [ ] *Click* "**Process and contextualize**" on the left side bar, and *select* "**OpenPipeline**" 
- [ ] *Click* on "**Business events**" menu group
- [ ] *Click* on "**Pipelines**" just above the table displayed
- [ ] *Click* the "**+ Pipeline**" on the far right of the screen
- [ ] *Rename* the pipeline from "**Untitled pipeline**" to:
```
Vegas Pipeline
```
:::screenshot[Click to view screenshot](BusinessAnalytics-Oneagent-CaptureRules.png)

## 2.20 OpenPipeline Processing Rule Configuration

- [ ] *Access* the "**Processing**" tab
- [ ] From the processor dropdown menu, *Select* "**DQL**" 
- [ ] *Name* the new processor, *copy* and *paste*:

```
Vegas Gaming Details - rqBody
```

- [ ] For "**Matching condition**", leave set to **true**
- [ ] For "**DQL processor definition**", *copy* and *paste*:

```
parse rqBody, "JSON:requestJSON"
| fieldsFlatten requestJSON
```


## 2.21 OpenPipeline Processing Rule Configuration

- [ ] Add another processor
- [ ] From the processor dropdown menu, *Select* "**DQL**" 
- [ ] *Name* the new processor, *copy* and *paste*:

```
      Vegas Gaming Details - rsBody
```

- [ ] For "**Matching condition**", leave set to **true**
- [ ] For "**DQL processor definition**", *copy* and *paste*:

```
parse rsBody, "JSON:resultJSON"
| fieldsFlatten resultJSON
```


## 2.30 OpenPipeline Metrics Extraction

- [ ] *Access* the "**Metric Extraction**" tab
- [ ] From the processor dropdown menu, *Select* "**Value Metric**" 
- [ ] *Name* the new Value metric, *copy* and *paste*:

```
BetAmount
```
- [ ] For "**Matching condition**", *copy* and *paste*:

```
isnotnull(requestJSON.BetAmount)
```
- [ ] For "**Field Extraction**", *copy* and *paste*:

```
requestJSON.BetAmount
```      
- [ ] For "**Metric key**", *copy* and *paste*:

```
bizevents.vegas.betAmount
```      
- [ ] For "**Dimensions**" select **custom**, *copy* and *paste*:
- [ ] Field name on record:
```
requestJSON.Game
```   
- [ ] Dimension name:
```
Game
```   
- [ ] Click "**Add dimension**" on the right hand side.
- [ ] Now, do the same for these other fields:
```
requestJSON.CheatType
```
- [ ] Dimension name:
```
CheatType
```   
- [ ] Field name on record:
```
requestJSON.CustomerName
```
- [ ] Dimension name:
```
CustomerName
```   
- [ ] Field name on record:
```
requestJSON.CheatActive
```
- [ ] Dimension name:
```
CheatActive
```   


## 2.31 OpenPipeline Metrics Extraction

- [ ] Add a new "**Mertric Extraction**" rule as a "**Value Metric**"
- [ ] *Name* the new Value metric, *copy* and *paste*:
```
WinAmount
```
- [ ] For "**Matching Condition**", *copy* and *paste*:
```
isNotNull(resultJSON.winAmount)
```
- [ ] For "**Field extraction Condition**", *copy* and *paste*:
```
resultJSON.WinningAmount
```      
- [ ] Change the "**Metric key**", *copy* and *paste*:
```
bizevents.vegas.winAmount
```         
- [ ] For "**Dimensions**" select **custom**, *copy* and *paste*:
- [ ] Field name on record:
```
resultJSON.Game
```   
- [ ] Dimension name:
```
Game
```   
- [ ] Click "**Add dimension**" on the right hand side.
- [ ] Now, do the same for these other fields:
```
resultJSON.CheatType
```
- [ ] Dimension name:
```
CheatType
```   
- [ ] Field name on record:
```
resultJSON.CustomerName
```
- [ ] Dimension name:
```
CustomerName
```   
- [ ] Field name on record:
```
resultJSON.CheatActive
```
- [ ] Dimension name:
```
CheatActive
```   

**At the top right of the screen, click "*Save*"**


## 2.40 OpenPipeline Dynamic Routing

- [ ] *Access* the "**Dynamic routing**" tab
- [ ] *Create* a *new Dynamic route*
- [ ] For "**Name**", *copy* and *paste*: 
```
Vegas Pipeline
```
- [ ] For "**Matching condition**", *copy* and *paste*:
```
isnotnull(event.provider)
```
- [ ] For "**Pipeline**", *select* "**Vegas Pipeline**"
- [ ] *Click* "**Add**" 

**Just above the table, click "*Save*"**
**Make sure you change Status to enable the Dynamic Routing**

### *PLAY SOME OF THE VEGAS APPLICATIONS IN THE WEBSITE, ACTIVATE CHEATS FOR BIG WINS* ###
### *CAREFUL, CHEATERS NEVER PROSPER!* ###


## 2.5 Queries

##### Validate new attribute
- [ ] From the menu, *open* "**Notebooks**"
- [ ] *Click* on the "**+**" to add a new section
- [ ] *Click* on "**DQL**"
- [ ] *Copy* and *paste* the **query** :

```
fetch bizevents
| filter not(matchesphrase(rsBody, "healthy"))
| filter dt.openpipeline.pipelines != array("bizevents:default")
| sort timestamp desc
```
- [ ] *Click* on the "**+**" to add a new section
- [ ] *Click* on "**Metrics**"
- [ ] Select the metrics you just created and split by any, or all, of the dimensions.
- [ ] What this will show is the betAmount where you can easily split by Game, CheatActive and other dimensions
- [ ] You can also add in the winAmount by click "**+ Source**" and finding the winAmount
- [ ] Play around with the visualizations by *clicking* "**Options**" on the widget

