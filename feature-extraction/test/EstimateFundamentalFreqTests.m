classdef EstimateFundamentalFreqTests < matlab.unittest.TestCase

    methods (TestClassSetup)
        function addToPath(testCase)
            p = path;
            testCase.addTeardown(@path, p);
            addpath('../');
        end
    end

    methods (Test)
        function testSinusoids(testCase)
            fundamentalFreq = 100;
            samplingFreq = 2000;
            t = 0:1/samplingFreq:999/samplingFreq;

            sin1 = sin(2 * pi * fundamentalFreq * t);
            sin2 = sin(2 * pi * 2 * fundamentalFreq * t);
            sin3 = sin(2 * pi * 3 * fundamentalFreq * t);
            x = sin1 + sin2 + sin3;

            expected = round(numel(t) / samplingFreq * fundamentalFreq + 1);

            psd = abs(fft(x)).^2;
            psd = psd(1:floor(end/2));

            result = estimateFundamentalFreq(psd);

            testCase.verifyEqual(result, expected);
        end
        
        function testSinusoidsPhaseOffset(testCase)

            fundamentalFreq = 200;
            samplingFreq = 5000;
            t = 0:1/samplingFreq:999/samplingFreq;

            sin1 = sin(2 * pi * fundamentalFreq * t + pi/2);
            sin2 = sin(2 * pi * 2 * fundamentalFreq * t + pi/4);
            sin3 = sin(2 * pi * 3 * fundamentalFreq * t + pi/6);
            x = sin1 + sin2 + sin3;

            expected = round(numel(t) / samplingFreq * fundamentalFreq + 1);

            psd = abs(fft(x)).^2;
            psd = psd(1:floor(end/2));

            result = estimateFundamentalFreq(psd);

            testCase.verifyEqual(result, expected);
        end

        function testSinusoidsPowerOf2(testCase)

            fundamentalFreq = 100;
            samplingFreq = 1000;
            t = 0:1/samplingFreq:1023/samplingFreq;

            sin1 = sin(2 * pi * fundamentalFreq * t);
            sin2 = sin(2 * pi * 2 * fundamentalFreq * t);
            sin3 = sin(2 * pi * 3 * fundamentalFreq * t);
            x = sin1 + sin2 + sin3;

            expected = round(numel(t) / samplingFreq * fundamentalFreq + 1);

            psd = abs(fft(x)).^2;
            psd = psd(1:floor(end/2));

            result = estimateFundamentalFreq(psd);

            testCase.verifyEqual(result, expected);
        end

        function test5Harmonics(testCase)

            fundamentalFreq = 50;
            samplingFreq = 2000;
            t = 0:1/samplingFreq:1023/samplingFreq;

            sin1 = sin(2 * pi * fundamentalFreq * t);
            sin2 = sin(2 * pi * 2 * fundamentalFreq * t);
            sin3 = sin(2 * pi * 3 * fundamentalFreq * t);
            sin4 = sin(2 * pi * 4 * fundamentalFreq * t);
            sin5 = sin(2 * pi * 5 * fundamentalFreq * t);
            x = sin1 + sin2 + sin3 + sin4 + sin5;

            expected = round(numel(t) / samplingFreq * fundamentalFreq + 1);

            psd = abs(fft(x)).^2;
            psd = psd(1:floor(end/2));

            result = estimateFundamentalFreq(psd);

            testCase.verifyEqual(result, expected);
        end

        function test5HarmonicsWithNoise(testCase)

            fundamentalFreq = 100;
            samplingFreq = 3000;
            t = 0:1/samplingFreq:1023/samplingFreq;

            sin1 = sin(2 * pi * fundamentalFreq * t);
            sin2 = sin(2 * pi * 2 * fundamentalFreq * t);
            sin3 = sin(2 * pi * 3 * fundamentalFreq * t);
            sin4 = sin(2 * pi * 4 * fundamentalFreq * t);
            sin5 = sin(2 * pi * 5 * fundamentalFreq * t);
            x = sin1 + sin2 + sin3 + sin4 + sin5 + rand(size(t));

            expected = round(numel(t) / samplingFreq * fundamentalFreq + 1);

            psd = abs(fft(x)).^2;
            psd = psd(1:floor(end/2));

            result = estimateFundamentalFreq(psd);

            % results need to be within 3 bins; that's what the findHarmonics algorithm looks for
            testCase.verifyEqual(result, expected, "AbsTol", 2);
        end

        function test3dHarmonicsWithNoise(testCase)

            fundamentalFreq = 55;
            samplingFreq = 3000;
            t = 0:1/samplingFreq:1023/samplingFreq;

            sin1 = sin(2 * pi * fundamentalFreq * t);
            sin3 = sin(2 * pi * 3 * fundamentalFreq * t);
            sin5 = sin(2 * pi * 5 * fundamentalFreq * t);
            x = sin1 +  sin3 + sin5 + rand(size(t));

            expected = round(numel(t) / samplingFreq * fundamentalFreq + 1);

            psd = abs(fft(x)).^2;
            psd = psd(1:floor(end/2));

            result = estimateFundamentalFreq(psd);

            % results need to be within 3 bins; that's what the findHarmonics algorithm looks for
            testCase.verifyEqual(result, expected);
        end

        function testOddHarmonics(testCase)


            fundamentalFreq = 55;
            samplingFreq = 3000;
            t = 0:1/samplingFreq:1023/samplingFreq;

            sin1 = sin(2 * pi * fundamentalFreq * t);
            sin3 = sin(2 * pi * 3 * fundamentalFreq * t);
            sin5 = sin(2 * pi * 5 * fundamentalFreq * t);
            x = sin1 +  sin3 + sin5;

            expected = round(numel(t) / samplingFreq * fundamentalFreq + 1);

            psd = abs(fft(x)).^2;
            psd = psd(1:floor(end/2));

            result = estimateFundamentalFreq(psd);

            testCase.verifyEqual(result, expected);
        end

        function testInHarmonicPeaks(testCase)
        % NOTE: this will occasionally fail if noise magnitude is high
        % enough.

            fundamentalFreq = 100;
            samplingFreq = 3000;
            t = 0:1/samplingFreq:1023/samplingFreq;

            sin1 = sin(2 * pi * fundamentalFreq * t);
            sin3 = sin(2 * pi * 3 * fundamentalFreq * t);
            sin5 = sin(2 * pi * 5 * fundamentalFreq * t);

            % inhamornic peaks
            sin2 = sin(2 * pi * 2.312 * fundamentalFreq * t);
            sin4 = sin(2 * pi * 7.138 * fundamentalFreq * t);

            x = sin1 + sin2 + sin3 + sin4 + sin5 + rand(size(t))*10;

            expected = round(numel(t) / samplingFreq * fundamentalFreq + 1);

            psd = abs(fft(x)).^2;
            psd = psd(1:floor(end/2));

            result = estimateFundamentalFreq(psd);

            testCase.verifyEqual(result, expected);
        end

        function testInHarmonicPeaksMatrix(testCase)

            fundamentalFreqs = [100:10:500]';
            % fundamentalFreqs = [100; 150; 222; 500; 440];
            % fundamentalFreqs = 500;

            samplingFreq = 4000;
            t = 0:1/samplingFreq:1023/samplingFreq;

                sin1 = sin(2 * pi * fundamentalFreqs .* t);
                sin3 = sin(2 * pi * 3 * fundamentalFreqs .* t);
                % sin5 = sin(2 * pi * 5 * fundamentalFreqs(i) * t);
    
                % inhamornic peaks
                sin2 = sin(2 * pi * 2.312 * fundamentalFreqs .* t);
                % sin4 = sin(2 * pi * 7.138 * fundamentalFreqs(i) * t);

                x = sin1 + sin2 + sin3;

                expected = round(numel(t) / samplingFreq * fundamentalFreqs + 1);
            

            psd = abs(fft(x, [], 2).^2);
            psd = psd(:,1:floor(end/2));

            result = estimateFundamentalFreq(psd);

            testCase.verifyEqual(result, expected);
        end
    end
end

