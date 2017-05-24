#R Script for mapping Philly Schools: Charters and District Schools
#Using Philly Open Data!
#Made by Alex Albright (thelittledataset.com)
#All coding/interpretation errors are my own
#Feel free to contact me with questions or concerns: alex.p.albright@gmail.com

#Load libs
library(ggplot2);library(RColorBrewer); library(sp);library(maptools);library(plyr);library(scales);library(grid);library(gridExtra)

#Make look of graphics
my_theme <- function() {

  # Define colors for the chart
  palette <- brewer.pal("Greys", n=9)
  color.background = palette[2]
  color.grid.major = palette[4]
  color.panel = palette[4]
  color.axis.text = palette[9]
  color.axis.title = palette[9]
  color.title = palette[9]

  # Create basic construction of chart
  theme_bw(base_size=9, base_family="Georgia") + 

  # Set the entire chart region to a light gray color
  theme(panel.background=element_rect(fill=color.panel, color=color.background)) +
  theme(plot.background=element_rect(fill=color.background, color=color.background)) +
  theme(panel.border=element_rect(color=color.background)) +

  # Format grid
  theme(panel.grid.major=element_blank()) +
  theme(panel.grid.minor=element_blank()) +
  theme(axis.ticks=element_blank()) +

  # Format legend
  theme(legend.position="bottom") +
  theme(legend.background = element_rect(fill=color.panel)) +
  theme(legend.title = element_text(size=8, color=color.axis.title)) +
  theme(legend.text = element_text(size=8,color=color.axis.title)) + 

  # Format title and axes labels these and tick marks
  theme(plot.title=element_text(color=color.title, size=14, vjust=0.5, hjust=0.5, face="bold")) +
  theme(axis.text.x=element_text(size=0,color=color.axis.text)) +
  theme(axis.text.y=element_text(size=0,color=color.axis.text)) +
  theme(axis.title.x=element_text(size=10,color=color.axis.title, vjust=-1, face="italic")) +
  theme(axis.title.y=element_text(size=0,color=color.axis.title, vjust=1.8, face="italic")) +

	#Format facet_wrap title
  theme(strip.text = element_text(size=8, face="bold"))+
  
  # Plot margins
  theme(plot.margin = unit(c(.5, .5, .5, .5), "cm"))
}

#Thanks to http://prabhasp.com/wp/how-to-make-choropleths-in-r/ in building up this code

#Open data from Philly Open Data Portal
setwd("downloaded_data")
data0<-read.csv("2014_2015_SCHOOL_PROGRESS_REPORT_20160208.csv")

data0$Governance0[data0$Governance=="Charter" & (data0$Admissions.Type=="Neighborhood")]<-"Charter (Neighborhood)"

data0$Governance0[data0$Governance=="Charter" & (data0$Admissions.Type=="Citywide With Criteria" | data0$Admissions.Type=="Citywide")]<-"Charter (Citywide)"

data0$Governance0[data0$Governance=="District" & (data0$Admissions.Type=="Neighborhood")]<-"District (Neighborhood)"

data0$Governance0[data0$Governance=="District" & (data0$Admissions.Type=="Citywide With Criteria" | data0$Admissions.Type=="Citywide" | data0$Admissions.Type=="Special Admit")]<-"District (Citywide)"

#Only keep relevant vars
data<-data0[c("SRC.School.ID", "Governance0", "Governance", "Admissions.Type", "Zip.Code", "Enrollment", "Overall.Score", "Prog.Score", "Ach.Score", "Clim.Score", "Rpt.Type.Long")]

library(plyr) 
spr1<-count(data, c("Zip.Code"))
spr1<-na.omit(spr1)

#data<-data[data$Rpt.Type.Long=="High School",]

#318 schools
#just care about governance: charter v. district

#Merge with long/lat data
#Bring in long/lat data
longlat<-read.csv("Schools.csv", header=T)
#Keep relevant vars
longlat<-longlat[c("X", "Y", "SCHOOL_NUM")]
#Merge with school ID data (need other ids to merge on later)
ids<-read.csv("2014-2015-Master-School-List-20150519.csv", header=T)
#Keep relevant vars
ids<-ids[c("PA..Code", "SRC.School.ID")]
longlat_new<-merge(longlat, ids, by.x="SCHOOL_NUM", by.y="PA..Code")
#Now, actually do the merge
data_new<-merge(data, longlat_new, by="SRC.School.ID")

#Bring in shape files
setwd("Zipcodes_Poly")
np_dist <- readShapeSpatial("Zipcodes_Poly.shp")

np_dist <- fortify(np_dist, region = "CODE")
np_dist$id <- toupper(np_dist$id)  #change ids to uppercase

#No schools in certain zip codes...
row1<-c(19107, 0)
row2<-c(19109, 0)
row3<-c(19112, 0)
spr1=rbind(spr1, row1)
spr1=rbind(spr1, row2)
spr1=rbind(spr1, row3)

datadistn <-data_new[which(data_new$Governance0=="District (Neighborhood)"),]
datachartn <-data_new[which(data_new$Governance0=="Charter (Neighborhood)"),]
datadistc <-data_new[which(data_new$Governance0=="District (Citywide)"),]
datachartc <-data_new[which(data_new$Governance0=="Charter (Citywide)"),]

ggplot() + geom_map(data = spr1, aes(map_id = Zip.Code), 
    map = np_dist, fill="gray40", color="gray60") + expand_limits(x = np_dist$long, y = np_dist$lat)+ 
    my_theme()+
    geom_point(data=datadistn, aes(x=X, y=Y, col="District (Neighborhood)"), size=1.5, alpha=1)+
    geom_point(data=datachartn, aes(x=X, y=Y, col="Charter (Neighborhood)"), size=1.5, alpha=1)+
    geom_point(data=datadistc, aes(x=X, y=Y, col="District (Citywide)"), size=1.5, alpha=1)+
    geom_point(data=datachartc, aes(x=X, y=Y, col="Charter (Citywide)"), size=1.5, alpha=1)+
    facet_wrap(~Rpt.Type.Long, ncol=2)+
    ggtitle(expression(atop(bold("Mapping Philly Schools"), atop(italic("Data via OpenDataPhilly; Visual via Alex Albright (thelittledataset.com)"),""))))+
  scale_colour_manual(values = c("Charter (Citywide)"="#b10026", "District (Citywide)"="#807dba","Charter (Neighborhood)"="red","District (Neighborhood)"="blue"), guide_legend(title="Type of School"))+
  labs(y="", x="")
  
#Yay! 
