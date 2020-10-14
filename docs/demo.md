# Tanzu End 2 End Demo

Generally follow the [script](https://github.com/Pivotal-Field-Engineering/tanzu-gitops/blob/gtm-e2e-demo/SCRIPT.md) from the end to end team.

## Traffic Generator

Ensure you are running the traffic generator from [Step 11](11-load-generation.md).

## Open the following tabs in your browser

1. **Pet Clinic App**: Introduce the application.
2. **Github Source Code**: Make an edit to the app and commit, trigging pipeline.
3. **Concourse Pipeline (petclinic pipeline)**: Show the pipeline and review the steps in the `c`ontinuous-integration` job. Move onto following steps, but come back after a time to show that the `continuous-deployment` job is executing, and describe those steps.  Including the event push to Tanzu Observability.
4. **Harbor (Spring Pet Clinic Project)**: Show comment in the drop of vulnerabilities in the second image.  Drill down into the vulnerabilities and show the project configuration preventing pulls.  
5. **Kubeapps (petclinic namespace)**: Show the catalog, show the details of the deployed mysql db that serves petclinic.
6. **Octant (petclinic namespace)**: Show the application tab to give indications of the developer experience, check out the pod level information as well, like logs or exec into container.
7. **Tanzu Observability (Pet Clinic Custom Dashboard)**: Show the customized dashboard.  Check out the event that now appears on in the charts.  Don't forget to set the `Show Events` setting to `From Dashboard Settings`.
8. **Tanzu Mission Control**: Show the workload cluster, highlight visibility into workloads, show data protection, and then link into Tanzu Observability to show cluster level metrics.
9. **Tanzu Application Catalog (MySql Helm Details)**: Discuss how the selection of apps in Kubeapps was curated and how you have visibility into security, functional, and license scans.

At this point the pipeline should be complete you and can check out updated spring pet clinic application.