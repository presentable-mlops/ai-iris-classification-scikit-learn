import mlflow
from src.config import load_params
from src.data import load_and_preprocess
from src.model import train_models

def main():

    # params = load_params()
    # X_train, X_test, y_train, y_test, iris = load_and_preprocess(params)
    # with mlflow.start_run(run_name="multi_model_training"):
    #     models = train_models(X_train, y_train, params)
    #     mlflow.log_params(params)
    #     # Save models, log artifacts, etc.

if __name__ == "__main__":
    main()