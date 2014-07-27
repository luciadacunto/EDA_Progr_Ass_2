# Get data
zipped = "exdata_data_NEI_data.zip"
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",zipped, "curl")
unzip(zipped)

# Read all data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Extract SCC code for coal combustion related pollutants
#
# The number of coal combustion related pollutants is calculated by selecting those where
# "Short Name" equals to "Coal" and where "EI Sector" equal to "Comb".
# In absence of additional information (i.e. cookbook), this seemed a reasonable method to
# calculate the number of coal combustion related pollutants.
# For a real client assignment, I would ask, whenever possible, for more information/material,
# such as the cookbook, and would verify with the client that my assumptions are correct.
library(sqldf)

names(SCC)[3]<-"Short_Name"
names(SCC)[4]<-"EI_Selector"
coal_comb_related <- unlist(sqldf("select distinct SCC from SCC where Short_Name like '%Coal%' and EI_Selector like '%Comb%'"))

# Calculate emissions of coal combustion related emissions in US per year
year<- unique(NEI$year) # extract years
scc<- NEI$SCC[coal_comb_related] # extract pollutant sources related to coal combustion
emissions <-numeric()

for (i in 1:length(year)){
    e <-numeric()
    for (j in 1:length(scc)){
        e <- sum(NEI[NEI$year==year[i] & NEI$SCC==scc[j],]$Emissions) # count total emissions per year
    }
    emissions <- rbind(emissions,e)
}

plot(,emissions, ylab="Emissions of PM2.5 (tons)", main="Emissions of PM2.5 in US from 1999 to 2008", xaxp=c(1999, 2008, 3), yaxp=c(min(emissions),max(emissions),2))
