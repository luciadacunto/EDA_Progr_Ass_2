# Get data
zipped = "exdata_data_NEI_data.zip"
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",zipped, "curl")
unzip(zipped)

# Read necessary data
NEI <- readRDS("summarySCC_PM25.rds")

# Calculate emissions in Baltimore City per year
y<- unique(NEI$year) # extract years
t<- unique(NEI$type) # extract pollutant sources types
emissions <-numeric()
year <-numeric()
type <-numeric()
for (i in 1:length(y)){ 
    for (j in 1:length(t)){ 
        emissions <- rbind(emissions,sum(NEI[NEI$year==y[i] & NEI$type==t[j] & NEI$fips == "24510",]$Emissions)) # count emissions per year per pollutant source type in Baltimore city
        year <- rbind(year,y[i])
        type <- rbind(type,t[j])
    }
}
data <- data.frame(emissions, year, type) # save data in dataframe (needed for plotting it with ggplot2)

# Make plot
library(ggplot2) # import ggplot2 package
png("plot3.png", width=800, height=400)
qplot(year, emissions, data=data, facets = .~type, geom=c("point", "line")) + labs(title = "Emissions of PM2.5 in Baltimore City per pollutant source type from 1999 to 2008")
dev.off()