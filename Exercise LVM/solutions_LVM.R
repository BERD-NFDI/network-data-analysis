setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
set.seed = 123456

# install.packages("network")
# install.packages("blockmodels")
# install.packages("latentnet")

# Task 1: Load all required packages (network, blockmodels, latentnet)
library(network)
library(blockmodels)
library(latentnet)

# Task 2: Load the file forex_network.RDS into your environment (hint: maybe check out readRDS)
forex_network <- readRDS("forex_network.rds")


# Task 3: What additional covariate is provided? Describe and visualize it
plot(density(forex_network %v% "gdpcap"))

# Task 4: Plot the network using the Fruchterman-Rheingold algorithm and use all additional covariates! 
#         Check out help("plot.network") to see how to modify the plot. 

plot(forex_network,
     mode = "fruchtermanreingold", # it's actually the default
     vertex.cex = ((forex_network %v% "gdpcap") - 5)
)


# we can plot with country labels:
plot(forex_network,
     mode = "fruchtermanreingold",
     vertex.cex = ((forex_network %v% "gdpcap") - 5),
     displaylabels = T
     )

# Task 5: Model the data using the classical stochastic blockmodel.
# estimate the model using the function BM_bernoulli, with the syntax:

# my_model= BM_bernoulli(...)
# my_model$estimate() 

#Estimate the model with different numbers of communities K.
#What do you think would be a reasonable choice for K?

library(blockmodels)
my_model= 
  BM_bernoulli(
    membership_type="SBM",
    adj=as.matrix(forex_network),
    verbosity=6,
    autosave='',
    plotting=character(0),
    exploration_factor=1.5,
    explore_min=1,
    explore_max=10)

my_model$estimate() #gives the likelihood for different number of comms
which.max(my_model$ICL) #The ICL criterion selects 4 communities



# Task 6: Next, plot the network as before, but coloring the nodes 
# by their estimated blocks just found through the SBM

#create network attribute equal to the found block
found_block<-my_model$memberships[[4]]$map()[[1]]
forex_network%v%"block"= found_block

#plot with color = block
plot(forex_network,vertex.col = found_block+1,displaylabels=T)

#we can also plot with size proportional to per-capita gdp:
plot(forex_network,vertex.col = found_block+1,
     vertex.cex = (forex_network %v% "gdpcap" - 5),
     displaylabels=T)

# Task 7: We now want to model the network using the Latent Space Model.
# Estimate an LSM using the function "ergmm()" from the package "latentnet".


#fit latent cluster random effect model in 2 dimensions and with 2 clusters
lsm <- ergmm(forex_network ~ euclidean(d=2, G=1) + rsender + rreceiver, 
             tofit="mkl", verbose=T)  

# Task 8: Finally, plot the estimated latent space, labeling each nodes.
# What patterns do you observe? How do the results compare with previous ones?

#plot latent positions and posterior probabilities of cluster memberships
plot(lsm, pie=T, print.formula=FALSE, labels=T)  
