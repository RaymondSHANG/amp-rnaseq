import pytest
import _mypath
import combine_metrics_sample as cps


@pytest.fixture(scope='function')
def mockstringfile(s, tmpdir):
    """
    Given a 'tmpdir' object and an input string, return a
    temporary file object with string written as contents.
    """
    f = tmpdir.join('mockfile')
    f.write(s)

    return str(f)


class TestCombinePicardSampleLevel:
    """
    Tests functions in `combine_picard_sample.py`.
    """
    def test_read_file(self, tmpdir):
        # GIVEN some file exists with arbitrary contents
        mockcontents = 'mockline\n'
        mockpath = mockstringfile(mockcontents, tmpdir)

        # WHEN the contents of the file are read
        testlines = cps.read_file(mockpath)

        # THEN the raw lines of the file should be returned
        assert len(testlines)

    def test_get_metrics_lines(self):
        # GIVEN any state

        # WHEN metrics data lines are extracted from the a list of lines
        # with some number of #-prefixed metadata lines followed by
        # three lines reporting 1) metrics source; 2) metric names; and
        # 3) metric values, where the source in (1) is denoted by the
        # string '## METRICS CLASS'
        mocklines = ['## file.header\n',
                     '# metadata line\n',
                     '\n',
                     '## METRICS CLASS\tpicard.analysis.class\n',
                     'METRIC_NAME_1\tMETRIC_NAME_2\n',
                     'METRIC_VALUE_1\t0.0\n',
                     '\n']
        testlines = cps.get_metrics_lines(mocklines)

        # THEN the lines returned should only include the relevant
        # three metrics lines
        assert len(testlines) == 3
        assert testlines == mocklines[3:6]

    def test_parse_metrics(self):
        # GIVEN any state

        # WHEN metrics data lines are parsed into a dictionary of
        # key-value pairs, with keys indicating metric names prepended
        # by metrics type and values indicating the corresponding
        # metric values
        mocklines = ['## METRICS CLASS\tpicard.analysis.class\n',
                     'METRIC_NAME_1\tMETRIC_NAME_2\n',
                     'METRIC_VALUE_1\t0.0\n']
        testdict = cps.parse_metrics(mocklines)

        # THEN the dictionary should match the expected result
        mockdict = {'class__METRIC_NAME_1': 'METRIC_VALUE_1',
                    'class__METRIC_NAME_2': 0.0}
        assert testdict == mockdict

    def test_combine_metrics(self):
        # GIVEN any state

        # WHEN two or more dictionaries (in a list) containing metrics
        # data are combined into a single dictionary
        mockdict1 = {'class1__METRIC_NAME_1': 'METRIC_VALUE_1',
                     'class1__METRIC_NAME_2': 0.0}
        mockdict2 = {'class2__METRIC_NAME_1': 'METRIC_VALUE_1',
                     'class2__METRIC_NAME_2': 0.0}
        testdict = cps.combine_metrics([mockdict1, mockdict2])

        # THEN the combined dictionary should match the expected result
        mockdict = {'class1__METRIC_NAME_1': 'METRIC_VALUE_1',
                    'class1__METRIC_NAME_2': 0.0,
                    'class2__METRIC_NAME_1': 'METRIC_VALUE_1',
                    'class2__METRIC_NAME_2': 0.0}
        assert testdict == mockdict
