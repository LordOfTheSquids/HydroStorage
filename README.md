# HydroStorage
ENGR 142 Project 2 code
The current pump loss depends on the energy inputted into the system. Currently, I'm trying to find a way where either can be found
but this seems to be elluding me. -Mark
Nevermind, I got it. eOut = Ereservoir - (turbine loss + pipe friction).
Ereservoir = eIn + pipe friction + turbine loss
and Ereservoir = eIn - pipe friction - pump loss
pump loss = (1-npump) * ein     Therefore
Ereservoir = eIn - pipe friction - (1-npump)eIn
so 
eIn = (Ereservoir + pipe friction) / (2 - npump). 
That is the code we can use for the final project. This can be used to determine the mass of the water needed to be used. -Mark
