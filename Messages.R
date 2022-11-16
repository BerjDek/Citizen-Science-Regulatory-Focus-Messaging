
library(lubridate)

message_data <- read.csv(file="sent.csv", header = TRUE)
colnames(message_data)
message_data <- message_data %>% separate(notification_label, c('type','language','msg_nmbr'))
message_data <- message_data %>% mutate(date_comment = ymd_hms(date_comment))


#how many massages approved by each user

read <- as.data.frame(table(message_data$sent_to_user_id, message_data$acknowledged))  %>% 
        pivot_wider(names_from = Var2, values_from =  Freq ) %>% 
        rename(user_id = Var1) %>% 
        arrange(desc(t))

