function [varargout] = gp_mu(hyp, inf, mean, cov, lik, x, y, xs, post)

% Gaussian Process inference and prediction. The gp function provides a
% flexible framework for Bayesian inference and prediction with Gaussian
% processes for scalar targets, i.e. both regression and binary
% classification. The prior is Gaussian process, defined through specification
% of its mean and covariance function. The likelihood function is also
% specified. Both the prior and the likelihood may have hyperparameters
% associated with them.
%
% Two modes are possible: training or prediction: if no test cases are
% supplied, then the negative log marginal likelihood and its partial
% derivatives w.r.t. the hyperparameters is computed; this mode is used to fit
% the hyperparameters. If test cases are given, then the test set predictive
% probabilities are returned. Usage:
%
%   training: [nlZ dnlZ          ] = gp(hyp, inf, mean, cov, lik, x, y);
% prediction: [ymu ys2 fmu fs2   ] = gp(hyp, inf, mean, cov, lik, x, y, xs);
%         or: [ymu ys2 fmu fs2 lp] = gp(hyp, inf, mean, cov, lik, x, y, xs, ys);
%
% where:
%
%   hyp      column vector of hyperparameters
%   inf      function specifying the inference method 
%   cov      prior covariance function (see below)
%   mean     prior mean function
%   lik      likelihood function
%   x        n by D matrix of training inputs
%   y        column vector of length n of training targets
%   xs       ns by D matrix of test inputs
%   ys       column vector of length nn of test targets
%
%   nlZ      returned value of the negative log marginal likelihood
%   dnlZ     column vector of partial derivatives of the negative
%               log marginal likelihood w.r.t. each hyperparameter
%   ymu      column vector (of length ns) of predictive output means
%   ys2      column vector (of length ns) of predictive output variances
%   fmu      column vector (of length ns) of predictive latent means
%   fs2      column vector (of length ns) of predictive latent variances
%   lp       column vector (of length ns) of log predictive probabilities
%
%   post     struct representation of the (approximate) posterior
%            3rd output in training mode or 6th output in prediction mode
%            can be reused in prediction mode gp(.., cov, lik, x, post, xs,..)
% 
% See also covFunctions.m, infMethods.m, likFunctions.m, meanFunctions.m.
%
% Copyright (c) by Carl Edward Rasmussen and Hannes Nickisch, 2013-01-21

  alpha = post.alpha; 
  if issparse(alpha)                  % handle things for sparse representations
    nz = alpha ~= 0;                                 % determine nonzero indices
  else nz = true(size(alpha,1),1); end               % non-sparse representation

  ns = size(xs,1);                                       % number of data points
  nperbatch = 1000;                       % number of data points per mini batch
  nact = 0;                       % number of already processed test data points
  ymu = zeros(ns,1); fmu = ymu;   % allocate mem
  while nact<ns               % process minibatches of test cases to save memory
    id = (nact+1):min(nact+nperbatch,ns);               % data points to process

    Ks  = feval(cov{:}, hyp.cov, x(nz,:), xs(id,:));         % cross-covariances
    ms = feval(mean{:}, hyp.mean, xs(id,:));
    N = size(alpha,2);  % number of alphas (usually 1; more in case of sampling)
    Fmu = repmat(ms,1,N) + Ks'*full(alpha(nz,:));        % conditional mean fs|f
    fmu(id) = sum(Fmu,2)/N;                                   % predictive means

    ymu(id) = sum(reshape(Fmu,[],N),2)/N;          % predictive mean ys|y and ..

    nact = id(end);          % set counter to index of last processed data point
  end
  if nargin<9
    varargout = {ymu};        % assign output arguments
  else
    varargout = {ymu};
  end

