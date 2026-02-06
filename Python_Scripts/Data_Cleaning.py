# clean_all_datasets

import pandas as pd
import os

# -------------------------------
# 1. Paths
# -------------------------------
RAW_PATH = "../Datasets/Raw_Data/"
CLEAN_PATH = "../Datasets/Clean_Data/"
os.makedirs(CLEAN_PATH, exist_ok=True)

# List of datasets
DATASETS = {
    "Sales": "sales.xlsx",
    "Customers": "customers.xlsx",
    "Products": "products.xlsx",
    "Stores": "stores.xlsx",
    "Exchange_Rates": "Exchange_Rates.xlsx"
}

# -------------------------------
# 2. Functions
# -------------------------------

# --- Null Handling / Custom Cleaning ---
def clean_dataset(name, df):
    df_clean = df.copy()

    if name == "Customers":
        # Drop Delivery Date column
        if "ZIP_CODE" in df_clean.columns:
            df_clean.drop(columns=["ZIP_CODE"], inplace=True)
        else:
            print("ZIP_CODE IS NULL")

    # Protect COUNTRY_CODE explicitly
    if 'STATE_CODE' in df_clean.columns:
        df_clean['STATE_CODE'] = df_clean['STATE_CODE'].fillna('NA')
    
    if name == "Sales":
        # Drop Delivery Date column
        if "DELIVERY_DATE" in df_clean.columns:
            df_clean.drop(columns=["DELIVERY_DATE"], inplace=True)
        else:
            print("DELIVERY_DATE IS NULL")

    return df_clean

# --- Trim whitespace ---
def trim_strings(df):
    for col in df.select_dtypes(include=['object', 'string']):
        df[col] = df[col].str.strip()
    return df

# --- Standardize text columns ---
def standardize_strings(df):
    for col in df.select_dtypes(include=['object', 'string']):
        # Skip date columns just in case
        if 'date' in col.lower():
            continue

        df[col] = df[col].str.upper()

    # Standardize Yes/No columns if they exist
    yes_no_cols = [
        col for col in df.columns
        if df[col].dropna().astype(str).isin(['YES', 'NO']).all()
    ]
    for col in yes_no_cols:
        df[col] = df[col].str.upper()

    return df

# --- Standardize numeric columns ---
def standardize_numeric(df):
    for col in df.columns:
        # Only process object/string columns
        if df[col].dtype not in ['object', 'string']:
            continue

        # Skip date-like columns explicitly
        if 'date' in col.lower():
            continue

        # Clean numeric-looking strings
        cleaned = (
            df[col]
            .astype(str)
            .str.replace(',', '', regex=False)
            .str.replace('$', '', regex=False)
            .str.strip()
        )

        converted = pd.to_numeric(cleaned, errors='coerce')

        # Convert ONLY if majority of values are numeric
        if converted.notna().mean() > 0.6:
            df[col] = converted

    return df

# --- Standardize date columns ---
def standardize_dates(df):
    for col in df.columns:
        if 'date' in col.lower():
            df[col] = pd.to_datetime(df[col], errors='coerce').dt.date
    return df

# --- standardize column names ---
def standardize_column_names(df):
    df.columns = (
        df.columns
        .str.strip()
        .str.replace(' ', '_')
        .str.upper()
    )
    return df

# --- Full cleaning pipeline ---
def full_clean_dataset(name, df):
    df = standardize_column_names(df)   # HEADERS FIRST
    df = clean_dataset(name, df)
    df = trim_strings(df)
    df = standardize_strings(df)
    df = standardize_dates(df)
    df = standardize_numeric(df)
    return df

# -------------------------------
# 3. Run cleaning pipeline
# -------------------------------
if __name__ == "__main__":
    for name, file in DATASETS.items():
        file_path = os.path.join(RAW_PATH, file)
        if os.path.exists(file_path):
            df = pd.read_excel(file_path)
            clean_df = full_clean_dataset(name, df)

            # Save as CSV only
            clean_df.to_csv(os.path.join(CLEAN_PATH, f"{name}_Clean.csv"), index=False)

            print(f"{name} cleaned and saved as CSV: {clean_df.shape}")
        else:
            print(f"File not found: {file_path}")


