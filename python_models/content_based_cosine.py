import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity

df = pd.read_csv('allRecipes_diabetes_recipes.csv', sep= ';')
df = df.fillna(0)

data = df[['recipe_id', 'name', 'calories', 'fat', 'sodium', 'sugars', 'protein']]

# Normaliser les données pour éviter les biais dus à l'échelle
normalized_data = (data[['calories', 'fat', 'sodium', 'sugars', 'protein']] - data[['calories', 'fat', 'sodium', 'sugars', 'protein']].mean()) / (data[['calories', 'fat', 'sodium', 'sugars', 'protein']].std())

# Calculer la similarité cosinus entre les recettes basées sur les données nutritionnelles
cosine_sim_matrix = cosine_similarity(normalized_data)

def recommend_recipe(recipe_id, cosine_sim_matrix, data):
    # Obtenir l'index de la recette
    recipe_index = data[data['recipe_id'] == recipe_id].index[0]

    # Obtenir les scores de similarité cosinus pour la recette donnée
    similarity_scores = list(enumerate(cosine_sim_matrix[recipe_index]))

    # Trier les recettes en fonction des scores de similarité
    sorted_recipes = sorted(similarity_scores, key=lambda x: x[1], reverse=True)

    # Ignorer la recette elle-même
    sorted_recipes = sorted_recipes[1:]

    # Récupérer les indices des recettes recommandées
    recommended_recipe_indices = [index for index, _ in sorted_recipes]

    # Retourner les informations des recettes recommandées avec les scores de similarité
    recommended_recipes = data[['recipe_id', 'name']].iloc[recommended_recipe_indices]
    recommended_recipes['similarity_score'] = [score for _, score in sorted_recipes]

    return recommended_recipes

recipe_id = df['recipe_id'][0]

recommendations = recommend_recipe(recipe_id, cosine_sim_matrix, data)

print(f'Voici les recommandations pour la recette {recipe_id} : \n{recommendations}')
