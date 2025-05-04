\name{sample_size}
\alias{sample_size}
\title{Calculate Required Sample Size for the Test on Subgroup Existence.}
\usage{
sample_size(outcome, theta0, sigma2, tau, N = 1000L, prob = 0.5, 
            alpha = 0.05, power = 0.9, K = 1000L, M = 1000L, seed = NULL,
            precision = 0.01, ...)
}
\arguments{
\item{outcome}{A formula object.
               The model of the indicator function. 
               The model must include an intercept.                     
               Any lhs variable will be ignored.}

\item{theta0 }{A named numeric vector.
               The true parameters of the indicator model.}

\item{sigma2 }{A numeric object.
               The variance of the random error.}

\item{tau    }{A numeric object.
               The desired treatment effect.}

\item{N      }{An integer object. 
               The number of random samples to draw.
               Default value is 1000.}

\item{prob   }{A numeric object.
               The probability of assigning individuals treatment 1.
               \code{0<=prob<=1}.}

\item{alpha  }{A numeric object.
               The significance level of the test, \code{0<alpha<1}.}

\item{power  }{A numeric object.
               The desired power of the test, \code{0<power<1}}

\item{K      }{An integer object. 
               The number of random sampled points on the unit ball 
               surface \eqn{\{\theta:||\theta||^2=1\}}. 
               These randomly sampled points are used for approximating 
               the Gaussian process in the null and local alternative       
               distributions of the test statistic with multivariate    
               normal distributions.                                    
               It is recommended that K be set to 10^p, where p is the  
               number of parameters in theta0.                          
               Note that it is recommended that the number of covariates
               be less than 10 for this implementation.                 
               Default value is 1000.}

\item{M      }{An integer object. 
               The number of resamplings of the perturbed test statistic.
               This sample is used to calculate the critical value of the
               test.
               Default and minimum values are 1000.}

\item{seed   }{An integer object or NULL. 
               If set, the seed for generating random values set at
               the onset of the calculation.
               If NULL, current seed in R environment is used.}

\item{precision}{A numeric object.
               The precision tolerance for estimating the power from the
               calculated sample size.
               Specifically, the power of the sample size returned, P,
               will be (power - precision) < P < (power + precision).}

\item{...    }{For each covariate in outcome, user must provide a list
               object indicating the distribution function to be sampled
               and any parameters to be set when calling that function.
               Each list contains "FUN", the function name of the
               random generator of the distribution, and any formal
               arguments of that function. For example:
               x1 = list("FUN" = rnorm, sd = 2.0, mean = 10.0)          
               x2 = list("FUN" = rbinom, size = 1, prob = 0.5)          
               The number of points generated is determined by input N. 
               Most distributions available through R's stats package   
               can be used. Exceptions are: rhyper, rsignrank, rwilcox. 
               Specifically, any random generator that passes the
               the number of observations to generate through formal
               argument 'n' can be used.}
}

\value{
A list consisting of
 \item{n    }{An integer object.
              The estimated sample size.}
 \item{power}{A numeric object.
              The estimated power.}
 \item{seed }{If seed was provided as input, the user specified 
              integer seed. If seed was not provided, not present. }
}
\description{Estimation of the required sample size for the 
             test on subgroup existence. With a pre-specified 
             significance level of the test \eqn{\alpha} and a 
             desired power \eqn{1-\beta} at a treatment effect 
             \eqn{\tau}, and other information about data, the 
             required sample size that achieves power \eqn{1-\beta} 
             can be estimated.
}
\details{The sample size calculation is based on the asymptotic null 
         and local alternative distributions of the test statistic. 
         More details can be  found in the reference paper.

         The difference between true baseline mean 
         function and posited mean function, \eqn{\mu(X)-h(X,\beta_0)}, 
         is set to zero when calculating the sample size.

         Because the calculated sample size is based on simulated 
         data following the null and local alternative distributions 
         of the test statistic, the results can be different with 
         different choices of \code{M} and \code{K}, as well as 
         different seeds. When the signal \code{tau} to noise 
         \code{sigma2} ratio is large, the calculated sample size 
         can be more robust.
}
\examples{
model <- ~ x1 + x2
theta0 <- c("(Intercept)" = 0.0, "x1" = 1.0, "x2" = 0.25)
sample_size(outcome = ~ x1 + x2,
            theta0 = theta0,
            N = 1000,
            sigma2 = 0.25,
            tau = 0.25,
            K = 100, 
            M = 1000,
            x1 = list(FUN=runif, min = -1, max = 1),
            x2 = list(FUN=rnorm, mean = 0.0, sd = 0.75))
}
\references{
Ailin Fan, Rui Song, and Wenbin Lu, (2016).
Change-plane analysis for subgroup detection and sample size calculation, 
Journal of the American Statistical Association, in press.
}

