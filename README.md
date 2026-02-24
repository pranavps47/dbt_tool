Project Setup Guide
1. Dataset Information

The dataset folder contains the required dataset downloaded from:

MovieLens 20M Dataset
https://grouplens.org/datasets/movielens/20m/

The dataset has been uploaded to the following S3 bucket:

s3://netflixmoviedatacsv/


2. Snowflake Prerequisites

Before loading the data, run the prerequisite SQL commands in Snowflake to:

Create a new user
Create a new database
Create a new schema

These steps prepare the Snowflake environment for this project.
refer to :snowflake_prereq_commands.sql

3. AWS Configuration
Option 1 – Using AWS Access Keys

Create a new IAM user in your AWS account with full access to S3.

Download the CSV file containing:
AWS Access Key ID
AWS Secret Access Key
These credentials will be required to create external stages in Snowflake pointing to the S3 bucket.
Recommended Option – Snowflake Storage Integration

A better and more secure approach is to use Snowflake Storage Integration instead of manually using AWS access keys. This avoids exposing credentials and follows best security practices.

4. Creating Stages and Tables in Snowflake

Use the following SQL file to create:External stages

Tables for the dataset File:
snowflake_create_tables.sql

Run this file in Snowflake after completing the prerequisite setup.

5. DBT setup
post this we need to setup DBT core locally
pip install dbt-core

# Install the adapter for your data warehouse
# For Snowflake:
pip install dbt-snowflake

# For BigQuery:
pip install dbt-bigquery

# For Redshift:
pip install dbt-redshift

# For PostgreSQL:
pip install dbt-postgres

Now create a virtual env in your project folder using these commands:
cd netflixdbt
virtualenv venv
venv\Scripts\activate

then run pip install dbt-snowflake==1.9.0 in venv as we need this specific version

then create root dbt folder which will store all the metadata using this command:
mkdir ~/.dbt

Now post this run dbt init netflix and choose snowflake as the databse
and then provide the necessary connection details
1.account-identifier
2.user created for this project
3.password for that role
4.role created for this project
5.default warehouse
6.defult database and schema
7.number of threads=1 for this project

if you want to change these info later change the profiles.yml file present in your root user folder inside .dbt folder

also install the dbttoolkit pycharm extensions from file>>settings>>plugins


6.DBT models
Is defined in a .sql file
Contains a single SELECT statement
Produces a table or view in your data warehouse
Can reference other models, creating a dependency graph

we keep the raw data as it is,but we create a staging env to replicate the raw data,then do our transformation on staging env

for this first create a .sql file in your models folder inside your project folder ,which in this case is netflix
and then run 
dbt run command in the netflix folder

this will run your tranformations present in your model folder
these transformation can then become view,table,incremental,ephemeral,material view based on how you want to store your transformation'
you can configure this indivually for each model/transformation by editing in dbt_project.yml present in netflix folder
which is our cases looks like:

  netflix:
    # Config indicated by + and applies to all files under models/example/
    example:
      +materialized: view
as mentioned in here:https://docs.getdbt.com/docs/build/materializations


now create more views in your staging env for all the tables present in your dataset

you can materialize the transformations in this way also:
models:
  netflix:
    +materialized: view
    dim:
      +materialized: table
    fct:
      +materialized: table

in our netflix project by default materialzation is view unless we mention explicitly,also in the above command see the indentation according to the directory structure

the main usp of dbt models is that you can reference the transformations already used in other env int his way:
{{ ref('src_movies')}}

if you want to run only one model at a time use this command
dbt run --model <model_file_name>

also if you change the type of materialization say from view to a table for any model it will delte the view and then create the table just by changing it in the dbt_project.yml