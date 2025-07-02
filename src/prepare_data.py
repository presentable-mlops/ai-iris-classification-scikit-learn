from src.config import load_params
from src.data import load_and_preprocess
import pandas as pd
import os

def main():
    params = load_params()
    X_train, X_test, y_train, y_test = load_and_preprocess(params)
    os.makedirs("data/processed", exist_ok=True)
    X_train.to_csv("data/processed/X_train.csv", index=False)
    X_test.to_csv("data/processed/X_test.csv", index=False)
    y_train.to_csv("data/processed/y_train.csv", index=False)
    y_test.to_csv("data/processed/y_test.csv", index=False)

if __name__ == "__main__":
    main()