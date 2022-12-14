
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

### Running a project locally with Docker

```bash  
$ docker build -t <IMAGE_NAME>:<IMAGE_TAG> .$ docker run <IMAGE_NAME>:<IMAGE_TAG> dbt run --project-dir ./<project_dir> --profiles-dir ./<project_dir>/profiles
```

### Running a project locally just dbt
#### Optional - Start a virtual environment
```bash
$ python -m venv venv
$ source venv/bin/activate
```

#### Update credentials in <your_project_dir>/profiles/profiles.yml

#### Run dbt
```bash  
$ pip install -r requirements.txt
$ cd <your_project_dir>
$ dbt seed --profiles-dir ./profiles
$ dbt run --profiles-dir ./profiles
```  

## CI/CD
In this repo, GitHub actions to push to GCP Artifact registry and AWS ECR are already included.  
Checkout `.github` workflows, and fill in the required credentials as repository secrets.  Also you need to make sure the respective repositories exist in GCP or AWS already.

Required credentials are:

### For AWS
```  
AWS_ACCESS_KEY_ID  
AWS_SECRET_ACCESS_KEY  
```  
### For GCP
```  
GCP_CREDENTIALS (as json)  
GCP_PROJECT_ID  
```  

## KubernetesPodOperator
When running this these dbt images in Airflow `KubernetesPodOperator`:
```python  
  migrate_data = KubernetesPodOperator(
        namespace='default',
        image='europe-west1-docker.pkg.dev/PROJECT-ID/transformations-repository/dbt-transformations:latest',
        cmds=["dbt", "run"],
        arguments=[
            "--project-dir", "./<project_dir>", "--profiles-dir", "./<project_dir>/profiles"
        ],
        name="dbt_transformations",
        task_id="dbt_transformations",
        get_logs=True
    )
```