## Lab 1: basic configuration and exploration 

This lab will show you how to *create* and *validate* **business rules**. 

### 1.1 OneAgent rule Configuration

##### Configure
1.	*Open* "**Settings Classic**"
1.	*Open* "**Business Analytics**" menu group
1.	*Click* on "**OneAgent**"
1.	*Click* on "**Add new capture rule**" on the **incoming** tab
1.	For field "**Rule name**", *copy* and *paste*:
      ```
      Vegas Application
      ```

##### Configure Trigger

1.	*Click* on "**Add trigger**"
1.	For "**Data source**", *select* "**Request - Body**"
1.	For "**Operator**", *select* "**exists**"
1.	For "**Path**", *copy* and *paste*:
      ```
      Game
      ```

##### Configure metadata (Event Provider)

1.	For "**Event provider Data Source**", *click* on "**Fixed value**" and make sure that "**Request - Body**" is *selected*
1.	For "**Field name**" and "**Path**", *copy* and *paste*:
      ```
      Game
      ```

##### Configure metadata (Event Type)

1.	For "**Event type data source**", *click* on "**Fixed value**" and make sure that "**Request - Body**" is *selected*
1.	For "**Field name**" and "**Path**", *copy* and *paste*:
      ```
      Action
      ```

##### Configure additional data (JSON Payloads)

1.	*Click* on "**Add data field**"
1.	For "**Data source**", make sure that "**Request - Body**" is *selected*
1.	For "**Field name**", *copy* and *paste*:
      ```
      rqBody
      ```
1.	For "**Path**", *copy* and *paste*:
      ```
      *
      ```

1.	*Click* on "**Add data field**"
1.	For "**Data source**", make sure that "**Response - Body**" is *selected*
1.	For "**Field name**", *copy* and *paste*:
      ```
      rsBody
      ```
1.	For "**Path**", *copy* and *paste*:
      ```
      *
      ```


**At the bottom of the screen, click "Save changes"**

### 1.2 Service Naming Rules

##### Create a Service Naming Rule for the intelligent traceing to be captured
1.	*Open* "**Settings Classic**"
1.	*Open* "**Server-side Service monitoring**" menu group
1.	*Click* on "**Service naming rules**" and add a new rule.
1.    For Rule name, *copy* and *paste*:
      ```
      Vegas Naming Rules
      ```
1.    For Service name format, *copy* and *paste*:
      ```
      {ProcessGroup:DetectedName}
      ```
1.    For Conditions name format, *select* **Detected process group name** from the dropdown
1.    Change matcher to **begins with**
1.    For "**value**", *copy* and *paste*:
      ```
      vegas
      ```
1.    Click *Preview* then **Save changes**

### *PLAY SOME OF THE VEGAS APPLICATIONS IN THE WEBSITE, ACTIVATE CHEATS FOR BIG WINS* ###
### *CAREFUL, CHEATERS NEVER PROSPER!* ###

### 1.3 Queries

##### Validate you have "**Business Events**"
1.	From the menu, *open* "**Notebooks**"
1.	*Click* on the "**+**" to add a new section
1.	*Click* on "**DQL**"
1.	*Copy* and *paste* the **query** - Change the **Game** to the one you are testing with surrounded by quotation marks:

      ```
      fetch bizevents
      | filter not(matchesphrase(rsBody, "healthy"))
      | sort timestamp desc 
      ```

### The Request and Response body are filled with valuable data, but it's still in JSON format ###
1. Change your DQL to this now:
     ```
     fetch bizevents
       | filter not(matchesphrase(rsBody, "healthy"))
       | sort timestamp desc
       | parse rqBody, "JSON:requestJSON"
       | fieldsFlatten requestJSON
       | parse rsBody, "JSON:resultJSON"
       | fieldsFlatten resultJSON
     ```
 ### Now this is great for a dashboard, but why not automate this parsing process instead? ###
