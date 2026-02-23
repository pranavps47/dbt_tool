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

Use the following SQL file to create:

External stages

Tables for the dataset

File:

snowflake_create_tables.sql

Run this file in Snowflake after completing the prerequisite setup.