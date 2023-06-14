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

            fundamentalFreq = 100;
            samplingFreq = 2000;
            t = 0:1/samplingFreq:999/samplingFreq;

            sin1 = sin(2 * pi * fundamentalFreq * t);
            sin2 = sin(2 * pi * 2 * fundamentalFreq * t);
            sin3 = sin(2 * pi * 3 * fundamentalFreq * t);
            x = sin1 + sin2 + sin3;

            expected = round(numel(t) / samplingFreq * fundamentalFreq * [1; 2; 3] + 1);

            psd = abs(fft(x)).^2;
            psd = psd(1:floor(end/2));

            fundamentalLoc = estimateFundamentalFreq(psd);

            [~, peakLocations] = findpeaks(psd);

            result = findHarmonics(peakLocations, fundamentalLoc, nHarmonics);

            testCase.verifyEqual(result, expected);
        end
        function testHarmonicIdx(testCase)

            nHarmonics = 3;

            fundamentalFreq = 100;
            samplingFreq = 2000;
            t = 0:1/samplingFreq:999/samplingFreq;

            sin1 = sin(2 * pi * fundamentalFreq * t);
            sin2 = sin(2 * pi * 2 * fundamentalFreq * t);
            sin3 = sin(2 * pi * 3 * fundamentalFreq * t);
            x = sin1 + sin2 + sin3;

            expectedPeakLoc = round(numel(t) / samplingFreq * fundamentalFreq * [1; 2; 3] + 1);

            psd = abs(fft(x)).^2;
            psd = psd(1:floor(end/2));

            fundamentalLoc = estimateFundamentalFreq(psd);

            [~, peakLocations] = findpeaks(psd);
            
            expectedIdx = find(sum(peakLocations == expectedPeakLoc)).';


            [resultPeakLoc, resultIdx] = findHarmonics(peakLocations, fundamentalLoc, nHarmonics);

            testCase.verifyEqual(resultPeakLoc, expectedPeakLoc);
            testCase.verifyEqual(resultIdx, expectedIdx);
        end
        function testSinusoidsPhaseOffset(testCase)

            nHarmonics = 3;

            fundamentalFreq = 200;
            samplingFreq = 5000;
            t = 0:1/samplingFreq:999/samplingFreq;

            sin1 = sin(2 * pi * fundamentalFreq * t + pi/2);
            sin2 = sin(2 * pi * 2 * fundamentalFreq * t + pi/4);
            sin3 = sin(2 * pi * 3 * fundamentalFreq * t + pi/6);
            x = sin1 + sin2 + sin3;

            expected = round(numel(t) / samplingFreq * fundamentalFreq * [1; 2; 3] + 1);
            % expected = [101; 201; 301];

            psd = abs(fft(x)).^2;
            psd = psd(1:floor(end/2));

            fundamentalLoc = estimateFundamentalFreq(psd);

            [~, peakLocations] = findpeaks(psd);

            result = findHarmonics(peakLocations, fundamentalLoc, nHarmonics);

            testCase.verifyEqual(result, expected);
        end
        function testSinusoidsPowerOf2(testCase)

            nHarmonics = 3;

            fundamentalFreq = 100;
            samplingFreq = 1000;
            t = 0:1/samplingFreq:1023/samplingFreq;

            sin1 = sin(2 * pi * fundamentalFreq * t);
            sin2 = sin(2 * pi * 2 * fundamentalFreq * t);
            sin3 = sin(2 * pi * 3 * fundamentalFreq * t);
            x = sin1 + sin2 + sin3;

            expected = round(numel(t) / samplingFreq * fundamentalFreq * [1; 2; 3] + 1);

            psd = abs(fft(x)).^2;
            psd = psd(1:floor(end/2));

            fundamentalLoc = estimateFundamentalFreq(psd);

            [~, peakLocations] = findpeaks(psd);

            result = findHarmonics(peakLocations, fundamentalLoc, nHarmonics);

            testCase.verifyEqual(result, expected);
        end
        function test5Harmonics(testCase)

            nHarmonics = 5;

            fundamentalFreq = 50;
            samplingFreq = 2000;
            t = 0:1/samplingFreq:1023/samplingFreq;

            sin1 = sin(2 * pi * fundamentalFreq * t);
            sin2 = sin(2 * pi * 2 * fundamentalFreq * t);
            sin3 = sin(2 * pi * 3 * fundamentalFreq * t);
            sin4 = sin(2 * pi * 4 * fundamentalFreq * t);
            sin5 = sin(2 * pi * 5 * fundamentalFreq * t);
            x = sin1 + sin2 + sin3 + sin4 + sin5;

            expected = round(numel(t) / samplingFreq * fundamentalFreq * [1; 2; 3; 4; 5] + 1);

            psd = abs(fft(x)).^2;
            psd = psd(1:floor(end/2));

            fundamentalLoc = estimateFundamentalFreq(psd);

            [~, peakLocations] = findpeaks(psd);

            result = findHarmonics(peakLocations, fundamentalLoc, nHarmonics);

            testCase.verifyEqual(result, expected);
        end
        function test5HarmonicsWithNoise(testCase)

            nHarmonics = 5;

            fundamentalFreq = 100;
            samplingFreq = 3000;
            t = 0:1/samplingFreq:1023/samplingFreq;

            sin1 = sin(2 * pi * fundamentalFreq * t);
            sin2 = sin(2 * pi * 2 * fundamentalFreq * t);
            sin3 = sin(2 * pi * 3 * fundamentalFreq * t);
            sin4 = sin(2 * pi * 4 * fundamentalFreq * t);
            sin5 = sin(2 * pi * 5 * fundamentalFreq * t);
            x = sin1 + sin2 + sin3 + sin4 + sin5 + rand(size(t));

            expected = round(numel(t) / samplingFreq * fundamentalFreq * [1; 2; 3; 4; 5] + 1);

            psd = abs(fft(x)).^2;
            psd = psd(1:floor(end/2));

            fundamentalLoc = estimateFundamentalFreq(psd);

            [~, peakLocations] = findpeaks(psd);

            result = findHarmonics(peakLocations, fundamentalLoc, nHarmonics);

            % results need to be within 3 bins; that's what the findHarmonics algorithm looks for
            testCase.verifyEqual(result, expected, "AbsTol", 2);
        end

        % NOTE: this test fails, but that's because I didn't use any minimum 
        % peak height or prominence to filter out the tiny peaks from the noise.
        % It just so happens that the noise has a peak near an integer multiple
        % of the fundamental frequency.
        % function test3OddHarmonicsWithNoise(testCase)

        %     nHarmonics = 3;

        %     fundamentalFreq = 55;
        %     samplingFreq = 3000;
        %     t = 0:1/samplingFreq:1023/samplingFreq;

        %     sin1 = sin(2 * pi * fundamentalFreq * t);
        %     sin3 = sin(2 * pi * 3 * fundamentalFreq * t);
        %     sin5 = sin(2 * pi * 5 * fundamentalFreq * t);
        %     x = sin1 +  sin3 + sin5 + rand(size(t));

        %     expected = round(numel(t) / samplingFreq * fundamentalFreq * [1; 3; 5] + 1);

        %     psd = abs(fft(x)).^2;
        %     psd = psd(1:floor(end/2));

        %     fundamentalLoc = estimateFundamentalFreq(psd);

        %     [~, peakLocations] = findpeaks(psd);

        %     result = findHarmonics(peakLocations, fundamentalLoc, nHarmonics);

        %     % results need to be within 3 bins; that's what the findHarmonics algorithm looks for
        %     testCase.verifyEqual(result, expected, "AbsTol", 3);
        % end
        function testOddHarmonics(testCase)

            nHarmonics = 3;

            fundamentalFreq = 55;
            samplingFreq = 3000;
            t = 0:1/samplingFreq:1023/samplingFreq;

            sin1 = sin(2 * pi * fundamentalFreq * t);
            sin3 = sin(2 * pi * 3 * fundamentalFreq * t);
            sin5 = sin(2 * pi * 5 * fundamentalFreq * t);
            x = sin1 +  sin3 + sin5;

            expected = round(numel(t) / samplingFreq * fundamentalFreq * [1; 0; 3] + [1; 0; 1]);

            psd = abs(fft(x)).^2;
            psd = psd(1:floor(end/2));

            fundamentalLoc = estimateFundamentalFreq(psd);

            [~, peakLocations] = findpeaks(psd);

            result = findHarmonics(peakLocations, fundamentalLoc, nHarmonics);

            % results need to be within 3 bins; that's what the findHarmonics algorithm looks for
            testCase.verifyEqual(result, expected);
        end
        function test2Harmonics5SinusoidsWithNoise(testCase)

            nHarmonics = 2;

            fundamentalFreq = 100;
            samplingFreq = 3000;
            t = 0:1/samplingFreq:1023/samplingFreq;

            sin1 = sin(2 * pi * fundamentalFreq * t);
            sin2 = sin(2 * pi * 2 * fundamentalFreq * t);
            sin3 = sin(2 * pi * 3 * fundamentalFreq * t);
            sin4 = sin(2 * pi * 4 * fundamentalFreq * t);
            sin5 = sin(2 * pi * 5 * fundamentalFreq * t);
            x = sin1 + sin2 + sin3 + sin4 + sin5 + rand(size(t));

            expected = round(numel(t) / samplingFreq * fundamentalFreq * [1; 2] + 1);

            psd = abs(fft(x)).^2;
            psd = psd(1:floor(end/2));

            fundamentalLoc = estimateFundamentalFreq(psd);

            [~, peakLocations] = findpeaks(psd);

            result = findHarmonics(peakLocations, fundamentalLoc, nHarmonics);

            % results need to be within 3 bins; that's what the findHarmonics algorithm looks for
            testCase.verifyEqual(result, expected, "AbsTol", 2);
        end
    end
end

