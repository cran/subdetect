\name{subgroup_detect}
\alias{subgroup_detect}
\title{Test for and Identify a Subgroup with an Enhanced Treatment Effect.}
\usage{
subgroup_detect(outcome, propen, data, 
                K = 1000L, M = 1000L, seed = NULL)
}
\arguments{
\item{outcome}{A formula object.
               The linear model for the outcome regression. 
               The left-hand-side variable must be the response.
               R function lm will be used to estimate model parameters.
               The response must be continuous.}

\item{propen }{A formula object.
               The model for the propensity score.
               The left-hand-side variable must be the treatment variable.
               R function glm will be used with input option
               family = binomial(link="logit") to estimate model parameters.
               The treatment must be binary.}

\item{data   }{A data.frame object.
               All covariates, treatment, and response variables.
               Note that the treatment must be binary and that the
               response must be continuous.}

\item{K      }{An integer object. 
               The number of random sampled points on the unit ball
               surface \eqn{\{\theta:||\theta||^2=1\}}.
               These randomly sampled points are used for approximating
               the Gaussian process in the null and local alternative
               distributions of the test statistic with multivariate
               normal distributions.
               It is recommended that K be set to 10^p, where p is the
               number of parameters in the outcome model.
               Note that it is recommended that the number of covariates
               be less than 10 for this implementation.
               Default value is 1000. }

\item{M      }{An integer object. 
               The number of resamplings of the perturbed test statistic.
               This sample is used to calculate the critical value of the
               test. 
               Default and minimum values are 1000.}

\item{seed   }{An integer object or NULL.
               If integer, the seed for random number generation,
               set at the onset of the calculation.
               If NULL, current seed in R environment is used. }
}
\value{
A list consisting of
 \item{outcome}{An lm object.
                The object returned by the lm fit of the outcome.}
 \item{propen }{A glm object.
                The object returned by the glm fit of the propensity.}
 \item{p_value}{A numeric object.
                The p-value of the test.}
 \item{theta  }{A named numeric vector.
                The change-plane parameter estimates for subgroup.}
 \item{prop   }{A numeric object.
                The proportion of sampled points on \eqn{\theta} unit
                ball surface that are used for calculating test
                statistic. For some values of \eqn{theta}, the
                subgroup contains no samples or all samples. These
                are discarded.}
\item{seed    }{If seed was provided as input, the user specified 
                integer seed. If seed was not provided, not present. }
}
\description{Tests for the existence of a subgroup with an enhanced 
             treatment effect. The subgroup of interest is represented 
             by \eqn{\{\theta:\theta^T X\ge 0\}}. The test returns a 
             p-value for \eqn{H_0:\tau=0}, where \eqn{\tau} is the 
             treatment effect in this subgroup. If \eqn{H_0} is 
             rejected, estimates for \eqn{\theta} can be used to 
             obtain the estimated subgroup.
}
\details{In this function, a linear model with least squares 
         estimate is used for fitting the baseline model \eqn{\mu(X)}, 
         and a logistic model with maximum likelihood estimate is 
         used for fitting the propensity score model \eqn{P(a=1|X)}.
         These settings cannot be changed by the user.
}
\examples{
#set parameters
tau <- 0.5
theta_t <- c(-0.15,0.3,sqrt(1-(-0.15)^2-(0.3)^2))
beta <- c(1,1,1)
sigma <- 0.5
n <- 50
p <- 2

#generate data
x1 <- rbinom(n,size=1,prob=0.5)
x2 <- runif(n,min=-1,max=1)
X <- cbind(1,x1,x2)
a <- rbinom(n,1,prob=0.5)
y <- drop(X\%*\%beta) + tau*a*(drop(X\%*\%theta_t)>=0) + rnorm(n,0,sigma)

data <- data.frame(X[,2:3], a, y)

subgroup_detect(outcome = y~x1+x2,
                propen = a~x1+x2,
                data = data)
}
\references{
Ailin Fan, Rui Song, and Wenbin Lu, (2016).
Change-plane analysis for subgroup detection and sample size calculation, 
Journal of the American Statistical Association, in press.
}

