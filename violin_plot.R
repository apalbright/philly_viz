#R Script for Comparing Scores Across Philly Schools: Charters and District Schools
#Using Philly Open Data!
#R version 3.1.2 (2014-10-31) -- "Pumpkin Helmet"
#Made by Alex Albright (thelittledataset.com)
#All coding/interpretation errors are my own
#Feel free to contact me with questions or concerns: alex.p.albright@gmail.com

#Call libs
library(ggplot2);library(plyr);library(reshape2); library(directlabels)
library(grid);library(scales);library(RColorBrewer); library(wordcloud); library(gridExtra)

#Function for look of charts
my_theme <- function() {

  # Define colors for the chart
  palette <- brewer.pal("Greys", n=9)
  color.background = palette[2]
  color.grid.major = palette[4]
  color.panel = palette[3]
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
  theme(panel.grid.major=element_line(color=color.grid.major,size=.25)) +
  theme(panel.grid.minor=element_blank()) +
  theme(axis.ticks=element_blank()) +

  # Format legend
  theme(legend.position="none") +
  theme(legend.background = element_rect(fill=color.panel)) +
  theme(legend.text = element_text(size=8,color=color.axis.title)) + 
  theme(legend.title=element_text(size=9)) +

  # Format title and axes labels these and tick marks
  theme(plot.title=element_text(color=color.title, size=16, vjust=0.5, hjust=0.5, face="bold")) +
  theme(axis.text.x=element_text(size=9,color=color.axis.text)) +
  theme(axis.text.y=element_text(size=9,color=color.axis.text)) +
  theme(axis.title.x=element_text(size=11,color=color.axis.title, vjust=-1, face="italic")) +
  theme(axis.title.y=element_text(size=11,color=color.axis.title, vjust=1.8, face="italic")) +

	#Format facet_wrap title
  theme(strip.text = element_text(size=10, face="bold"))+
  
  # Plot margins
  theme(plot.margin = unit(c(.5, .5, .5, .5), "cm"))
}

library(ggplot2);library(grid)

setwd("downloaded_data")
data0<-read.csv("2014_2015_SCHOOL_PROGRESS_REPORT_20160208.csv")

data0$Governance0[data0$Governance=="Charter" & (data0$Admissions.Type=="Neighborhood")]<-"Charter (Neighborhood)"

data0$Governance0[data0$Governance=="Charter" & (data0$Admissions.Type=="Citywide With Criteria" | data0$Admissions.Type=="Citywide")]<-"Charter (Citywide)"

data0$Governance0[data0$Governance=="District" & (data0$Admissions.Type=="Neighborhood")]<-"District (Neighborhood)"

data0$Governance0[data0$Governance=="District" & (data0$Admissions.Type=="Citywide With Criteria" | data0$Admissions.Type=="Citywide" | data0$Admissions.Type=="Special Admit")]<-"District (Citywide)"

#Only keep relevant vars
data<-data0[c("SRC.School.ID", "Governance0", "Governance", "Admissions.Type", "Zip.Code", "Enrollment", "Overall.Score", "Prog.Score", "Ach.Score", "Clim.Score", "Rpt.Type.Long")]

names(data)[names(data) == 'Overall.Score'] <- 'Overall Score'
names(data)[names(data) == 'Ach.Score'] <- 'Achievement Score'
names(data)[names(data) == 'Prog.Score'] <- 'Progress Score'
names(data)[names(data) == 'Clim.Score'] <- 'Climate Score'

data_new <- reshape(data,
             varying = c("Overall Score", "Achievement Score", "Progress Score", "Climate Score"), 
             v.names = "Score",
             timevar = "Score_type", 
             times = c("Overall Score", "Achievement Score", "Progress Score", "Climate Score"), 
             #new.row.names = 1:1000,
             direction = "long")

data_new<-data_new[c("Governance0", "Score", "Score_type")]
pal2 <- c("#b10026", "red", "#807dba", "blue")
data_new$Score<-as.numeric(data_new$Score)

ggplot(data_new, aes(factor(data_new$Governance0), data_new$Score))+
geom_violin(trim=T, adjust=.2, aes(fill=Governance0))+
geom_boxplot(width=0.1, aes(fill=Governance0, color="orange"))+
my_theme()+
scale_fill_manual(values = pal2, guide_legend(title="School Type")) +
ylim(0,100)+
labs(x="", y="")+
facet_wrap(~Score_type, ncol=2, scales="free")+
ggtitle(expression(atop(bold("Comparing Philly School Score Distributions"), atop(italic("Data via OpenDataPhilly (2014-2015); Visual via Alex Albright (thelittledataset.com)"),""))))

#Yay! Part 2