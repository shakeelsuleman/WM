library(ggplot2)
library(rgdal)
library(broom)
library(dplyr)

wm<- readOGR(dsn = "C:/Users/shake/OneDrive/Desktop/R files/WM/WM", layer = "WM_UTLAs")
cases<- read.csv(file = "Area.csv", header = T)

wme<- tidy(wm, region = "GSS_CD")
clean<- left_join(wme, cases, by = c("id" = "GSS_CD"))


pc<- read.table("pc.txt", sep = ",", header = T)
coordinates(pc)<- ~long+lat
proj4string(pc)<- CRS("+proj=longlat +datum=OSGB36")
pc<- spTransform(pc, CRS(proj4string(wm)))
pc<- data.frame(pc)

ggplot() +
  geom_polygon(data = clean, aes(x = long, y = lat, group = la, fill = cases)) +
  geom_point(data = pc, aes(x = long, y = lat), color = "red", size = 2) +
  coord_quickmap()