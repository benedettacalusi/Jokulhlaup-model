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

[Q_max,t_max,fit,z_inf,Ss,Tfit] = Jokulhlaup_model(TIME_EsternSkafta071989, QQ_EsternSkafta071989,'07/1989','1989')
AA1989 = [Q_max,t_max,fit(1), fit(2), fit(3)];
SS1989 = Ss;
TT1989 = Tfit;
close all; 
clear Ss,Tfit

[Q_max,t_max,fit,z_inf,Ss,Tfit] = Jokulhlaup_model(TIME_EsternSkafta081991, QQ_EsternSkafta081991,'08/1991','1991')
AA1991 = [Q_max,t_max,fit(1), fit(2), fit(3)];
SS1991 = Ss;
TT1991 = Tfit;
close all; 
clear Ss , Tfit

[Q_max,t_max,fit,z_inf,Ss,Tfit] = Jokulhlaup_model(TIME_Skafta2006, QQ_Skafta2006,'04/2006','2006')
AA2006 = [Q_max,t_max,fit(1), fit(2), fit(3)];
SS2006 = Ss;
TT2006 = Tfit;



AA =[AA1989;AA1991;AA2006];
AA_string = {'1989';'1991';'2006'};


T = table(AA_string, round(AA(:,1),3), round(AA(:,2),3), round(AA(:,3),3), round(AA(:,4),3),...
    round(AA(:,5),3),'VariableNames', { 'Event', 'Q_max', 't_ref', 'beta',...
    'alpha', 'gamma' })
writetable(T, 'Event_name.txt','Delimiter',' ')
