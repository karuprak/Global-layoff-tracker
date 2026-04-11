import snowflake.connector
import os

# Go to your project folder
os.chdir(r'C:\Users\click\OneDrive\Desktop\layoff-tracker')

# Connect to Snowflake
conn = snowflake.connector.connect(
    user      = 'PrakashKarunanithi',        # ← your Snowflake signup email
    password  = 'SaroJa@1234567',     # ← your Snowflake password
    account   = 'cinycpf-cj86209',   # ✅ already filled in!
    warehouse = 'COMPUTE_WH',
    database  = 'LAYOFF_DB',
    schema    = 'RAW'
)

print("✅ Connected to Snowflake!")

cursor = conn.cursor()

# Upload CSV to the stage (loading dock)
cursor.execute(
    "PUT file://C:/Users/click/OneDrive/Desktop/layoff-tracker/data/layoffs.csv @layoff_stage AUTO_COMPRESS=TRUE OVERWRITE=TRUE"
)

print("✅ File uploaded to stage successfully!")

cursor.close()
conn.close()
print("✅ All done!")

