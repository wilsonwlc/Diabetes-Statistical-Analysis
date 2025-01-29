# Logistic Regression - Risk Prediction for Diabetes

## Project Description
To better understand the relationship between lifestyle factors and diabetes in the US, the likelihood of diabetes (including pre-diabetes) based on healthcare statistics and lifestyle survey information is predicted using logistic regression. 

## Dataset Information
### Target
* Diabetes_binary: 0 = no diabetes; 1 = pre-diabetes or diabetes
### Features
1.	`HighBP`: 0 = no high blood pressure; 1 = high blood pressure
2.	`HighChol`: 0 = no high cholesterol; 1 = high cholesterol
3.	`CholCheck`: 0 = no cholesterol check in 5 years; 1 = cholesterol check in 5 years
4.	`BMI`: Body Mass Index (integer)
5.	`Smoker`: 0 = no; 1 = yes
6.	`Stroke`: 0 = no; 1 = yes
7.	`HeartDiseaseorAttack`: 0 = no; 1 = yes
8.	`PhysActivity`: 0 = no; 1 = yes
9.	`Fruits`: 0 = no; 1 = yes (consume fruit daily)
10.	`Veggies`: 0 = no; 1 = yes (consume vegetables daily)
11.	`HvyAlcoholConsump`: 0 = no; 1 = yes (heavy alcohol consumption)
12.	`AnyHealthcare`: 0 = no; 1 = yes (healthcare coverage)
13.	`NoDocbcCost`: 0 = no; 1 = yes (couldn’t see doctor due to cost)
14.	`GenHlth`: General health (scale 1-5, from excellent to poor)
15.	`MentHlth`: Days in the past month with poor mental health (1-30)
16.	`PhysHlth`: Days in the past month with poor physical health (1-30)
17.	`DiffWalk`: 0 = no; 1 = yes (difficulty walking)
18.	`Sex`: 0 = female; 1 = male
19.	`Age`: Age in categories (1-13, from 18-24 to 80+)
20.	`Education`: Education level (1-6, from no school to college graduate)
21.	`Income`: Income level (1-8, from <$10,000 to $75,000+)

## Project Structure
* **Dataset**: `diabetes_binary_5050split_health_indicators_BRFSS2015.csv`
* **Analysis**: `main.ipynb` (Jupyter Notebook for analysis)

## Data Preprocessing
### Feature Engineering
1. Creat a new variable `cvd` representing the cardiovascular diseases including high blood pressure `HighBP`, high cholesterol `HighChol`, stroke `Stroke`, coronary heart disease (CHD), and myocardial infarction (MI) `HeartDiseaseorAttack`. 
2. Perform logarithmic transformation and truncation on `BMI`
3. To avoid recall bias, all of the perceived health i.e. `GenHlth`, `MentHlth`, `PhysHlth` are not selected. 
4. Create a new variable `healthy_diet` which combines `Fruits` and `Veggies` and represents whether the person has a healthy diet
5. Not select any variables related to financial difficulty `AnyHealthcare`, `NoDocbcCost` because `Income` already reflect the difficulty


## Modeling Approach
A logistic regression model was fitted with the following formula:
`Diabetes_binary` ~ `CholCheck` + `BMI` + `Smoker` + `PhysActivity` + `HvyAlcoholConsump` + `DiffWalk` + `Sex` + `Age` + `Education` + `Income` + `cvd` + `healthy_diet`

Backward selection using AIC was applied to simplify the models. Evaluation was done using a confusion matrix, AUC and accuracy.

## Results
The following variables showed significant result: 
`CholCheck`, `BMI`, `Smoker`, `PhysActivity`, `HvyAlcoholConsump`, `DiffWalk`, `Sex`, `Age over 30`, `Income over $20k`, `cvd`

