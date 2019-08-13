function [] = learnGMM_Freq() 
    run('./vlfeat-0.9.20/toolbox/vl_setup.m');
    %run('D:\E_zhanghm\vlfeat-0.9.18\toolbox\vl_setup');
    load('dictionary/DEEP_KernelSC_fea_forGMM.mat');
    X = DEEP_KernelSC_fea_forGMM';
    
    numClusters = 32;
    [means, covariances, priors] = vl_gmm(X, numClusters);
    
    save('dictionary/GMM_para_KernelSC.mat', 'means', 'covariances', 'priors');
    
    
end