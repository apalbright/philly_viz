# philly_viz
raw data and R code for "Building Visualizations Using City Open Data: Philly School Comparisons"

#Replication
Clone the repo and run the R scripts of interest (using R version 3.1.2 (2014-10-31) -- "Pumpkin Helmet"):

#To make the violin plot
Run violin_plot.R

#To make the map plot
Run points_on_map.R

#Data notes:
All data was downloaded from Philly open data portal!!! (Yay open data!!!)
All originals are in the "downloaded_data" folder
Code then calls these files in making the two visuals of interest

#Get school and score data
2014_2015_SCHOOL_PROGRESS_REPORT_20160208.xlsx downloaded from
https://www.opendataphilly.org/dataset/school-school-progress-report-data/resource/f4491afc-f872-4c2d-a898-6f5f4fe962e8 (last updated July 21, 2016)
(first sheet resaved as csv for ease of calling into R)

#Get long and lat for schools
Schools.csv downloaded from https://www.opendataphilly.org/dataset/schools/resource/8e1bb3e6-7fb5-4018-95f8-63b3fc420557 (last updated 1/21/15)

#Get ID numbers for merging for schools
"2014-15 Master School List" (last updated 9/8/15)
https://www.opendataphilly.org/dataset/school-district-school-information/resource/c5876647-e4b5-4138-b547-acd443285f45
(second sheet resaved as csv for ease of calling into R)

#Get data for mapping
"Zipcodes_Poly" folder downloaded from https://www.opendataphilly.org/dataset/zip-codes/resource/4cb98d0e-24e1-484b-936c-ddbe255a2ec1

#Ping me if you have any questions/concerns
#Here's my email: alex.p.albright@gmail.com
