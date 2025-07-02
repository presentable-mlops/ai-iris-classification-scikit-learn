from sklearn.naive_bayes import GaussianNB
from sklearn.tree import DecisionTreeClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import GridSearchCV

def train_models(X_train, y_train, params):
    models = {
        "knn": (
            KNeighborsClassifier(),
            {
                "n_neighbors": range(1, 21),
                "weights": ["uniform", "distance"],
                "metric": ["euclidean", "manhattan"]
            }
        ),
        "dtree": (
            DecisionTreeClassifier(random_state=params["data"]["random_state"]),
            {
                "max_depth": [3, 5, 7, 10, None],
                "min_samples_split": [2, 5, 10],
                "min_samples_leaf": [1, 2, 4]
            }
        ),
        "gnb": (
            GaussianNB(),
            {
                "var_smoothing": [1e-9, 1e-8, 1e-7, 1e-6, 1e-5]
            }
        )
    }

    best_models = {}

    for name, (model, grid) in models.items():
        search = GridSearchCV(model, grid, cv=params["data"]["cv_folds"], n_jobs=-1)
        search.fit(X_train, y_train)
        best_models[name] = search

    return best_models
