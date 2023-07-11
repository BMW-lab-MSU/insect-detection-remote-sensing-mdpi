classdef FormatGridSearchParamsTests < matlab.unittest.TestCase

    methods (TestClassSetup)
        function addToPath(testCase)
            p = path;
            testCase.addTeardown(@path, p);
            addpath('../');
        end
    end

    methods (Test)
        function test2Params(testCase)

            param1 = 1:3;
            param2 = [4 8];

            params.param1 = param1;
            params.param2 = param2;

            [param1grid, param2grid] = ndgrid(param1, param2);

            gridSize = numel(param1grid);

            param1grid = reshape(param1grid, gridSize, 1);
            param2grid = reshape(param2grid, gridSize, 1);

            result = formatGridSearchParams(params);

            testCase.verifyEqual(result.param1, param1grid);
            testCase.verifyEqual(result.param2, param2grid);
        end

        function test2ParamsRand(testCase)

            param1 = rand(1,10);
            param2 = rand(1,40);

            params.param1 = param1;
            params.param2 = param2;

            [param1grid, param2grid] = ndgrid(param1, param2);

            gridSize = numel(param1grid);

            param1grid = reshape(param1grid, gridSize, 1);
            param2grid = reshape(param2grid, gridSize, 1);

            result = formatGridSearchParams(params);

            testCase.verifyEqual(result.param1, param1grid);
            testCase.verifyEqual(result.param2, param2grid);
        end

        function test3Params(testCase)

            param1 = 1:3;
            param2 = [4 8 20 6];
            param3 = [10 12 40 11 5];

            params.param1 = param1;
            params.param2 = param2;
            params.param3 = param3;

            [param1grid, param2grid, param3grid] = ndgrid(param1, param2, param3);

            gridSize = numel(param1grid);

            param1grid = reshape(param1grid, gridSize, 1);
            param2grid = reshape(param2grid, gridSize, 1);
            param3grid = reshape(param3grid, gridSize, 1);

            result = formatGridSearchParams(params);

            testCase.verifyEqual(result.param1, param1grid);
            testCase.verifyEqual(result.param2, param2grid);
            testCase.verifyEqual(result.param3, param3grid);
        end

        function test7Params(testCase)

            param1 = 1:3;
            param2 = [4 8 20 6];
            param3 = [10 12 40 11 5];
            param4 = [2 5];
            param5 = 1;
            param6 = 1:5:30;
            param7 = [1 2 3 4 5];

            params.param1 = param1;
            params.param2 = param2;
            params.param3 = param3;
            params.param4 = param4;
            params.param5 = param5;
            params.param6 = param6;
            params.param7 = param7;

            [param1grid, param2grid, param3grid, param4grid, param5grid, param6grid, param7grid] ...
                = ndgrid(param1, param2, param3, param4, param5, param6, param7);

            gridSize = numel(param1grid);

            param1grid = reshape(param1grid, gridSize, 1);
            param2grid = reshape(param2grid, gridSize, 1);
            param3grid = reshape(param3grid, gridSize, 1);
            param4grid = reshape(param4grid, gridSize, 1);
            param5grid = reshape(param5grid, gridSize, 1);
            param6grid = reshape(param6grid, gridSize, 1);
            param7grid = reshape(param7grid, gridSize, 1);

            result = formatGridSearchParams(params);

            testCase.verifyEqual(result.param1, param1grid);
            testCase.verifyEqual(result.param2, param2grid);
            testCase.verifyEqual(result.param3, param3grid);
            testCase.verifyEqual(result.param4, param4grid);
            testCase.verifyEqual(result.param5, param5grid);
            testCase.verifyEqual(result.param6, param6grid);
            testCase.verifyEqual(result.param7, param7grid);
        end

        function test1Param(testCase)
            param1 = 1:3;

            params.param1 = param1;

            param1grid = ndgrid(param1);

            gridSize = numel(param1grid);

            param1grid = reshape(param1grid, gridSize, 1);

            result = formatGridSearchParams(params);

            testCase.verifyEqual(result.param1, param1grid);
        end

        function testDifferentParamNames(testCase)

            param1 = 1:3;
            param2 = [4 8 20 6];
            param3 = [10 12 40 11 5];

            params.x = param1;
            params.y = param2;
            params.z = param3;

            [param1grid, param2grid, param3grid] = ndgrid(param1, param2, param3);

            gridSize = numel(param1grid);

            param1grid = reshape(param1grid, gridSize, 1);
            param2grid = reshape(param2grid, gridSize, 1);
            param3grid = reshape(param3grid, gridSize, 1);

            result = formatGridSearchParams(params);

            testCase.verifyEqual(result.x, param1grid);
            testCase.verifyEqual(result.y, param2grid);
            testCase.verifyEqual(result.z, param3grid);
        end

        function testScalarParams(testCase)

            param1 = 1;
            param2 = 4;
            param3 = 10;

            params.param1 = param1;
            params.param2 = param2;
            params.param3 = param3;

            [param1grid, param2grid, param3grid] = ndgrid(param1, param2, param3);

            gridSize = numel(param1grid);

            param1grid = reshape(param1grid, gridSize, 1);
            param2grid = reshape(param2grid, gridSize, 1);
            param3grid = reshape(param3grid, gridSize, 1);

            result = formatGridSearchParams(params);

            testCase.verifyEqual(result.param1, param1grid);
            testCase.verifyEqual(result.param2, param2grid);
            testCase.verifyEqual(result.param3, param3grid);
        end

        function testArgumentValidation(testCase)
            import matlab.unittest.constraints.Throws
            
            params(1).param1 = 1;
            params(1).param2 = 2;
            params(2).param1 = 4;
            params(2).param2 = 5;

            testCase.verifyThat(@() formatGridSearchParams(params), Throws(?MException))
        end
    end
end

