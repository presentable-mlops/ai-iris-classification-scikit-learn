import mlflow
from mlflow.models.signature import infer_signature
from mlflow.evaluate import evaluate
import pandas as pd
from src.config import load_params
from src.data import load_and_preprocess
from src.model import SKLEARN_MODELS

def main():
    params = load_params()
    X_train, X_test, y_train, y_test, iris = load_and_preprocess(params)
    comparison_results = {}
    for model_name, cfg in params["models"].items():
        estimator_cls = SKLEARN_MODELS[cfg["estimator"]]
        # Load best params from training (could be saved to file, here just use defaults)
        best_params = cfg.get("param_grid", {})
        model = estimator_cls(**{k: v[0] if isinstance(v, list) else v for k, v in best_params.items()}, random_state=params["data"]["random_state"])
        model.fit(X_train, y_train)
        with mlflow.start_run(run_name=f"eval_{model_name}"):
            signature = infer_signature(X_test, model.predict(X_test))
            mlflow.sklearn.log_model(model, "model", signature=signature)
            model_uri = mlflow.get_artifact_uri("model")
            result = mlflow.evaluate(
                model_uri,
                X_test.assign(label=y_test),
                targets="label",
                model_type="classifier",
                evaluators=["default"],
            )
            comparison_results[model_name] = result.metrics
            mlflow.log_metrics({
                "accuracy": result.metrics["accuracy_score"],
                "f1": result.metrics["f1_score"],
                "roc_auc": result.metrics.get("roc_auc", 0),
                "precision": result.metrics["precision_score"],
                "recall": result.metrics["recall_score"],
            })
    comparison_df = pd.DataFrame(comparison_results).T
    print("Model Comparison Summary:")
    print(comparison_df[["accuracy_score", "f1_score", "roc_auc"]].round(3))
    best_model = comparison_df["f1_score"].idxmax()
    print(f"\nBest model by F1 score: {best_model}")

if __name__ == "__main__":
    main()