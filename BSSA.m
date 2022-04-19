function [Convergence,best_odor,bstsi]=BSSA(Fobj,dim)
%% parameter setup
N=100;                  % number of population
maxiter=10;             % maximum iterations
lb=-0.1;                  % lower bound
ub=0.1;                   % upper bound
% dim=10;                 % number of variables 
thresh1=1.2;              % threshold 1(?1)
thresh2=50;             % threshold 2(?1)
Function_name='F1';     % Name of the test function that can be from F1 to F23 (Table 1,2,3 in the paper)
% [~,~,~,Fobj]=Get_Functions_details(Function_name);
% initialize population
bear_odour=initialization(N,dim,lb,ub);     % generate initial random population
bear_fitness=zeros(1,N);                    % Fitness
C1=zeros(N,dim);C2=zeros(N,dim);C3=zeros(N,dim);C4=zeros(N,dim);
POC=zeros(N,dim);
POf=zeros(1,N);
DOC=zeros(N,dim);
EOF=zeros(1,N);
%%
t=0;
bstsi=[];
Score=inf; 
tic;
while t<maxiter
    for i=1:size(bear_odour,1)
        Flag4Upperbound=bear_odour(i,:)>ub;
        Flag4Lowerbound=bear_odour(i,:)<lb;
        bear_odour(i,:)=(bear_odour(i,:).*(~(Flag4Upperbound+Flag4Lowerbound)))+ub.*Flag4Upperbound+lb.*Flag4Lowerbound;
        [bear_fitness(i),signal(i,:)]=Fobj(bear_odour(i,:));              % evaluate fitness
        if min(bear_fitness)<Score 
            Score=bear_fitness(i); 
            best_odor=bear_odour(i,:);
            bstsi=signal(i,:);
        end

    end
   for i=1:size(bear_odour,1)
   for j=1:size(bear_odour,2)
        POC(i,j)=bear_odour(i,j)/max(bear_odour(i,:))+rand;         % probability odor component
        POf(i)=bear_fitness(i)/max(bear_fitness);                   % Probability odor fitness
        POF_global=min(POf);                                        % global solution
        DOC(i,j)=1-(sum(POC(i,j)-(POC(i,j).*POC(i,j))/sqrt(sum((POC(i,j)-(POC(i,j).*POC(i,j))))^2)));   % distance odor components
        EOF(i)=abs(POf(i)-POF_global)+rand;                         % expected odor fitness
        C1(i,j)=-EOF(i)*((2-(DOC(i,j)/thresh2)));                   % Coefficient C1
        C2(i,j)=-EOF(i)*((2-(DOC(i,j)/thresh1)));                   % Coefficient C2
        C3(i,j)=EOF(i)*((2-(DOC(i,j)/thresh2)));                    % Coefficient C3
        C4(i,j)=EOF(i)*((2-(DOC(i,j)/thresh1)));                    % Coefficient C4

   end
   
   end
 for i4=1:N
    if DOC(i4)<= thresh2 && EOF(i4)<=thresh1
        bear_odour(i4,:)=C1(i4)*bear_odour(i4,:)-rand*(C2(i4))*(bear_odour(i4,:)-best_odor);
    else
        bear_odour(i4,:)=C3(i4)*bear_odour(i4,:)-rand*(C4(i4))*(bear_odour(i4,:)-best_odor);
    end
end
    t=t+1;
    Convergence(t)=Score;
%     [t Score];
    sprintf('Iteration number = %s , Best score is = %s',num2str(t),num2str(Score))
end
timec=toc;                                              % time consumed
