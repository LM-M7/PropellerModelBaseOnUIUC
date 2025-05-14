clear;
Files = dir('UIUC-data\*.txt');
ALLnps = [];
ALLct = [];
ALLJ = [];
ALLeta = [];
ALLBeta = [];
l = 0;
for i=1:40
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
    %fprintf('训练螺旋桨型号为%d*%d:\n', D,H);
    D = D * 0.0254;
    H = H * 0.0254;
    beta = H / D;
    eta = T1.eta;
    CT = T1.CT;
    J = T1.J;
    % 读入所有的CP和J
    for j = 1:length(CT)
        l = l + 1;
        ALLnps(l,1) = (nps*nps*D*D)^-1;
        ALLeta(l,1) = eta(j,1);
        ALLct(l,1) = CT(j,1);
        ALLJ(l,1) = J(j,1);
        ALLBeta(l,1) = beta;
    end
end
Data = [ALLJ , ALLnps, ALLBeta, ALLct];

J_train = Data(:, 1);
nps_train = Data(:, 2);
beta_train = Data(:, 3);
Z_train = Data(:, 4);

designMatrix = [ones(size(J_train)), J_train, J_train.^2,...
                nps_train.*J_train, nps_train.*J_train.^2,...          
                beta_train,beta_train.*J_train, beta_train.*J_train.^2];

coefficients = designMatrix \ Z_train;

a1 = coefficients(1)
a2 = coefficients(2)
a3 = coefficients(3)
a4 = coefficients(4)
a5 = coefficients(5)
a6 = coefficients(6)
a7 = coefficients(7)
a8 = coefficients(8)

