## Verify Setup & Quick Start Guide

Before we begin, let's verify that you can access the application and environments.

### 1. **Access Dynatrace University**
- [ ] *Open* [**university.dynatrace.com**](https://university.dynatrace.com)
- [ ] *Log in* with your **account credentials**
- [ ] *Open* the **Business Partner event** in the section **Upcoming events**

### 2. In your "**University Classroom**"
- [ ] *Navigate* to "**Environments**"
- [ ] Cick "**Open terminal**"
- [ ] You should see your Dynatrace dashboard beginning with "**dashboard.**"
- [ ] If this does not appear, *copy* and *paste* the following in your terminal to get your dashboard URL:
  ```
  kubectl get ingress -A 2>/dev/null || echo "No kubectl found"
  ```
- [ ] *Open* your Dynatrace Dashboard from the terminal URL

### 3. **Verify Dynatrace Dashboard**
- [ ] *Verify* **access** to your **Dynatrace Dashboard** from the University Terminal
- [ ] *Verify* **access** to your **Dynatrace Environment**
- [ ] *Verify* **access** to the **Dynatrace Vegas Application** through the Dashboard
