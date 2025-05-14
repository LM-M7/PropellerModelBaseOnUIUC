function Current = MotorModelAns(Torque)
%   依据实际使用到的电机模型，修改其中的二次系数，在本模型中，电机电流与电机扭矩呈二次关系
motorEf = 0.61; % 电机效率，影响输入扭矩
Torque = Torque / motorEf;
a0 = 0.1; % 常态电流
a1 = 65.6806;
a2 = 1237.6874;
Current = a2 * Torque ^ 2 + a1 * Torque + a0; 
end

