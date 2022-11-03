library(tidyverse)

data <- read.csv(file="data.csv", header = TRUE)
data <- data %>%  rename(Consent = I.GIVE.MY.CONSENT.to.participate.in.this.study.and.allow.the.use.of.data.generated.in.Mosquito.Alert.on.my.device.to.be.re.used.in.this.research.project..,
                         age = How.old.are.you., Gender = What.is.your.gender., Country = What.is.the.country.you.currently.reside.in., GenderOther= Please.state.your.gender.if.you.have.chosen.the.option..other.,
                         Province = Please.specify.the.province.state.administrative.division.you.currently.reside.in, Network = How.many.people.do.you.personally.know..acquaintances..friends..family.members.etc...who.are.participating.in.Mosquito.Alert..not.including.yourself..,
                         Recommended = Have.you.recommended.Mosquito.Alert.to.anyone.else., OtherCitSci = Are.you.currently.engaged.in.other.citizen.science.projects., CitSciName = Can.you.please.name.them., Rank1= Please.rank..top.to.bottom..the.reasons.given.below.for.your..participation.in.MosquitoAlert..Rank.1.,
                         Rank2 = Please.rank..top.to.bottom..the.reasons.given.below.for.your..participation.in.MosquitoAlert..Rank.2., Rank3 = Please.rank..top.to.bottom..the.reasons.given.below.for.your..participation.in.MosquitoAlert..Rank.3., Rank4 = Please.rank..top.to.bottom..the.reasons.given.below.for.your..participation.in.MosquitoAlert..Rank.4.,
                         Rank5 = Please.rank..top.to.bottom..the.reasons.given.below.for.your..participation.in.MosquitoAlert..Rank.5., Participation_Reason= Please.explain.your.reasons.for.participating, Reg1 = Compared.to.most.people..are.you.typically.unable.to.get.what.you.want.out.of.life., Reg2 =Growing.up..would.you.ever..cross.the.line..by.doing.things.that.your.parents.would.not.tolerate.,
                         Reg3 = How.often.have.you.accomplished.things.that.got.you..psyched..to.work.even.harder., Reg4 = Did.you.get.on.your.parents..nerves.often.when.you.were.growing.up., Reg5= How.often.did.you.obey.rules.and.regulations.that.were.established.by.your.parents., Reg6 = Growing.up..did.you.ever.act.in.ways.that.your.parents.thought.were.objectionable., Reg7 = Do.you.often.do.well.at.different.things.that.you.try.,
                         Reg8 = Not.being.careful.enough.has.gotten.me.into.trouble.at.times., Reg9 = When.it.comes.to.achieving.things.that.are.important.to.me..I.find.that.I.don.t.perform.as.well.as.I.ideally.would.like.to.do., Reg10 = X.I.feel.like.I.have.made.progress.toward.being.successful.in.my.life.., Reg11 = I.have.found.very.few.hobbies.or.activities.in.my.life.that.capture.my.interest.or.motivate.me.to.put.effort.into.them) 



colnames(data)

data$Reg1[data$Reg1 == "[1] Never/Seldom"] <- 1
data$Reg1[data$Reg1 == "[2] Rarely"] <- 2
data$Reg1[data$Reg1 == "[3] Sometimes"] <- 3
data$Reg1[data$Reg1 == "[4] Often"] <- 4
data$Reg1[data$Reg1 == "[5] Very Often"] <- 5

data$Reg2[data$Reg2 == "[1] Never/Seldom"] <- 1
data$Reg2[data$Reg2 == "[2] Rarely"] <- 2
data$Reg2[data$Reg2 == "[3] Sometimes"] <- 3
data$Reg2[data$Reg2 == "[4] Often"] <- 4
data$Reg2[data$Reg2 == "[5] Very Often"] <- 5

data$Reg3[data$Reg3 == "[1] Never/Seldom"] <- 1
data$Reg3[data$Reg3 == "[2] Rarely"] <- 2
data$Reg3[data$Reg3 == "[3]  A Few Times"] <- 3
data$Reg3[data$Reg3 == "[4] Often"] <- 4
data$Reg3[data$Reg3 == "[5] Many Times"] <- 5

data$Reg4[data$Reg4 == "[1] Never/Seldom"] <- 1
data$Reg4[data$Reg4 == "[2] Rarely"] <- 2
data$Reg4[data$Reg4 == "[3] Sometimes"] <- 3
data$Reg4[data$Reg4 == "[4] Often"] <- 4
data$Reg4[data$Reg4 == "[5] Very Often"] <- 5

data$Reg5[data$Reg5 == "[1] Never/Seldom"] <- 1
data$Reg5[data$Reg5 == "[2] Rarely"] <- 2
data$Reg5[data$Reg5 == "[3] Sometimes"] <- 3
data$Reg5[data$Reg5 == "[4] Mostly"] <- 4
data$Reg5[data$Reg5 == "[5] Always"] <- 5

data$Reg6[data$Reg6 == "[1] Never/Seldom"] <- 1
data$Reg6[data$Reg6 == "[2] Rarely"] <- 2
data$Reg6[data$Reg6 == "[3] Sometimes"] <- 3
data$Reg6[data$Reg6 == "[4] Often"] <- 4
data$Reg6[data$Reg6 == "[5] Very Often"] <- 5

data$Reg7[data$Reg7 == "[1] Never/Seldom"] <- 1
data$Reg7[data$Reg7 == "[2] Rarely"] <- 2
data$Reg7[data$Reg7 == "[3] Sometimes"] <- 3
data$Reg7[data$Reg7 == "[4] Often"] <- 4
data$Reg7[data$Reg7 == "[5] Very Often"] <- 5

data$Reg8[data$Reg8 == "[1] Never/Seldom"] <- 1
data$Reg8[data$Reg8 == "[2] Rarely"] <- 2
data$Reg8[data$Reg8 == "[3] Sometimes"] <- 3
data$Reg8[data$Reg8 == "[4] Often"] <- 4
data$Reg8[data$Reg8 == "[5] Very Often"] <- 5

data$Reg9[data$Reg9 == "[1] Never True"] <- 1
data$Reg9[data$Reg9 == "[2] Rarely True"] <- 2
data$Reg9[data$Reg9 == "[3] Sometimes True"] <- 3
data$Reg9[data$Reg9 == "[4] Often True"] <- 4
data$Reg9[data$Reg9 == "[5] Very Often True"] <- 5

data$Reg10[data$Reg10 == "[1] Certainly False"] <- 1
data$Reg10[data$Reg10 == "[2] Mostly False"] <- 2
data$Reg10[data$Reg10 == "[3] Uncertain"] <- 3
data$Reg10[data$Reg10 == "[4] Mostly True"] <- 4
data$Reg10[data$Reg10 == "[5] Certainly True"] <- 5

data$Reg11[data$Reg11 == "[1] Certainly False"] <- 1
data$Reg11[data$Reg11 == "[2] Mostly False"] <- 2
data$Reg11[data$Reg11 == "[3] Uncertain"] <- 3
data$Reg11[data$Reg11 == "[4] Mostly True"] <- 4
data$Reg11[data$Reg11 == "[5] Certainly True"] <- 5

data$Reg1 <- as.numeric(data$Reg1)
data$Reg2 <- as.numeric(data$Reg2)
data$Reg3 <- as.numeric(data$Reg3)
data$Reg4 <- as.numeric(data$Reg4)
data$Reg5 <- as.numeric(data$Reg5)
data$Reg6 <- as.numeric(data$Reg6)
data$Reg7 <- as.numeric(data$Reg7)
data$Reg8 <- as.numeric(data$Reg8)
data$Reg9 <- as.numeric(data$Reg9)
data$Reg10 <- as.numeric(data$Reg10)
data$Reg11 <- as.numeric(data$Reg11)

data <- data %>% mutate(promotion =((6-Reg1) + Reg3 + Reg7 + (6-Reg9) + Reg10 + (6-Reg11))/ 6) %>% 
                 mutate(prevention =((6-Reg2) + (6-Reg4) + Reg5 + (6-Reg6) + (6-Reg8)) / 5)



mean(data$promotion,na.rm = T)
mean(data$prevention,na.rm = T)

propre <- na.omit(data[,c("promotion", "prevention")])



cor(propre$promotion,propre$prevention)

data1 <- data %>% filter(Last.page==5)

#Motivation Ranking
ggplot(data.entry())
df <- as.data.frame(summary(as.factor(data$Rank1)))
