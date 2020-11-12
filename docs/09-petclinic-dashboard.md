# Create TO Wavefront Dashboard

1. Within Tanzu Observability, access the Dynamically Generated Application Dashboard for Spring Pet Clinic.  Application -> Application Status

2. Click on your Application, click on the petclinic service.  You now see the dynamically generated dashboard.

3. Clone the dashboard

4. Click "Settings" followed by "Advanced"

5. Add the following events query `events(name="DEPLOY_EVENT_NAME")`

>Note: The DEPLOY_EVENT_NAME value above is from `yq r $PARAMS_YAML petclinic.wavefront.deployEventName`

6. Save the dashboard and name it something specific to your user name.  I chose `dpfeffer-petclinic-dashboard`.

7. In your dashboard at the top right where it says "Show Events" change it to "From Dashboard Settings". This will cause your events query to be the source of events for all charts in your dashboard.

## Go to Next Step

[Update TBS Stack to Remediate CVEs](10-tbs-stack-update.md)