## Lab 2: OpenPipeline Configuration

This lab will show you how to "**Process**" and "**Extract**" your business data to help increase revenue and reduce risk.

### 1.1 OpenPipeline Pipeline Configuration

1. *Open* "**OpenPipeline**" 
1. *Click* on "**Business events**" menu group
1. *Click* on "**Pipelines**"
1. *Create* a **new pipeline**
1. *Rename* the pipeline:

      ```
      Vegas Pipeline
      ```

### 1.2 OpenPipeline Processing Rule Configuration

1.	*Access* the "**Processing**" tab
1.	From the processor dropdown menu, *Select* "**DQL**" 
1.	*Name* the new processor, *copy* and *paste*:

      ```
      Vegas Gaming Details - rqBody
      ```

1.	For "**Matching condition**", leave set to **true**
1.	For "**DQL processor definition**", *copy* and *paste*:

      ```
     parse rqBody, "JSON:requestJSON"
     | fieldsFlatten requestJSON
      ```

1.    Add another processor
1.	From the processor dropdown menu, *Select* "**DQL**" 
1.	*Name* the new processor, *copy* and *paste*:

      ```
      Vegas Gaming Details - rsBody
      ```

1.	For "**Matching condition**", leave set to **true**
1.	For "**DQL processor definition**", *copy* and *paste*:

      ```
      parse rsBody, "JSON:resultJSON"
      | fieldsFlatten resultJSON
      ```
### 1.3 OpenPipeline Metrics Extraction

1.	*Access* the "**Metric Extraction**" tab
1.	From the processor dropdown menu, *Select* "**Value Metric**" 
1.	*Name* the new Value metric, *copy* and *paste*:

      ```
      BetAmount
      ```
1.	For "**Matching condition**", *copy* and *paste*:

      ```
      isnotnull(requestJSON.BetAmount)
      ```
1.	For "**Field Extraction**", *copy* and *paste*:

      ```
      requestJSON.BetAmount
      ```      
1.	For "**Metric key**", *copy* and *paste*:

      ```
      bizevents.vegas.betAmount
      ```      
1.    For "**Dimensions**" select **custom**, *copy* and *paste*:
1.    Field name on record:
      ```
      requestJSON.Game
      ```   
1.    Dimension name:
      ```
      Game
      ```   
1.   Click "**Add dimension**" on the right hand side.
1.   Now, do the same for these other fields:
      ```
      requestJSON.CheatType
      ```
1.    Dimension name:
      ```
      CheatType
      ```   
1.    Field name on record:
      ```
      requestJSON.CustomerName
      ```
1.    Dimension name:
      ```
      CustomerName
      ```   
1.    Field name on record:

      ```
      requestJSON.CheatActive
      ```

1.    Dimension name:
      ```
      CheatActive
      ```   
1.   Add a new "**Mertric Extraction**" rule as a "**Value Metric**"
1.   *Name* the new Value metric, *copy* and *paste*:
      ```
      WinAmount
      ```
1.   For "**Matching Condition**", *copy* and *paste*:
      ```
      isNotNull(resultJSON.winAmount)
      ```
1.   For "**Field extraction Condition**", *copy* and *paste*:
      ```
      resultJSON.winAmount
      ```      
1.   Change the "**Metric key**", *copy* and *paste*:
      ```
      bizevents.vegas.winAmount
      ```         
1.    For "**Dimensions**" select **custom**, *copy* and *paste*:
1.    Field name on record:
      ```
      resultJSON.Game
      ```   
1.    Dimension name:
      ```
      Game
      ```   
1.   Click "**Add dimension**" on the right hand side.
1.   Now, do the same for these other fields:
      ```
      resultJSON.CheatType
      ```
1.    Dimension name:
      ```
      CheatType
      ```   
1.    Field name on record:
      ```
      resultJSON.CustomerName
      ```
1.    Dimension name:
      ```
      CustomerName
      ```   
1.    Field name on record:

      ```
      resultJSON.CheatActive
      ```

1.    Dimension name:
      ```
      CheatActive
      ```   

**At the top right of the screen, click "*Save*"**


### 1.4 OpenPipeline Dynamic Routing

1. *Access* the "**Dynamic routing**" tab
1. *Create* a *new Dynamic route*
1. For "**Name**", *copy* and *paste*: 

      ```
      Vegas Pipeline
      ```

1. For "**Matching condition**", *copy* and *paste*:

      ```
      isnotnull(event.provider)
      ```

1. For "**Pipeline**", *select* "**Vegas Pipeline**"
1. *Click* "**Add**" 

**Just above the table, click "*Save*"**
**Make sure you change Status to enable the Dynamic Routing**


### *PLAY SOME OF THE VEGAS APPLICATIONS IN THE WEBSITE, ACTIVATE CHEATS FOR BIG WINS* ###
### *CAREFUL, CHEATERS NEVER PROSPER!* ###

### 1.5 Queries

##### Validate new attribute
1.	From the menu, *open* "**Notebooks**"
1.	*Click* on the "**+**" to add a new section
1.	*Click* on "**DQL**"
1.	*Copy* and *paste* the **query** :

      ```
     fetch bizevents
      | filter not(matchesphrase(rsBody, "healthy"))
      | filter dt.openpipeline.pipelines != array("bizevents:default")
      | sort timestamp desc
      ```

1.	*Click* on the "**+**" to add a new section
1.	*Click* on "**Metrics**"
1.	Select the metrics you just created and split by any, or all, of the dimensions.
1.    What this will show is the betAmount where you can easily split by Game, CheatActive and other dimensions
1.    You can also add in the winAmount by click "**+ Source**" and finding the winAmount
1.    Play around with the visualizations by *clicking* "**Options**" on the widget

