classdef FindHarmonicsTests < matlab.unittest.TestCase

    methods (TestClassSetup)
        function addToPath(testCase)
            p = path;
            testCase.addTeardown(@path, p);
            addpath('../');
        end
    end

    methods (Test)
        function testSinusoids(testCase)

            nHarmonics = 3;

            fundamentalFreq = 93.6;
            samplingFreq = 2000;
            t = 0:1/samplingFreq:999/samplingFreq;

            sin1 = sin(2 * pi * fundamentalFreq * t);
            sin2 = sin(2 * pi * 2 * fundamentalFreq * t);
            sin3 = sin(2 * pi * 3 * fundamentalFreq * t);
            x = sin1 + sin2 + sin3;

            expected = fundamentalFreq * [1; 2; 3];

            esd = abs(fft(x)).^2;
            esd = esd(1:floor(end/2));

            fundamentalLoc = estimateFundamentalFreq(esd);

            [~, peakLocations] = findpeaks(esd);

            result = findHarmonics(peakLocations, fundamentalLoc, nHarmonics, samplingFreq, numel(x));

            testCase.verifyEqual(result, expected, RelTol=0.02);
        end
        function testSinusoidsPhaseOffset(testCase)

            nHarmonics = 3;

            fundamentalFreq = 201.3;
            samplingFreq = 5000;
            t = 0:1/samplingFreq:999/samplingFreq;

            sin1 = sin(2 * pi * fundamentalFreq * t + pi/2);
            sin2 = sin(2 * pi * 2 * fundamentalFreq * t + pi/4);
            sin3 = sin(2 * pi * 3 * fundamentalFreq * t + pi/6);
            x = sin1 + sin2 + sin3;

            expected = fundamentalFreq * [1; 2; 3];

            esd = abs(fft(x)).^2;
            esd = esd(1:floor(end/2));

            fundamentalLoc = estimateFundamentalFreq(esd);

            [~, peakLocations] = findpeaks(esd);

            result = findHarmonics(peakLocations, fundamentalLoc, nHarmonics, samplingFreq, numel(x));

            testCase.verifyEqual(result, expected, RelTol=0.02);
        end
        function testSinusoidsPowerOf2(testCase)

            nHarmonics = 3;

            fundamentalFreq = 120.4;
            samplingFreq = 1000;
            t = 0:1/samplingFreq:1023/samplingFreq;

            sin1 = sin(2 * pi * fundamentalFreq * t);
            sin2 = sin(2 * pi * 2 * fundamentalFreq * t);
            sin3 = sin(2 * pi * 3 * fundamentalFreq * t);
            x = sin1 + sin2 + sin3;

            expected = fundamentalFreq * [1; 2; 3];

            esd = abs(fft(x)).^2;
            esd = esd(1:floor(end/2));

            fundamentalLoc = estimateFundamentalFreq(esd);

            [~, peakLocations] = findpeaks(esd);

            result = findHarmonics(peakLocations, fundamentalLoc, nHarmonics, samplingFreq, numel(x));

            testCase.verifyEqual(result, expected, RelTol=0.02);
        end
        function test5Harmonics(testCase)

            nHarmonics = 5;

            fundamentalFreq = 10.123;
            samplingFreq = 2000;
            t = 0:1/samplingFreq:1023/samplingFreq;

            sin1 = sin(2 * pi * fundamentalFreq * t);
            sin2 = sin(2 * pi * 2 * fundamentalFreq * t);
            sin3 = sin(2 * pi * 3 * fundamentalFreq * t);
            sin4 = sin(2 * pi * 4 * fundamentalFreq * t);
            sin5 = sin(2 * pi * 5 * fundamentalFreq * t);
            x = sin1 + sin2 + sin3 + sin4 + sin5;

            expected = fundamentalFreq * [1; 2; 3; 4; 5];

            esd = abs(fft(x)).^2;
            esd = esd(1:floor(end/2));

            fundamentalLoc = estimateFundamentalFreq(esd);

            [~, peakLocations] = findpeaks(esd);

            result = findHarmonics(peakLocations, fundamentalLoc, nHarmonics, samplingFreq, numel(x));

            testCase.verifyEqual(result, expected, RelTol=0.05);
        end
        function test5HarmonicsWithNoise(testCase)

            nHarmonics = 5;

            fundamentalFreq = 56.78;
            samplingFreq = 3000;
            t = 0:1/samplingFreq:1023/samplingFreq;

            sin1 = sin(2 * pi * fundamentalFreq * t);
            sin2 = sin(2 * pi * 2 * fundamentalFreq * t);
            sin3 = sin(2 * pi * 3 * fundamentalFreq * t);
            sin4 = sin(2 * pi * 4 * fundamentalFreq * t);
            sin5 = sin(2 * pi * 5 * fundamentalFreq * t);
            x = sin1 + sin2 + sin3 + sin4 + sin5 + rand(size(t));

            expected = fundamentalFreq * [1; 2; 3; 4; 5];

            esd = abs(fft(x)).^2;
            esd = esd(1:floor(end/2));

            fundamentalLoc = estimateFundamentalFreq(esd);

            [~, peakLocations] = findpeaks(esd);

            result = findHarmonics(peakLocations, fundamentalLoc, nHarmonics, samplingFreq, numel(x));

            testCase.verifyEqual(result, expected, RelTol=0.05);
        end

        % NOTE: this test fails if the noise amplitude is too large, but that's because I didn't use any minimum 
        % peak height or prominence to filter out the tiny peaks from the noise.
        % It just so happens that the noise has a peak near an integer multiple
        % of the fundamental frequency.
        function test3OddHarmonicsWithNoise(testCase)

            nHarmonics = 3;

            fundamentalFreq = 55;
            samplingFreq = 3000;
            t = 0:1/samplingFreq:1023/samplingFreq;

            sin1 = sin(2 * pi * fundamentalFreq * t);
            sin3 = sin(2 * pi * 3 * fundamentalFreq * t);
            sin5 = sin(2 * pi * 5 * fundamentalFreq * t);
            x = sin1 +  sin3 + sin5 + rand(size(t)) * 0.05;

            expected = fundamentalFreq * [1; 0; 3];

            esd = abs(fft(x)).^2;
            esd = esd(1:floor(end/2));

            fundamentalLoc = estimateFundamentalFreq(esd);

            [~, peakLocations] = findpeaks(esd);

            result = findHarmonics(peakLocations, fundamentalLoc, nHarmonics, samplingFreq, numel(x));

            testCase.verifyEqual(result, expected, RelTol=0.02);
        end
        function testOddHarmonics(testCase)

            nHarmonics = 3;

            fundamentalFreq = 55.32;
            samplingFreq = 3000;
            t = 0:1/samplingFreq:1023/samplingFreq;

            sin1 = sin(2 * pi * fundamentalFreq * t);
            sin3 = sin(2 * pi * 3 * fundamentalFreq * t);
            sin5 = sin(2 * pi * 5 * fundamentalFreq * t);
            x = sin1 +  sin3 + sin5;

            expected = fundamentalFreq * [1; 0; 3];

            esd = abs(fft(x)).^2;
            esd = esd(1:floor(end/2));

            fundamentalLoc = estimateFundamentalFreq(esd);

            [~, peakLocations] = findpeaks(esd);

            result = findHarmonics(peakLocations, fundamentalLoc, nHarmonics, samplingFreq, numel(x));

            testCase.verifyEqual(result, expected, RelTol=0.02);
        end
        function test2Harmonics5SinusoidsWithNoise(testCase)

            nHarmonics = 2;

            fundamentalFreq = 104.7;
            samplingFreq = 3000;
            t = 0:1/samplingFreq:1023/samplingFreq;

            sin1 = sin(2 * pi * fundamentalFreq * t);
            sin2 = sin(2 * pi * 2 * fundamentalFreq * t);
            sin3 = sin(2 * pi * 3 * fundamentalFreq * t);
            sin4 = sin(2 * pi * 4 * fundamentalFreq * t);
            sin5 = sin(2 * pi * 5 * fundamentalFreq * t);
            x = sin1 + sin2 + sin3 + sin4 + sin5 + rand(size(t));

            expected = fundamentalFreq * [1; 2];

            esd = abs(fft(x)).^2;
            esd = esd(1:floor(end/2));

            fundamentalLoc = estimateFundamentalFreq(esd);

            [~, peakLocations] = findpeaks(esd);

            result = findHarmonics(peakLocations, fundamentalLoc, nHarmonics, samplingFreq, numel(x));

            testCase.verifyEqual(result, expected, RelTol=0.02);
        end
    end
end

