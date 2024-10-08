# Logistic Regression - Risk Prediction for Diabetes

## Project Description
To better understand the relationship between lifestyle factors and diabetes in the US. Using logistic regression, so the likelihood of diabetes (including pre-diabetes) based on healthcare statistics and lifestyle survey information is predicted

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

## Installation and Requirements
To run this project, you will need the following R packages: `glm2`, `ggplot2`, `forcats`, `dplyr`, `purrr`, `tidyr`, `caret`, `lmtest`, `pROC`, `MASS`

## Data Preprocessing
### Feature Engineering
1.	Created cvd (cardiovascular diseases) to combine high blood pressure, high cholesterol, stroke, coronary heart disease, and myocardial infarction.
2.	Created healthy_diet, combining Fruits and Veggies, to indicate if a person has a healthy diet.
3.	Only included PhysActivity. Excluded DiffWalk as difficulty walking could result from non-diabetes-related conditions.
4.	Only included NoDocbcCost; excluded Education due to weaker association with diabetes.
5.	To avoid recall bias, variables such as GenHlth were not selected.

## Modeling Approach
Two logistic regression models were fitted:

* Model 1 - a simple logistic regression model:
 `Diabetes_binary` ~ `cvd` + `Sex` + `Age` + `BMI` + `healthy_diet` + `PhysActivity` + `Smoker` + `HvyAlcoholConsump` + `NoDocbcCost`
* Model 2 - an interaction model with interaction terms:
`Diabetes_binary` ~ `cvd` + `Sex` + `Age` + `BMI` + `healthy_diet` + `PhysActivity` + `Smoker` + `HvyAlcoholConsump` + `NoDocbcCost` + `cvd:Sex` + `cvd:Age` + `cvd:BMI` + `cvd:healthy_diet` + `cvd:PhysActivity` + `cvd:Smoker` + `cvd:HvyAlcoholConsump` + `cvd:NoDocbcCost` + `Age:BMI` + `Age:PhysActivity` + `BMI:healthy_diet` + `BMI:PhysActivity`

The models were selected based on interpretability, complexity, and AIC. Evaluation was done using accuracy and a confusion matrix.

## Results
The following variables showed significant results in both models: `cvd`, `Sex`, `Age`, `BMI`, `healthy_diet`, `PhysActivity`, `Smoker`, `HvyAlcoholConsump`, and `NoDocbcCost`

## Future Work
* Improve the project with enhanced data visualization
* Explore fitting a neural network model for improved prediction

