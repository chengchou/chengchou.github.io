# Given an npcdensbw object, get the fitted conditional probability of Y = 1.
np2ccp <- function(bw, newdata = NULL) {
  # np1 is the output of npcdensbw function.
  if (is.null(newdata)) {
    # If mode is 1, use the conditional density
    np1 <- npconmode(bw)
    p <- ifelse(np1$conmode == 1, np1$condens, 1 - np1$condens) 
  } else {
    np1 <- npconmode(bw, newdata = newdata)
    p <- ifelse(np1$conmode == 1, np1$condens, 1 - np1$condens) 
  }
  p
}

# Use bootstrap to find the bandwith when the sample size is large.
bw.bootstrap <- function(n.resample = 50, n.sub = 250, auto = FALSE, fun, ...) {
  # NOTE: You must use formula + data specification to make it work.
  # n.resample: the numeber of resampling.
  # n.sub: the number of observations in each subsample. Let n.sub = Inf, if
  # you need to use the whole sample.
  # auto: if auto = TRUE, n.resample = n / (n.sub * 10).
  # fun: the name of a function from np package.
  # ...: the additional arguments for that np function.
  FUN <- match.fun(fun)
  args <- list(...)
  if (! 'formula' %in% names(args) | ! 'data' %in% names(args)) {
    stop("This routine uses 'formula' and 'data' specification")
  }
  # sample size of the data
  n <- nrow(args[['data']])
  # Determine the n.resample and n.sub based on n.
  if (n.sub >= n) {
    # If the sub-sample size (n.sub) is greater than sample size, use the whole
    # sample.
    bw <- do.call(FUN, args)
    return(bw)
  }
  if (auto) {
    # If auto pick n.resample
    n.resample <- round(n / (n.sub * 10))
  } else {
    # If the sample size n is too small relative to n.sub, make n.resample
    # smaller, but not smaller than 10.
    n.resample <- replace(n.resample, n.resample > n / n.sub, max(10, round(n / n.sub)))
  }
  # turn off np messages.
  options(np.messages = FALSE)
  bw.vec <- c()
  pgbar <- txtProgressBar(min = 1, max = n.resample, style = 3)
  for (i in 1 : n.resample) {
    setTxtProgressBar(pgbar, i)
    bw.i <- do.call(FUN, c(args, list(subset = sample(n, n.sub))))
    if('bw' %in% names(bw.i) | all(c('ybw', 'xbw') %in% names(bw.i))) {
      if ('bw' %in% names(bw.i)) {
        # if returned 'bw', e.g. npudensbw, npregbw
        # The dimension of bandwidth.
        p <- length(bw.i$bw)
        bw.vec <- append(bw.vec, c(bw.i$bw))
      }
      if (all(c('ybw', 'xbw') %in% names(bw.i))) {
        # if returned 'ybw' and 'xbw', e.g. npcdist
        # The dimension of bandwidth.
        p <- length(bw.i$ybw) + length(bw.i$xbw)
        bw.vec <- append(bw.vec, c(bw.i$ybw, bw.i$xbw))
      }
    } else {
      stop('Error: This np function is not supported.')
    }
  }
  close(pgbar)
  # Use the median of bandwidth from the replications.
  bw <- apply(matrix(bw.vec, nc = p, byrow = TRUE), 2, median)
  bw.obj <- do.call(FUN, c(args, list(bws = bw, bandwidth.compute = FALSE)))
  # reset np messages.
  options(np.messages = TRUE)
  # return bandwidth object
  bw.obj
}
