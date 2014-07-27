# Get data
zipped = "exdata_data_NEI_data.zip"
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",zipped, "curl")
unzip(zipped)

# Read necessary data
NEI <- readRDS("summarySCC_PM25.rds")

# Calculate total emissions per year
year<- unique(NEI$year) # extract years
emissions<- year
for (i in 1:length(year)){ 
    emissions[i] <- sum(NEI[NEI$year==year[i],]$Emissions) # count total emissions per year
}

# Make plot
png("plot1.png")
plot(year,emissions, ylab="Emissions of PM2.5 (tons)", main="Emissions of PM2.5 in US from 1999 to 2008", xaxp=c(1999, 2008, 3), yaxp=c(min(emissions),max(emissions),2))
lines(year,emissions)
dev.off()