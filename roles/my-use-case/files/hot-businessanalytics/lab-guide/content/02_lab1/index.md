## Lab 1: basic configuration and exploration 

This lab will show you how to *create* and *validate* **business rules**. 

### 1.1 OneAgent rule Configuration

##### Configure
1.	*Open* "**Settings**"
2.	*Open* "**Collect and capture**" sidebar tab
3.	*Click* on "**Business events**"
4.	*Click* on "**Incoming**"
5.	*Click* on "**Add new capture rule**" on the **incoming** tab
6.	For field "**Rule name**", *copy* and *paste*:
      ```
      Vegas Application
      ```

##### Configure Trigger

7.	*Click* on "**Add trigger**"
8.	For "**Data source**", *select* "**Request - Body**"
9.	For "**Operator**", *select* "**exists**"
10.	For "**Path**", *copy* and *paste*:
      ```
      Game
      ```

##### Configure metadata (Event Provider)

11.	For "**Event provider Data Source**", *click* on "**Fixed value**" and make sure that "**Request - Body**" is *selected*
12.	For "**Path**", *copy* and *paste*:
      ```
      Game
      ```

##### Configure metadata (Event Type)

13.	For "**Event type data source**", *click* on "**Fixed value**" and make sure that "**Request - Body**" is *selected*
14.	For "**Path**", *copy* and *paste*:
      ```
      Action
      ```
15.    Leave "**Event category**" **empty*, it's optional and not needed for this training lab.
##### Configure additional data (JSON Payloads)

16.	*Click* on "**Add data field**"
17.	For "**Data source**", make sure that "**Request - Body**" is *selected*
18.	For "**Field name**", *copy* and *paste*:
      ```
      rqBody
      ```
19.	For "**Path**", *copy* and *paste*:
      ```
      *
      ```

20.	*Click* on "**Add data field**"
21.	For "**Data source**", make sure that "**Response - Body**" is *selected*
22.	For "**Field name**", *copy* and *paste*:
      ```
      rsBody
      ```
23.	For "**Path**", *copy* and *paste*:
      ```
      *
      ```
**At the bottom of the screen, click "Save changes"**

### 1.2 Service Naming Rules

##### Create a Service Naming Rule for the intelligent traceing to be captured
1.	*Open* "**Settings Classic**"
2.	*Open* "**Server-side Service monitoring**" menu group
3.	*Click* on "**Service naming rules**" and add a new rule.
4.    For Rule name, *copy* and *paste*:
      ```
      Vegas Naming Rules
      ```
5.    For Service name format, *copy* and *paste*:
      ```
      {ProcessGroup:DetectedName}
      ```
6.    For Conditions name format, *select* **Detected process group name** from the dropdown
7.    Change matcher to **begins with**
8.    For "**value**", *copy* and *paste*:
      ```
      vegas
      ```
9.    *Click* "**Preview**"
10.    You will see the "**Process Group Detected Names**" are now showing as the "**New name*"" for the services. This is a typical step when working with *node.js* applications running from a single server.
11.    *Click* "**Save changes**" at the bottom of the screen

### *PLAY SOME OF THE VEGAS APPLICATIONS IN THE WEBSITE, ACTIVATE CHEATS FOR BIG WINS* ###
### *CAREFUL, CHEATERS NEVER PROSPER!* ###

### 1.3 Queries

##### Validate you have "**Business Events**"
1.	From the menu, *open* "**Notebooks**"
2.	*Click* on the "**+**" to add a new section
3.	*Click* on "**DQL**"
4.	*Copy* and *paste* the **query** - Change the **Game** to the one you are testing with surrounded by quotation marks:

      ```
      fetch bizevents
      | filter not(matchesphrase(rsBody, "healthy"))
      | sort timestamp desc 
      ```

### The Request and Response body are filled with valuable data, but it's still in JSON format ###
5. Change your DQL to this now:
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
