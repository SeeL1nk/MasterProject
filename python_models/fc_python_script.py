import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from tensorflow.keras.models import load_model
import sys

username = sys.argv[1]

data = pd.read_csv('allRecipes_users_data.csv', sep=';')

user_dict = {}

for index, row in data.iterrows():
    user_id = row['recipe_id']
    username = row['username']
    
    if user_id not in user_dict:
        user_dict[user_id] = [username]
    else:
        user_dict[user_id].append(username)

X = data[['username', 'recipe_id']]
y = data['rating']


encoder = OneHotEncoder(sparse_output=False, handle_unknown='ignore')
X_encoded = encoder.fit_transform(X[['recipe_id', 'username']])
X_encoded = pd.DataFrame(X_encoded, columns=encoder.get_feature_names_out(['recipe_id', 'username']))
X = pd.concat([X_encoded, X.drop(['recipe_id', 'username'], axis=1)], axis=1)

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)


myModel = load_model('myModel.h5')

# Prédiction pour de nouvelles données
new_data = pd.DataFrame({'username': ['arthur'], 'recipe_id': ['b7526c6b-560b-4000-a4da-9112bcaa657a']})
new_data_encoded = encoder.transform(new_data[['recipe_id', 'username']])
new_data_encoded = pd.DataFrame(new_data_encoded, columns=encoder.get_feature_names_out(['recipe_id', 'username']))
new_data_processed = pd.concat([new_data_encoded, new_data.drop(['recipe_id', 'username'], axis=1)], axis=1)
new_data_scaled = scaler.transform(new_data_processed)

# Prédiction
prediction = myModel.predict(new_data_scaled)
print("Prediction for user 'arthur' and recipe 'b7526c6b-560b-4000-a4da-9112bcaa657a':", prediction[0, 0])

recipesdata = pd.read_csv('allRecipes_diabetes_recipes.csv', sep = ';')

def nutrition_filter(cal_limit, fat_limit, sodium_limit, sugars_limit, protein_limit, cal, fat, sodium, sugars, protein):
    
    if cal_limit is not None:
        if cal > cal_limit:
            return True
    
    if fat_limit is not None:
        if fat > fat_limit:
            return True
    
    if sodium_limit is not None:
        if sodium > sodium_limit:
            return True
    
    if sugars_limit is not None:
        if sugars > sugars_limit:
            return True
    
    if protein_limit is not None:
        if protein > protein_limit:
            return True
    
    return False


def recommandation(username=None, cal_limit = None, fat_limit = None, sodium_limit = None, sugars_limit = None, protein_limit = None, n=10):
    
    
    recipes_not_rated_by_user = []    

    for recipe_id in user_dict:
        if username not in user_dict[recipe_id]:
            recipes_not_rated_by_user.append(recipe_id) 

    predictions = []
        
    for recipe_id in recipes_not_rated_by_user:
        new_data = pd.DataFrame({'username': [username], 'recipe_id': [recipe_id]})
        new_data_encoded = encoder.transform(new_data[['recipe_id', 'username']])
        new_data_encoded = pd.DataFrame(new_data_encoded, columns=encoder.get_feature_names_out(['recipe_id', 'username']))
        new_data_processed = pd.concat([new_data_encoded, new_data.drop(['recipe_id', 'username'], axis=1)], axis=1)
        new_data_scaled = scaler.transform(new_data_processed)
        prediction = myModel.predict(new_data_scaled)[0][0]

        predictions.append({"recipe_id": recipe_id, "prediction": prediction})


    predictions.sort(key=lambda x: x.get("prediction"), reverse=True)
        
    top_n_recommendations = predictions[:n]

    for prediction in top_n_recommendations:
        recipe_id = prediction.get("recipe_id","")
        pred = prediction.get("prediction", None)
        if pred is None:
            pred = prediction.get("score", None)
        recipedata = recipesdata[recipesdata['recipe_id'] == recipe_id]
        name = recipedata['name'].values[0]
        cal = recipedata['calories'].values[0]
        fat = recipedata['fat'].values[0]
        sodium = recipedata['sodium'].values[0]
        sugars = recipedata['sugars'].values[0]
        protein = recipedata['protein'].values[0]
        
        # Filtre
        
        if not nutrition_filter(cal_limit, fat_limit, sodium_limit, sugars_limit, protein_limit, cal, fat, sodium, sugars, protein):
            print(f"ID: {recipe_id} Estimation: {pred} Name: {name}")

print(recommandation(username = "arthur"))