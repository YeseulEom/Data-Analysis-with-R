install.packages("XML")
library(XML)
library(RCurl)
library(data.table)

total<-list()
temp<-list()
item<-list()
item_temp_lt<-list()
item_temp_dt<-data.table()

api_t<-"http://openapi.kised.or.kr/openapi/service/rest/ContentsService/getAnnouncementList?serviceKey=&numOfRows=1000&pageSize=1000&startPage=1&startDate=20140101&endDate=20181231&pageNo="

for (i in 1:6) {
  raw<-xmlTreeParse(paste(api_t,i,sep = ""),useInternalNodes = TRUE,isURL = TRUE,encoding = "utf-8") 
  
  root<-xmlRoot(raw)
  
  items<-root[[2]][['items']]
  
  size<-xmlSize(items)
  
  for(j in 1:size){
    item_temp<-xmlSApply(items[[j]],xmlValue)
    
    item_temp_dt<-data.table(
      areaname=item_temp[1],
      biztitle=item_temp[2],
      detailurl=item_temp[3],
      enddate=item_temp[4],
      insertdate=item_temp[5],
      organizationname=item_temp[6],
      postsn=item_temp[7],
      posttarget=item_temp[8],
      posttargetage=item_temp[9],
      posttargetcomage=item_temp[10],
      startdate=item_temp[11],
      supporttype=item_temp[12]
    )
    
    item[[j]]<-item_temp_dt
  }
  total[[i]]<-rbindlist(item,fill = TRUE)
}
test_dt<-rbindlist(total)
head(test_dt)
View(test_dt)
write.csv(test_dt,"",row.names=FALSE)
