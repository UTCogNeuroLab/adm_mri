#subset to past depression and not
##compare rumination, attention bias, rt attention bias, gaze bias

data = read.csv("~/Documents/R56/new final mean activity day1.csv", header = TRUE, sep = ",",na = c("-","99999","NA"))
data$f21CSD1 = (data$OpenCSDF21 + data$ClosedCSDF21)/2
data$f21AVG1 = (data$OpenAVGF21 + data$ClosedAVGF21)/2
data$f43CSD1 = (data$OpenCSDF43 + data$ClosedCSDF43)/2
data$f43AVG1 = (data$OpenAVGF43 + data$ClosedAVGF43)/2
data$f65AVG1 = (data$OpenAVGF65 + data$ClosedAVGF65)/2
data$f65CSD1 = (data$OpenCSDF65 + data$ClosedCSDF65)/2
data$f87CSD1 = (data$OpenCSDF87 + data$ClosedCSDF87)/2
data$f87AVG1 = (data$OpenAVGF87 + data$ClosedAVGF87)/2
data$midCSD1 = (data$midfrontOpenCSD + data$midfrontClosedCSD)/2
data$midAVG1 = (data$midfrontOpenAVG + data$midfrontClosedAVG)/2
#since we have 99999 and - values, this creates subsets where there are no null values to then
##plot from there


data2 = read.csv("~/Documents/R56/new final mean activity day2.csv", header = TRUE, sep = ",",na = c("-","99999","NA"))
data2$f21CSD1 = (data2$OpenCSDF21 + data2$ClosedCSDF21)/2
data2$f21AVG1 = (data2$OpenAVGF21 + data2$ClosedAVGF21)/2
data2$f43CSD1 = (data2$OpenCSDF43 + data2$ClosedCSDF43)/2
data2$f43AVG1 = (data2$OpenAVGF43 + data2$ClosedAVGF43)/2
data2$f65AVG1 = (data2$OpenAVGF65 + data2$ClosedAVGF65)/2
data2$f65CSD1 = (data2$OpenCSDF65 + data2$ClosedCSDF65)/2
data2$f87CSD1 = (data2$OpenCSDF87 + data2$ClosedCSDF87)/2
data2$f87AVG1 = (data2$OpenAVGF87 + data2$ClosedAVGF87)/2
data2$midCSD1 = (data2$midfrontOpenCSD + data2$midfrontClosedCSD)/2
data2$midAVG1 = (data2$midfrontOpenAVG + data2$midfrontClosedAVG)/2


#gaze bias and F21
withpast1 <- subset(data, data$mdd_past_meets == "1")
withoutpast1<- subset(data, data$mdd_past_meets == "0")

write.csv(withpast1, "faawithhistoryofdep.csv")
write.csv(withoutpast1, "faawithouthistoryofdep.csv")

a1=read.csv("~/faawithhistoryofdep.csv")
b1=read.csv("~/faawithouthistoryofdep.csv")
#looks at rumination and F21 in those with history of dep
plot(data$pre_bdi_total,data$midAVG1,las=1,ylab="Eyes Open Midfrontal Day 1",
     xlab="Attention Bias to Sad Faces (variation gaze bias)",col="black",pch=18)
abline(lm(data$midAVG1~data$pre_bdi_total))
cor.test(data$pre_bdi_total,data$midAVG1)


t.test(a1$midfrontOpenAVG,b1$midfrontOpenAVG)


sp <- ggplot(data = a1, aes(x=a1$mean_gaze_toward, y=a1$f87AVG1))
sp <- sp + geom_point(col="maroon", size=2)
sp<- sp + stat_smooth(method="lm") + theme_bw() + theme(axis.text=element_text(size=14)) + xlab("Negative Attention Bias Day 1") + ylab("F87 AVG Day 1")+
  theme(axis.title.x=element_text(size=12))+ theme(axis.title.y=element_text(size=12))
sp<-sp+ggtitle("F87 AVG vs Negative Attention Bias Day 1") + theme(plot.title = element_text(hjust = 0.5, size=12))
sp
cor.test(a1$f87AVG1,a1$mean_gaze_toward)


#F43
#gaze bias and F43
withpast2 <- subset(data, data$mdd_current_meets == "1")
withoutpast2<- subset(data, data$mdd_current_meets == "0")

write.csv(withpast2, "faawithhistoryofdep.csv")
write.csv(withoutpast2, "faawithouthistoryofdep.csv")

a2=read.csv("~/faawithhistoryofdep.csv")
b2=read.csv("~/faawithouthistoryofdep.csv")
plot(a2$var_gaze_bias,a2$ClosedCSDF43,las=1,ylab="Eyes Closed Alpha: F4-F3",
     xlab="Attention Bias to Sad Faces",col="black",pch=18)
abline(lm(a2$ClosedCSDF43~a2$var_gaze_bias))
cor.test(a2$var_gaze_bias,a2$ClosedCSDF43)




#F65
withpast3 <- subset(data, data$mdd_current_meets == "1")
withoutpast3<- subset(data, data$mdd_current_meets == "0")

write.csv(withpast3, "faawithhistoryofdep.csv")
write.csv(withoutpast3, "faawithouthistoryofdep.csv")

a3=read.csv("~/faawithhistoryofdep.csv")
b3=read.csv("~/faawithouthistoryofdep.csv")
plot(a3$var_gaze_bias,a3$ClosedCSDF65,las=1,ylab="Eyes Closed Alpha: F6-F5",
     xlab="Attention Bias to Sad Faces",col="black",pch=18)
abline(lm(a3$ClosedCSDF65~a3$var_gaze_bias))
cor.test(a3$var_gaze_bias,a3$ClosedCSDF65)




#F87
withpast4 <- subset(data, data$mdd_current_meets == "1")
withoutpast4<- subset(data, data$mdd_current_meets == "0")

write.csv(withpast4, "faawithhistoryofdep.csv")
write.csv(withoutpast4, "faawithouthistoryofdep.csv")

a4=read.csv("~/faawithhistoryofdep.csv")
b4=read.csv("~/faawithouthistoryofdep.csv")
plot(a4$var_gaze_bias,a4$ClosedCSDF87,las=1,ylab="Eyes Closed Alpha: F8-F7",
     xlab="BDI",col="black",pch=18)
abline(lm(a4$ClosedCSDF87~a4$var_gaze_bias))
cor.test(a4$var_gaze_bias,a4$ClosedCSDF87)




#midfrontal
withpast5 <- subset(data, data$mdd_current_meets == "1")
withoutpast5<- subset(data, data$mdd_current_meets == "0")

write.csv(withpast5, "faawithhistoryofdep.csv")
write.csv(withoutpast5, "faawithouthistoryofdep.csv")

a5=read.csv("~/faawithhistoryofdep.csv")
b5=read.csv("~/faawithouthistoryofdep.csv")
plot(a5$var_gaze_bias,a5$midfrontClosedCSD,las=1,ylab="Eyes Closed Alpha: midfrontal",
     xlab="attention bias",col="black",pch=18)
abline(lm(a5$midfrontClosedCSD~a5$var_gaze_bias))
cor.test(a5$var_gaze_bias,a5$midfrontClosedCSD)

#subset to current depression and not
##compare rumination, attention bias, rt attention bias, gaze bias