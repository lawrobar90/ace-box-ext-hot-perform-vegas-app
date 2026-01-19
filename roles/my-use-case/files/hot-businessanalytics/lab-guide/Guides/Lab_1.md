# Lab 1: Basic configuration and exploration 

This lab will show you how to *create* and *validate* **business rules**. 

## 1.1 OneAgent rule Configuration

Configure
- [ ] *Click* on the "**Apps Drawer**" on your Dynatrace tenant, and search for "**Settings**" and open
- [ ] *Open* "**Collect and capture**" sidebar tab
- [ ] *Click* on "**Business events**"
- [ ] *Click* on "**Incoming**"
- [ ] *Click* on "**Add new capture rule**" on the **incoming** tab
- [ ] For field "**Rule name**", *copy* and *paste*:

```
Vegas Application
```

- [ ] *Click* on "**Add trigger**"
- [ ] For "**Data source**", *select* "**Request - Body**"
- [ ] For "**Operator**", *select* "**exists**"
- [ ] For "**Path**", *copy* and *paste*:

```
Game
```

- [ ] For "**Event provider**", *change* "**Data source**" to "**Request - Body**"
- [ ] For "**Path**", *copy* and *paste*:
```
Game
```

##### Configure metadata (Event Type)

- [ ] For "**Event type**", *change* "**Data source**" to "**Request - Body**"
- [ ] For "**Path**", *copy* and *paste*:

```
Action
```

- [ ] Leave "**Event category**" **empty*, it's optional and not needed for this training lab.
##### Configure additional data (JSON Payloads)
- [ ] *Click* on "**Add data field**"
- [ ] For "**Data source**", make sure that "**Request - Body**" is *selected*
- [ ] For "**Field name**", *copy* and *paste*:
  
```
rqBody
```
  
- [ ] For "**Path**", *copy* and *paste*:
  
```
*
```

- [ ] *Click* on "**Add data field**"
- [ ] For "**Data source**", make sure that "**Response - Body**" is *selected*
- [ ] For "**Field name**", *copy* and *paste*:
  
```
rsBody
```
  
- [ ] For "**Path**", *copy* and *paste*:
  
```
*
```
  
**At the bottom of the screen, click "Save changes"**

## 1.2 Service Naming Rules

##### Create a Service Naming Rule for the intelligent traceing to be captured
- [ ] On the same screen, *Click* "**Server-side Service monitoring**" from the left *Navigation Panel*
- [ ] *Click* on "**Service naming rules**" and add a new rule.
- [ ] For "**Rule name**", *copy* and *paste*:
  
```
Vegas Naming Rules
```
  
- [ ] For "**Service name format**", *copy* and *paste*:
  
```
{ProcessGroup:DetectedName}
```
  
- [ ] For "**Conditions**", *select* **Detected process group name** from the dropdown
- [ ] Change matcher to **begins with**
- [ ] For "**value**", *copy* and *paste*:
  
```
vegas
```
  
- [ ] *Click* "**Preview**"
- [ ] You will see the "**Process Group Detected Names**" are now showing as the "**New name**" for the services instead of "**dynatrace-vegas-casino**". This is a typical step when working with *node.js* applications running from a single server.
- [ ] *Click* **Create Rule**"
- [ ] *Click* "**Save changes**" at the bottom of the screen

### *PLAY SOME OF THE VEGAS APPLICATIONS IN THE WEBSITE, ACTIVATE CHEATS FOR BIG WINS* ###
### *CAREFUL, CHEATERS NEVER PROSPER!* ###

### 1.3 Queries

##### Validate you have "**Business Events**"
- [ ] From the menu, *open* "**Notebooks**"
- [ ] *Click* "**+ Notebook**" at the top left of this screen
- [ ] *Click* on the "**+**" to add a new section
- [ ] *Click* on "**DQL**"
- [ ] *Copy* and *paste* the **query** - Change the **Game** to the one you are testing with surrounded by quotation marks:

```
fetch bizevents
| filter not(matchesphrase(rsBody, "healthy"))
| sort timestamp desc 
```

### The Request and Response body are filled with valuable data, but it's still in JSON format ###
- [ ] Change your DQL to this now:
  
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
