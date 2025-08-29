import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns


data = pd.read_csv("Baseball.csv")
print(data.head(10))


avg_height_by_year = (
    data.groupby("yearID")["avg_height"]
    .mean()
    .reset_index()
)

plt.figure(figsize=(10,6))
sns.lineplot(
    data=avg_height_by_year, 
    x="yearID", 
    y="avg_height", 
    marker="o"
)
plt.xlabel("Year")
plt.ylabel("Average Height (Inches)")
plt.title("Average Height by Year")
plt.show()


avg_weight_by_year = (
    data.groupby("yearID")["avg_height"]
    .mean()
    .reset_index()
)

plt.figure(figsize=(10,6))
sns.lineplot(
    data=avg_weight_by_year, 
    x="yearID", 
    y="avg_weight", 
    marker="o"
)
plt.xlabel("Year")
plt.ylabel("Average Weight (LBs)")
plt.title("Average Weight by Year")
plt.show()