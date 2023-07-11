classdef MergeStructsTests < matlab.unittest.TestCase

    methods (TestClassSetup)

        function addToPath(testCase)
            p = path;
            testCase.addTeardown(@path, p);
            addpath('../');
        end

    end

    methods (Test)

        function test2structs(testCase)

            s1.a = 1;
            s1.b = 2;

            s2.c = 3;
            s2.d = 'asdf';

            expected.a = 1;
            expected.b = 2;
            expected.c = 3;
            expected.d = 'asdf';

            result = mergeStructs(s1, s2);

            testCase.verifyEqual(result, expected);
        end

        function test2structsOverlapingFields(testCase)

            s1.a = 1;
            s1.b = 2;

            s2.b = 3;
            s2.d = 'asdf';

            expected.a = 1;
            expected.b = 3;
            expected.d = 'asdf';

            result = mergeStructs(s1, s2);

            testCase.verifyEqual(result, expected);
        end

        function test2structs2OverlapingFields(testCase)

            s1.d = 1;
            s1.b = 2;

            s2.b = 3;
            s2.d = 'asdf';

            expected.b = 3;
            expected.d = 'asdf';

            result = mergeStructs(s1, s2);

            testCase.verifyEqual(result, expected);
        end

        function test3structs(testCase)

            s1.a = 1;
            s1.b = 2;

            s2.c = 3;
            s2.asdf = 'asdf';

            s3.field1 = 'test';
            s3.d = 42;

            expected.a = 1;
            expected.b = 2;
            expected.c = 3;
            expected.asdf = 'asdf';
            expected.field1 = 'test';
            expected.d = 42;

            result = mergeStructs(s1, s2, s3);

            testCase.verifyEqual(result, expected);
        end

        function test3structsOverlappingFields(testCase)

            s1.a = 1;
            s1.b = 2;

            s2.c = 3;
            s2.asdf = 'asdf';

            s3.c = 'test';
            s3.a = 42;

            expected.a = 42;
            expected.b = 2;
            expected.c = 'test';
            expected.asdf = 'asdf';

            result = mergeStructs(s1, s2, s3);

            testCase.verifyEqual(result, expected);
        end

        function test4structs(testCase)

            s1.a = 1;
            s1.b = 2;

            s2.c = 3;
            s2.asdf = 'asdf';

            s3.field1 = 'test';
            s3.d = 42;

            s4.field2 = [1 2 3 4 5];
            s4.param = 'test';

            expected.a = 1;
            expected.b = 2;
            expected.c = 3;
            expected.asdf = 'asdf';
            expected.field1 = 'test';
            expected.d = 42;
            expected.field2 = [1 2 3 4 5];
            expected.param = 'test';

            result = mergeStructs(s1, s2, s3, s4);

            testCase.verifyEqual(result, expected);
        end

        function test4structsOverlappingFields(testCase)

            s1.a = 1;
            s1.b = 2;

            s2.c = 3;
            s2.asdf = 'asdf';

            s3.field1 = 'test';
            s3.d = 42;

            s4.field1 = [1 2 3 4 5];
            s4.param = 'test';

            expected.a = 1;
            expected.b = 2;
            expected.c = 3;
            expected.asdf = 'asdf';
            expected.d = 42;
            expected.field1 = [1 2 3 4 5];
            expected.param = 'test';

            result = mergeStructs(s1, s2, s3, s4);

            testCase.verifyEqual(result, expected);
        end

        function testInvalidArgsStructArray(testCase)
            import matlab.unittest.constraints.Throws

            s1(1).a = 1;
            s1(2).a = 3;

            s2.b = 1;

            testCase.verifyThat(@() mergeStructs(s1, s2), Throws(?MException))
        end

        function testInvalidArgsNotStruct(testCase)
            import matlab.unittest.constraints.Throws

            s1 = "asdf";

            s2 = 1;

            testCase.verifyThat(@() mergeStructs(s1, s2), Throws(?MException))
        end

        function testOneStruct(testCase)
            s1.a = 1;
            s1.b = 2;

            result = mergeStructs(s1);

            testCase.verifyEqual(result, s1);
        end

        function testEmptyArgs(testCase)
            import matlab.unittest.constraints.Throws

            testCase.verifyThat(@() mergeStructs(), Throws(?MException))
        end

    end

end
