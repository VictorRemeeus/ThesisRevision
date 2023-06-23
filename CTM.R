#all the code is taken from the STM paper/manual: https://cran.r-project.org/web/packages/stm/vignettes/stmVignette.pdf
library("Rtsne")
library("rsvd")
library("geometry")
library("stm")

#reading and checking the data
data <- read.csv("G:\\Master\\Thesis revision\\Datasets\\dataset_ctm_under.csv")
head(data)

#making the data ready for the topic model, pre-processing already done
processed <- textProcessor(data$review_text, metadata = data, lowercase = FALSE,
                           removestopwords = FALSE,
                           removenumbers = FALSE,
                           removepunctuation = FALSE, stem = FALSE)
out <- prepDocuments(processed$documents, processed$vocab, processed$meta, lower.thresh = 5)
docs <- out$documents
vocab <- out$vocab
meta <- out$meta

#searching for the best K
modeltest <- searchK(documents = out$documents, vocab = out$vocab, K= c(seq(5,55,5)) , data = out$meta, init.type = "Spectral")
modeltest
plot(modeltest)
#topic modelling
model30 <- stm(documents = out$documents, vocab = out$vocab, K=30 , data = out$meta, max.em.its = 75, init.type = "Spectral", seed = 101)
save(model30, file = "G:\\Master\\Thesis revision\\Datasets\\model30_ctm.csv")

model40 <- stm(documents = out$documents, vocab = out$vocab, K=40 , data = out$meta, max.em.its = 75, init.type = "Spectral", seed = 101)
save(model40, file = "G:\\Master\\Thesis revision\\Datasets\\model40_ctm.csv")

model50 <- stm(documents = out$documents, vocab = out$vocab, K=50 , data = out$meta, max.em.its = 75, init.type = "Spectral", seed = 101)
save(model50, file = "G:\\Master\\Thesis revision\\Datasets\\model50_ctm.csv")
#looking at the topic topics, and their keywords               
plot(model)
labelTopics(model, c(35,19,68,49,64,4,55,86,37,110))
cloud(model, topic = , scale = c(2,.25))

#Saving output for sentiment classifcation
output30 <- model30$theta
dataset_for_classification <- cbind(out$meta$review_text, output30, out$meta$review_score)

write.csv(dataset_for_classification, "G:\\Master\\Thesis revision\\Datasets\\ctm_features_30.csv", row.names=FALSE)

output40 <- model40$theta
dataset_for_classification <- cbind(out$meta$review_text, output40, out$meta$review_score)

write.csv(dataset_for_classification, "G:\\Master\\Thesis revision\\Datasets\\ctm_features_40.csv", row.names=FALSE)

output50 <- model50$theta
dataset_for_classification <- cbind(out$meta$review_text, output50, out$meta$review_score)

write.csv(dataset_for_classification, "G:\\Master\\Thesis revision\\Datasets\\ctm_features_50.csv", row.names=FALSE)

