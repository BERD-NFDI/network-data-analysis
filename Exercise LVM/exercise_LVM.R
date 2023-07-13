setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
# install.packages("network")
# install.packages("blockmodels")
# install.packages("latentnet")

# Task 1: Load all required packages (network, blockmodels, latentnet).

# Task 2: Load the file forex_network.rds into your environment .
# Hint: you can check out the R help with ?readRDS

# Task 3: What additional covariate is provided? Describe and visualize it.

# Task 4: Plot the network using the Fruchterman-Rheingold algorithm and use all additional covariates! 
#         Check out help("plot.network") to see how to modify the plot. 

# Task 5: Model the data using the classical stochastic blockmodel.
# estimate the model using the function BM_bernoulli, with the syntax:

# my_model= BM_bernoulli(...)
# my_model$estimate() 

#Estimate the model with different numbers of communities K.
#What do you think would be a reasonable choice for K?

# Task 6: Next, plot the network as before, but coloring the nodes 
# by their estimated blocks just found through the SBM.

# Task 7: We now want to model the network using the Latent Space Model.
# Estimate an LSM using the function "ergmm()" from the package "latentnet".

# Task 8: Finally, plot the estimated latent space, labeling each nodes.
# What patterns do you observe? How do the results compare with previous ones?

