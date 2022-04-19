
clc;
clear;
close all;
load trainData.mat
load label.mat
inputs=[real(train_data(1:5000)) ;imag(train_data(1:5000))];
targets=[real(d(1:5000)) ;imag(d(1:5000))];
% inputs for the neural net(AND gate example== 2 inputs && 4 samples)
% inputs = [0 0;0 1;1 0;1 1]';
% targets for the neural net
% targets = [0;0;0;1]';
% number of neurons
n = 4;
% create a neural network
net = feedforwardnet(n);
% configure the neural network for this dataset
net = configure(net, inputs, targets);
% get the normal NN weights and bias
wbb=getwb(net);
% error MSE normal NN
error = targets - net(inputs);
calc = mean(error.^2)/mean(var(targets',1));
% create handle to the MSE_TEST function, that
% calculates MSE
h = @(x) NMSE(x, net, inputs, targets);
% running the particle swarm optimization algorithm with desired options
[x1, BestCost,bestpso] = pso(h, size(wbb,1));
[Convergence,x,bestbssa]=BSSA(h, size(wbb,1));
figure;
plot(real(BestCost),'r');hold on
plot(real(Convergence),'g');hold on
xlabel('Iterations')
ylabel('objective value')
legend('PSO','BSSA')
net = setwb(net, x');
% get the PSO optimized NN weights and bias
getwb(net)
% error MSE PSO optimized NN
error = targets - net(inputs);
% calc = mean(error.^2)/mean(var(targets',1))
Nsamp = 16; 
num = ones(Nsamp,1)/Nsamp;
den = 1;
qam=4;
EbNo = 0:20; % Range of Eb/No values under study
berpso = semianalytic(train_data,bestpso,'qam',qam,Nsamp,num,den,EbNo);
berbssa = semianalytic(train_data,bestbssa,'qam',qam,Nsamp,num,den,EbNo);
figure(); 
semilogy(EbNo,berpso,'y-*','linewidth',2);hold on
semilogy(EbNo,berbssa,'b-*','linewidth',2);hold on
legend('PSO','BSSA')


