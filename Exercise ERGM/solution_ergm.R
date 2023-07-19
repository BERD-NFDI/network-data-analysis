setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(igraph)
library(ergm)
library(sna)
library(statnet)
library(intergraph)
# install.packages("igraph")
# install.packages("ergm")
# install.packages("sna")
# install.packages("statnet")
# install.packages("intergraph")

# Task 1: Load all required packages (statnet, igraph)
library(statnet)
# Task 2: Load the file faculty_network.RDS into your environment (hint: maybe check out readRDS)
faculty_network <- readRDS(file = "faculty_network.RDS")
# Task 3: What additional covariates are provided describe and visualize them?
barplot(table(faculty_network %v% "group"))
plot(density(faculty_network %v% "wealth", from = 0))
# Task 4: Plot the network using the Fruchterman-Rheingold algorithmn and use all additional covariates!
plot(faculty_network,
     mode = "fruchtermanreingold",
     vertex.cex =log(faculty_network %v% "wealth"),
     vertex.col=faculty_network %v% "group")
# Task 5: We next want to model the data with the available information.
#         Check out help("ergm-terms") and state frequently used ways in which nodal attributes
#         can be incorporated. Which ones are reasonable for our network?
help("ergm-terms") #  see absdiff(), absdiffcat(), diff(), nodematch(), edgecov(), nodeicov(), nodeocov() , ...
# Task 6: Next we want to estimate an ergm with terms counting the following things:
#         1. Number of edges in the network
#         2. Geometrically weighted DEG-distribution with alpha = log(2)
#         3. Geometrically weighted ESP-distribution with alpha = log(2)
#         4. Absolute difference in wealth between actors
#         5. Homophily based on the same group
#         Specify how to use those terms in ergm!
# Task 7: Try to estimate the ergm with the Stochastic Approximation method.
#         Inspect the function "control.ergm" to decide on the type of estimation algorithm.
faculty_model_beginning <- ergm(faculty_network~ edges+
                                  gwdegree(log(2), fixed = T) +
                                  gwesp(log(2), fixed = T) +
                                  absdiff("wealth") +
                                  nodematch("group"),
                                control = control.ergm(main.method = "Stochastic-Approximation"))
# Task 8: Finally, we want to use those estimates as starting values for the MCMCMLE estimation.
faculty_model_final <- ergm(faculty_network~ edges+
                              gwdegree(log(2), fixed = T) +
                              gwesp(log(2), fixed = T) +
                              absdiff("wealth") +
                              nodematch("group"),
                            control = control.ergm(main.method = "MCMLE", init = faculty_model_beginning$coefficients))
# Task 9: Print a summary of the model and interpret the findings.
summary(faculty_model_final)
# Task 10: Probabilistic models should be able to represent the observed data.
#          Inspect the gof function, plot it, and assess the fit of our model.
plot(gof(faculty_model_final))
# Task 11: The model was fit with MCMC methods. Thus, the estimates are only valid,
#          if the networks are really from the stationary distribution.
#          Further, ML estimates have the property to recover the observed sufficient
#          statistics on average. Use the function "mcmc.diagnostics" on your fitted model
#          which visualizes the path of sufficient statistics centered around the observed
#          statistics.
mcmc.diagnostics(faculty_model_final)
