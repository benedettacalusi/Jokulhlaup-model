# Jokulhlaup-model

Description
===========
Jokulhlaup-model is a MATLAB script to solve a simplified mechanical model for explaining fast-rising jokulhlaups  
and includes two MATLAB scripts: 

Output_Jokulhlaup_model.m
---------
It provides 
- the plot of
   * simulated discharge vs. data 
   * simulated emptying lake behaviour
- a table with main outputs from simulation. 

Jokulhlaup_model.m
---------
A numerical method to solve the mechanical model, using ode45 and the least-squares
fitting algorithm implemented by lsqcurvefit function.

Installation
============
Download the source files folder.

Usage
=====
- Run Output_Jokulhlaup_model.m with new data 
    * Import the new data  
    * Update the script inputs coherently to the new data 
    * Run 
        Output_Jokulhlaup_model.m 

Contribute
==========
- If you want to contribute to Jokulhlaup-model, follow the contribution guidelines and code of conduct. 

 - Jokulhlaup-model is related to the following publication:
   Calusi B., Farina A., Rosso F., A simplified mechanical model for explaining fast-rising jökulhlaups (2020), 3,
   art. no. 100013 DOI: 10.1016/j.apples.2020.100013

Credits
=======
- Benedetta Calusi
- Angiolo Farina
- Fabio Rosso

License
=======
GNU General Public License v3.0
