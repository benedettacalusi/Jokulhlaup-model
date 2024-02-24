% """
% Output_Jokulhlaup_model - MATLAB script to solve a simplified mechanical model for explaining fast-rising jokulhlaups
% 
% Copyright (C) 2020-#### 
%                by    Benedetta Calusi benedetta.calusi@unifi.it
% 
% This program is free software; you can redistribute it and/or 
% modify it under the terms of the GNU General Public License 
% as published by the Free Software Foundation; either version 
% 3 of the License, or (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful, 
% but WITHOUT ANY WARRANTY; without even the implied warranty of 
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License 
% along with this program; if not, write to the Free Software 
% Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
% 
% """


format short 


[Q_max,t_max,fit,z_inf,Ss,Tfit,chi2,NDF,chi2_lsq] = Jokulhlaup_model(TIME_EsternSkafta011982, QQ_EsternSkafta011982,'01/1982','1982')
AA1982 = [Q_max,t_max,fit(1), fit(2), fit(3), z_inf,chi2_lsq,chi2,NDF,chi2cdf(chi2,NDF)];  
SS1982 = Ss;
TT1982 = Tfit;
close all; 
clear Ss,Tfit
[Q_max,t_max,fit,z_inf,Ss,Tfit,chi2,NDF,chi2_lsq] = Jokulhlaup_model(TIME_EsternSkafta081984, QQ_EsternSkafta081984,'08/1984','1984')
AA1984 = [Q_max,t_max,fit(1), fit(2), fit(3),z_inf,chi2_lsq,chi2,NDF,chi2cdf(chi2,NDF)];
SS1984 = Ss;
TT1984 = Tfit;
close all; 
clear Ss,Tfit



QQ_EsternSkafta111986 = QQ_EsternSkafta111986([1,3:length(TIME_EsternSkafta111986)]);
TIME_EsternSkafta111986= TIME_EsternSkafta111986([1,3:length(TIME_EsternSkafta111986)]);
LL = length(TIME_EsternSkafta111986);
[Q_max,t_max,fit,z_inf,Ss,Tfit,chi2,NDF,chi2_lsq] = Jokulhlaup_model(TIME_EsternSkafta111986([1:LL-4,LL-1:LL]), QQ_EsternSkafta111986([1:LL-4,LL-1:LL]),'11/1986','1986')
AA1986 = [Q_max,t_max,fit(1), fit(2), fit(3),z_inf,chi2_lsq,chi2,NDF,chi2cdf(chi2,NDF)];
SS1986 = Ss;
TT1986 = Tfit;
close all; 
clear Ss,Tfit
[Q_max,t_max,fit,z_inf,Ss,Tfit,chi2,NDF,chi2_lsq] = Jokulhlaup_model(TIME_EsternSkafta071989, QQ_EsternSkafta071989,'07/1989','1989')
AA1989 = [Q_max,t_max,fit(1), fit(2), fit(3),z_inf,chi2_lsq,chi2,NDF,chi2cdf(chi2,NDF)];
SS1989 = Ss;
TT1989 = Tfit;
close all; 
clear Ss,Tfit
[Q_max,t_max,fit,z_inf,Ss,Tfit,chi2,NDF,chi2_lsq] = Jokulhlaup_model(TIME_EsternSkafta081991, QQ_EsternSkafta081991,'08/1991','1991')
AA1991 = [Q_max,t_max,fit(1), fit(2), fit(3), z_inf,chi2_lsq,chi2,NDF,chi2cdf(chi2,NDF)];
SS1991 = Ss;
TT1991 = Tfit;
close all; 
clear Ss , Tfit
[Q_max,t_max,fit,z_inf,Ss,Tfit,chi2,NDF,chi2_lsq] = Jokulhlaup_model(TIME_EsternSkafta071997, QQ_EsternSkafta071997,'07/1997','1997')
AA1997 = [Q_max,t_max,fit(1), fit(2), fit(3), z_inf,chi2_lsq,chi2,NDF,chi2cdf(chi2,NDF)]; 
SS1997 = Ss;
TT1997 = Tfit;
close all; 
clear Ss,Tfit
[Q_max,t_max,fit,z_inf,Ss,Tfit,chi2,NDF,chi2_lsq] = Jokulhlaup_model(TIME_EsternSkafta092002, QQ_EsternSkafta092002,'09/2002','2002')
AA2002 = [Q_max,t_max,fit(1), fit(2), fit(3), z_inf,chi2_lsq,chi2,NDF,chi2cdf(chi2,NDF)];
SS2002 = Ss;
TT2002 = Tfit;
close all; 
clear Ss,Tfit
[Q_max,t_max,fit,z_inf,Ss,Tfit,chi2,NDF,chi2_lsq] = Jokulhlaup_model(TIME_Skafta2006, QQ_Skafta2006,'04/2006','2006')
AA2006 = [Q_max,t_max,fit(1), fit(2), fit(3), z_inf,chi2_lsq,chi2,NDF,chi2cdf(chi2,NDF)];
SS2006 = Ss;
TT2006 = Tfit;
close all; 
clear Ss,Tfit
[Q_max,t_max,fit,z_inf,Ss,Tfit,chi2,NDF,chi2_lsq] = Jokulhlaup_model(TIME_Skafta2008, QQ_Skafta2008,'10/2008','2008')
AA2008 = [Q_max,t_max,fit(1), fit(2), fit(3),z_inf,chi2_lsq,chi2,NDF,chi2cdf(chi2,NDF)];
SS2008 = Ss;
TT2008 = Tfit;


AA =[AA1982;AA1984;AA1986;AA1989;AA1991;AA1997;AA2002;AA2006;AA2008];
AA_string = {'1982';'1984';'1986';'1989';'1991';'1997';'2002';'2006';'2008'};%{'1986'};%{'1982';'1984';'1986';'1989';'1991';'1997';'2002';'2006';'2008'};


T = table(AA_string, round(AA(:,1),3), round(AA(:,2),3), round(AA(:,3),3), round(AA(:,4),3),...
    round(AA(:,5),3),round(AA(:,6),3),round(AA(:,7),3),round(AA(:,8),3),round(AA(:,9),3),'VariableNames', { 'Event', 'Q_max', 't_ref', 'beta',...
    'alpha',  'z_inf', 'chi2lsq', 'chi2', 'NDF', 'probchi2lesschi2calc' })
writetable(T, 'Event_name.txt','Delimiter',' ')
