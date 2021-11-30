library("ggplot2")
my.data <- read.csv("Biofilm Test 1-table.csv",skip=6)
my.data <- my.data[c("X.run.number.","Biofilm.Thickness", "Flow.Rate", "count.producers", 'count.cheaters', 'X.step.')]
colnames(my.data) <- c('Run', 'Biofilm.Thickness', "Flow.Rate", "Producers", "Cheaters", "Step")
my.data$Producers_Higher <- ifelse(my.data$Cheaters == 0, ((3000 - my.data$Step) && my.data$Producers > 0), (my.data$Producers > my.data$Cheaters))

Time_Producers_Higher <- aggregate(my.data$Producers_Higher, list(my.data$Run), sum)
colnames(Time_Producers_Higher) <- c('Run', 'Time_Producers_Higher')
my.data.new <- merge(Time_Producers_Higher, my.data, by= 'Run')

Time_Producers_Higher_Mean <- aggregate(my.data.new$Time_Producers_Higher, list(my.data.new$"Biofilm.Thickness", my.data.new$"Flow.Rate"), mean)

colnames(Time_Producers_Higher_Mean) <- c("Biofilm.Thickness", "Flow.Rate", 'Time_Producers_Higher_Mean_Log_Scale')
my.data.new2 <- merge(Time_Producers_Higher_Mean, my.data.new, by=c("Biofilm.Thickness", "Flow.Rate"))
deduped.data <- unique( my.data.new2[c("Biofilm.Thickness", "Flow.Rate", 'Time_Producers_Higher_Mean_Log_Scale')] )
#deduped.data$Time_Producers_Higher_Mean_Log_Scale <- log(deduped.data$Time_Producers_Higher_Mean_Log_Scale, 5)

ggplot(deduped.data, aes(x = Biofilm.Thickness, y = Flow.Rate, fill = Time_Producers_Higher_Mean_Log_Scale)) +
  geom_tile()
ggsave("biofilm_log_scale.png")



#my.data
#Time_Producers_Higher
#deduped.data
