clear;
MyModelCTTrain
Files = dir('UIUC-data\*.txt'); 
PreD = 0;
PreH = 0;
l = 0;
nps_test = [];
Z_test = [];
J_test = [];
beta_test = [];
CTRMSEAns = [];
CTR2 = [];
ALLTrue = [];
ALLPre = [];
for i=41:length(Files)
    filename = Files(i).name;
    T1 = readtable(['UIUC-data\',filename]);
    result = strsplit(filename,'_');
    DH =strsplit(result{2},'x');
    D = str2double(DH{1});
    H = str2double(DH{2});
    npm = strsplit(result{4},'.');
    nps = str2double(npm{1}) / 60;
    if H > 50
        H = H / 10;
    end
    if D > 50
        D = D / 10;
    end
    if PreH == 0
        PreH = H;
        PreD = D;
    end
    if D ~= PreD || H ~= PreH
        Z_pred = a1 + a2 * J_test + a3 * J_test.^2 + ...
                 a4 * nps_test.*J_test + a5 * nps_test.*J_test.^2 +...
                 a6 * beta_test + a7 * beta_test.*J_test + a8 * beta_test.*J_test.^2 ;
        ALLPre = [ALLPre',Z_pred']';
        ALLTrue = [ALLTrue',Z_test']';
        rmse = sqrt(mean((Z_test - Z_pred).^2));
        ss_tot = sum((Z_test - mean(Z_test)).^2);  % 总平方和
        ss_res = sum((Z_test - Z_pred).^2);        % 残差平方和
        r2 = 1 - (ss_res / ss_tot);
        % 输出评估结果
        fprintf('测试螺旋桨型号为%d*%d:\n', PreD,PreH);
        % fprintf('均方误差 (MSE): %f\n', rmse);
        % fprintf('决定系数 (R²): %f\n\n', r2);
        [AnsA,CTPreA,CPPreA] = ModelA(PreD,PreH,J_test,Z_test,Z_test);
        [AnsB,CTPreB,CPPreB] = ModelB(PreD,PreH,J_test,Z_test,Z_test);
        [fitresult, gof] = MySameModel(nps_test,J_test,Z_test,"CT","MyModel-A-CT-"+ string(PreD) +"x"+  string(PreH));
        CTRMSEAns = [CTRMSEAns;sqrt(AnsA(1,3)),sqrt(AnsB(1,3)),rmse,gof.rmse];
        CTR2 = [CTR2;AnsA(1,1),AnsB(1,1),r2,gof.rsquare];
        l = 0;
        nps_test = [];
        Z_test = [];
        J_test = [];
        beta_test = [];
        PreH = H;
        PreD = D;
    end
    D = D * 0.0254;
    H = H * 0.0254;
    beta = H / D;
    eta = T1.eta;
    CT = T1.CT;
    J = T1.J;
    % 读入所有的CP和J
    for j = 1:length(CT)
        l = l + 1;
        nps_test(l,1) = (nps*nps*D*D)^-1;
        Z_test(l,1) = CT(j,1);
        J_test(l,1) = J(j,1);
        beta_test(l,1) = beta;
    end
end
% CTR2 = sum(CTR2) / 11;
% CTRMSEAns = sum(CTRMSEAns) / 11;
% showAllRMSE(CTRMSEAns);
% comparePredictions(ALLTrue,ALLPre);


