function [Q_max,t_max,fit,z_inf,Ss1,Tfit,chi2,NDF,chi2_lsq] = Jokulhlaup_model(TIME,QQ,AAA,AAAA)
% 2020 08 06

    function [q,T,xx1] = dynamic_model(fit,t,Q_ref)
    H = 1; pout = 0; hat_L = 1.4; %hat_L sarebbe hat_d 
     NN = 8/3; %gamma_fit3 = 10^3;
    z0 = 1.13;%0.7;%
    x0 = [0;z0]; % initial condition odes 
    [T,Xa] = ode45(@DifEq,t,x0); 
        function dX = DifEq(t,x) 
        %H = 1; pout = 0;
        H = 1; pout = 0; hat_L = 1.4; NN = 8/3; %gamma_fit3 = 10^3; 
        dxdt = zeros(2,1);
        dxdt(1) = fit(2).*(x(2).*(1+exp(-(max(0,x(1)))./fit(3)))./2-H+pout);
        dxdt(2) = -fit(1).*(x(2).*(1-exp(-(max(0,x(1)))./fit(3)))-pout+hat_L).^(0.5)*(max(0,x(1))).^(NN/2);
%         dxdt(1) = fit(2).*(x(2).*(1+exp(-(max(0,x(1)))./gamma_fit3))./2-H+pout);
%         dxdt(2) = -fit(1).*(x(2).*(1-exp(-(max(0,x(1)))./gamma_fit3))-pout+hat_L).^(0.5)*(max(0,x(1))).^(NN/2);
        dX = dxdt;
        end
    ss = max(0,Xa(:,1));    
    q1 = (ss.^(NN)).^(1/2);
    q2 = (Xa(:,2).^(1/2));
    q = q1.*q2; %Portata adimensionalizzata 
    xx1 = Xa; 
    end

fit0 = [7;1;1];%0.1];%1]; % starting guess 
lb = [0;0;0];%0];%1]; % limite inferiore per il beta fittato 
ub = [1e+30;1e+30;1e+30];%15];%1e+30]; % limite superiore per il beta fittato 

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
% FunctionTolerance is a tolerance for the size of the latest change in
% objective function value [Iterations end when the last step issmaller
% than FunctionTolerance] 
% https://de.mathworks.com/help/optim/ug/lsqcurvefit.html
[fit,Rsdnrm,Rsd,ExFlg,OptmInfo,Lmda,Jmat]=lsqcurvefit(@dynamic_model,fit0,t_tot,x_tot,lb,ub,options); %Solve nonlinear curve-fitting (data-fitting) problems in least-squares sense 
fprintf(['The ''trust-region-reflective'' algorithm has residual norm %f,\n'],Rsdnrm) %residual = fun(x,xdata)-ydata 
fprintf(['Exitflag: %d,\n'],ExFlg)

fprintf(1,'\tFit Constants:\n')
for k1 = 1:length(fit)
    fprintf(1, '\t\tfit(%d) = %8.5f\n', k1, fit(k1))
end

Tfit = t_tot; %linspace(min(t_tot), max(t_tot),length(x_tot));
Tfit2 = linspace(min(t_tot), max(t_tot),100);%length(x_tot)
[Xfit,T,X_sol] = dynamic_model(fit, Tfit); %ci restituisce Q/Q_bar nel valore fittato così facciamo il confronto grafico con i dati 
[Xfit2,T2,X_sol2] = dynamic_model(fit, Tfit2);
Q_max = round(Q_ref)
t_max = round(t_ref,1) 
z_inf = X_sol(end,2)
XX = X_sol 
Ss = max(X_sol(:,1),0)
Ss1 = [];
Ss1 = [Ss1 Ss];
diff = x_tot(1);%sum(x_tot - X_sol(:,1))- Rsd
chi2 = sum(((x_tot(2:end-1) - Xfit((2:end-1),1)).^2)./((0.3*x_tot(2:end-1)).^2));%Rsdnrm
chi2_lsq = Rsdnrm./((0.3).^2);
XTOT = x_tot(2:end-1);
XFITT = Xfit((2:end-1),1);
NDF = length(x_tot)-2; %adesso abbiamo due parametri alpha e beta
% II_1 = find((XTOT > 0)&(XTOT <= 0.3*Q_max));
% II_2 = find((XTOT > 0.3*Q_max)&(XTOT <= 0.8*Q_max));
% II_3 = find((XTOT > 0.8*Q_max)&(XTOT <= Q_max));
% resnorm — Squared norm of the residual
% nonnegative real
% Squared norm of the residual, returned as a nonnegative real. 
% resnorm is the squared 2-norm of the residual at x: sum((fun(x,xdata)-ydata).^2).
% chi2_1 = 0; 
% chi2_2 = 0; 
% chi2_3 = 0;
% for i = II_1
%     chi2_1 = chi2_1 + ((XTOT(i) - XFITT(i)).^2)./((0.3*XTOT(i)).^2)%((0.3^2))) 
% end
% for j = II_2
%     chi2_2 = chi2_2 + ((XTOT(j) - XFITT(j)).^2)./((0.3*XTOT(j)).^2)%((0.2^2)))
% end
% for k = II_3
%     chi2_3 = chi2_3 + ((XTOT(k) - XFITT(k)).^2)./((0.3*XTOT(k)).^2)%((0.1^2)))
% end
% % chi2_tot = chi2_1(length(II_1)) + chi2_2(length(II_2)) + chi2_3(length(II_3)) 
% chi2_tot = length(chi2_1)% + chi2_2 + chi2_3 
%--------------------------------------------------------------------------

figureHandle1 = figure(1)
plot(t_tot, x_tot, 'ro','LineWidth',0.9);
hold on
plot(Tfit2, Xfit2,'b','LineWidth',0.9);
hold off
xlabel('Dimensionless Time','Interpreter','latex','FontSize',14)
ylabel('Dimensionless Discharge, $ Q/ Q_{ref} $ ','Interpreter','latex','FontSize',14)
%legend('Data','Simulation','Interpreter','latex','FontSize',11)  % mettere accento e date dei jouk 
legend('Data','Simulation','Interpreter','latex','FontSize',11)  % mettere accento e date dei jouk 
% legend('Data {Gr\''{\i}msv\"{o}tn} 1996(b)','Simulation','Interpreter','latex')
% legend('Data Katla 1918'){Skaft\''a} 

title({['Eastern {Skaft\''a} ', AAA]},'Interpreter','latex','FontSize',18);
% annotation('textbox', [0.659, 0.675, 0.1, 0.1], 'String', ...
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
%legend('{Grimsv\"{o}tn}','Interpreter','latex','FontSize',11) % mettere accento e date dei jouk 
% legend('{Gr\''{\i}msv\"{o}tn} 1996(b)','Interpreter','latex')
% legend('Katla 1918')
title({['Eastern {Skaft\''a} ', AAA]},'Interpreter','latex','FontSize',18);
% annotation(figure1,'textbox',...
%     [0.673619047619048 0.636507936507936 0.177571428571428 0.096825396825397],...
%     'String',{'Q_ref = ... , t_ref = ...'},...
%     'FitBoxToText','off');%,'Interpreter','latex');
saveas(figureHandle2,['zz_Skafta' AAAA '.fig']);
saveas(figureHandle2,['zz_Skafta' AAAA '.eps']);
saveas(figureHandle2,['zz_Skafta' AAAA '.png']);

% figureHandle3 = figure(3)
% plot(TIME, QQ, 'ro','LineWidth',0.9);
% xlabel('Time','Interpreter','latex','FontSize',14)
% ylabel('Discharge, $ Q $ ','Interpreter','latex','FontSize',14)
% legend('Data','Interpreter','latex','FontSize',11)  % mettere accento e date dei jouk 
% % legend('Data {Gr\''{\i}msv\"{o}tn} 1996(b)','Simulation','Interpreter','latex')
% % legend('Data Katla 1918'){Skaft\''a}
% title({['Eastern {Skaft\''a} ', AAA]},'Interpreter','latex','FontSize',18);
% saveas(figureHandle3,['DATI_QQ_Skafta' AAAA '.fig']);
% saveas(figureHandle3,['DATI_QQ_Skafta' AAAA '.png']);

% hold all
% figureHandle4 = figure(4)
% plot(Tfit,Ss,'LineWidth',0.9,'DisplayName',AAAA);%'b',
% xlabel('Dimensionless Time','Interpreter','latex','FontSize',14)
% ylabel('$ s(t) $ ','Interpreter','latex','FontSize',14)
% legend('-DynamicLegend')
% %legend('{Grimsv\"{o}tn}','Interpreter','latex','FontSize',11) % mettere accento e date dei jouk 
% % legend('{Gr\''{\i}msv\"{o}tn} 1996(b)','Interpreter','latex')
% % legend('Katla 1918')
% title({['Eastern {Skaft\''a}']},'Interpreter','latex','FontSize',18);
% % {['Eastern {Skaft\''a}', AAA]}
% % annotation(figure1,'textbox',...
% %     [0.673619047619048 0.636507936507936 0.177571428571428 0.096825396825397],...
% %     'String',{'Q_ref = ... , t_ref = ...'},...
% %     'FitBoxToText','off');%,'Interpreter','latex');
% saveas(figureHandle4,['ss_Skafta_from1982to' AAAA '.fig']);
% saveas(figureHandle4,['ss_Skafta_from1982to' AAAA '.eps']);
% saveas(figureHandle4,['ss_Skafta_from1982to' AAAA '.png']);
hold all
end