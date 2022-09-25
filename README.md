# dbt-docker

A repository how to manage dbt projects and have the pushed in cloud docker repositories.

## Projects
Start each project using `dbt init`.

For consistency create in the project's directory `profiles`, and add also add in there `profiles.yml`.

```
$ dbt init dbt_project_3
$ cd dbt_project_3
$ mkdir profiles
$ touch profiles/profiles.yml
```

## Docker

Add every project in the `Dockerfile`, to make sure the project is included in the docker image.

```dockerfile
RUN mkdir dbt_project_3
COPY dbt_project_3 ./dbt_project_3
RUN ["dbt", "deps", "--project-dir", "./dbt_project_3"]
```

### Running a project locally
```bash
$  docker build -t <IMAGE_NAME>:<IMAGE_TAG> .
$  docker run <IMAGE_NAME>:<IMAGE_TAG> dbt run --project-dir ./<project_dir> --profiles-dir ./<project_dir>/profiles
```

## CI/CD
In this repo, GitHub actions to push to GCP Artifact registry and AWS ECR are included.
Checkout `.github` workflows, and fill in the required credentials as repository secrets.

Required credentials are:
### AWS
```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```
### GCP
```
GCP_CREDENTIALS (as json)
GCP_PROJECT_ID
```

## KubernetesPodOperator
When running this these dbt images in Airflow KubernetesPodOperator:
```python


```
