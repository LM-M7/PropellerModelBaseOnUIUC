% 基本参数，输入实际的机身参数
np = 4;
gravity = 1540 * 9.8 / 1000;
dragCof = 0.52;
% 螺旋桨实际直径与螺距
propellerD = 5 * 0.0254;
propellerP = 5 * 0.0254;
beta = propellerP / propellerD;
% 环境参数与力数据
airDensity = 1.29;
speed = 2;
drag = speed * dragCof;
force = sqrt(drag ^ 2 + gravity ^ 2);
sinAngle = gravity / force;
cosAngle = drag / force;
force = force / np;
rpsL = 0;
rpsR = 25000;
rpsAns = rpsL;
while rpsL < rpsR
    rpsMid = (rpsL + rpsR) / 2;
    rpsAns = rpsMid;
    J = speed * cosAngle / rpsMid / propellerD;
    CT = CTmodelAns(J,(rpsMid * propellerD)^-2,beta);
    Thrust = CT * airDensity * rpsMid ^ 2 * propellerD ^ 4;
    if Thrust > force
        rpsR = rpsMid - 1;
    else 
        rpsL = rpsMid + 1;
    end
end
CT = CTmodelAns(J,(rpsAns * propellerD)^-2,beta);
CP = CPmodelAns(J,(rpsAns * propellerD)^-2,beta);
CQ = CPmodelAns(J,(rpsAns * propellerD)^-2,beta) / 2 / pi;
Thrust = CT * airDensity * rpsAns ^ 2 * propellerD ^ 4;
Torque = CQ * airDensity * rpsAns ^ 2 * propellerD ^ 5;
Current = MotorModelAns(Torque) * np;


