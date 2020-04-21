function [M, err] = GPregression(xk, yk, ok, xs, kernel , hyperparam)
% GPregression makes a Gaussian Processes prediction of arrays (length Ns)
% of mean, M, and errors, err, for a function of which some samples are
% available. The input parameters are:
% xk	 -  N length array of x values of known data samples
% yk     -  N length array y values of known data samples
% ok     -  N length 1-sigma uncertainty of known data samples
% xs     -  Ns positions of the predictor values and uncertrainties.
% kernel -  the integer value choice of function for defining the covariance matrix
% hyperparam -  array containing any parameters needed by the kernel
% 
% Kernel choices:
%
%  kernel       function                 hyperparams
%  1            squared exponential      length scale = l
%
% only one kernel yet...
%
% This code was made by Peter Andersson at Uppsala University
% On the 21 of april 2020.
% Don't trust the code to be perfect. I'm new at this.


% Setting kernel
switch kernel
    case 1
        %length scale
        l = hyperparam;
        % kernel 
        K = @(x1, x2) exp(-  (x1-x2).^2 / (2* l^2));
    otherwise 
        error('Kernel value can so far only be "1"')
end


% Creating cov matrices

%cov C
for i = 1:length(xk) 
    for j = 1:length(xk)
        C(j,i) = K(xk(i), xk(j));
        if i==j
        C(j,i) = (1+ok(i)*ok(j))*K(xk(i), xk(j));
        end
        %C(j,i) = K(xk(i), xk(j));
    end
end


%cov A
for i = 1:length(xs) 
    for j = 1:length(xs)
        A(j,i) = K(xs(i), xs(j));
    end
end

%cov B
for i = 1:length(xk) 
    for j = 1:length(xs)
        B(j,i) = K(xk(i), xs(j));
         
    end
end



% prediction mean
M =  B*inv(C) * (yk'  ) ;

% prediction covariance
COV = A - B*inv(C) * B';
for i = 1:length(xs)
    err(i) = COV(i,i).^.5;
end
