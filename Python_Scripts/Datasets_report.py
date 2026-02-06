# missing_value_report.py
import os
import pandas as pd

# -------------------------------
# 1. Load datasets
# -------------------------------
datasets = {
    "Sales": "../Datasets/Raw_Data/Sales.xlsx",
    "Customers": "../Datasets/Raw_Data/customers.xlsx",
    "Products": "../Datasets/Raw_Data/Products.xlsx",
    "Stores": "../Datasets/Raw_Data/Stores.xlsx",
    "Exchange_Rates": "../Datasets/Raw_Data/Exchange_Rates.xlsx"
}

# -------------------------------
# 2. Create Reports folder if not exists
# -------------------------------
reports_dir = "../Datasets_Reports"
if not os.path.exists(reports_dir):
    os.makedirs(reports_dir)

# -------------------------------
# 3. Function to clean dataframe
# -------------------------------
def clean_dataframe(df):
    # Strip leading/trailing spaces from string/object columns
    for col in df.select_dtypes(include=['object', 'string']):
        df[col] = df[col].str.strip()
    
    # Replace empty strings with NaN
    df.replace("", pd.NA, inplace=True)
    
    return df

# -------------------------------
# 4. Function to generate missing value report
# -------------------------------
def missing_value_report(df, df_name="", save=True):
    df = clean_dataframe(df)
    
    # Generate report
    report = pd.DataFrame({
        "Column Name": df.columns,
        "Missing Count": df.isna().sum().values,
        "Missing Percentage": (df.isna().mean() * 100).round(2)
    })
    
    # Add recommendation
    def recommendation(row):
        if row["Missing Percentage"] > 50:
            return "Drop / Investigate"
        elif row["Missing Percentage"] > 5:
            return "Impute / Investigate"
        else:
            return "Keep"
    
    report["Recommendation"] = report.apply(recommendation, axis=1)
    
    # Save to Excel
    if save:
        output_path = os.path.join(reports_dir, f"{df_name}_Report.xlsx")
        report.to_excel(output_path, index=False)
        print(f"Report saved: {output_path}")
    
    return report

# -------------------------------
# 5. Loop through all datasets
# -------------------------------
all_reports = {}
for name, path in datasets.items():
    if os.path.exists(path):
        df = pd.read_excel(path, keep_default_na=True)
        all_reports[name] = missing_value_report(df, df_name=name, save=True)
    else:
        print(f"File not found: {path}")
