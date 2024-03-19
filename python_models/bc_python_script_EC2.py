import pandas as pd
import numpy as np
from sklearn.preprocessing import MinMaxScaler
from tensorflow.keras.models import load_model
import sys

recipe_id = sys.argv[1]

# Charger les données
data = pd.read_csv("allRecipes_diabetes_recipes.csv", delimiter=";")
data.dropna(inplace=True)
X = data[['calories', 'fat', 'sodium', 'sugars', 'protein']].values
features = ['calories', 'fat', 'sodium', 'sugars', 'protein']

# Normaliser les données
scaler = MinMaxScaler()
X_normalized = scaler.fit_transform(X)

# Charger le modèle sauvegardé
loaded_model = load_model("model_bc1.h5")

def recommend_similar_recipes(recipe_id, top_n=5):
    # Rechercher les caractéristiques de la recette correspondant à recipe_id
    recipe_features = data[data['recipe_id'] == recipe_id][features].values
    
    if len(recipe_features) == 0:
        print("Recipe ID non valide.")
        return
    
    # Normaliser les caractéristiques de la recette
    recipe_features_normalized = scaler.transform(recipe_features.reshape(1, -1))
    
    # Utiliser le modèle chargé pour prédire les caractéristiques de la recette
    predicted_features = loaded_model.predict(recipe_features_normalized)
    
    # Calculer la similarité entre la recette donnée et toutes les autres recettes
    similarities = np.linalg.norm(predicted_features - X_normalized, axis=1)
    
    # Trier les recettes en fonction de leur similarité avec la recette donnée (ordre croissant)
    sorted_indices = similarities.argsort()
    
    # Exclure la recette donnée elle-même de la recommandation
    sorted_indices = sorted_indices[sorted_indices != 0]
    
    # Obtenir les indices des recettes recommandées
    recommended_indices = sorted_indices[:top_n]
    
    # Obtenir les IDs des recettes recommandées
    recommended_recipe_ids = data.iloc[recommended_indices]['recipe_id']
    
    return recommended_recipe_ids

# Exemple d'utilisation : recommander des recettes similaires à une recette donnée
recipe_id_to_recommend = recipe_id  # Remplacez ceci par l'ID de la recette pour laquelle vous souhaitez des recommandations
recommended_recipe_ids = recommend_similar_recipes(recipe_id_to_recommend)
print("Recettes recommandées pour la recette avec l'ID {} :".format(recipe_id_to_recommend))
print(recommended_recipe_ids)