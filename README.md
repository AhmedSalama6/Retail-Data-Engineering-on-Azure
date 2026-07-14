# Retail Data Engineering Pipeline on Microsoft Azure

## Overview

This project demonstrates an end-to-end cloud data engineering solution built on Microsoft Azure. The pipeline ingests raw retail data, performs cleaning and transformation using PySpark, stores analytics-ready data in Parquet format, loads a Star Schema into Azure Synapse Dedicated SQL Pool, and visualizes business insights using Power BI.

---

## Architecture

<p align="center">
<img src="Architecture/Project_arch.png" width="900">
</p>

---

## Technologies

- Azure Synapse Analytics
- Azure Data Lake Storage Gen2
- PySpark
- Azure Synapse Pipelines
- Azure Synapse Dedicated SQL Pool
- SQL
- Power BI

---

## Pipeline

CSV Files

↓

Azure Data Lake (Raw)

↓

PySpark Transformation

↓

Parquet (Curated)

↓

Star Schema

↓

Power BI Dashboard

<p align="center">
<img src="Pipeline/Pipeline.png" width="900">
</p>
---

## Project Structure

- Notebook
- SQL Scripts
- Pipeline
- Power BI Dashboard
- Architecture

---

## Dashboard
<p align="center">
<img src="PowerBI/Dashboard 1.png" width="900">
</p>

<p align="center">
<img src="PowerBI/Dashboard 2.png" width="900">
</p>

<p align="center">
<img src="PowerBI/Dashboard 3.png width="900">
</p>


---

## Features

- End-to-End Azure Data Pipeline
- Automated ETL using Synapse Pipelines
- Data Cleaning using PySpark
- Star Schema Data Warehouse
- Interactive Power BI Dashboard
- Parquet-based Analytics Layer
