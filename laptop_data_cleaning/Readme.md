# 💻 Laptop Data Cleaning

This project focuses on cleaning and preprocessing laptop data using SQL.

## 📋 Overview

The dataset used in this project contains information about laptops, including specifications such as screen size, CPU, RAM, storage, operating system, price, etc. The goal of this project is to clean and preprocess the dataset using SQL queries.

## 📁 Files

- [raw_data.csv](raw_data.csv): Original dataset before cleaning.
- [cleaned_data.csv](cleaned_data.csv): Dataset after applying data cleaning operations.
- [data_cleaning_script.sql](data_cleaning_script.sql): SQL script containing the data cleaning operations.

## 🛠️ Data Cleaning Operations

1. **Removing Unnecessary Columns:** The ALTER TABLE statements with DROP COLUMN were used to remove columns that were not needed for analysis, such as the Unnamed: 0 column.

2. **Standardizing Data Types:** The ALTER TABLE statements with MODIFY COLUMN were used to standardize data types. For example, converting the Inches column to a decimal format with one decimal place.

3. **Cleaning Text Data:** The UPDATE statements with REPLACE were used to clean text data. For example, removing the 'GB' and 'kg' units from the Ram and Weight columns, respectively.

4. **Rounding Numeric Data:** The UPDATE statements were used to round numeric data, such as rounding the Price column to the nearest integer.

5. **Normalization of Operating System Names:** The UPDATE statement with CASE was used to normalize operating system names in the OpSys column. Various OS names were mapped to standardized categories such as 'macos', 'windows', 'linux', and 'N/A'.

6. **Extracting and Splitting Data:** Various UPDATE statements were used with functions like SUBSTRING_INDEX and REGEXP_SUBSTR to extract and split data. For example, extracting GPU brand and name, extracting CPU brand and speed, and splitting screen resolution into width and height.

7. **Handling Missing Values:** While it's not explicitly shown in the provided SQL code, handling missing values is often an important data cleaning operation. This could involve identifying missing values and either filling them in using imputation techniques or removing rows with missing values, depending on the specific situation.

## 📝 Instructions

To replicate the data cleaning process:

1. Download or clone this repository to your local machine.
2. Open your preferred SQL environment (e.g., MySQL Workbench, DBeaver, etc.).
3. Execute the SQL script (`data_cleaning_script.sql`) to perform the data cleaning operations.
4. Verify the results by comparing the cleaned data with the raw data.

## 🔍 Data Source
[Kaggle Dataset Link](https://www.kaggle.com/datasets/ehtishamsadiq/uncleaned-laptop-price-dataset?rvi=1)

Feel free to explore the project and contribute to this repository!
