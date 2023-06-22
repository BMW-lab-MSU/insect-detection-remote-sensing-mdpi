classdef ExtractFeaturesTests < matlab.unittest.TestCase

    methods (TestClassSetup)
        function addToPath(testCase)
            p = path;
            testCase.addTeardown(@path, p);
            addpath('../');
        end
    end

    methods (Test)
        function testHarmonicFrequencies(testCase)
            % Make sure that the harmonic feature extraction works when
            % called from the top-level extractFeatures function. Since we
            % have to pass the sampling frequency all the way down, we need
            % to make sure that works.

            fundamentalFreq = [23.4; 43.1; 104.7; 200.3; 251.1; 66.66];
            samplingFreq = 3000;
            t = 0:1/samplingFreq:1023/samplingFreq;

            sin1 = sin(2 * pi * fundamentalFreq * t);
            sin2 = sin(2 * pi * 2 * fundamentalFreq * t);
            sin3 = sin(2 * pi * 3 * fundamentalFreq * t);
            sin4 = sin(2 * pi * 4 * fundamentalFreq * t);
            sin5 = sin(2 * pi * 5 * fundamentalFreq * t);
            x = sin1 + sin2 + sin3 + sin4 + sin5 + rand(size(t));

            expectedFreqs = fundamentalFreq.' .* [1; 2; 3];

            features = extractFeatures(x, samplingFreq);

            resultFreqs = [features.HarmonicFreq1.'; features.HarmonicFreq2.'; features.HarmonicFreq3.'];

            testCase.verifyEqual(resultFreqs, expectedFreqs, RelTol=0.02);
        end
    end
end

