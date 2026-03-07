title1 "Data checking";
/* Import data */
proc import datafile="/home/u46099885/data/diabetes_binary_5050split_health_indicators_BRFSS2015.csv"
out=df0
dbms=csv
replace;
run;

title2 "Dimension & data type";
proc contents data=df0;
run;

title2 "Missing values";
proc means data=df0 N NMISS;
run; 
title;



title1 "Data exploration";
/* Data cleansing */
proc format;
value genhlth_gp
1 = "(1) Excellent"
2 = "(2) Very Good"
3 = "(3) Good"
4 = "(4) Fair"
5 = "(5) Poor";
value age_gp
1 = "(01) 18-24"
2 = "(02) 25-29"
3 = "(03) 30-34"
4 = "(04) 35-39"
5 = "(05) 40-44"
6 = "(06) 45-49"
7 = "(07) 50-54"
8 = "(08) 55-59"
9 = "(09) 60-64"
10 = "(10) 65-69"
11 = "(11) 70-74"
12 = "(12) 75-79"
13 = "(13) 80 or older";
value education_gp
1 = "(1) Never attended school or only kindergarten"
2 = "(2) Elementary"
3 = "(3) Some high school"
4 = "(4) High school graduate"
5 = "(5) Some college or technical school"
6 = "(6) College graduate";
value income_gp
1 = "(1) Less than $10k"
2 = "(2) 10k to less than 15k"
3 = "(3) 15k to less than 20k"
4 = "(4) 20k to less than 25k"
5 = "(5) 25k to less than 35k"
6 = "(6) 35k to less than 50k"
7 = "(7) 50k to less than 75k"
8 = "(8) $75k or more";
run;
data df0;
set df0(rename=(genhlth=genhlth_num age=age_num education=education_num income=income_num));
genhlth = put(genhlth_num, genhlth_gp.);
age = put(age_num, age_gp.);
education = put(education_num, education_gp.);
income = put(income_num, income_gp.);
run;
%let target = Diabetes_binary;
%let var_continuous = BMI MentHlth PhysHlth;
proc contents data=df0 out=df0_metadata varnum; run;
proc sql noprint; 
select name into :var_discrete separated by ' '  
from df0_metadata
where name not in ("BMI", "MentHlth", "PhysHlth", "&target") and name not like '%_num';  
quit;
%put Macro target has value: &target.;
%put Macro var_continuous has value: &var_continuous.;
%put Macro var_discrete has value: &var_discrete.;

title2 "Crosstab - Categorical variables";
proc freq data=df0 ;
tables (&var_discrete.)*&target. / nocol nopercent;
run;

title2 "Summary statistics - Continuous variables";
proc means data=df0 mean std min p25 median p75 max;
var &var_continuous.;
run;
title;



title1 "Hypothesis testing";
/* Data transformation */
proc format;
value hlth_gp
0 = '(1) 0'
1-7 = '(2) 1-7'
8-14 = '(3) 8-14'
15-21 = '(4) 15-21'
22-28 = '(5) 22-28'
29-30 = '(6) 29-30';
run;
data df0;
set df0;
PhysHlth_group = put(PhysHlth, hlth_gp.);
MentHlth_group = put(MentHlth, hlth_gp.);
run;
%let target = Diabetes_binary;
%let var_continuous = BMI;
proc contents data=df0 out=df0_metadata varnum; run;
proc sql noprint; 
select name into :var_discrete separated by ' '  
from df0_metadata
where name not in ("&var_continuous", "&target") 
and name not like '%_num' 
and name not in ("MentHlth", "PhysHlth");  
quit;
%put Macro target has value: &target.;
%put Macro var_continuous has value: &var_continuous.;
%put Macro var_discrete has value: &var_discrete.;

title2 "Chi square test";
proc freq data=df0;
tables (&var_discrete.)*&target. / chisq;
run;

title2 "t-test";
proc ttest data=df0;
class &target.;
var &var_continuous.;
run;
title;



title1 "Modelling";
/* Feature engineering */
proc means data=df0 noprint p99;
var BMI;
output out=BMI_pct p99=BMI_99;
run;
data _null_;
set BMI_pct;
call symputx('BMI_99', BMI_99);
run;
data df1;
set df0(where=(BMI < &BMI_99.));
if HighBP = 0 and HighChol = 0 and HeartDiseaseorAttack = 0 and Stroke = 0 then cvd = 0; else cvd = 1;
if Fruits = 0 and Veggies = 0 then healthy_diet = 0; else healthy_diet = 1;
BMI_log = log(BMI);
run;

title2 "Logistic regression";
/* Caution: these results differ from those obtained in R because analysing with SAS uses the full dataset */
proc logistic data=df1;
class 
cvd(ref='0') DiffWalk(ref='0') healthy_diet(ref='0') 
CholCheck(ref='0') Smoker(ref='0') PhysActivity(ref='0') 
HvyAlcoholConsump(ref='0') Sex(ref='0') 
age(ref="(01) 18-24") 
education(ref="(1) Never attended school or only kindergarten")
income(ref="(1) Less than $10k") / param=ref;
model Diabetes_binary(event='1') = CholCheck BMI_log Smoker PhysActivity HvyAlcoholConsump DiffWalk Sex
age education income cvd healthy_diet;
run;
title;



