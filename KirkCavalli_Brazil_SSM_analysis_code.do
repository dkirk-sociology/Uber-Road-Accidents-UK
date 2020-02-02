/*******************************************************************************
Code for models used in the following article:

Kirk, David S., Nicolo Cavalli, and Noli Brazil. 2020. “The Implications of 
Ridehailing for Risky Driving and Road Accident Injuries and Fatalities.” 
Social Science & Medicine. https://doi.org/10.1016/j.socscimed.2020.112793.

* Last updated: 17 Nov 2019
*******************************************************************************/


use "C:\KirkCavalliBrazil_SSM2020_Data.dta"

*** may need to set matsize
set matsize 3000


** TABLE 1 - Summary statistics
sum Number_of_Casualties Casualties_Slight Casualties_Serious Casualties_Fatal  
sum Uber_rollout unemp pop100k TaxiPHVsPopulation100 gasprice_pounds CRASH_rollout TrafficMiles_AllVehicles_monthly TrafficMiles_AllVehicles_yearly vehicle_pop


** TABLE 2: main results ** 
eststo clear
foreach var of varlist Number_of_Casualties Casualties_Slight Casualties_Serious Casualties_Fatal {
eststo: nbreg `var'  Uber_rollout i.lad16nm_id i.Year i.Month unemp pop100k TaxiPHVsPopulation100 gasprice_pounds CRASH_rollout, exposure(TrafficMiles_AllVehicles_monthly) cluster(LicensingArea_name) irr
}
esttab using "`c(current_date)'_table2", star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace se


** TABLE 3, column 1: capped injuries at max 10 per accident 
eststo clear
foreach var of varlist Cap_Casualties Cap_Casualties_Slight Cap_Casualties_Serious Cap_Casualties_Fatal {
eststo: nbreg `var' Uber_rollout i.lad16nm_id i.Year i.Month unemp pop100k TaxiPHVsPopulation100 gasprice_pounds CRASH_rollout, exposure(TrafficMiles_AllVehicles_monthly) cluster(LicensingArea_name) irr
}
esttab using "`c(current_date)'_table3_robustness_capped", star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace se


** TABLE 3, column 2: weekends ** 
eststo clear
foreach var of varlist Casualties_weekend Casualties_Slight_weekend Casualties_Serious_weekend Casualties_Fatal_weekend {
eststo: nbreg `var'  Uber_rollout i.lad16nm_id i.Year i.Month unemp pop100k TaxiPHVsPopulation100 gasprice_pounds CRASH_rollout, exposure(TrafficMiles_AllVehicles_monthly) cluster(LicensingArea_name) irr
}
esttab using "`c(current_date)'_table3_robustness_weekend", star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace se


** TABLE 3, column 3: local authorities with > 100K population (as of 2009) ** 
eststo clear
foreach var of varlist Number_of_Casualties Casualties_Slight Casualties_Serious Casualties_Fatal {
eststo: nbreg `var' Uber_rollout i.lad16nm_id i.Year i.Month unemp pop100k TaxiPHVsPopulation100 gasprice_pounds CRASH_rollout if popidentifier>100000, exposure(TrafficMiles_AllVehicles_monthly) cluster(LicensingArea_name)
}
esttab using "`c(current_date)'_table3_robustness_pop100k", star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace se


** Table 4: Categorical measure of Uber
eststo clear
foreach var of varlist Number_of_Casualties Casualties_Slight Casualties_Serious Casualties_Fatal {
eststo: nbreg `var'  i.Uber_cat_1month i.lad16nm_id i.Year i.Month unemp pop100k TaxiPHVsPopulation100 gasprice_pounds CRASH_rollout, exposure(TrafficMiles_AllVehicles_monthly) cluster(LicensingArea_name) irr
}
esttab using "`c(current_date)'_table4_categoricalUber", star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace se


** TABLE 5: London interaction **
eststo clear
foreach var of varlist Number_of_Casualties Casualties_Slight Casualties_Serious Casualties_Fatal {
eststo: nbreg `var'  Uber_rollout##London i.lad16nm_id i.Year i.Month unemp pop100k TaxiPHVsPopulation100 gasprice_pounds CRASH_rollout, exposure(TrafficMiles_AllVehicles_monthly) cluster(LicensingArea_name) irr
}
esttab using "`c(current_date)'_table5_londoninter", star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace se



/*****************************************************************************************************************************
* The remainder of the code is for supplementary analyses included in the online "Supplementary Information"                 * 
*****************************************************************************************************************************/

***** APPENDIX B ***** 

** TABLE B.1, Column 1: Different clustering: local authority **
eststo clear
foreach var of varlist Number_of_Casualties Casualties_Slight Casualties_Serious Casualties_Fatal {
eststo: nbreg `var'  Uber_rollout i.lad16nm_id i.Year i.Month unemp pop100k TaxiPHVsPopulation100 gasprice_pounds CRASH_rollout, exposure(TrafficMiles_AllVehicles_monthly) cluster(lad16nm_id) irr
}
esttab using "`c(current_date)'_tableb1_cluster_la", star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace se


** TABLE B.1, Column 2: Different clustering: police force **
eststo clear
foreach var of varlist Number_of_Casualties Casualties_Slight Casualties_Serious Casualties_Fatal {
eststo: nbreg `var'  Uber_rollout i.lad16nm_id i.Year i.Month unemp pop100k TaxiPHVsPopulation100 gasprice_pounds CRASH_rollout, exposure(TrafficMiles_AllVehicles_monthly) cluster(Police_Force_Name) irr
}
esttab using "`c(current_date)'_tableb1_cluster_police", star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace se


** TABLE B.1, Column 3: Different clustering: region **
eststo clear
foreach var of varlist Number_of_Casualties Casualties_Slight Casualties_Serious Casualties_Fatal {
eststo: nbreg `var'  Uber_rollout i.lad16nm_id i.Year i.Month unemp pop100k TaxiPHVsPopulation100 gasprice_pounds CRASH_rollout, exposure(TrafficMiles_AllVehicles_monthly) cluster(region) irr
}
esttab using "`c(current_date)'_tableb1_cluster_region", star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace se


** TABLE B.2: Different exposure variables **
eststo clear
foreach var of varlist Number_of_Casualties Casualties_Slight Casualties_Serious Casualties_Fatal {
eststo: nbreg `var'  Uber_rollout i.lad16nm_id i.Year i.Month unemp pop100k TaxiPHVsPopulation100 gasprice_pounds CRASH_rollout, exposure(TrafficMiles_AllVehicles_yearly) cluster(LicensingArea_name) irr
eststo: nbreg `var'  Uber_rollout i.lad16nm_id i.Year i.Month unemp pop100k TaxiPHVsPopulation100 gasprice_pounds CRASH_rollout, exposure(vehicle_pop) cluster(LicensingArea_name) irr
eststo: nbreg `var'  Uber_rollout i.lad16nm_id i.Year i.Month unemp TaxiPHVsPopulation100 gasprice_pounds CRASH_rollout, exposure(totalpopulation) cluster(LicensingArea_name) irr
}
esttab using "`c(current_date)'_tableb2_exposure", star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace se


** TABLE B.3: Categorical measure of Uber (3 and 6 months)
foreach var of varlist Number_of_Casualties Casualties_Slight Casualties_Serious Casualties_Fatal {
eststo clear
eststo: nbreg `var'  i.Uber_cat_3month i.lad16nm_id i.Year i.Month unemp pop100k TaxiPHVsPopulation100 gasprice_pounds CRASH_rollout, exposure(TrafficMiles_AllVehicles_monthly) cluster(LicensingArea_name) irr
eststo: nbreg `var'  i.Uber_cat_6month i.lad16nm_id i.Year i.Month unemp pop100k TaxiPHVsPopulation100 gasprice_pounds CRASH_rollout, exposure(TrafficMiles_AllVehicles_monthly) cluster(LicensingArea_name) irr
esttab using "`c(current_date)'_tableb3_category_`var'", star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace se
}




***** APPENDIX D (APPENDIX C IS AFTER APPENDIX D CODE) ***** 
***** RE-ESTIMATION WITH ACCIDENT DATA                 *****

** TABLE D1 - Summary statistics - Accidents
sum Accidents_Count Slight Serious Fatal 


** TABLE D2: Total, Slight, and Serious Accidents ** 
eststo clear
foreach var of varlist Accidents_Count Slight Serious {
eststo: nbreg `var'  Uber_rollout i.lad16nm_id i.Year i.Month unemp pop100k TaxiPHVsPopulation100 gasprice_pounds CRASH_rollout, exposure(TrafficMiles_AllVehicles_monthly) cluster(LicensingArea_name) irr
}
esttab using "`c(current_date)'_tabled2", star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace se


** TABLE D2: Fatal Accidents ** 
*** Negative binomial model for Fatal accident models failed to converge so use Poisson instead 
eststo clear
eststo: poisson Fatal  Uber_rollout i.lad16nm_id i.Year i.Month unemp pop100k TaxiPHVsPopulation100 gasprice_pounds CRASH_rollout, exposure(TrafficMiles_AllVehicles_monthly) cluster(LicensingArea_name) irr
esttab using "`c(current_date)'_tabled2_Fatal", star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace se


** TABLE D3, column 1: weekends, Total, Slight, and Serious Accidents ** 
eststo clear
foreach var of varlist Accidents_weekend Slight_weekend Serious_weekend {
eststo: nbreg `var'  Uber_rollout i.lad16nm_id i.Year i.Month unemp pop100k TaxiPHVsPopulation100 gasprice_pounds CRASH_rollout, exposure(TrafficMiles_AllVehicles_monthly) cluster(LicensingArea_name) irr
}
esttab using "`c(current_date)'_tabled3_weekend", star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace se


** TABLE D3, column 1: weekends, Fatal ** 
** Negative binominal did not converge for Fatal accidents, so estimate with Poisson
eststo clear
poisson Fatal_weekend  Uber_rollout i.lad16nm_id i.Year i.Month unemp pop100k TaxiPHVsPopulation100 gasprice_pounds CRASH_rollout, exposure(TrafficMiles_AllVehicles_monthly) cluster(LicensingArea_name) irr
esttab using "`c(current_date)'_tabled3_weekend_Fatal", star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace se


** TABLE D3, column 2: 100K+ population as of 2009, Total, Slight, and Serious Accidents  **
eststo clear
foreach var of varlist Accidents_Count Slight Serious {
eststo: nbreg `var' Uber_rollout i.lad16nm_id i.Year i.Month unemp pop100k TaxiPHVsPopulation100 gasprice_pounds CRASH_rollout if popidentifier>100000, exposure(TrafficMiles_AllVehicles_monthly) cluster(LicensingArea_name) 
}
esttab using "`c(current_date)'_tabled3_100k", star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace se


** TABLE D3, column 2: 100K+ population as of 2009, Fatal Accidents  **
** Negative binominal did not converge for Fatal accidents, so estimate with Poisson
eststo clear
poisson Fatal Uber_rollout i.lad16nm_id i.Year i.Month unemp pop100k TaxiPHVsPopulation100 gasprice_pounds CRASH_rollout if popidentifier>100000, exposure(TrafficMiles_AllVehicles_monthly) cluster(LicensingArea_name)
esttab using "`c(current_date)'_tabled3_100k_Fatal", star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace se


** Table D4: Categorical measure of Uber
eststo clear
foreach var of varlist Accidents_Count Slight Serious {
eststo: nbreg `var' i.Uber_cat_1month i.lad16nm_id i.Year i.Month unemp pop100k TaxiPHVsPopulation100 gasprice_pounds CRASH_rollout, exposure(TrafficMiles_AllVehicles_monthly) cluster(LicensingArea_name)
}
esttab using "`c(current_date)'_tabled4", star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace se


** Table D4: Categorical measure of Uber, Fatal Accidents
** Negative binominal did not converge for Fatal accidents, so estimate with Poisson
eststo clear
poisson Fatal i.Uber_cat_1month i.lad16nm_id i.Year i.Month unemp pop100k TaxiPHVsPopulation100 gasprice_pounds CRASH_rollout, exposure(TrafficMiles_AllVehicles_monthly) cluster(LicensingArea_name)
esttab using "`c(current_date)'_tabled4_Fatal", star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace se


** TABLE D5: London interaction accidents ** 
eststo clear
foreach var of varlist Accidents_Count Slight Serious {
eststo: nbreg `var'  Uber_rollout##London i.lad16nm_id i.Year i.Month unemp pop100k TaxiPHVsPopulation100 gasprice_pounds CRASH_rollout, exposure(TrafficMiles_AllVehicles_monthly) cluster(LicensingArea_name) irr
}
esttab using "`c(current_date)'_tabled5_londoninter", star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace se

** Negative binominal did not converge for Fatal accidents, so estimate with Poisson
eststo clear
poisson Fatal  Uber_rollout##London i.lad16nm_id i.Year i.Month unemp pop100k TaxiPHVsPopulation100 gasprice_pounds CRASH_rollout, exposure(TrafficMiles_AllVehicles_monthly) cluster(LicensingArea_name) irr
esttab using "`c(current_date)'_tabled5_londoninter_fatal", star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace se




/*****************************************************************************************************************************
* CHANGE DATASETS FOR ANALYSIS OF DAILY DATA IN APPENDIX C                                                                   * 
*****************************************************************************************************************************/

***** APPENDIX C ***** 


*** RE-ESTIMATION WITH DAILY DATA ** 

***Daily data too large for Github. Can be found here:
* https://www.dropbox.com/sh/eej01995ayuvnyd/AABMjt7G1FRuF588LwGpBUoia?dl=0

** Open file **
use "C:\KirkCavalliBrazil_SSM2020_Data_daily.dta"


* TABLE C1: main results ** 
eststo clear
foreach var of varlist Number_of_Casualties Casualties_Slight Casualties_Serious Casualties_Fatal {
eststo: nbreg `var' Uber_rollout i.lad16nm_id i.Year i.Month i.day_of_week unemp pop100k TaxiPHVsPopulation100 gasprice_pounds CRASH_rollout, exposure(TrafficMiles_AllVehicles_monthly) cluster(LicensingArea_name) irr
}
esttab using "tablec1_daily", star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace se


** TABLE C2, column 1: cap injuries to max 10 **
eststo clear
foreach var of varlist Cap_Casualties Cap_Casualties_Slight Cap_Casualties_Serious Cap_Casualties_Fatal {
eststo: nbreg `var' Uber_rollout i.lad16nm_id i.Year i.Month i.day_of_week unemp pop100k TaxiPHVsPopulation100 gasprice_pounds CRASH_rollout, exposure(TrafficMiles_AllVehicles_monthly) cluster(LicensingArea_name)
}
esttab using "tablec2_daily_capped", star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace se


** TABLE C2, column 2: weekends, restrict to Friday - Sunday **
eststo clear
foreach var of varlist Number_of_Casualties Casualties_Slight Casualties_Serious Casualties_Fatal  {
eststo: nbreg `var'  Uber_rollout i.lad16nm_id i.Year i.Month i.day_of_week unemp pop100k TaxiPHVsPopulation100 gasprice_pounds CRASH_rollout if (day_of_week <= 0 | day_of_week >= 5), exposure(TrafficMiles_AllVehicles_monthly) cluster(LicensingArea_name) irr
}
esttab using "tablec2_daily_weekend", star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace se


** TABLE C2, column 3: 100K+ population (as of 2009)
*gen popidentifier=totalpopulation if Year==2009
*bysort lad16nm_id : replace popidentifier =popidentifier[1]

eststo clear
foreach var of varlist Number_of_Casualties Casualties_Slight Casualties_Serious Casualties_Fatal {
eststo: nbreg `var' Uber_rollout i.lad16nm_id i.Year i.Month i.day_of_week unemp pop100k TaxiPHVsPopulation100 gasprice_pounds CRASH_rollout if popidentifier>100000, exposure(TrafficMiles_AllVehicles_monthly) cluster(LicensingArea_name) 
}
esttab using "tablec2_daily_pop100k", star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace se


** Table C3: Categorical measure of Uber
eststo clear
foreach var of varlist Number_of_Casualties Casualties_Slight Casualties_Serious Casualties_Fatal {
eststo: nbreg `var' i.Uber_cat_1month i.lad16nm_id i.Year i.Month i.day_of_week unemp pop100k TaxiPHVsPopulation100 gasprice_pounds CRASH_rollout, exposure(TrafficMiles_AllVehicles_monthly) cluster(LicensingArea_name)
}
esttab using "tablec3_daily_categoricalUber", star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace se


** TABLE C4: London interaction with daily data ** 
*gen London=(region=="London")

eststo clear
foreach var of varlist Number_of_Casualties Casualties_Slight Casualties_Serious Casualties_Fatal {
eststo: nbreg `var' Uber_rollout##London i.lad16nm_id i.Year i.Month i.day_of_week unemp pop100k TaxiPHVsPopulation100 gasprice_pounds CRASH_rollout, exposure(TrafficMiles_AllVehicles_monthly) cluster(LicensingArea_name) irr
}
esttab using "tablec4_daily_londoninter", star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace se



**** END ***


