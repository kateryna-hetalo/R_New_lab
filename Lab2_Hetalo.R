#download file
file<-tempfile(fileext=".hdf5")
options(timeout=600)
download.file(url="https://dcc.ligo.org/public/0146/P1700337/001/H-H1_LOSC_C00_4_V1-1187006834-4096.hdf5",destfile=file,mode="wb")

install.packages("BiocManager")
BiocManager::install("rhdf5")
library(rhdf5)
h5ls(file)

strain <- h5read(file, 'strain/Strain')
head(strain)

st <- h5readAttributes(file, "strain/Strain")$Xspacing

gpsStart <- h5read(file, 'meta/GPSstart')
duration <- h5read(file, 'meta/Duration')
gpsEnd <- gpsStart + duration

myTime <- seq(gpsStart, gpsEnd, by = st)

numSamples <- 1000000
plot(myTime[0:numSamples], strain[0:numSamples], type = "l", xlab = "GPS Time (s)", ylab = "H1 Strain")
