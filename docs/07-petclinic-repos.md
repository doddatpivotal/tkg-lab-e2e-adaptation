# Setup Spring Pet Clinic code and config repositories

You will need to setup two repositories.

## Spring Pet Clinic Source Code Repo

The sample application is based upon Spring Pet Clinic canonical app, with adjustments made to add Tanzu Observability integration.

You can choose to fork, my repo [https://github.com/doddatpivotal/spring-petclinic](https://github.com/doddatpivotal/spring-petclinic) which may grow stale and be done with it.

Or you could fork the Spring Project's repo [https://github.com/spring-projects/spring-petclinic](https://github.com/spring-projects/spring-petclinic) and make the appropriate adjustments.

1. Add following to spring petclinic pom.xml

```xml
  ...
  <properties>
    ...
    <wavefront.version>2.1.0-SNAPSHOT</wavefront.version>
    <spring-cloud.version>2020.0.0-M6</spring-cloud.version>
  </properties>
  ...
  <dependencyManagement>
    <dependencies>
      <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-dependencies</artifactId>
        <version>${spring-cloud.version}</version>
        <type>pom</type>
        <scope>import</scope>
      </dependency>
      <dependency>
        <groupId>com.wavefront</groupId>
        <artifactId>wavefront-spring-boot-bom</artifactId>
        <version>${wavefront.version}</version>
        <type>pom</type>
        <scope>import</scope>
      </dependency>
    </dependencies>
  </dependencyManagement>
  ...
  <dependencies>
  ...
    <dependency>
      <groupId>com.wavefront</groupId>
      <artifactId>wavefront-spring-boot-starter</artifactId>
    </dependency>
    <dependency>
      <groupId>org.springframework.cloud</groupId>
      <artifactId>spring-cloud-starter-sleuth</artifactId>
    </dependency>
  ...
  </depenencies>
  ...
```

2. Update PetclinicIntegrationTests.java

```java
import org.springframework.test.context.ActiveProfiles;
@ActiveProfiles("test")
```

3. Add test profile properties `/src/test/resources/application-test.properties`

```
management.metrics.export.wavefront.enabled=false
management.metrics.export.wavefront.apiToken=foo
```

## Spring Pet Clinic Kubernetes Config Repo

- Config Repo: Fork [https://github.com/doddatpivotal/spring-petclinic-config](https://github.com/doddatpivotal/spring-petclinic-config)

- If using the GitOps (ArgoCD) based approach make sure your config repo has the `/argocd` folder. Example in [https://github.com/jaimegag/spring-petclinic-config](https://github.com/jaimegag/spring-petclinic-config)

## Go to Next Step

[Create Concourse Pipeline for Spring Pet Clinic](08-petclinic-pipeline.md)

If using the GitOps (ArgoCD) go to [Create ArgoCD Pipeline for Spring Pet Clinic](08-petclinic-pipeline-gitops.md)
