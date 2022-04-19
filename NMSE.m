function [out,signal] = NMSE( wb, net, input, target)

% wb is the weights and biases row vector obtained from the genetic algorithm.

% It must be transposed when transferring the weights and biases to the network net.

 net = setwb(net, wb');

% The net output matrix is given by net(input). The corresponding error matrix is given by
y=net(input);
 error = target - net(input);

% The mean squared error normalized by the mean target variance is
txSig=complex(input(1,:),input(2,:));
signal=complex(y(1,:),y(2,:));
out=20*log10(mse(txSig,signal));
%  NMSE_calc = mean(error.^2)/mean(var(target',1));

% It is independent of the scale of the target components and related to the Rsquare statistic via

% Rsquare = 1 - NMSEcalc ( see Wikipedia)
