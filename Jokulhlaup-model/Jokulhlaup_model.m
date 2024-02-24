function [Q_max,t_max,fit,z_inf,Ss1,Tfit,chi2,NDF,chi2_lsq] = Jokulhlaup_model(TIME,QQ,AAA,AAAA)

    function [q,T,xx1] = dynamic_model(fit,t,Q_ref)
    H = 1; pout = 0; hat_L = 1.4; 
     NN = 8/3; 
    z0 = 1.13;
    x0 = [0;z0]; % initial condition odes 
    [T,Xa] = ode45(@DifEq,t,x0); 
        function dX = DifEq(t,x) 
        H = 1; pout = 0; hat_L = 1.4; NN = 8/3; 
        dxdt = zeros(2,1);
        dxdt(1) = fit(2).*(x(2).*(1+exp(-(max(0,x(1)))./fit(3)))./2-H+pout);
        dxdt(2) = -fit(1).*(x(2).*(1-exp(-(max(0,x(1)))./fit(3)))-pout+hat_L).^(0.5)*(max(0,x(1))).^(NN/2);
        dX = dxdt;
        end
    ss = max(0,Xa(:,1));    
    q1 = (ss.^(NN)).^(1/2);
    q2 = (Xa(:,2).^(1/2));
    q = q1.*q2; % Portata adimensionalizzata 
    xx1 = Xa; 
    end

fit0 = [7;1;1];%0.1];%1]; % starting guess 
lb = [0;0;0]; % lower bound 
ub = [1e+30;1e+30;1e+30]; % upper bound 

%--------------------------------------------------------------------------
% % data 
% %  
AA = [TIME,QQ];
BB = sortrows(AA,1);
TIME = BB(:,1);
QQ = BB(:,2);
t_tot_dim = TIME - TIME(1); 
t_ref = max(t_tot_dim);
t_tot = (1/t_ref).*t_tot_dim; 
x_tot_dim = QQ - QQ(1); 
Q_ref = max(x_tot_dim);
x_tot = (Q_ref^(-1)).*x_tot_dim; 

%--------------------------------------------------------------------------

options = optimoptions('lsqcurvefit','StepTolerance',1e-10,'TolFun', 1e-10,'MaxFunctionEvaluations',6000,'MaxIterations',3500,'Display', 'iter-detailed')%'MaxFunctionEvaluations',2000,'MaxIterations',400,'Algorithm','levenberg-marquardt',

[fit,Rsdnrm,Rsd,ExFlg,OptmInfo,Lmda,Jmat]=lsqcurvefit(@dynamic_model,fit0,t_tot,x_tot,lb,ub,options); 
fprintf(['The ''trust-region-reflective'' algorithm has residual norm %f,\n'],Rsdnrm) %residual = fun(x,xdata)-ydata 
fprintf(['Exitflag: %d,\n'],ExFlg)

fprintf(1,'\tFit Constants:\n')
for k1 = 1:length(fit)
    fprintf(1, '\t\tfit(%d) = %8.5f\n', k1, fit(k1))
end

Tfit = t_tot; %linspace(min(t_tot), max(t_tot),length(x_tot));
Tfit2 = linspace(min(t_tot), max(t_tot),100);%length(x_tot)
[Xfit,T,X_sol] = dynamic_model(fit, Tfit); 
[Xfit2,T2,X_sol2] = dynamic_model(fit, Tfit2);
Q_max = round(Q_ref)
t_max = round(t_ref,1) 
z_inf = X_sol(end,2)
XX = X_sol 
Ss = max(X_sol(:,1),0)
Ss1 = [];
Ss1 = [Ss1 Ss];
diff = x_tot(1);
chi2 = sum(((x_tot(2:end-1) - Xfit((2:end-1),1)).^2)./((0.3*x_tot(2:end-1)).^2));
chi2_lsq = Rsdnrm./((0.3).^2);
XTOT = x_tot(2:end-1);
XFITT = Xfit((2:end-1),1);
NDF = length(x_tot)-2; 

%--------------------------------------------------------------------------

figureHandle1 = figure(1)
plot(t_tot, x_tot, 'ro','LineWidth',0.9);
hold on
plot(Tfit2, Xfit2,'b','LineWidth',0.9);
hold off
xlabel('Dimensionless Time','Interpreter','latex','FontSize',14)
ylabel('Dimensionless Discharge, $ Q/ Q_{ref} $ ','Interpreter','latex','FontSize',14)
legend('Data','Simulation','Interpreter','latex','FontSize',11)  


title({['Eastern {Skaft\''a} ', AAA]},'Interpreter','latex','FontSize',18);
annotation('textbox', [0.6259, 0.675, 0.1, 0.1], 'String', ...
    {"$Q_{ref} \enspace = \enspace $"  + num2str( Q_max) + "$\enspace$" + "m$^3/$s", ... 
    "$t_{ref} \enspace = \enspace $" + num2str( t_max) + "\enspace days"}, ... 
    'Interpreter','latex','FontSize',11,'FitBoxToText','on'); 
saveas(figureHandle1,['QQ_Skafta' AAAA '.fig']);
saveas(figureHandle1,['QQ_Skafta' AAAA '.eps']);
saveas(figureHandle1,['QQ_Skafta' AAAA '.png']);

figureHandle2 = figure(2)
plot(Tfit2,X_sol2(:,2),'b','LineWidth',0.9);
xlabel('Dimensionless Time','Interpreter','latex','FontSize',14)
ylabel('$ z(t) $ ','Interpreter','latex','FontSize',14)
saveas(figureHandle2,['zz_Skafta' AAAA '.fig']);
saveas(figureHandle2,['zz_Skafta' AAAA '.eps']);
saveas(figureHandle2,['zz_Skafta' AAAA '.png']);

hold all
end
