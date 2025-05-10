/*********************
*********************

This file uses reported crime data for toronto
to produce a trends in crimes against property.
Crime against property is divided into subcategories.

Source: https://open.toronto.ca/dataset/police-annual-statistical-report-reported-crimes/

***********************/
*************************

 cd "/Users/Bisma/Dropbox/visualization"
 
import delimited "./ReportedCrimes.csv", encoding(ISO-8859-1)clear


*****Keeping only crimes against property:

keep if category == "Crimes Against Property" 

****collapsing some sub-categories:

generate subcat= 1 if subtype =="Auto Theft"
replace subcat = 2 if subtype == "Break & Enter-Apartment" | subtype == "Break & Enter-House" | subtype == "Break & Enter-Commercial" | subtype == "Break & Enter-Other"
replace subcat = 3 if subtype == "Fraud"
replace subcat = 4 if subtype == "Theft Over $5000" 
replace subcat = 5 if subtype == "Theft Under $5000"
replace subcat = 6 if subtype == "Other"

*checking accuracy of the collapsed variable
tab subcat subtype

*assigning variable labels
label define subcat 1 "Auto Theft" 2 "Break & Enter" 3 "Fraud" 4 "Theft - Above $5000" 5" Theft - Under $5000" 6 "Other"
label val subcat subcat


***creating summary statistics to plot
bysort report_year subcat:egen total_crime = sum(count_)


****Creating visualization
twoway (connected total_crime report_year if subcat ==1) (connected total_crime report_year if subcat == 2) (connected total_crime report_year if subcat ==3) (connected total_crime report_year if subcat ==4) (connected total_crime report_year if subcat ==5) (connected total_crime report_year if subcat ==6), ytitle(Total Crime) xtitle(Year) title(Trend in Crime Rates by Crime Category) subtitle(Crimes Against Property) legend(order(1 "Auto Theft" 2 "Break & Enter" 3 "Fraud" 4 "Theft - Above $5000" 5 "Theft - Below $5000" 6 "Other") cols(3)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ytitle(,margin(medium)) name(full, replace)
graph export crime_trend_type.png, height(1600) width(2400)
