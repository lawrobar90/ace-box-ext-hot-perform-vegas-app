## Lab 4: creating automation for security events

In this hands-on, we’ll be setting up this process using some existing building blocks! You will be capturing cheat logs, then using automation you will reduce the risk and increase revenue for your casino. 

### 4.1 Locking the users out
- [ ] Using the “**App drawer**” in the top-left of the screen (or the search) – *find* the "**Setting Classic**" app and *open* it.
- [ ] *Scroll down* to "**Preferences**" and *click* "**Limite outbound connections**"
- [ ] *Click* "**Add item**", then *copy* and *paste* the URL of your "**Vegas Application**":
It should looke like the below
   ```
   vegas.******-******-******-******-*****.dynatrace.training
   ```
- [ ] Click "**Save changes**"
- [ ] Using the “**App drawer**” in the top-left of the screen (or the search) – *find* the "**Workflows**" app and *open* it.
- [ ] *Click* "**+ Workflow**"
- [ ] In the first step, select "**On demand trigger**"
- [ ] Click the *+* underneath the trigger step, and choose "**Execute DQL Query**"
- [ ] Change the name of this step, *copy* and *paste*:
   ```
   get_cheaters
   ```
- [ ] In the "**DQL query section**", *copy* and *paste*:
   ```
   fetch bizevents, from:now()-15m
   | filter event.provider == "Vegas Casino Fraud Detection"
   | fields timestamp,
       event.provider,
       event.type,
       json.game,
       json.CustomerName, 
       json.cheatType,
       json.winAmount,
       json.Balance,
       json.CorrelationId,
       json.DetectionRisk,
       json.requires_investigation,
       json.BetAmount,
       json.multiplier,
       json.cheat_active,
       json.result, dt.openpipeline.pipelines
    | sort timestamp desc
    | filter json.CustomerName == "Your_UI_Username"
   ```
- [ ] Click the *+* underneath the *get_cheaters* step, and choose "**HTTP Request**"
- [ ] Change the name of this step, *copy* and *paste*:
   ```
   lock_user
   ```
- [ ] In the "**Method**", Select *POST*
- [ ] In the "**URL**", take the URL of the "**Vegas Casino App**", then add this to the end:
   ```
   /api/admin/lockout-user-cheat
   ```
- [ ] Your result should look like this - *https://vegas.841aedbc-af37-4e1b-a45d-ada915bf7498.dynatrace.training/api/admin/lockout-user-cheat*

- [ ] In the "**Payload**", *copy* and *paste*:
   ```
   {{ result("get_cheaters")["records"] | to_json }}
   ```
- [ ] Click the *+* underneath the *lock_user* step, and choose "**Run JavaScript**"
- [ ] Change the name of this step, *copy* and *paste*:
   ```
   create_bizevents_for_lockouts
   ```
- [ ] In the "**Source code**", *copy* and *paste*:
  
```js
import { execution } from '@dynatrace-sdk/automation-utils';
import { businessEventsClient } from '@dynatrace-sdk/client-classic-environment-v2';

export default async function ({ execution_id }) {
  const stepName = "lock_user";

  // Fetch lock_user result
  const r = await fetch(`/platform/automation/v1/executions/${execution_id}/tasks/${stepName}/result`);
  const raw = await r.json();

  const lockResult = raw?.json ? raw.json : (typeof raw === "string" ? JSON.parse(raw) : raw);
  const results = lockResult?.results || [];

  if (!results.length) {
    return { success: false, events_created: 0, message: "No lock_user results found", raw_response: lockResult };
  }

  // Build Dynatrace business events (flat schema)
  const bizevents = results
    .filter(r => r.success)
    .map((r, i) => ({
      id: `vegas-lock-${r.username}-${Date.now()}-${i}`,
      "event.provider": "vegas-casino-fraud-prevention",
      "event.type": "CheatReimbursed",
      user_locked: true,
      customer_name: r.username,
      cheat_violations: r.cheatViolations,
      winnings_confiscated: r.totalWinningsConfiscated,
      balance_before: r.balanceBefore,
      balance_after: r.balanceAfter,
      lock_reason: r.lockReason,
      detection_method: "lock_user_step_summary",
      timestamp: new Date().toISOString()
    }));

  // Log payload before sending
  console.log("Business events payload:", JSON.stringify(bizevents, null, 2));

  // Ingest into Dynatrace
  await businessEventsClient.ingest({
    type: "application/json",
    body: bizevents
  });

  return {
    success: true,
    events_created: bizevents.length,
    message: `Created ${bizevents.length} business events from ${results.length} lock_user results`,
    summary: lockResult?.summary || {}
  };
}
```

- [ ] *Click* "**Save Draft**", then *click* "**Deploy**", and finally "**Run**" the workflow to test it works.
- [ ] *Click the "**Setting Cog**" at the top right of the workflow, and *enable* "**Workflow Admin**".
- [ ] You will see Customers who are cheating, but likely will not see your name yet.

### Go back to the "**Vegas App**" and play some games with cheats enabled

- [ ] Go back to your notebook
- [ ] Add a new DQL, *copy* and *paste*:
      ```
      fetch bizevents
      | filter event.type == "CheatFound"
      | sort timestamp desc
      | fields timestamp,
             json.CustomerName, 
             json.cheatType,
             json.winAmount,
             json.Balance,
             json.CorrelationId,
             json.DetectionRisk,
             json.requires_investigation,
             json.BetAmount,
             json.multiplier,
             json.cheat_active
      ```
- [ ] When you see your *customer_name*, go back to the workflow you just created and "**Run**"
- [ ] Go back to your notebook
- [ ] Add a new DQL, *copy* and *paste*:
```
      fetch bizevents
      | filter event.provider == "vegas-casino-fraud-prevention"
      | sort timestamp desc
      | fields timestamp,
            cheat_violations,
            customer_name,
            winnings_confiscated,
            detection_method,
            balance_after,
            lock_reason,
            user_locked,
            event.type
```
- [ ] Go back into your Vegas Casino UI, and you should have an "**Account Locked**" message with a full red background.
- [ ] You are now deemed to be a cheater, thrown out of the hotel and have a cirminal record.... Well done!
