function[c,ceq]= DelayConstraint(X)

tau0=7.92;
GammaD=0.627;
Cload=50;
D0=100; %il ritardo lo esprimo in ps
%Vincoli di uguaglianza non lineari(visti come ceq==0)
ceq=tau0*(1+X(1)/GammaD + 1 + X(2)/(GammaD*X(1)) + 1 + Cload/(GammaD*X(2))) -D0;
c=1-X(1);
